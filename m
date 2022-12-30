Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE487C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbiLaAWZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbiLaAWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:22:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619C1BE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:22:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D79C7B81E7F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86056C433D2;
        Sat, 31 Dec 2022 00:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446140;
        bh=LS9EeKH1LyN2PoHSOlGOZNdF2qy/kZ9oK2/N/zFYqkA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cXRxKd+sChVNCyAGY82RNq2Trl7npLla5VvlUwI2LAL3D/6PjPBJCISxe68rfwkrU
         gl5/L5Hat/0RGF36/jBqLPoVCCYXotNi+K4Uxz5hAvy+Ch5um5NXgZ1k+ajyct49Sk
         oo12CQcXIq8eZG4Kp9gajW0U+GhGw5l5i1oZXjvRMJ4EdcQvVJiGumJrWVQg2oTPLY
         QW1aaZeRlV1TNaEH6knqE2UTBJnBJ42Eq1dzuGSRLGC6O2P2njSpp9TgpBMcYC4Ttm
         IP5g7DnSPDOQCbH38tzqUs55TBRTqgPp4McLuPcNIIAXTtjITSE/0F4f+5oBGIk9tA
         ouJVxEsI956aA==
Subject: [PATCH 14/19] xfs_logprint: support dumping swapext log items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:01 -0800
Message-ID: <167243868122.713817.2689187417030432747.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Support dumping swapext log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_misc.c      |   11 ++++
 logprint/log_print_all.c |   12 ++++
 logprint/log_redo.c      |  128 ++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |    6 ++
 4 files changed, 157 insertions(+)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 836156e0d58..565e7b76284 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1052,6 +1052,17 @@ xlog_print_record(
 					be32_to_cpu(op_head->oh_len));
 			break;
 		    }
+		    case XFS_LI_SXI: {
+			skip = xlog_print_trans_sxi(&ptr,
+					be32_to_cpu(op_head->oh_len),
+					continued);
+			break;
+		    }
+		    case XFS_LI_SXD: {
+			skip = xlog_print_trans_sxd(&ptr,
+					be32_to_cpu(op_head->oh_len));
+			break;
+		    }
 		    case XFS_LI_QUOTAOFF: {
 			skip = xlog_print_trans_qoff(&ptr,
 					be32_to_cpu(op_head->oh_len));
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 8d3ede190e5..6e528fcd097 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -440,6 +440,12 @@ xlog_recover_print_logitem(
 	case XFS_LI_BUI:
 		xlog_recover_print_bui(item);
 		break;
+	case XFS_LI_SXD:
+		xlog_recover_print_sxd(item);
+		break;
+	case XFS_LI_SXI:
+		xlog_recover_print_sxi(item);
+		break;
 	case XFS_LI_DQUOT:
 		xlog_recover_print_dquot(item);
 		break;
@@ -498,6 +504,12 @@ xlog_recover_print_item(
 	case XFS_LI_BUI:
 		printf("BUI");
 		break;
+	case XFS_LI_SXD:
+		printf("SXD");
+		break;
+	case XFS_LI_SXI:
+		printf("SXI");
+		break;
 	case XFS_LI_DQUOT:
 		printf("DQ ");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index edf7e0fbfa9..770485df75d 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -847,3 +847,131 @@ xlog_recover_print_attrd(
 		f->alfd_size,
 		(unsigned long long)f->alfd_alf_id);
 }
+
+/* Atomic Extent Swapping Items */
+
+static int
+xfs_sxi_copy_format(
+	struct xfs_sxi_log_format *sxi,
+	uint			  len,
+	struct xfs_sxi_log_format *dst_fmt,
+	int			  continued)
+{
+	if (len == sizeof(struct xfs_sxi_log_format) || continued) {
+		memcpy(dst_fmt, sxi, len);
+		return 0;
+	}
+	fprintf(stderr, _("%s: bad size of SXI format: %u; expected %zu\n"),
+		progname, len, sizeof(struct xfs_sxi_log_format));
+	return 1;
+}
+
+int
+xlog_print_trans_sxi(
+	char			**ptr,
+	uint			src_len,
+	int			continued)
+{
+	struct xfs_sxi_log_format *src_f, *f = NULL;
+	struct xfs_swap_extent	*ex;
+	int			error = 0;
+
+	src_f = malloc(src_len);
+	if (src_f == NULL) {
+		fprintf(stderr, _("%s: %s: malloc failed\n"),
+			progname, __func__);
+		exit(1);
+	}
+	memcpy(src_f, *ptr, src_len);
+	*ptr += src_len;
+
+	/* convert to native format */
+	if (continued && src_len < sizeof(struct xfs_sxi_log_format)) {
+		printf(_("SXI: Not enough data to decode further\n"));
+		error = 1;
+		goto error;
+	}
+
+	f = malloc(sizeof(struct xfs_sxi_log_format));
+	if (f == NULL) {
+		fprintf(stderr, _("%s: %s: malloc failed\n"),
+			progname, __func__);
+		exit(1);
+	}
+	if (xfs_sxi_copy_format(src_f, src_len, f, continued)) {
+		error = 1;
+		goto error;
+	}
+
+	printf(_("SXI:  #regs: %d	num_extents: 1  id: 0x%llx\n"),
+		f->sxi_size, (unsigned long long)f->sxi_id);
+
+	if (continued) {
+		printf(_("SXI extent data skipped (CONTINUE set, no space)\n"));
+		goto error;
+	}
+
+	ex = &f->sxi_extent;
+	printf("(ino1: 0x%llx, ino2: 0x%llx, off1: %lld, off2: %lld, len: %lld, flags: 0x%llx)\n",
+		(unsigned long long)ex->sx_inode1,
+		(unsigned long long)ex->sx_inode2,
+		(unsigned long long)ex->sx_startoff1,
+		(unsigned long long)ex->sx_startoff2,
+		(unsigned long long)ex->sx_blockcount,
+		(unsigned long long)ex->sx_flags);
+error:
+	free(src_f);
+	free(f);
+	return error;
+}
+
+void
+xlog_recover_print_sxi(
+	struct xlog_recover_item	*item)
+{
+	char				*src_f;
+	uint				src_len;
+
+	src_f = item->ri_buf[0].i_addr;
+	src_len = item->ri_buf[0].i_len;
+
+	xlog_print_trans_sxi(&src_f, src_len, 0);
+}
+
+int
+xlog_print_trans_sxd(
+	char				**ptr,
+	uint				len)
+{
+	struct xfs_sxd_log_format	*f;
+	struct xfs_sxd_log_format	lbuf;
+
+	/* size without extents at end */
+	uint core_size = sizeof(struct xfs_sxd_log_format);
+
+	memcpy(&lbuf, *ptr, min(core_size, len));
+	f = &lbuf;
+	*ptr += len;
+	if (len >= core_size) {
+		printf(_("SXD:  #regs: %d	                 id: 0x%llx\n"),
+			f->sxd_size,
+			(unsigned long long)f->sxd_sxi_id);
+
+		/* don't print extents as they are not used */
+
+		return 0;
+	} else {
+		printf(_("SXD: Not enough data to decode further\n"));
+		return 1;
+	}
+}
+
+void
+xlog_recover_print_sxd(
+	struct xlog_recover_item	*item)
+{
+	char				*f;
+
+	f = item->ri_buf[0].i_addr;
+	xlog_print_trans_sxd(&f, sizeof(struct xfs_sxd_log_format));
+}
diff --git a/logprint/logprint.h b/logprint/logprint.h
index b4479c240d9..892b280b548 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -65,4 +65,10 @@ extern void xlog_recover_print_attri(struct xlog_recover_item *item);
 extern int xlog_print_trans_attrd(char **ptr, uint len);
 extern void xlog_recover_print_attrd(struct xlog_recover_item *item);
 extern void xlog_print_op_header(xlog_op_header_t *op_head, int i, char **ptr);
+
+extern int xlog_print_trans_sxi(char **ptr, uint src_len, int continued);
+extern void xlog_recover_print_sxi(struct xlog_recover_item *item);
+extern int xlog_print_trans_sxd(char **ptr, uint len);
+extern void xlog_recover_print_sxd(struct xlog_recover_item *item);
+
 #endif	/* LOGPRINT_H */

