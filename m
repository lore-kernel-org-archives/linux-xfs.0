Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36064 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730395AbeG0Pwf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 11:52:35 -0400
Subject: Re: [PATCH 2/2] xfs: verify icount in superblock write
References: <153262651940.8934.17525988748289196893.stgit@magnolia>
 <153262652554.8934.816888163232208002.stgit@magnolia>
 <20180726232028.GC2234@dastard> <20180727000715.GJ30972@magnolia>
 <20180727104439.GA21835@bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1be8e8e4-6089-cd73-7ef6-b23250d61505@sandeen.net>
Date: Fri, 27 Jul 2018 07:30:17 -0700
MIME-Version: 1.0
In-Reply-To: <20180727104439.GA21835@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, billodo@redhat.com

On 7/27/18 3:44 AM, Brian Foster wrote:
> On Thu, Jul 26, 2018 at 05:07:15PM -0700, Darrick J. Wong wrote:
>> On Fri, Jul 27, 2018 at 09:20:28AM +1000, Dave Chinner wrote:
>>> On Thu, Jul 26, 2018 at 10:35:25AM -0700, Darrick J. Wong wrote:
>>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>>
>>>> Add a helper predicate to check the inode count for sanity, then use it
>>>> in the superblock write verifier to inspect sb_icount.
>>>>
>>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>>> ---
>>>>  fs/xfs/libxfs/xfs_sb.c    |    1 +
>>>>  fs/xfs/libxfs/xfs_types.c |   34 ++++++++++++++++++++++++++++++++++
>>>>  fs/xfs/libxfs/xfs_types.h |    1 +
>>>>  3 files changed, 36 insertions(+)
>>>>
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>>>> index b2c683588519..1659016875f9 100644
>>>> --- a/fs/xfs/libxfs/xfs_sb.c
>>>> +++ b/fs/xfs/libxfs/xfs_sb.c
>>>> @@ -714,6 +714,7 @@ xfs_sb_write_verify(
>>>>  	 * cases.
>>>>  	 */
>>>>  	if (sb.sb_fdblocks > sb.sb_dblocks ||
>>>> +	    !xfs_verify_icount(mp, sb.sb_icount) ||
>>>>  	    sb.sb_ifree > sb.sb_icount) {
>>>>  		xfs_notice(mp, "SB summary counter sanity check failed");
>>>>  		error = -EFSCORRUPTED;
>>>> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
>>>> index 2e2a243cef2e..2e9c0c25ccb6 100644
>>>> --- a/fs/xfs/libxfs/xfs_types.c
>>>> +++ b/fs/xfs/libxfs/xfs_types.c
>>>> @@ -171,3 +171,37 @@ xfs_verify_rtbno(
>>>>  {
>>>>  	return rtbno < mp->m_sb.sb_rblocks;
>>>>  }
>>>> +
>>>> +/* Calculate the range of valid icount values. */
>>>> +static void
>>>> +xfs_icount_range(
>>>> +	struct xfs_mount	*mp,
>>>> +	unsigned long long	*min,
>>>> +	unsigned long long	*max)
>>>> +{
>>>> +	unsigned long long	nr_inos = 0;
>>>> +	xfs_agnumber_t		agno;
>>>> +
>>>> +	/* root, rtbitmap, rtsum all live in the first chunk */
>>>> +	*min = XFS_INODES_PER_CHUNK;
>>>> +
>>>> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>>>> +		xfs_agino_t	first, last;
>>>> +
>>>> +		xfs_agino_range(mp, agno, &first, &last);
>>>> +		nr_inos += first - last + 1;
> 
> Shouldn't this be last - first?
> 
>>>> +	}
>>>> +	*max = nr_inos;
>>>> +}
>>>
>>> And the effect of the inode32 mount option on the valid icount range?
>>
>> Heh, I wondered about that.  The premise of inode32 is that we will
>> never allocate an inode with a number exceeding 2^32, correct?  Do we
>> ever write anything to that fs to say "this fs must never have inode
>> numbers > 2^32"?  i.e. something that permanently restricts it to
>> 32-bit inode numbers and counts?  I don't think I see any such device.
>>
>> What's supposed to happen if I create a > 1TB fs, put a bunch of files
>> on it such that some of them end up with inode numbers exceeding 2^32,
>> unmount it, and then mount it again with inode32?  Do we detect this and
>> refuse the mount because we can't honor the inode32 constraints?
>>
>> Similarly, what if I create a filesystem with more than 4 billion files
>> on it, then unmount and remount with inode32?  Do we actually detect
>> this situation and refuse to mount because we know the counter is
>> already larger than 2^32?  If we allow the mount today, should we start
>> failing superblock writes because sb_icount is greater than 2^32?
>>
> 
> I thought an inode32 mount should allow reading existing inode64 inodes
> without an issue. As noted above, it just prevents the allocation of
> further inodes beyond 1TB.
> 
>> In other words, I'm not sure inode32 can have any effect on the icount
>> *max if we don't refuse the mount if the fs already has 64-bit inodes.
>>
> 
> This patch looks like it doesn't consider inode32. It just ensures that
> the icount falls into a valid range based on the ag geometry, which
> seems broad enough to cover all cases... hm?
> 
> That aside.. since these values shouldn't change often I'm wondering if
> it's worth calculating the global min/max once at mount time (we'd have
> to recalc on growfs) rather than in the sb verifier path... It looks
> like we already have a bunch of such misc min/max counters in xfs_mount.

It does seem like a fair bit of work to calculate unchanging values.  Since
this is really only an order-ofmagnitude sanity check anyway, I wonder if
this part of the verifier isn't working too hard to arrive at the
best-possible upper bound. My 64-bit divide was dumb & broken, but wouldn't
~(dblocks/inopb) get us close enough with a lot less work?

-Eric
