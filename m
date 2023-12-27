Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35B87F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDg0BwML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE92C433C8;
	Mon,  1 Jan 2024 00:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067690;
	bh=i22axxX+zAQX3d1BrB7HkOV1+MjRI+JagvsqqpTzXDo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VDg0BwMLTu377QgculmcVNTZSM4pb7ZuSEBMoGBrHwskM9B67KzR9rTXYndZUkWDr
	 7fhC+Oky5iBOmficmJRN++YxXmbHQsiuOhIQoGQ0O1MAtCoRbgW9ZBTaxGE+mpxNW3
	 gfxUzWOsieApjeDqCv8Lg2LpC/CgE/U4rl8BKodut6bbT9WSuFB606HNSrng8KQWFU
	 GbHmStji3HIXjU96ZxBRGHnlBcl+VQKnsnWI6D3MiqncyPEBYzb//gcPk4nID/Ytlc
	 IK7m9NqIvCyRswgNj5twJSwQEcIObSiKpQ3Rhz1Ov9mdpNoVxIFt5FB00q4Szw0o5n
	 wBSoAHRie9n3w==
Date: Sun, 31 Dec 2023 16:08:10 +9900
Subject: [PATCH 3/3] xfs_logprint: report realtime EFIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014501.1815106.15031078756302132060.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014459.1815106.2840285507026368491.stgit@frogsfrogsfrogs>
References: <170405014459.1815106.2840285507026368491.stgit@frogsfrogsfrogs>
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

Decode the EFI format just enough to report if an EFI targets the
realtime device or not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_misc.c      |    2 ++
 logprint/log_print_all.c |    8 ++++++
 logprint/log_redo.c      |   57 +++++++++++++++++++++++++++++++++++-----------
 3 files changed, 53 insertions(+), 14 deletions(-)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 565e7b76284..9d63f376390 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -997,12 +997,14 @@ xlog_print_record(
 					&i, num_ops);
 			break;
 		    }
+		    case XFS_LI_EFI_RT:
 		    case XFS_LI_EFI: {
 			skip = xlog_print_trans_efi(&ptr,
 					be32_to_cpu(op_head->oh_len),
 					continued);
 			break;
 		    }
+		    case XFS_LI_EFD_RT:
 		    case XFS_LI_EFD: {
 			skip = xlog_print_trans_efd(&ptr,
 					be32_to_cpu(op_head->oh_len));
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 6e528fcd097..d030efa9efb 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -410,9 +410,11 @@ xlog_recover_print_logitem(
 	case XFS_LI_INODE:
 		xlog_recover_print_inode(item);
 		break;
+	case XFS_LI_EFD_RT:
 	case XFS_LI_EFD:
 		xlog_recover_print_efd(item);
 		break;
+	case XFS_LI_EFI_RT:
 	case XFS_LI_EFI:
 		xlog_recover_print_efi(item);
 		break;
@@ -474,6 +476,12 @@ xlog_recover_print_item(
 	case XFS_LI_INODE:
 		printf("INO");
 		break;
+	case XFS_LI_EFD_RT:
+		printf("EFD_RT");
+		break;
+	case XFS_LI_EFI_RT:
+		printf("EFI_RT");
+		break;
 	case XFS_LI_EFD:
 		printf("EFD");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 948924d5bcb..0cc3cd4ba28 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -67,6 +67,7 @@ xlog_print_trans_efi(
 	uint			src_len,
 	int			continued)
 {
+	const char		*item_name = "EFI?";
 	xfs_efi_log_format_t	*src_f, *f = NULL;
 	uint			dst_len;
 	xfs_extent_t		*ex;
@@ -103,8 +104,14 @@ xlog_print_trans_efi(
 		goto error;
 	}
 
-	printf(_("EFI:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
-		f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
+	switch (f->efi_type) {
+	case XFS_LI_EFI:	item_name = "EFI"; break;
+	case XFS_LI_EFI_RT:	item_name = "EFI_RT"; break;
+	}
+
+	printf(_("%s:  #regs: %d	num_extents: %u  id: 0x%llx\n"),
+			item_name, f->efi_size, f->efi_nextents,
+			(unsigned long long)f->efi_id);
 
 	if (continued) {
 		printf(_("EFI free extent data skipped (CONTINUE set, no space)\n"));
@@ -113,7 +120,7 @@ xlog_print_trans_efi(
 
 	ex = f->efi_extents;
 	for (i=0; i < f->efi_nextents; i++) {
-		printf("(s: 0x%llx, l: %d) ",
+		printf("(s: 0x%llx, l: %u) ",
 			(unsigned long long)ex->ext_start, ex->ext_len);
 		if (i % 4 == 3) printf("\n");
 		ex++;
@@ -130,6 +137,7 @@ void
 xlog_recover_print_efi(
 	struct xlog_recover_item *item)
 {
+	const char		*item_name = "EFI?";
 	xfs_efi_log_format_t	*f, *src_f;
 	xfs_extent_t		*ex;
 	int			i;
@@ -155,12 +163,18 @@ xlog_recover_print_efi(
 		return;
 	}
 
-	printf(_("	EFI:  #regs:%d	num_extents:%d  id:0x%llx\n"),
-		   f->efi_size, f->efi_nextents, (unsigned long long)f->efi_id);
+	switch (f->efi_type) {
+	case XFS_LI_EFI:	item_name = "EFI"; break;
+	case XFS_LI_EFI_RT:	item_name = "EFI_RT"; break;
+	}
+
+	printf(_("	%s:  #regs:%d	num_extents:%u  id:0x%llx\n"),
+			item_name, f->efi_size, f->efi_nextents,
+			(unsigned long long)f->efi_id);
 	ex = f->efi_extents;
 	printf("	");
 	for (i=0; i< f->efi_nextents; i++) {
-		printf("(s: 0x%llx, l: %d) ",
+		printf("(s: 0x%llx, l: %u) ",
 			(unsigned long long)ex->ext_start, ex->ext_len);
 		if (i % 4 == 3)
 			printf("\n");
@@ -174,8 +188,10 @@ xlog_recover_print_efi(
 int
 xlog_print_trans_efd(char **ptr, uint len)
 {
-	xfs_efd_log_format_t *f;
-	xfs_efd_log_format_t lbuf;
+	const char		*item_name = "EFD?";
+	xfs_efd_log_format_t	*f;
+	xfs_efd_log_format_t	lbuf;
+
 	/* size without extents at end */
 	uint core_size = sizeof(xfs_efd_log_format_t);
 
@@ -185,11 +201,17 @@ xlog_print_trans_efd(char **ptr, uint len)
 	 */
 	memmove(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
+
+	switch (f->efd_type) {
+	case XFS_LI_EFD:	item_name = "EFD"; break;
+	case XFS_LI_EFD_RT:	item_name = "EFD_RT"; break;
+	}
+
 	*ptr += len;
 	if (len >= core_size) {
-		printf(_("EFD:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
-			f->efd_size, f->efd_nextents,
-			(unsigned long long)f->efd_efi_id);
+		printf(_("%s:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+				item_name, f->efd_size, f->efd_nextents,
+				(unsigned long long)f->efd_efi_id);
 
 		/* don't print extents as they are not used */
 
@@ -204,18 +226,25 @@ void
 xlog_recover_print_efd(
 	struct xlog_recover_item *item)
 {
+	const char		*item_name = "EFD?";
 	xfs_efd_log_format_t	*f;
 
 	f = (xfs_efd_log_format_t *)item->ri_buf[0].i_addr;
+
+	switch (f->efd_type) {
+	case XFS_LI_EFD:	item_name = "EFD"; break;
+	case XFS_LI_EFD_RT:	item_name = "EFD_RT"; break;
+	}
+
 	/*
 	 * An xfs_efd_log_format structure contains a variable length array
 	 * as the last field.
 	 * Each element is of size xfs_extent_32_t or xfs_extent_64_t.
 	 * However, the extents are never used and won't be printed.
 	 */
-	printf(_("	EFD:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
-		f->efd_size, f->efd_nextents,
-		(unsigned long long)f->efd_efi_id);
+	printf(_("	%s:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+			item_name, f->efd_size, f->efd_nextents,
+			(unsigned long long)f->efd_efi_id);
 }
 
 /* Reverse Mapping Update Items */

