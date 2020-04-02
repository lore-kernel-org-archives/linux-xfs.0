Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F7BC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 04:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3D3620757
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 04:17:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LLC2BdVd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgDBERK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 00:17:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgDBERK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 00:17:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03249dxe101827
        for <linux-xfs@vger.kernel.org>; Thu, 2 Apr 2020 04:17:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=4nfYOqC+bE3cpAfcSk71GeSWYGENH7xxUSFyuvtC9oA=;
 b=LLC2BdVdlnR2AYNRqYd8qCHKki8OSYeAW8AyaJYmhdoO6s7NT6XUDskVsoez9BeAVqjQ
 7/7Zh8WpLd4OTOw4HopL8tvnDOdughYjRmYotDNjD4q3Ze+kKuA1KXY26XRttfNoMHxN
 CQ9jJjpAmevJUi/GLaXl7yZnS4HHUHIQBPjqvllM3vGS0gt3bx0uTZ4lTz/FSGsjwQK9
 +LYNDrpmun1BsAJbiiXs5G/5z2CFLGw/8pP5OW1sk1SVwPRJRUb1fIgsHGpVqRtywvLy
 6UPE+Ey/E2FPxA07NNKyXzGemR+0LM2UqwEvBkkUMII7h+cePlkRssaLzLrtVey4Bk26 Eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 303yunbk5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Apr 2020 04:17:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03248OVU184034
        for <linux-xfs@vger.kernel.org>; Thu, 2 Apr 2020 04:17:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 302g4uu20v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Apr 2020 04:17:08 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0324H6n8025906
        for <linux-xfs@vger.kernel.org>; Thu, 2 Apr 2020 04:17:06 GMT
Received: from localhost (/10.159.142.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Apr 2020 21:17:06 -0700
Date:   Wed, 1 Apr 2020 21:17:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: reflink should force the log out if mounted with wsync
Message-ID: <20200402041705.GD80283@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020036
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Reflink should force the log out to disk if the filesystem was mounted
with wsync, the same as most other operations in xfs.

Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c    |   21 +++++++++++++++++++--
 fs/xfs/xfs_reflink.c |   15 ++++++++++++++-
 fs/xfs/xfs_reflink.h |    3 ++-
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b8a4a3f29b36..17bdc5bbc2ae 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1029,8 +1029,10 @@ xfs_file_remap_range(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	struct xfs_mount	*mp = src->i_mount;
+	xfs_lsn_t		sync_lsn = 0;
 	loff_t			remapped = 0;
 	xfs_extlen_t		cowextsize;
+	bool			need_sync;
 	int			ret;
 
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
@@ -1068,13 +1070,28 @@ xfs_file_remap_range(
 		cowextsize = src->i_d.di_cowextsize;
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
-			remap_flags);
+			remap_flags, &need_sync);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * If this is a synchronous mount and xfs_reflink_update_dest didn't
+	 * already take care of this, make sure that the transaction goes to
+	 * disk before returning to the user.
+	 */
+	if (need_sync && xfs_ipincount(dest))
+		sync_lsn = dest->i_itemp->ili_last_lsn;
 
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
-	return remapped > 0 ? remapped : ret;
+	if (remapped > 0) {
+		if (sync_lsn)
+			xfs_log_force_lsn(mp, sync_lsn, XFS_LOG_SYNC, NULL);
+		return remapped;
+	}
+	return ret;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b0ce04ffd3cd..4f148d58ff98 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -919,12 +919,19 @@ xfs_reflink_update_dest(
 	struct xfs_inode	*dest,
 	xfs_off_t		newlen,
 	xfs_extlen_t		cowextsize,
-	unsigned int		remap_flags)
+	unsigned int		remap_flags,
+	bool			*need_sync)
 {
 	struct xfs_mount	*mp = dest->i_mount;
 	struct xfs_trans	*tp;
 	int			error;
 
+	/*
+	 * If this is a synchronous mount, make sure that the
+	 * transaction goes to disk before returning to the user.
+	 */
+	*need_sync = (mp->m_flags & XFS_MOUNT_WSYNC);
+
 	if (newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
 		return 0;
 
@@ -948,6 +955,12 @@ xfs_reflink_update_dest(
 
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 
+	/* We can force the transaction to disk here. */
+	if (*need_sync) {
+		xfs_trans_set_sync(tp);
+		*need_sync = false;
+	}
+
 	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_error;
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 3e4fd46373ab..e9b505e0ad7a 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -55,7 +55,8 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
 		struct xfs_inode *dest, loff_t pos_out, loff_t remap_len,
 		loff_t *remapped);
 extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
-		xfs_extlen_t cowextsize, unsigned int remap_flags);
+		xfs_extlen_t cowextsize, unsigned int remap_flags,
+		bool *need_sync);
 extern void xfs_reflink_remap_unlock(struct file *file_in,
 		struct file *file_out);
 
