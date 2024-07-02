Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDD2393
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881703; cv=none; b=ZDxbqJ+bPM4STh0EKQ3jQVwQoXsSjmG1nNGGJRujI/xU14ZHb0WfFbcnnh7PkruEEbvlR8qmbAl8ztbzab2pMyKKiVO7EHRI2IQbT9+XEe1PXEdeK2Jss9XseZNhXwZMGuHQn1xPQ5DAoQMYa9uPtMZgeR3v20YFHvLfM161LuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881703; c=relaxed/simple;
	bh=NXGpydbxye97G+m7PSTVceX8+QzEJpOD7ffs2tpd9jY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7enYEjZkeSPOR5m8mgM37rzHobk4dDOXP5bGCTK+rCrgkcNLFEGIi6eBz8ah8CHmUlkBtDM0cBIemnmijIRW+GrvL2Q/TPPkCGjbhtKga4sS5Z+VXC4iMXXDibKhaV7OmTbY3JfhcWxJ1QVBObrkIIFDKUeYHpaPig+NRgz5Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqI+kH5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqI+kH5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1C1C116B1;
	Tue,  2 Jul 2024 00:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881703;
	bh=NXGpydbxye97G+m7PSTVceX8+QzEJpOD7ffs2tpd9jY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nqI+kH5nb5nnpElgUJHqlUJ2l7ccvt2/mboKk9aWV7/vDwMx2fDT3DkJx41cQgg44
	 X1sfcJl/nQX4d5txU10Y5wlrme0AP2Ms/VRuySj02YULNQRLvV00kHPiKJ6nKPnFR6
	 BXg0mmuEZxYyZlcmDQUy/cUUNL9AFg/c70lIWfdIV6R2QyktCO3CC7GF1o5x0zRc18
	 t0kykmq3aUaX0YZH+P7ipVS0ZUmTtKp5AEknnLaooIbewXj61DaRbw3CB7Q47IPiFm
	 sXhe43CVrDuGzIa/dIdJ0taJKdDwvDop77eLGH9h5Ws6A4slRX8AvTR44I+OhhDTXN
	 qWtGvE3kpLffQ==
Date: Mon, 01 Jul 2024 17:55:02 -0700
Subject: [PATCH 06/12] xfs_logprint: support dumping exchmaps log items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116801.2006519.17657789199852782439.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
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

Support dumping exchmaps log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_misc.c      |   11 ++++
 logprint/log_print_all.c |   12 ++++
 logprint/log_redo.c      |  128 ++++++++++++++++++++++++++++++++++++++++++++++
 logprint/logprint.h      |    6 ++
 4 files changed, 157 insertions(+)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 9d38113402f4..8e86ac347fa9 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1052,6 +1052,17 @@ xlog_print_record(
 					be32_to_cpu(op_head->oh_len));
 			break;
 		    }
+		    case XFS_LI_XMI: {
+			skip = xlog_print_trans_xmi(&ptr,
+					be32_to_cpu(op_head->oh_len),
+					continued);
+			break;
+		    }
+		    case XFS_LI_XMD: {
+			skip = xlog_print_trans_xmd(&ptr,
+					be32_to_cpu(op_head->oh_len));
+			break;
+		    }
 		    case XFS_LI_QUOTAOFF: {
 			skip = xlog_print_trans_qoff(&ptr,
 					be32_to_cpu(op_head->oh_len));
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index f436e10917d8..a4a5e41f17fa 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -440,6 +440,12 @@ xlog_recover_print_logitem(
 	case XFS_LI_BUI:
 		xlog_recover_print_bui(item);
 		break;
+	case XFS_LI_XMD:
+		xlog_recover_print_xmd(item);
+		break;
+	case XFS_LI_XMI:
+		xlog_recover_print_xmi(item);
+		break;
 	case XFS_LI_DQUOT:
 		xlog_recover_print_dquot(item);
 		break;
@@ -498,6 +504,12 @@ xlog_recover_print_item(
 	case XFS_LI_BUI:
 		printf("BUI");
 		break;
+	case XFS_LI_XMD:
+		printf("XMD");
+		break;
+	case XFS_LI_XMI:
+		printf("XMI");
+		break;
 	case XFS_LI_DQUOT:
 		printf("DQ ");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index edf7e0fbfa90..ca6dadd7551a 100644
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
+xfs_xmi_copy_format(
+	struct xfs_xmi_log_format *xmi,
+	uint			  len,
+	struct xfs_xmi_log_format *dst_fmt,
+	int			  continued)
+{
+	if (len == sizeof(struct xfs_xmi_log_format) || continued) {
+		memcpy(dst_fmt, xmi, len);
+		return 0;
+	}
+	fprintf(stderr, _("%s: bad size of XMI format: %u; expected %zu\n"),
+		progname, len, sizeof(struct xfs_xmi_log_format));
+	return 1;
+}
+
+int
+xlog_print_trans_xmi(
+	char			**ptr,
+	uint			src_len,
+	int			continued)
+{
+	struct xfs_xmi_log_format *src_f, *f = NULL;
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
+	if (continued && src_len < sizeof(struct xfs_xmi_log_format)) {
+		printf(_("XMI: Not enough data to decode further\n"));
+		error = 1;
+		goto error;
+	}
+
+	f = malloc(sizeof(struct xfs_xmi_log_format));
+	if (f == NULL) {
+		fprintf(stderr, _("%s: %s: malloc failed\n"),
+			progname, __func__);
+		exit(1);
+	}
+	if (xfs_xmi_copy_format(src_f, src_len, f, continued)) {
+		error = 1;
+		goto error;
+	}
+
+	printf(_("XMI:  #regs: %d	num_extents: 1  id: 0x%llx\n"),
+		f->xmi_size, (unsigned long long)f->xmi_id);
+
+	if (continued) {
+		printf(_("XMI extent data skipped (CONTINUE set, no space)\n"));
+		goto error;
+	}
+
+	printf("(ino1: 0x%llx, igen1: 0x%x, ino2: 0x%llx, igen2: 0x%x, off1: %lld, off2: %lld, len: %lld, flags: 0x%llx)\n",
+		(unsigned long long)f->xmi_inode1,
+		(unsigned int)f->xmi_igen1,
+		(unsigned long long)f->xmi_inode2,
+		(unsigned int)f->xmi_igen2,
+		(unsigned long long)f->xmi_startoff1,
+		(unsigned long long)f->xmi_startoff2,
+		(unsigned long long)f->xmi_blockcount,
+		(unsigned long long)f->xmi_flags);
+error:
+	free(src_f);
+	free(f);
+	return error;
+}
+
+void
+xlog_recover_print_xmi(
+	struct xlog_recover_item	*item)
+{
+	char				*src_f;
+	uint				src_len;
+
+	src_f = item->ri_buf[0].i_addr;
+	src_len = item->ri_buf[0].i_len;
+
+	xlog_print_trans_xmi(&src_f, src_len, 0);
+}
+
+int
+xlog_print_trans_xmd(
+	char				**ptr,
+	uint				len)
+{
+	struct xfs_xmd_log_format	*f;
+	struct xfs_xmd_log_format	lbuf;
+
+	/* size without extents at end */
+	uint core_size = sizeof(struct xfs_xmd_log_format);
+
+	memcpy(&lbuf, *ptr, min(core_size, len));
+	f = &lbuf;
+	*ptr += len;
+	if (len >= core_size) {
+		printf(_("XMD:  #regs: %d	                 id: 0x%llx\n"),
+			f->xmd_size,
+			(unsigned long long)f->xmd_xmi_id);
+
+		/* don't print extents as they are not used */
+
+		return 0;
+	} else {
+		printf(_("XMD: Not enough data to decode further\n"));
+		return 1;
+	}
+}
+
+void
+xlog_recover_print_xmd(
+	struct xlog_recover_item	*item)
+{
+	char				*f;
+
+	f = item->ri_buf[0].i_addr;
+	xlog_print_trans_xmd(&f, sizeof(struct xfs_xmd_log_format));
+}
diff --git a/logprint/logprint.h b/logprint/logprint.h
index b4479c240d94..8867b110ecaf 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -65,4 +65,10 @@ extern void xlog_recover_print_attri(struct xlog_recover_item *item);
 extern int xlog_print_trans_attrd(char **ptr, uint len);
 extern void xlog_recover_print_attrd(struct xlog_recover_item *item);
 extern void xlog_print_op_header(xlog_op_header_t *op_head, int i, char **ptr);
+
+extern int xlog_print_trans_xmi(char **ptr, uint src_len, int continued);
+extern void xlog_recover_print_xmi(struct xlog_recover_item *item);
+extern int xlog_print_trans_xmd(char **ptr, uint len);
+extern void xlog_recover_print_xmd(struct xlog_recover_item *item);
+
 #endif	/* LOGPRINT_H */

