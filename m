Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05029188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992110; cv=none; b=Yg71Yl7+UxqggLY465uGnfNgnxFg/PdOqKP3ZS2wcZ+l1yhm7CPZK12cyKy9Yjr2HRLEqTx8jn7iWPiN/un00dnGMgfgsRdQwxMgtonew5asvuY7jPNVNtdshFKcjd32348LXM45yGyNImOGVy6pVAmajSIXRy+d815n03GdfDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992110; c=relaxed/simple;
	bh=H7u7PObzHymrqJ9acOFDDAey06ZwFVtKCQHRCWpDVAU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fb7fiyhflNZ6uG0vlJRhoqb49LIvQLRAhFWGZdRPjALY9NXP1PLNpuR2BG/FWLrsGpmvCNeN2Xrt5A/13p+5zPWUi+X1Q+IM84Vv6LIlHMUoywxrscwtn+YZASi2W0cS2Vmm+dntqncbRVNAxCf1MajRWZjzvCYR9nreKGpqlpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTztbj8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTztbj8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F216C4CED3;
	Mon, 23 Dec 2024 22:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992109;
	bh=H7u7PObzHymrqJ9acOFDDAey06ZwFVtKCQHRCWpDVAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uTztbj8IqAbhgh3hd5DzJ0b7FwOdaf9g3xgowVea8MqSkw4c655onDAjbw4Yo7fDZ
	 ygxCNxh1MeLqi+FTGIhvR9u3325zFlIwXJap+2ZLWZRORqCcvXBMllQNQj0SPd1JiC
	 SM2CxnjTGr6XnnlvwM+iF7B7D9lZQBoiBE56rUhCZaUqofl5S1V9ivJRBfB8oVU6r+
	 GkQZEEuC0OYzdQfinWGVuoyY6GJ5voEyvYzTCZXurgYqZ8Ff9NSwduTRQbEH6jwr9Z
	 yn6xlVSe+65DhihyGTiEoz8q90hJ7GSGTf7qVPn+WtbbkK2IzTDJYc/C80SLMWy/ZY
	 qx+Nbht7bOJ4Q==
Date: Mon, 23 Dec 2024 14:15:09 -0800
Subject: [PATCH 13/51] xfs_logprint: report realtime EFIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944003.2297565.10725313991768318320.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

