Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D59C2563
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530083; cv=none; b=lnA2LtLk677I8JKNV4QOdeXyOE3CGDKQiWJMebT5wFJcXEIc2Emw3Nn8wNm/hWcWB88IrEn1sUxH5fO8RXgBX/cenaNqmGCxwQJk1ZIuomcmrGEuULoA9jaXejcSX75FT5T9XOUzbb7EPfzJmhFrS6GhRSPkZDrNdiFYQV9e3pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530083; c=relaxed/simple;
	bh=0CblLwD0mlTVLE76IFfccTMkQvySm5NxZDHW1y7xH6o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AY8Mv7zoWJC2n2RGLwQnFDTxMyE+b8WLFOLHE+pbdIipcheG+CHFZDZc2Wg4vuVnAeODjnyue5uHFGdTPVxeBsaZbJxyBe5v0twMP51M2JWcrrsTQw3Shl8h9sFvNQfD0PRovoAtn3vLWHg7hcsXukr3i1fYqerm01uAo8LRV9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENQtvZVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENQtvZVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F45C4CED1;
	Sat,  7 Dec 2024 00:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530082;
	bh=0CblLwD0mlTVLE76IFfccTMkQvySm5NxZDHW1y7xH6o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ENQtvZVqffvjqcDzlJ2joBf4V/suPDNadRGJju25ibBo5YWvDrNY0aBOBgO4eid4i
	 YSsbl7c7etn1yb3IUuvAMwjUZMVNwzpFLtgUBLiDGLy5LfA4DEoSaPR7xmQHEiFvbC
	 zNPu9+a6yUAsrjdBzeXHQ5VBIdyqMGDlgLw88b3bELy5A3XDqE6MZqoSJZMLYz1mOk
	 SsyQPz7y8Lx6dqZJRK7wC37hQ4Vzr+50sk4R3OG/21PECnomcZ6bb1/CRRG9FYGzoY
	 myMZU6P73EQIxbeIm8BnFu1rAeWgS0zQkuK9ov57viy1scn5OX1qVkkXhbdD2RZhAP
	 EvTVRwjaKQYKw==
Date: Fri, 06 Dec 2024 16:08:02 -0800
Subject: [PATCH 12/50] xfs_logprint: report realtime EFIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752129.126362.2344806594434228770.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 logprint/log_misc.c      |    2 ++
 logprint/log_print_all.c |    8 ++++++
 logprint/log_redo.c      |   57 +++++++++++++++++++++++++++++++++++-----------
 3 files changed, 53 insertions(+), 14 deletions(-)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8e86ac347fa963..1df8c5d377c02d 100644
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
index a4a5e41f17fa64..5a9ddd05ab1288 100644
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
index 684e5f4a3f32c2..41e7c94a52dc21 100644
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

