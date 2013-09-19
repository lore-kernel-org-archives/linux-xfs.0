Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85EB87F50
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 08:42:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 704058F8089
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 06:42:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Oi7Me8WUNpm5cQiY for
	<xfs@oss.sgi.com>; Thu, 19 Sep 2013 06:42:04 -0700 (PDT)
Message-ID: <523AF458.6040106@redhat.com>
Date: Thu, 19 Sep 2013 08:55:52 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: push down inactive transaction mgmt for remote
	symlinks
References: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
	<1379520960-22972-2-git-send-email-bfoster@redhat.com>
	<20130918221729.GB9901@dastard>
In-Reply-To: <20130918221729.GB9901@dastard>
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
Cc: xfs@oss.sgi.com

On 09/18/2013 06:17 PM, Dave Chinner wrote:
> On Wed, Sep 18, 2013 at 12:15:58PM -0400, Brian Foster wrote:
>> Push down the transaction management for remote symlinks from
>> xfs_inactive() down to xfs_inactive_symlink_rmt(). The latter is
>> cleaned up to avoid transaction management intended for the
>> calling context (i.e., trans duplication, reservation, item
>> attachment).
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_inode.c   | 15 ++++++------
>>  fs/xfs/xfs_symlink.c | 64 ++++++++++++++++++----------------------------------
>>  fs/xfs/xfs_symlink.h |  2 +-
>>  3 files changed, 31 insertions(+), 50 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index e3d7538..30db70e 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -1724,9 +1724,14 @@ xfs_inactive(
>>  	if (error)
>>  		return VN_INACTIVE_CACHE;
>>  
>> +	if (S_ISLNK(ip->i_d.di_mode)) {
>> +		error = xfs_inactive_symlink(ip);
>> +		if (error)
>> +			goto out;
>> +	}
>> +
>>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>> -	resp = (truncate || S_ISLNK(ip->i_d.di_mode)) ?
>> -		&M_RES(mp)->tr_itruncate : &M_RES(mp)->tr_ifree;
>> +	resp = truncate ? &M_RES(mp)->tr_itruncate : &M_RES(mp)->tr_ifree;
>>  
>>  	error = xfs_trans_reserve(tp, resp, 0, 0);
>>  	if (error) {
>> @@ -1738,11 +1743,7 @@ xfs_inactive(
>>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>>  	xfs_trans_ijoin(tp, ip, 0);
>>  
>> -	if (S_ISLNK(ip->i_d.di_mode)) {
>> -		error = xfs_inactive_symlink(ip, &tp);
>> -		if (error)
>> -			goto out_cancel;
>> -	} else if (truncate) {
>> +	if (truncate) {
>>  		ip->i_d.di_size = 0;
>>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 
> Just to maintain the same logic here, if it is a symlink shouldn't
> we be ensuring that truncate is zero so we don't go down that path
> (even if it's just an assert that you add)?
> 

I missed this on my first pass of your review, but this actually turns
back into an if/else after patch 2. E.g., once we pull the truncate case
back before the transaction allocation still being used for the ifree
(until patch 3). So I think this is probably unnecessary.

Brian

>> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
>> index f622a97..f85f6f2 100644
>> --- a/fs/xfs/xfs_symlink.c
>> +++ b/fs/xfs/xfs_symlink.c
>> @@ -424,8 +424,7 @@ xfs_symlink(
>>   */
>>  STATIC int
>>  xfs_inactive_symlink_rmt(
>> -	xfs_inode_t	*ip,
>> -	xfs_trans_t	**tpp)
>> +	xfs_inode_t	*ip)
>>  {
>>  	xfs_buf_t	*bp;
>>  	int		committed;
>> @@ -437,11 +436,9 @@ xfs_inactive_symlink_rmt(
>>  	xfs_mount_t	*mp;
>>  	xfs_bmbt_irec_t	mval[XFS_SYMLINK_MAPS];
>>  	int		nmaps;
>> -	xfs_trans_t	*ntp;
>>  	int		size;
>>  	xfs_trans_t	*tp;
>>  
>> -	tp = *tpp;
>>  	mp = ip->i_mount;
>>  	ASSERT(ip->i_df.if_flags & XFS_IFEXTENTS);
>>  	/*
>> @@ -453,6 +450,14 @@ xfs_inactive_symlink_rmt(
>>  	 */
>>  	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
>>  
>> +	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
>> +	if (error)
>> +		goto error0;
> 
> 		goto error_trans_cancel;
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>> +
>>  	/*
>>  	 * Lock the inode, fix the size, and join it to the transaction.
>>  	 * Hold it so in the normal path, we still have it locked for
>> @@ -471,7 +476,7 @@ xfs_inactive_symlink_rmt(
>>  	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
>>  				mval, &nmaps, 0);
>>  	if (error)
>> -		goto error0;
>> +		goto error1;
> 
> 		goto error_unlock;
> 
>>  	/*
>>  	 * Invalidate the block(s). No validation is done.
>>  	 */
>> @@ -481,7 +486,7 @@ xfs_inactive_symlink_rmt(
>>  			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
>>  		if (!bp) {
>>  			error = ENOMEM;
>> -			goto error1;
>> +			goto error2;
> 
> 			goto error_bmap_cancel;
> 
>>  		}
>>  		xfs_trans_binval(tp, bp);
>>  	}
>> @@ -490,13 +495,13 @@ xfs_inactive_symlink_rmt(
>>  	 */
>>  	if ((error = xfs_bunmapi(tp, ip, 0, size, XFS_BMAPI_METADATA, nmaps,
>>  			&first_block, &free_list, &done)))
>> -		goto error1;
>> +		goto error2;
> 
> Can you convert this to:
> 
> 	error = xfs_bunmapi(tp, ip, 0, size, XFS_BMAPI_METADATA, nmaps,
> 			    &first_block, &free_list, &done);
> 	if (error)
> 		goto error_bmap_cancel;
> 
>>  	ASSERT(done);
>>  	/*
>>  	 * Commit the first transaction.  This logs the EFI and the inode.
>>  	 */
>>  	if ((error = xfs_bmap_finish(&tp, &free_list, &committed)))
>> -		goto error1;
>> +		goto error2;
> 
> Same here.
> 
>>  	/*
>>  	 * The transaction must have been committed, since there were
>>  	 * actually extents freed by xfs_bunmapi.  See xfs_bmap_finish.
>> @@ -508,29 +513,16 @@ xfs_inactive_symlink_rmt(
>>  	 * Mark it dirty so it will be logged and moved forward in the log as
>>  	 * part of every commit.
>>  	 */
>> -	xfs_trans_ijoin(tp, ip, 0);
>> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> 
> Oh, good, you caught the "need to unlock the inode at commit" case
> :)
> 
>>  
>> - error1:
>> +error2:
>>  	xfs_bmap_cancel(&free_list);
>> - error0:
>> +error1:
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +error0:
>> +	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
>>  	return error;
> 
> And the error labels need reworking appropriately.
> 
>>  }
>>  
>> @@ -563,16 +546,13 @@ xfs_inactive_symlink_rmt(
>>   */
>>  int
>>  xfs_inactive_symlink(
>> -	struct xfs_inode	*ip,
>> -	struct xfs_trans	**tp)
>> +	struct xfs_inode	*ip)
>>  {
>>  	struct xfs_mount	*mp = ip->i_mount;
>>  	int			pathlen;
>>  
>>  	trace_xfs_inactive_symlink(ip);
>>  
>> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>> -
>>  	if (XFS_FORCED_SHUTDOWN(mp))
>>  		return XFS_ERROR(EIO);
> 
> The call to xfs_idata_realloc() needs to be done under the
> XFS_ILOCK_EXCL here. We can race with other inode cache lookups
> that do work, so we do need to ensure that we correctly lock
> everything for modifications that are to be made to the inode state.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
