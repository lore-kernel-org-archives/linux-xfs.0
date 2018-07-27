Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38534 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732143AbeG0Q2E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 12:28:04 -0400
Subject: Re: [PATCH 1/2] libxfs: add more bounds checking to sb sanity checks
References: <153262651940.8934.17525988748289196893.stgit@magnolia>
 <20180726232855.GD2234@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <73448b8c-21a0-f3b7-98cd-00a0abc687a5@sandeen.net>
Date: Fri, 27 Jul 2018 08:05:39 -0700
MIME-Version: 1.0
In-Reply-To: <20180726232855.GD2234@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, billodo@redhat.com

On 7/26/18 4:28 PM, Dave Chinner wrote:
> On Thu, Jul 26, 2018 at 10:35:19AM -0700, Darrick J. Wong wrote:
>> From: Bill O'Donnell <billodo@redhat.com>
>>
>> Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
>> Add sanity checks for these parameters.
>>
>> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
>> [darrick: remove the icount check, tweak the comments a little]
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_sb.c |   45 +++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 35 insertions(+), 10 deletions(-)
>>
>>
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index b3ad15956366..b2c683588519 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -599,22 +599,16 @@ xfs_sb_to_disk(
>>  static int
>>  xfs_sb_verify(
>>  	struct xfs_buf	*bp,
>> +	struct xfs_sb	*sb,
>>  	bool		check_version)
>>  {
>>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>> -	struct xfs_sb	sb;
>> -
>> -	/*
>> -	 * Use call variant which doesn't convert quota flags from disk 
>> -	 * format, because xfs_mount_validate_sb checks the on-disk flags.
>> -	 */
>> -	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
>>  
>>  	/*
>>  	 * Only check the in progress field for the primary superblock as
>>  	 * mkfs.xfs doesn't clear it from secondary superblocks.
>>  	 */
>> -	return xfs_mount_validate_sb(mp, &sb,
>> +	return xfs_mount_validate_sb(mp, sb,
>>  				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
>>  				     check_version);
> 
> Why do we need to keep this wrapper function? The in-progress check
> is a primary superblock read verifier check (only useful at mount
> time), as is the "check_version" flag used to validate the V5
> feature mask during mount.
> 
> i.e. xfs_sb_verify() needs to go away, and the read-side only checks
> need to be moved from xfs_mount_validate_sb() into
> xfs_sb_read_verify() too. At which point, xfs_mount_validate_sb()
> has nothing to do with mount and can be renamed to
> xfs_sb_verify_common()....

Yeah, I had thought about that too, but Darrick mentioned other pending
rearrangements and figured maybe it could come as a followup patch.

-Eric
