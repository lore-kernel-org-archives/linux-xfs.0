Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0475EC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C01772186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WK3DxMh5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfHZVag (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:30:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34186 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbfHZVag (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:30:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDl9M000864;
        Mon, 26 Aug 2019 21:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LYq1cn71QfBIPgVRv6wQtDmfV6hDom94Lr5EAinaMs4=;
 b=WK3DxMh5vN1UVN1fYGVEpUrQU9suZhQj5eUcY4KnyGygNt/YMFfXlgE8bl49k7wFJQfF
 Ydc2aX2sqxQxOkCJdcsOcD82uZXyhO5njlLoiG6fpOiDIhkEpDKvui32k8sqDCBBKrDp
 3hc9IGjouxpYa4qvK9Ac+SGhkSysBNSq3kIPnf6+GEOHezHkDWroDmHZX8wLa8JX1pPs
 fBGjJ1RORjpgRrjVGX6SLELhAeQjnc699Et0ed5udukMgJK6HmLbdRvfly7R9u4Zi6xp
 31xjXx7D26qT2MhvnGISQni04/xK+FU5f23wNYAbUdRwGEuK813qLEaTsw4k5/NtpXtK MQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umpxx05fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIR0Q025060;
        Mon, 26 Aug 2019 21:30:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2umj1tk7un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLUW11029045;
        Mon, 26 Aug 2019 21:30:32 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:30:32 -0700
Subject: [PATCH 06/11] xfs_scrub: refactor inode prefix rendering code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:30:29 -0700
Message-ID: <156685502969.2841898.11326261977295341282.stgit@magnolia>
In-Reply-To: <156685499099.2841898.18430382226915450537.stgit@magnolia>
References: <156685499099.2841898.18430382226915450537.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
 scrub/scrub.c  |   20 +++++++++++---------
 7 files changed, 73 insertions(+), 26 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 1cd2b7ba..fdbbf294 100644
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
+xfs_scrub_render_ino_suffix(
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
+	agno = xfrog_ino_to_agno(&ctx->mnt, ino);
+	agino = xfrog_ino_to_agino(&ctx->mnt, ino);
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
+xfs_scrub_render_ino(
+	const struct scrub_ctx	*ctx,
+	char			*buf,
+	size_t			buflen,
+	uint64_t		ino,
+	uint32_t		gen)
+{
+	return xfs_scrub_render_ino_suffix(ctx, buf, buflen, ino, gen, NULL);
+}
diff --git a/scrub/common.h b/scrub/common.h
index 33555891..b34cb4a6 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -86,4 +86,10 @@ bool within_range(struct scrub_ctx *ctx, unsigned long long value,
 		unsigned long long desired, unsigned long long abs_threshold,
 		unsigned int n, unsigned int d, const char *descr);
 
+int xfs_scrub_render_ino_suffix(const struct scrub_ctx *ctx, char *buf,
+		size_t buflen, uint64_t ino, uint32_t gen,
+		const char *format, ...);
+int xfs_scrub_render_ino(const struct scrub_ctx *ctx, char *buf,
+		size_t buflen, uint64_t ino, uint32_t gen);
+
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/inodes.c b/scrub/inodes.c
index ef12a692..8f4c5e83 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -156,8 +156,8 @@ xfs_iterate_inodes_ag(
 					ireq->hdr.ino = inogrp->xi_startino;
 					goto igrp_retry;
 				}
-				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
-						(uint64_t)bs->bs_ino);
+				xfs_scrub_render_ino(ctx, idescr, DESCR_BUFSZ,
+						bs->bs_ino, bs->bs_gen);
 				str_info(ctx, idescr,
 _("Changed too many times during scan; giving up."));
 				break;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 399f0e92..72e67d47 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -48,14 +48,10 @@ xfs_scrub_inode_vfs_error(
 	struct xfs_bulkstat	*bstat)
 {
 	char			descr[DESCR_BUFSZ];
-	xfs_agnumber_t		agno;
-	xfs_agino_t		agino;
 	int			old_errno = errno;
 
-	agno = xfrog_ino_to_agno(&ctx->mnt, bstat->bs_ino);
-	agino = xfrog_ino_to_agino(&ctx->mnt, bstat->bs_ino);
-	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
-			(uint64_t)bstat->bs_ino, agno, agino);
+	xfs_scrub_render_ino(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
+			bstat->bs_gen);
 	errno = old_errno;
 	str_errno(ctx, descr);
 }
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 335b0d19..224081d5 100644
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
 
-	agno = xfrog_ino_to_agno(&ctx->mnt, bstat->bs_ino);
-	agino = xfrog_ino_to_agino(&ctx->mnt, bstat->bs_ino);
-	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
-			(uint64_t)bstat->bs_ino, agno, agino);
+	xfs_scrub_render_ino(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
+			bstat->bs_gen);
 	background_sleep();
 
 	/* Warn about naming problems in xattrs. */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 86d848a0..fec25c31 100644
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
 
+	xfs_scrub_render_ino_suffix(ctx, descr, DESCR_BUFSZ,
+			bstat->bs_ino, bstat->bs_gen, _(" (unlinked)"));
+
 	/* Try to open the inode. */
 	fd = xfs_open_handle(handle);
 	if (fd < 0) {
diff --git a/scrub/scrub.c b/scrub/scrub.c
index a428b524..82beb7ad 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -92,24 +92,26 @@ static const struct scrub_descr scrubbers[XFS_SCRUB_TYPE_NR] = {
 /* Format a scrub description. */
 static void
 format_scrub_descr(
+	struct scrub_ctx		*ctx,
 	char				*buf,
 	size_t				buflen,
-	struct xfs_scrub_metadata	*meta,
-	const struct scrub_descr	*sc)
+	struct xfs_scrub_metadata	*meta)
 {
-	switch (sc->type) {
+	const struct scrub_descr	*sd = &scrubbers[meta->sm_type];
+
+	switch (sd->type) {
 	case ST_AGHEADER:
 	case ST_PERAG:
 		snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
-				_(sc->name));
+				_(sd->name));
 		break;
 	case ST_INODE:
-		snprintf(buf, buflen, _("Inode %"PRIu64" %s"),
-				(uint64_t)meta->sm_ino, _(sc->name));
+		xfs_scrub_render_ino_suffix(ctx, buf, buflen,
+				meta->sm_ino, meta->sm_gen, " %s", _(sd->name));
 		break;
 	case ST_FS:
 	case ST_SUMMARY:
-		snprintf(buf, buflen, _("%s"), _(sc->name));
+		snprintf(buf, buflen, _("%s"), _(sd->name));
 		break;
 	case ST_NONE:
 		assert(0);
@@ -191,7 +193,7 @@ xfs_check_metadata(
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
-	format_scrub_descr(buf, DESCR_BUFSZ, meta, &scrubbers[meta->sm_type]);
+	format_scrub_descr(ctx, buf, DESCR_BUFSZ, meta);
 
 	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
 retry:
@@ -749,7 +751,7 @@ xfs_repair_metadata(
 		return CHECK_RETRY;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
-	format_scrub_descr(buf, DESCR_BUFSZ, &meta, &scrubbers[meta.sm_type]);
+	format_scrub_descr(ctx, buf, DESCR_BUFSZ, &meta);
 
 	if (needs_repair(&meta))
 		str_info(ctx, buf, _("Attempting repair."));

