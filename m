Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BDCC8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ngfjfs/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765B6C433C8;
	Sun, 31 Dec 2023 22:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061858;
	bh=LS9EeKH1LyN2PoHSOlGOZNdF2qy/kZ9oK2/N/zFYqkA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ngfjfs/CC7vxdMu8WLn7UWT7SQYtKzdZt1+cR9WpQvAmhu1H7JYig7phtTaVyiEM4
	 5ZWwr3DwE1ohvzNLhBkhclj32S4PKObtyuZuBLwKYxvda/SXbg6Ita/Gz4nBUZClvm
	 WndH6CGrpUzcvu4nijAtnicZUG1RJ5hjMTXVh8CJYIXOYJ7bVelwvZxQrp2aFDAYmb
	 sjYVC1YH1AtOAVYzDad1vLmjACd3wtABQDtFJX+gG9Kdhh7dPQXs7Yam0vZkqeOd4C
	 GSOZ/KoAVqDmbT8rQM0zkPX5W1qOjGiflO1XVZgHIoWApH2TTlxPzdH5x/8xAD9Q5p
	 ZRKORKZgI/w3Q==
Date: Sun, 31 Dec 2023 14:30:57 -0800
Subject: [PATCH 15/20] xfs_logprint: support dumping swapext log items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996475.1796128.2613882333794931172.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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

