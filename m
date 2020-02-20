Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9106DC7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6976021D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YD3KibpU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTBnY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:43:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBnX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:43:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hMop064466;
        Thu, 20 Feb 2020 01:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/LHKTr/3CJR4mpDuh1+rpiWp71PZnEz1J8xYZrz6Pt0=;
 b=YD3KibpUEnuqO3o8HcB0+7TCjwxrmVkf2RkbXC+JSvwGnfnpS1zUqoaxkFue/Rw5BUoG
 7AHrkklAaDVwfVsC+zmmjhVfySS0wj94W0N6EPp0xtv8Cck6H7zyarTPoktQJzt4uHVf
 naacra2wlPnUb3B/XzbrygI75qxNzPMbD2AC//KyJyMndlPehG5dzcJ3mYkTeaMPYF/F
 Q2Lf3GCSMnqZet00glAln9NQl0XE3nF2tlMU+UFRtuShbGvSNP8ycy23jJlJgLxT/iCD
 1jgA3nTQwfDRwZ0p3d2VcRe9B8upSOT2ZdxG7G64TrQHWSytu1QkAlcPAuUhlV7UlATA Tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y8udket00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gCAP188971;
        Thu, 20 Feb 2020 01:43:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8ud972jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1hKNd006311;
        Thu, 20 Feb 2020 01:43:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:43:20 -0800
Subject: [PATCH 07/18] libxfs: make libxfs_bwrite do what libxfs_writebufr
 does
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:43:19 -0800
Message-ID: <158216299927.602314.10659390054898124986.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make libxfs_bwrite equivalent to libxfs_writebufr.  This makes it so
that libxfs bwrite calls write the buffer to disk immediately and
without double-freeing the buffer.  However, we choose to consolidate
around the libxfs_bwrite name to match the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/io.c                  |    4 ++--
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_io.h       |    2 +-
 libxfs/libxfs_priv.h     |    1 -
 libxfs/rdwr.c            |   11 ++++++-----
 5 files changed, 10 insertions(+), 9 deletions(-)


diff --git a/db/io.c b/db/io.c
index 163ccc89..7c7a4624 100644
--- a/db/io.c
+++ b/db/io.c
@@ -426,7 +426,7 @@ write_cur_buf(void)
 {
 	int ret;
 
-	ret = -libxfs_writebufr(iocur_top->bp);
+	ret = -libxfs_bwrite(iocur_top->bp);
 	if (ret != 0)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
@@ -442,7 +442,7 @@ write_cur_bbs(void)
 {
 	int ret;
 
-	ret = -libxfs_writebufr(iocur_top->bp);
+	ret = -libxfs_bwrite(iocur_top->bp);
 	if (ret != 0)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 57cf5f83..df267c98 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -48,6 +48,7 @@
 #define xfs_buf_read			libxfs_buf_read
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_bunmapi			libxfs_bunmapi
+#define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
 #define xfs_da_get_buf			libxfs_da_get_buf
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 9484c627..f00ff8d3 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -222,7 +222,7 @@ extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
 extern void	libxfs_putbufr(xfs_buf_t *);
 
 extern int	libxfs_writebuf_int(xfs_buf_t *, int);
-extern int	libxfs_writebufr(struct xfs_buf *);
+int		libxfs_bwrite(struct xfs_buf *);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
 extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 0f26120f..5d6dd063 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -377,7 +377,6 @@ roundup_64(uint64_t x, uint32_t y)
 	(len) = __bar; /* no set-but-unused warning */	\
 	NULL;						\
 })
-#define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 
 #define XBRW_READ			LIBXFS_BREAD
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index ea2f4a13..2a4ef15a 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1091,9 +1091,10 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
 }
 
 int
-libxfs_writebufr(xfs_buf_t *bp)
+libxfs_bwrite(
+	struct xfs_buf	*bp)
 {
-	int	fd = libxfs_device_to_fd(bp->b_target->dev);
+	int		fd = libxfs_device_to_fd(bp->b_target->dev);
 
 	/*
 	 * we never write buffers that are marked stale. This indicates they
@@ -1303,7 +1304,7 @@ libxfs_bflush(
 	struct xfs_buf		*bp = (struct xfs_buf *)node;
 
 	if (!bp->b_error && bp->b_flags & LIBXFS_B_DIRTY)
-		return libxfs_writebufr(bp);
+		return libxfs_bwrite(bp);
 	return bp->b_error;
 }
 
@@ -1311,7 +1312,7 @@ void
 libxfs_putbufr(xfs_buf_t *bp)
 {
 	if (bp->b_flags & LIBXFS_B_DIRTY)
-		libxfs_writebufr(bp);
+		libxfs_bwrite(bp);
 	libxfs_brelse((struct cache_node *)bp);
 }
 
@@ -1524,7 +1525,7 @@ xfs_buf_delwri_submit(
 
 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
 		list_del_init(&bp->b_list);
-		error2 = libxfs_writebufr(bp);
+		error2 = libxfs_bwrite(bp);
 		if (!error)
 			error = error2;
 		libxfs_buf_relse(bp);

