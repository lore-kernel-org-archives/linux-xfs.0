Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44703C7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 127BA21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QPrbpy7p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgBTBnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:43:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33828 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:43:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1heQw064553;
        Thu, 20 Feb 2020 01:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fHm36qQvvHZPSh/RJCc6EUNvl7O1RI/9jN3Ofxozx9A=;
 b=QPrbpy7pE/Zm+z0AlTj0riJGhWSIIeKsn12rGZG6K97mEL8Zkr52Rao2rd6pCD5c98Y4
 66Y3ZSV1sTXalF7v9d3On0Y3URKV8J5EwmJSjI2MTbpxSLjIbMmdzMdCTHONLKbTud8W
 NAl3lAZSighBgw4liBFZPsSvw0tKXeoBpjxVZl8Q162IGdOm19TVTeiyNCjDu+mKaXT6
 HVM2ROMQPdGQqsOJ2264YKMFrOe/ZuQS0yWhumLdA0wCcUYl+b39iA3jPZa3SaSlbBBU
 3BRvcIkNStiFBrLyiplM0QQR0MGPSeU7usumGh85XpkSRLRhVvlrZJaSCEWPQPZxBRD+ ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y8udket0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hdA9114447;
        Thu, 20 Feb 2020 01:43:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2y8ud2g3tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:39 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1hcFJ006370;
        Thu, 20 Feb 2020 01:43:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:43:38 -0800
Subject: [PATCH 10/18] libxfs: introduce libxfs_buf_read_uncached
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:43:37 -0800
Message-ID: <158216301746.602314.17789861786273491972.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=901 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=960 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce an uncached read function so that userspace can handle them in
the same way as the kernel.  This also eliminates the need for some of
the libxfs_purgebuf calls (and two trips into the cache code).

Refactor the get/read uncached buffer functions to hide the details of
uncached buffer-ism in rdwr.c.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 copy/xfs_copy.c          |   13 +++++++--
 db/init.c                |    9 +++---
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_io.h       |   22 +++------------
 libxfs/rdwr.c            |   67 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 88 insertions(+), 25 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index bb3ecd43..75c39407 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -562,6 +562,7 @@ main(int argc, char **argv)
 	libxfs_init_t	xargs;
 	thread_args	*tcarg;
 	struct stat	statbuf;
+	int		error;
 
 	progname = basename(argv[0]);
 
@@ -710,14 +711,20 @@ main(int argc, char **argv)
 
 	/* We don't yet know the sector size, so read maximal size */
 	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
-	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
-			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
+	error = -libxfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
+			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &sbp, NULL);
+	if (error) {
+		do_log(_("%s: couldn't read superblock, error=%d\n"),
+				progname, error);
+		exit(1);
+	}
+
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 
 	/* Do it again, now with proper length and verifier */
 	libxfs_buf_relse(sbp);
-	libxfs_purgebuf(sbp);
+
 	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			     1 << (sb->sb_sectlog - BBSHIFT),
 			     0, &xfs_sb_buf_ops);
diff --git a/db/init.c b/db/init.c
index acab349c..eb53d672 100644
--- a/db/init.c
+++ b/db/init.c
@@ -47,6 +47,7 @@ init(
 	struct xfs_buf	*bp;
 	unsigned int	agcount;
 	int		c;
+	int		error;
 
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -112,10 +113,9 @@ init(
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
 	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
-	bp = libxfs_buf_read(xmount.m_ddev_targp, XFS_SB_DADDR,
-			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
-
-	if (!bp || bp->b_error) {
+	error = -libxfs_buf_read_uncached(xmount.m_ddev_targp, XFS_SB_DADDR,
+			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
+	if (error) {
 		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
 			"bytes)\n"), progname, fsdevice);
 		exit(1);
@@ -124,7 +124,6 @@ init(
 	/* copy SB from buffer to in-core, converting architecture as we go */
 	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
 	libxfs_buf_relse(bp);
-	libxfs_purgebuf(bp);
 
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index df267c98..1149e301 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -45,7 +45,9 @@
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
+#define xfs_buf_get_uncached		libxfs_buf_get_uncached
 #define xfs_buf_read			libxfs_buf_read
+#define xfs_buf_read_uncached		libxfs_buf_read_uncached
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index b01f2896..546b7710 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -257,23 +257,11 @@ xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
 	return 0;
 }
 
-/*
- * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
- * and the cache node hash list will be empty to indicate that it's uncached.
- */
-static inline struct xfs_buf *
-xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
-{
-	struct xfs_buf	*bp;
-
-	bp = libxfs_getbufr(targ, XFS_BUF_DADDR_NULL, bblen);
-	if (!bp)
-		return NULL;
-
-	INIT_LIST_HEAD(&bp->b_node.cn_hash);
-	bp->b_node.cn_count = 1;
-	return bp;
-}
+struct xfs_buf *libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen,
+		int flags);
+int libxfs_buf_read_uncached(struct xfs_buftarg *targ, xfs_daddr_t daddr,
+		size_t bblen, int flags, struct xfs_buf **bpp,
+		const struct xfs_buf_ops *ops);
 
 /* Push a single buffer on a delwri queue. */
 static inline void
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 51f93c3e..ada20dd9 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1070,6 +1070,73 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 	return bp;
 }
 
+/* Allocate a raw uncached buffer. */
+static inline struct xfs_buf *
+libxfs_getbufr_uncached(
+	struct xfs_buftarg	*targ,
+	xfs_daddr_t		daddr,
+	size_t			bblen)
+{
+	struct xfs_buf		*bp;
+
+	bp = libxfs_getbufr(targ, daddr, bblen);
+	if (!bp)
+		return NULL;
+
+	INIT_LIST_HEAD(&bp->b_node.cn_hash);
+	bp->b_node.cn_count = 1;
+	return bp;
+}
+
+/*
+ * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
+ * and the cache node hash list will be empty to indicate that it's uncached.
+ */
+struct xfs_buf *
+libxfs_buf_get_uncached(
+	struct xfs_buftarg	*targ,
+	size_t			bblen,
+	int			flags)
+{
+	return libxfs_getbufr_uncached(targ, XFS_BUF_DADDR_NULL, bblen);
+}
+
+/*
+ * Allocate and read an uncached buffer.  The refcount will be 1, and the cache
+ * node hash list will be empty to indicate that it's uncached.
+ */
+int
+libxfs_buf_read_uncached(
+	struct xfs_buftarg	*targ,
+	xfs_daddr_t		daddr,
+	size_t			bblen,
+	int			flags,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	*bpp = NULL;
+	bp = libxfs_getbufr_uncached(targ, daddr, bblen);
+	if (!bp)
+		return -ENOMEM;
+
+	error = libxfs_readbufr(targ, daddr, bp, bblen, flags);
+	if (error)
+		goto err;
+
+	error = libxfs_readbuf_verify(bp, ops);
+	if (error)
+		goto err;
+
+	*bpp = bp;
+	return 0;
+err:
+	libxfs_buf_relse(bp);
+	return error;
+}
+
 static int
 __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
 {

