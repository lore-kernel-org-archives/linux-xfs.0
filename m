Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 21:15:33 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A4FQv3029347
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 21:15:26 -0700
Message-ID: <48EED73F.1010208@sgi.com>
Date: Fri, 10 Oct 2008 15:17:03 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix barrier fail detection
References: <20081009130042.GA21071@lst.de> <48EEAC1A.2080309@sgi.com>
In-Reply-To: <48EEAC1A.2080309@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, toei.rei@stargazer.at

Timothy Shimmin wrote:
> Christoph Hellwig wrote:
>> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-10-09 13:36:50.000000000 +0200
>> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2008-10-09 13:38:38.000000000 +0200
>> @@ -1007,6 +1007,7 @@ xfs_buf_iodone_work(
>>  	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
>>  		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
>>  		bp->b_flags &= ~XBF_ORDERED;
>> +		bp->b_flags |= _XFS_BARRIER_FAILED;
>>  		xfs_buf_iorequest(bp);
>>  	} else if (bp->b_iodone)
>>  		(*(bp->b_iodone))(bp);
> 
> Actually, probably need to update the comment for this one.
> 

>> Index: linux-2.6-xfs/fs/xfs/xfs_log.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2008-10-09 13:38:44.000000000 +0200
>> +++ linux-2.6-xfs/fs/xfs/xfs_log.c	2008-10-09 13:39:32.000000000 +0200
>> @@ -1037,7 +1037,8 @@ xlog_iodone(xfs_buf_t *bp)
>>  	 * layer, it means the underlyin device no longer supports
>>  	 * barrier I/O. Warn loudly and turn off barriers.
>>  	 */
>> -	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ISORDERED(bp)) {
>> +	if (bp->b_flags & _XFS_BARRIER_FAILED) {
>> +		bp->b_flags &= ~_XFS_BARRIER_FAILED;
>>  		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
>>  		xfs_fs_cmn_err(CE_WARN, l->l_mp,
>>  				"xlog_iodone: Barriers are no longer supported"
>>
> Okay, we probably should update this comment too.
> 
> Might as well fix the existing typo "underlyin" in the comment as well :)
> Thanks,
> --Tim
> 

i.e. something like:

Index: 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-09-19 13:47:36.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_buf.c	2008-10-10 15:07:51.316145158 +1100
@@ -1001,12 +1001,13 @@ xfs_buf_iodone_work(
 	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
 	 * ordered flag and reissue them.  Because we can't tell the higher
 	 * layers directly that they should not issue ordered I/O anymore, they
-	 * need to check if the ordered flag was cleared during I/O completion.
+	 * need to check if the _XFS_BARRIER_FAILED flag was set during I/O completion.
 	 */
 	if ((bp->b_error == EOPNOTSUPP) &&
 	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
 		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
 		bp->b_flags &= ~XBF_ORDERED;
+		bp->b_flags |= _XFS_BARRIER_FAILED;
 		xfs_buf_iorequest(bp);
 	} else if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
Index: 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-09-19 13:47:36.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_buf.h	2008-10-10 11:54:23.269373217 +1100
@@ -85,6 +85,14 @@ typedef enum {
 	 * modifications being lost.
 	 */
 	_XBF_PAGE_LOCKED = (1 << 22),
+
+	/*
+	 * If we try a barrier write, but it fails we have to communicate
+	 * this to the upper layers.  Unfortunately b_error gets overwritten
+	 * when the buffer is re-issued so we have to add another flag to
+	 * keep this information.
+	 */
+	_XFS_BARRIER_FAILED = (1 << 23),
 } xfs_buf_flags_t;
 
 typedef enum {
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_log.c	2008-09-22 11:54:19.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_log.c	2008-10-10 15:09:56.967725107 +1100
@@ -1033,11 +1033,12 @@ xlog_iodone(xfs_buf_t *bp)
 	l = iclog->ic_log;
 
 	/*
-	 * If the ordered flag has been removed by a lower
-	 * layer, it means the underlyin device no longer supports
+	 * If the _XFS_BARRIER_FAILED flag was set by a lower
+	 * layer, it means the underlying device no longer supports
 	 * barrier I/O. Warn loudly and turn off barriers.
 	 */
-	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ISORDERED(bp)) {
+	if (bp->b_flags & _XFS_BARRIER_FAILED) {
+		bp->b_flags &= ~_XFS_BARRIER_FAILED;
 		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		xfs_fs_cmn_err(CE_WARN, l->l_mp,
 				"xlog_iodone: Barriers are no longer supported"
