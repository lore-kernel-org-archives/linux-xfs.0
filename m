Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF429ECE58F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 23:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF9842067B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 23:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfJOXZN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 19:25:13 -0400
Received: from sandeen.net ([63.231.237.45]:58354 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfJOXZN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 19:25:13 -0400
Received: from Liberator-6.local (c-174-53-190-166.hsd1.mn.comcast.net [174.53.190.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B13CE7BDB;
        Tue, 15 Oct 2019 18:24:34 -0500 (CDT)
Subject: Re: [PATCH 06/11] xfs_scrub: refactor inode prefix rendering code
From:   Eric Sandeen <sandeen@sandeen.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
 <156944733375.298887.14903136321208702854.stgit@magnolia>
 <0afea659-939d-d82b-67ea-b2742748921c@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <a4cd281d-8d05-debe-1af9-1192770c6cd1@sandeen.net>
Date:   Tue, 15 Oct 2019 18:25:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0afea659-939d-d82b-67ea-b2742748921c@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

How about this:

Refactor all the places in the code where we try to render an inode
number as a prefix for some sort of status message.  This will help make
message prefixes more consistent, which should help users to locate
broken metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[sandeen: swizzle stuff]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

this uses a single function, scrub_render_ino_descr() with a new comment,
and automatic space-adding for any extra format.


diff --git a/scrub/common.c b/scrub/common.c
index 7db47044..7f971de8 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -354,3 +354,38 @@ within_range(
 
 	return true;
 }
+
+/*
+ * Render an inode number into a buffer in a format suitable for use as a
+ * prefix for log messages. The buffer will be filled with:
+ * 	"inode <inode number> (<ag number>/<ag inode number>)"
+ * If the @format argument is non-NULL, it will be rendered into the buffer
+ * after the inode representation and a single space.
+ */
+int
+scrub_render_ino_descr(
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
+	ret = snprintf(buf, buflen, _("inode %"PRIu64" (%"PRIu32"/%"PRIu32")%s"),
+			ino, agno, agino, format ? " " : "");
+	if (ret < 0 || ret >= buflen || format == NULL)
+		return ret;
+
+	va_start(args, format);
+	ret += vsnprintf(buf + ret, buflen - ret, format, args);
+	va_end(args);
+	return ret;
+}
diff --git a/scrub/common.h b/scrub/common.h
index 33555891..9a37e9ed 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -86,4 +86,8 @@ bool within_range(struct scrub_ctx *ctx, unsigned long long value,
 		unsigned long long desired, unsigned long long abs_threshold,
 		unsigned int n, unsigned int d, const char *descr);
 
+int scrub_render_ino_descr(const struct scrub_ctx *ctx, char *buf,
+		size_t buflen, uint64_t ino, uint32_t gen,
+		const char *format, ...);
+
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 91632b55..7aa61ebe 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -159,8 +159,8 @@ xfs_iterate_inodes_ag(
 					ireq->hdr.ino = inumbers->xi_startino;
 					goto igrp_retry;
 				}
-				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
-						(uint64_t)bs->bs_ino);
+				scrub_render_ino_descr(ctx, idescr, DESCR_BUFSZ,
+						bs->bs_ino, bs->bs_gen, NULL);
 				str_info(ctx, idescr,
 _("Changed too many times during scan; giving up."));
 				break;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 1e908c2c..0d2c9019 100644
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
+	scrub_render_ino_descr(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
+			bstat->bs_gen, NULL);
 	errno = old_errno;
 	str_errno(ctx, descr);
 }
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 99cd51b2..27941907 100644
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
+	scrub_render_ino_descr(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
+			bstat->bs_gen, NULL);
 	background_sleep();
 
 	/* Warn about naming problems in xattrs. */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 8063d6ce..2ce2a19e 100644
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
 
+	scrub_render_ino_descr(ctx, descr, DESCR_BUFSZ,
+			bstat->bs_ino, bstat->bs_gen, _("(unlinked)"));
+
 	/* Try to open the inode. */
 	fd = xfs_open_handle(handle);
 	if (fd < 0) {
diff --git a/scrub/scrub.c b/scrub/scrub.c
index d7a6b49b..0293ce30 100644
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
+		scrub_render_ino_descr(ctx, buf, buflen,
+				meta->sm_ino, meta->sm_gen, "%s",
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

