Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC1AC2D0DE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BBEE206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Me8DCjPB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgAABJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xY6091236
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6e3Aj0gaGHb7Rlo4Cz/IfErHAY/xak8vGXjQxKTco7g=;
 b=Me8DCjPBCXkjKm4mEWH7ZTgQSCsoLLK7tCLhF+5MPqj0seH75JpvO4FlVwsYyTYthXb2
 zv+AjoOil4WIkaRjUNMMNY5owpjWFZRFO7YGAPUcguklND52eHkpTpfnjD/KE53GiXGj
 aP6sfn0LNsfXVJMQE8/T3C29lC8WFKfUjoKdqUuF9SFtDIiBaWihBST1qEvZJqtE4diO
 wOGURoOZtk8bO6KHRIfEZtxXp6QV2BndxPlXJV8ju80N6RkEFE/QDtKGLKkhPY9GKJT6
 KOx48Gki4fv0DCC0/4YR6K2Wpkg4t1ArrRGgckdUTkfEbZTcnW9kYJE8U2Cpt5kRzJW0 Eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uml190218
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrfy09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:56 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00117mno005341
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:48 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:07:48 -0800
Subject: [PATCH 5/6] xfs: flush speculative space allocations when we run
 out of quota
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:07:46 -0800
Message-ID: <157784086638.1361522.14471831853437220735.stgit@magnolia>
In-Reply-To: <157784083298.1361522.7064886067520069080.stgit@magnolia>
References: <157784083298.1361522.7064886067520069080.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a fs modification (creation, file write, reflink, etc.) is unable to
reserve enough quota to handle the modification, try clearing whatever
space the filesystem might have been hanging onto in the hopes of
speeding up the filesystem.  The flushing behavior will become
particularly important when we add deferred inode inactivation because
that will increase the amount of space that isn't actively tied to user
data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   17 +++++++++++++++++
 fs/xfs/xfs_file.c      |    2 +-
 fs/xfs/xfs_icache.c    |    9 +++++++--
 fs/xfs/xfs_icache.h    |    2 +-
 fs/xfs/xfs_inode.c     |   17 +++++++++++++++++
 fs/xfs/xfs_ioctl.c     |    2 ++
 fs/xfs/xfs_iomap.c     |   19 +++++++++++++++++++
 fs/xfs/xfs_reflink.c   |   45 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trace.c     |    1 +
 fs/xfs/xfs_trace.h     |   40 ++++++++++++++++++++++++++++++++++++++++
 10 files changed, 146 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f96c1d9a68a7..72965a22ad1d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -761,6 +761,7 @@ xfs_alloc_file_space(
 	 */
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
+		bool		cleared_space = false;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -803,6 +804,7 @@ xfs_alloc_file_space(
 		/*
 		 * Allocate and setup the transaction.
 		 */
+retry:
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
 				resrtextents, 0, &tp);
 
@@ -819,6 +821,20 @@ xfs_alloc_file_space(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
 						      0, quota_flag);
+		/*
+		 * We weren't able to reserve enough quota to handle fallocate.
+		 * Flush any disk space that was being held in the hopes of
+		 * speeding up the filesystem.  We hold the IOLOCK so we cannot
+		 * do a synchronous scan.
+		 */
+		if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
+			xfs_trans_cancel(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			cleared_space = xfs_inode_free_quota_blocks(ip, false);
+			if (cleared_space)
+				goto retry;
+			goto error2;
+		}
 		if (error)
 			goto error1;
 
@@ -857,6 +873,7 @@ xfs_alloc_file_space(
 error1:	/* Just cancel transaction */
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+error2:
 	return error;
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 26e3edc07445..6b37d0435e3a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -655,7 +655,7 @@ xfs_file_buffered_aio_write(
 	 */
 	if (ret == -EDQUOT && !cleared_space) {
 		xfs_iunlock(ip, iolock);
-		cleared_space = xfs_inode_free_quota_blocks(ip);
+		cleared_space = xfs_inode_free_quota_blocks(ip, true);
 		if (cleared_space)
 			goto write_retry;
 		iolock = 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d954e37af5d0..5dffa87973b4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1536,7 +1536,8 @@ xfs_icache_free_eofblocks(
  */
 bool
 xfs_inode_free_quota_blocks(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	bool			sync)
 {
 	struct xfs_eofblocks	eofb = {0};
 	struct xfs_dquot	*dq;
@@ -1546,7 +1547,9 @@ xfs_inode_free_quota_blocks(
 	 * Run a sync scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION;
+	if (sync)
+		eofb.eof_flags |= XFS_EOF_FLAGS_SYNC;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
 		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
@@ -1578,6 +1581,8 @@ xfs_inode_free_quota_blocks(
 	if (!do_work)
 		return false;
 
+	trace_xfs_inode_free_quota_blocks(ip->i_mount, &eofb, _RET_IP_);
+
 	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
 	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
 	return true;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 6727b792ee40..835c735301b8 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -57,7 +57,7 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
-bool xfs_inode_free_quota_blocks(struct xfs_inode *ip);
+bool xfs_inode_free_quota_blocks(struct xfs_inode *ip, bool sync);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3a88014fc259..c17ac64c0896 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1143,6 +1143,7 @@ xfs_create(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
+	bool			cleared_space = false;
 	uint			resblks;
 
 	trace_xfs_create(dp, name);
@@ -1176,6 +1177,7 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
+retry:
 	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
@@ -1193,6 +1195,21 @@ xfs_create(
 	 */
 	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
 						pdqp, resblks, 1, 0);
+	/*
+	 * We weren't able to reserve enough quota to handle adding the inode.
+	 * Flush any disk space that was being held in the hopes of speeding up
+	 * the filesystem.
+	 */
+	if ((error == -EDQUOT || error == -ENOSPC) && !cleared_space) {
+		xfs_trans_cancel(tp);
+		if (unlock_dp_on_error)
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+		unlock_dp_on_error = false;
+		cleared_space = xfs_inode_free_quota_blocks(dp, true);
+		if (cleared_space)
+			goto retry;
+		goto out_release_inode;
+	}
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f1c40b20fa6..d11857125f45 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2285,6 +2285,8 @@ xfs_file_ioctl(
 		if (error)
 			return error;
 
+		trace_xfs_ioc_free_eofblocks(mp, &keofb, _RET_IP_);
+
 		return xfs_icache_free_eofblocks(mp, &keofb);
 	}
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c1befb899911..1eed29139b58 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -28,6 +28,7 @@
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
 #include "xfs_health.h"
+#include "xfs_icache.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -202,6 +203,7 @@ xfs_iomap_write_direct(
 	int			error;
 	int			bmapi_flags = XFS_BMAPI_PREALLOC;
 	uint			tflags = 0;
+	bool			cleared_space = false;
 
 	ASSERT(count_fsb > 0);
 
@@ -241,6 +243,7 @@ xfs_iomap_write_direct(
 			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
 			tflags, &tp);
 	if (error)
@@ -249,6 +252,22 @@ xfs_iomap_write_direct(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
+	/*
+	 * We weren't able to reserve enough quota for the direct write.
+	 * Flush any disk space that was being held in the hopes of speeding up
+	 * the filesystem.  Historically, we expected callers to have
+	 * preallocated all the space before a direct write, but this is not an
+	 * absolute requirement.  We still hold the IOLOCK so we cannot do a
+	 * sync scan.
+	 */
+	if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
+		xfs_trans_cancel(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		cleared_space = xfs_inode_free_quota_blocks(ip, false);
+		if (cleared_space)
+			goto retry;
+		return error;
+	}
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index de451235c4ee..6bff74ab49a0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -353,13 +353,14 @@ xfs_reflink_allocate_cow(
 	bool			convert_now)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
 	xfs_fileoff_t		offset_fsb = imap->br_startoff;
 	xfs_filblks_t		count_fsb = imap->br_blockcount;
-	struct xfs_trans	*tp;
-	int			nimaps, error = 0;
-	bool			found;
 	xfs_filblks_t		resaligned;
 	xfs_extlen_t		resblks = 0;
+	bool			found;
+	bool			cleared_space = false;
+	int			nimaps, error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (!ip->i_cowfp) {
@@ -378,6 +379,7 @@ xfs_reflink_allocate_cow(
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 
 	xfs_iunlock(ip, *lockmode);
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	*lockmode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, *lockmode);
@@ -402,6 +404,23 @@ xfs_reflink_allocate_cow(
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
 			XFS_QMOPT_RES_REGBLKS);
+	/*
+	 * We weren't able to reserve enough quota to handle copy on write.
+	 * Flush any disk space that was being held in the hopes of speeding up
+	 * the filesystem.  We potentially hold the IOLOCK so we cannot do a
+	 * synchronous scan.
+	 */
+	if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
+		xfs_trans_cancel(tp);
+		xfs_iunlock(ip, *lockmode);
+		*lockmode = 0;
+		cleared_space = xfs_inode_free_quota_blocks(ip, false);
+		if (cleared_space)
+			goto retry;
+		*lockmode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, *lockmode);
+		goto out;
+	}
 	if (error)
 		goto out_trans_cancel;
 
@@ -443,6 +462,7 @@ xfs_reflink_allocate_cow(
 			XFS_QMOPT_RES_REGBLKS);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out:
 	return error;
 }
 
@@ -1005,6 +1025,7 @@ xfs_reflink_remap_extent(
 	xfs_filblks_t		rlen;
 	xfs_filblks_t		unmap_len;
 	xfs_off_t		newlen;
+	bool			cleared_space = false;
 	int			error;
 
 	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
@@ -1020,21 +1041,37 @@ xfs_reflink_remap_extent(
 
 	/* Start a rolling transaction to switch the mappings */
 	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
 		goto out;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
 
 	/* If we're not just clearing space, then do we have enough quota? */
 	if (real_extent) {
 		error = xfs_trans_reserve_quota_nblks(tp, ip,
 				irec->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
+		/*
+		 * We weren't able to reserve enough quota for the remapping.
+		 * Flush any disk space that was being held in the hopes of
+		 * speeding up the filesystem.  We still hold the IOLOCK so we
+		 * cannot do a sync scan.
+		 */
+		if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
+			xfs_trans_cancel(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			cleared_space = xfs_inode_free_quota_blocks(ip, false);
+			if (cleared_space)
+				goto retry;
+			goto out;
+		}
 		if (error)
 			goto out_cancel;
 	}
 
+	xfs_trans_ijoin(tp, ip, 0);
+
 	trace_xfs_reflink_remap(ip, irec->br_startoff,
 				irec->br_blockcount, irec->br_startblock);
 
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 9b5e58a92381..09c643643604 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -28,6 +28,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_filestream.h"
 #include "xfs_fsmap.h"
+#include "xfs_icache.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 222b313f61b0..8307d188aea7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -36,6 +36,7 @@ struct xfs_owner_info;
 struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
+struct xfs_eofblocks;
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
@@ -3740,6 +3741,45 @@ TRACE_EVENT(xfs_btree_bload_block,
 		  __entry->nr_records)
 )
 
+DECLARE_EVENT_CLASS(xfs_eofblocks_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, eofb, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(__u32, flags)
+		__field(uint32_t, uid)
+		__field(uint32_t, gid)
+		__field(prid_t, prid)
+		__field(__u64, min_file_size)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+                __entry->flags = eofb->eof_flags;
+                __entry->uid = xfs_kuid_to_uid(eofb->eof_uid);
+                __entry->gid = xfs_kgid_to_gid(eofb->eof_gid);
+                __entry->prid = eofb->eof_prid;
+                __entry->min_file_size = eofb->eof_min_file_size;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+                  __entry->flags,
+                  __entry->uid,
+                  __entry->gid,
+                  __entry->prid,
+                  __entry->min_file_size,
+		  (char *)__entry->caller_ip)
+);
+#define DEFINE_EOFBLOCKS_EVENT(name)	\
+DEFINE_EVENT(xfs_eofblocks_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, eofb, caller_ip))
+DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
+DEFINE_EOFBLOCKS_EVENT(xfs_inode_free_quota_blocks);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

