Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AB8C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F8420838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XafBsn2/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgBYAMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:12:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48264 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:12:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07lkI050164;
        Tue, 25 Feb 2020 00:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iIJPcUjs7l2B7EfsgbcPdDpjVw6iO+CkBIfhj7jOno0=;
 b=XafBsn2/wB+NGquBI4eWtIF9CUV9VZ9LFTA+9YPslGCRQJSdpUjFr7c/5W6wCMkgTs7w
 YETUrpkUP0x7GINZusKN6YtPp+CAK9736Vww4fZVu7xd7J8hHYdSQnujtVAuGrrH4qmU
 iDYBfXjq9TzSyTAbw16fy4ETZmCwHHZ2TFsZo5HSnA20kAotDwv41mT6RMUBAh5NTKhR
 2qdQPhXo9+gSat69+SmKjFo/AoGIiVw3Ym0sxbrTNCdhSNZrzEqi5lvs+czGTipePmE9
 YIT8QscyRk8KE8r0L3K73UVk3E6LkZRSPGX2WAg9skLyuSSOAiXyPgIbv+LQXkQIEagV wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07uEF109072;
        Tue, 25 Feb 2020 00:12:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ybe12epqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:15 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0CEAV031255;
        Tue, 25 Feb 2020 00:12:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:12:14 -0800
Subject: [PATCH 07/25] libxfs: rename libxfs_writebufr to libxfs_bwrite
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:12:13 -0800
Message-ID: <158258953343.451378.17961363922648690111.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename this function so that we have an API that matches the kernel
without a #define.

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
index 1b8318af..0370d685 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -220,7 +220,7 @@ extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
 extern void	libxfs_putbufr(xfs_buf_t *);
 
 extern int	libxfs_writebuf_int(xfs_buf_t *, int);
-extern int	libxfs_writebufr(struct xfs_buf *);
+int		libxfs_bwrite(struct xfs_buf *bp);
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
index fbd6f322..7100d4df 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1083,9 +1083,10 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
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
@@ -1294,7 +1295,7 @@ libxfs_bflush(
 	struct xfs_buf		*bp = (struct xfs_buf *)node;
 
 	if (!bp->b_error && bp->b_flags & LIBXFS_B_DIRTY)
-		return libxfs_writebufr(bp);
+		return libxfs_bwrite(bp);
 	return bp->b_error;
 }
 
@@ -1302,7 +1303,7 @@ void
 libxfs_putbufr(xfs_buf_t *bp)
 {
 	if (bp->b_flags & LIBXFS_B_DIRTY)
-		libxfs_writebufr(bp);
+		libxfs_bwrite(bp);
 	libxfs_brelse((struct cache_node *)bp);
 }
 
@@ -1515,7 +1516,7 @@ xfs_buf_delwri_submit(
 
 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
 		list_del_init(&bp->b_list);
-		error2 = libxfs_writebufr(bp);
+		error2 = libxfs_bwrite(bp);
 		if (!error)
 			error = error2;
 		libxfs_buf_relse(bp);

