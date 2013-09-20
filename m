Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F22897F37
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 08:09:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DEB508F8081
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 06:09:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QrsAUmVT6xC8z0yB for
	<xfs@oss.sgi.com>; Fri, 20 Sep 2013 06:09:12 -0700 (PDT)
Message-ID: <523C4816.1040105@redhat.com>
Date: Fri, 20 Sep 2013 09:05:26 -0400
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
...
>> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
>> index f622a97..f85f6f2 100644
>> --- a/fs/xfs/xfs_symlink.c
>> +++ b/fs/xfs/xfs_symlink.c
>> @@ -424,8 +424,7 @@ xfs_symlink(
>>   */
>>  STATIC int
>>  xfs_inactive_symlink_rmt(
...
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

Yeah, and while fixing the error handling order issues in v2 I just
noticed that this leaves the final xfs_idata_realloc() call in
xfs_inactive_symlink_rmt() unprotected wrt to the ilock. ;) I'll fix
that up to just do the (un)locking manually here as well for v3...

Brian

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
