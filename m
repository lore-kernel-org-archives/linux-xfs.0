Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4E0C4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6843B21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ip1DJL3T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfIYVfk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:35:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38420 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbfIYVfj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:35:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYWf4058026;
        Wed, 25 Sep 2019 21:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=WXDhZ/Ed6LK/gDbkKf5JkoiTtfevjexVORsCqkzaPJY=;
 b=Ip1DJL3T8UlvxpoKAfVIFxrBw4F2RSeboJ+P1Yxo8ItASC//ynqWYFtV4GxiaDdk0OGF
 PXotVQ3IyChgm9C2zgddHEXcqNy3dqxB532JEZQRdmujNamD8B43O47zreDJFdhWLpmx
 mu+59Lhm4twEMphEtpTv476fttocSArrLeoYIiX7pIkDuMUnWNnx3uXjFlmK1+/mePP3
 GjEV7HQORbG391RJafkJLty372UwcVtaA1TAJxsHfcDnzfUUIit7fDAGOT46nhwTeGbw
 KJp6s0xiTrvEnEAwiwJYY9lVDHEk2jTAr3oIQGN6uYAiIwaeBUYKk/b02PSA3oGpGalv IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tyh4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYOfk023662;
        Wed, 25 Sep 2019 21:35:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuqjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:36 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLZZbA015694;
        Wed, 25 Sep 2019 21:35:35 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:35:35 -0700
Subject: [PATCH 06/11] xfs_scrub: refactor inode prefix rendering code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:35:33 -0700
Message-ID: <156944733375.298887.14903136321208702854.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the places in the code where we try to render an inode
number as a prefix for some sort of status message.  This will help make
message prefixes more consistent, which should help users to locate
broken metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 scrub/common.h |    6 ++++++
 scrub/inodes.c |    4 ++--
 scrub/phase3.c |    8 ++------
 scrub/phase5.c |    8 ++------
 scrub/phase6.c |    6 +++---
 scrub/scrub.c  |   17 +++++++++--------
 7 files changed, 71 insertions(+), 25 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 7db47044..a814f568 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -354,3 +354,50 @@ within_range(
 
 	return true;
 }
+
+/*
+ * Render an inode number as both the raw inode number and as an AG number
+ * and AG inode pair.  This is intended for use with status message reporting.
+ * If @format is not NULL, it should provide any desired leading whitespace.
+ *
+ * For example, "inode 287232352 (13/352) <suffix>: <status message>"
+ */
+int
+scrub_render_ino_suffix(
+	const struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen,
+	uint64_t		ino,
+	uint32_t		gen,
+	const char		*format,
+	...)
+{
+	va_list			args;
+	uint32_t		agno;
+	uint32_t		agino;
+	int			ret;
+
+	agno = cvt_ino_to_agno(&ctx->mnt, ino);
+	agino = cvt_ino_to_agino(&ctx->mnt, ino);
+	ret = snprintf(buf, buflen, _("inode %"PRIu64" (%"PRIu32"/%"PRIu32")"),
+			ino, agno, agino);
+	if (ret < 0 || ret >= buflen || format == NULL)
+		return ret;
+
+	va_start(args, format);
+	ret += vsnprintf(buf + ret, buflen - ret, format, args);
+	va_end(args);
+	return ret;
+}
+
+/* Render an inode number for message reporting with no suffix. */
+int
+scrub_render_ino(
+	const struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen,
+	uint64_t		ino,
+	uint32_t		gen)
+{
+	return scrub_render_ino_suffix(ctx, buf, buflen, ino, gen, NULL);
+}
diff --git a/scrub/common.h b/scrub/common.h
index 33555891..1b9ad48f 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -86,4 +86,10 @@ bool within_range(struct scrub_ctx *ctx, unsigned long long value,
 		unsigned long long desired, unsigned long long abs_threshold,
 		unsigned int n, unsigned int d, const char *descr);
 
+int scrub_render_ino_suffix(const struct scrub_ctx *ctx, char *buf,
+		size_t buflen, uint64_t ino, uint32_t gen,
+		const char *format, ...);
+int scrub_render_ino(const struct scrub_ctx *ctx, char *buf,
+		size_t buflen, uint64_t ino, uint32_t gen);
+
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/inodes.c b/scrub/inodes.c
index c459a3b4..bfc0a1e9 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -159,8 +159,8 @@ xfs_iterate_inodes_ag(
 					ireq->hdr.ino = inumbers->xi_startino;
 					goto igrp_retry;
 				}
-				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
-						(uint64_t)bs->bs_ino);
+				scrub_render_ino(ctx, idescr, DESCR_BUFSZ,
+						bs->bs_ino, bs->bs_gen);
 				str_info(ctx, idescr,
 _("Changed too many times during scan; giving up."));
 				break;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 1e908c2c..48bcc21c 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -48,14 +48,10 @@ xfs_scrub_inode_vfs_error(
 	struct xfs_bulkstat	*bstat)
 {
 	char			descr[DESCR_BUFSZ];
-	xfs_agnumber_t		agno;
-	xfs_agino_t		agino;
 	int			old_errno = errno;
 
-	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
-	agino = cvt_ino_to_agino(&ctx->mnt, bstat->bs_ino);
-	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
-			(uint64_t)bstat->bs_ino, agno, agino);
+	scrub_render_ino(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
+			bstat->bs_gen);
 	errno = old_errno;
 	str_errno(ctx, descr);
 }
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 99cd51b2..997c88d9 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -234,15 +234,11 @@ xfs_scrub_connections(
 	bool			*pmoveon = arg;
 	char			descr[DESCR_BUFSZ];
 	bool			moveon = true;
-	xfs_agnumber_t		agno;
-	xfs_agino_t		agino;
 	int			fd = -1;
 	int			error;
 
-	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
-	agino = cvt_ino_to_agino(&ctx->mnt, bstat->bs_ino);
-	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
-			(uint64_t)bstat->bs_ino, agno, agino);
+	scrub_render_ino(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
+			bstat->bs_gen);
 	background_sleep();
 
 	/* Warn about naming problems in xattrs. */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 8063d6ce..4554af9a 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -180,15 +180,15 @@ xfs_report_verify_inode(
 	int				fd;
 	int				error;
 
-	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (unlinked)"),
-			(uint64_t)bstat->bs_ino);
-
 	/* Ignore linked files and things we can't open. */
 	if (bstat->bs_nlink != 0)
 		return 0;
 	if (!S_ISREG(bstat->bs_mode) && !S_ISDIR(bstat->bs_mode))
 		return 0;
 
+	scrub_render_ino_suffix(ctx, descr, DESCR_BUFSZ,
+			bstat->bs_ino, bstat->bs_gen, _(" (unlinked)"));
+
 	/* Try to open the inode. */
 	fd = xfs_open_handle(handle);
 	if (fd < 0) {
diff --git a/scrub/scrub.c b/scrub/scrub.c
index d7a6b49b..32c15dea 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -26,11 +26,13 @@
 /* Format a scrub description. */
 static void
 format_scrub_descr(
+	struct scrub_ctx		*ctx,
 	char				*buf,
 	size_t				buflen,
-	struct xfs_scrub_metadata	*meta,
-	const struct xfrog_scrub_descr	*sc)
+	struct xfs_scrub_metadata	*meta)
 {
+	const struct xfrog_scrub_descr	*sc = &xfrog_scrubbers[meta->sm_type];
+
 	switch (sc->type) {
 	case XFROG_SCRUB_TYPE_AGHEADER:
 	case XFROG_SCRUB_TYPE_PERAG:
@@ -38,8 +40,9 @@ format_scrub_descr(
 				_(sc->descr));
 		break;
 	case XFROG_SCRUB_TYPE_INODE:
-		snprintf(buf, buflen, _("Inode %"PRIu64" %s"),
-				(uint64_t)meta->sm_ino, _(sc->descr));
+		scrub_render_ino_suffix(ctx, buf, buflen,
+				meta->sm_ino, meta->sm_gen, " %s",
+				_(sc->descr));
 		break;
 	case XFROG_SCRUB_TYPE_FS:
 		snprintf(buf, buflen, _("%s"), _(sc->descr));
@@ -123,8 +126,7 @@ xfs_check_metadata(
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
-	format_scrub_descr(buf, DESCR_BUFSZ, meta,
-			&xfrog_scrubbers[meta->sm_type]);
+	format_scrub_descr(ctx, buf, DESCR_BUFSZ, meta);
 
 	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
 retry:
@@ -681,8 +683,7 @@ xfs_repair_metadata(
 		return CHECK_RETRY;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
-	format_scrub_descr(buf, DESCR_BUFSZ, &meta,
-			&xfrog_scrubbers[meta.sm_type]);
+	format_scrub_descr(ctx, buf, DESCR_BUFSZ, &meta);
 
 	if (needs_repair(&meta))
 		str_info(ctx, buf, _("Attempting repair."));

