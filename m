Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 193047F4E
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 17:49:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B15CAC002
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 15:49:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hBvyU74QkAFYgTwc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jun 2015 15:49:57 -0700 (PDT)
Message-ID: <557F5693.30504@redhat.com>
Date: Mon, 15 Jun 2015 17:49:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix remote symlinks on V5/CRC filesystems
References: <557F4E1E.8000505@redhat.com> <20150615222157.GD10224@dastard>
	<557F532F.9060505@redhat.com> <20150615224710.GE10224@dastard>
In-Reply-To: <20150615224710.GE10224@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/15/15 5:47 PM, Dave Chinner wrote:
> On Mon, Jun 15, 2015 at 05:35:27PM -0500, Eric Sandeen wrote:
>> On 6/15/15 5:21 PM, Dave Chinner wrote:
>>> On Mon, Jun 15, 2015 at 05:13:50PM -0500, Eric Sandeen wrote:
>>>> If we create a CRC filesystem, mount it, and create a symlink with
>>>> a path long enough that it can't live in the inode, we get a very
>>>> strange result upon remount:
>>>>
>>>> # ls -l mnt
>>>> total 4
>>>> lrwxrwxrwx. 1 root root 929 Jun 15 16:58 link -> XSLM
>>>>
>>>> XSLM is the V5 symlink block header magic (which happens to be
>>>> followed by a NUL, so the string looks terminated).
>>>>
>>>> xfs_readlink_bmap() advanced cur_chunk by the size of the header
>>>> for CRC filesystems, but never actually used that pointer; it
>>>> kept reading from bp->b_addr, which is the start of the block,
>>>> rather than the start of the symlink data after the header.
>>>>
>>>> Looks like this problem goes back to v3.10.
>>>>
>>>> Fixing this gets us reading the proper link target, again.
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> Cc: stable@vger.kernel.org
>>>> ---
>>>>
>>>> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
>>>> index 3df411e..40c0765 100644
>>>> --- a/fs/xfs/xfs_symlink.c
>>>> +++ b/fs/xfs/xfs_symlink.c
>>>> @@ -104,7 +104,7 @@ xfs_readlink_bmap(
>>>>  			cur_chunk += sizeof(struct xfs_dsymlink_hdr);
>>>>  		}
>>>>  
>>>> -		memcpy(link + offset, bp->b_addr, byte_cnt);
>>>> +		memcpy(link + offset, cur_chunk, byte_cnt);
>>>>  
>>>>  		pathlen -= byte_cnt;
>>>>  		offset += byte_cnt;
>>>
>>> Looks like the correct fix, so:
>>>
>>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>>>
>>> However, it raises a more disturbing question: how did we not trip
>>> over this until now? I though we had long symlink test coverage in
>>> xfstests but clearly we haven't - do you have a test that closes
>>> this verification hole?
>>
>> It was a smaller part of a larger test harness I was using with xfs_metadump,
>> which was trying to create every type of on-disk metadata.  However, even with
>> that I only stumbled on it, because I was only verifying that the results were
>> uncorrupted and consistent with the original, not actually verifying that
>> what I created was still there (on the original!)
>>
>> So, I don't have a test specific to this, no, but could certainly write one;
>> I suppose a quick targeted fstest for just this bug would be ok, although
>> a test w/ broader scope might make sense too.
> 
> Sure, the metadump test is a good idea, but my question is more
> asking why our broader tests haven't already covered verifying
> MAXPATHLEN symlinks work correctly or not. Surely symlink
> correctness is verified *somewhere* (even outside xfstests,
> e.g. LTP?), and if so why haven't we seen this before now? If not,
> then I'd suggest we've just uncovered a potential Nest O' Bugs...

A) CRCs aren't default
B) I bet LTP doesn't do a remount to verify on-disk persistence
C) ???
D) Profit!

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
