Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116F22417C0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882920; cv=none; b=n0R1eY6bvxHfHL9FjpPA7F1ewScJr4q9E2kG2FymyvU5dYon0iXxgJk+hFSXG065wpQRX+e39Wv/EI4bRurfds2uIYy93tTEdFolmQ1MDvmAdP8FeJa6K7MhZpUEA8j8VtNKshFElpnAMe1R3SiZUYJoCBZTP0ovsUOQYoIGG+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882920; c=relaxed/simple;
	bh=tqlFjDEPU+p94UtgLCxiF3UAxK1eibZ7xFwjdGivLtE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nLNL9G+IRFfDJ0HUll/H4KVfBUga1G36xnvJjU0ps9oh/Pwbs6tTgCoeJxxiObzIAXpM8NJXdmytO/jzCyoKriy/tNHd1t6oTsRmF/a7EavKwENpoOg5Ze7xs4G9sg1NFE0bfafsUKubDiag/C4XUxYnBLr94vXY9yEEVFS1uLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s014ikEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s014ikEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693E0C4CEDD;
	Thu,  6 Feb 2025 23:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882919;
	bh=tqlFjDEPU+p94UtgLCxiF3UAxK1eibZ7xFwjdGivLtE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s014ikEBmwdLaI6U2gkb3etUdYnz7Ksp4n1iawY+DUoxj+mX1F5ORIeUqLaZS1x0j
	 NA1sS5RG+c2CLUvX0rKjg88GQ237zdS5fTV1Y/QdkFAHaekOvmjgMnzyaNJtmJjTjl
	 JG8iMSiw8uMjFOv8nhbUWkWKOqMV0pbxyT2jodFa/ZxVoIjLOdCfc3QrLEjVXtMWrX
	 ROIU8kZShY1g5MsQs7ATlEpuGgugwsUJIsHknG2hcKC8sA9FP0AgsJq7XEOnOoBt9O
	 Uhow93EAEDCG5vtiur84O9i6qIoEk0ddq7i4Mev7Ps9895Iyd24Nr0rPGRKDKgUezv
	 FWTEMs17r+TIQ==
Date: Thu, 06 Feb 2025 15:01:58 -0800
Subject: [PATCH 20/22] xfs_logprint: report realtime CUIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089238.2741962.6117855127240783512.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Decode the CUI format just enough to report if an CUI targets the
realtime device or not.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 logprint/log_misc.c      |    2 ++
 logprint/log_print_all.c |    8 ++++++++
 logprint/log_redo.c      |   24 +++++++++++++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index aaa9598616a308..144695753211aa 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1027,12 +1027,14 @@ xlog_print_record(
 					be32_to_cpu(op_head->oh_len));
 			break;
 		    }
+		    case XFS_LI_CUI_RT:
 		    case XFS_LI_CUI: {
 			skip = xlog_print_trans_cui(&ptr,
 					be32_to_cpu(op_head->oh_len),
 					continued);
 			break;
 		    }
+		    case XFS_LI_CUD_RT:
 		    case XFS_LI_CUD: {
 			skip = xlog_print_trans_cud(&ptr,
 					be32_to_cpu(op_head->oh_len));
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 56e765d64f2df4..1498ef97247d3d 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -430,9 +430,11 @@ xlog_recover_print_logitem(
 	case XFS_LI_RUI:
 		xlog_recover_print_rui(item);
 		break;
+	case XFS_LI_CUD_RT:
 	case XFS_LI_CUD:
 		xlog_recover_print_cud(item);
 		break;
+	case XFS_LI_CUI_RT:
 	case XFS_LI_CUI:
 		xlog_recover_print_cui(item);
 		break;
@@ -512,6 +514,12 @@ xlog_recover_print_item(
 	case XFS_LI_CUI:
 		printf("CUI");
 		break;
+	case XFS_LI_CUD_RT:
+		printf("CUD_RT");
+		break;
+	case XFS_LI_CUI_RT:
+		printf("CUI_RT");
+		break;
 	case XFS_LI_BUD:
 		printf("BUD");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index a0cc558499ae0b..89d7448342b33d 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -440,6 +440,7 @@ xlog_print_trans_cui(
 	uint			src_len,
 	int			continued)
 {
+	const char		*item_name = "CUI?";
 	struct xfs_cui_log_format	*src_f, *f = NULL;
 	uint			dst_len;
 	uint			nextents;
@@ -480,8 +481,14 @@ xlog_print_trans_cui(
 		goto error;
 	}
 
-	printf(_("CUI:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
-		f->cui_size, f->cui_nextents, (unsigned long long)f->cui_id);
+	switch (f->cui_type) {
+	case XFS_LI_CUI:	item_name = "CUI"; break;
+	case XFS_LI_CUI_RT:	item_name = "CUI_RT"; break;
+	}
+
+	printf(_("%s:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+			item_name, f->cui_size, f->cui_nextents,
+			(unsigned long long)f->cui_id);
 
 	if (continued) {
 		printf(_("CUI extent data skipped (CONTINUE set, no space)\n"));
@@ -520,6 +527,7 @@ xlog_print_trans_cud(
 	char				**ptr,
 	uint				len)
 {
+	const char			*item_name = "CUD?";
 	struct xfs_cud_log_format	*f;
 	struct xfs_cud_log_format	lbuf;
 
@@ -528,11 +536,17 @@ xlog_print_trans_cud(
 
 	memcpy(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
+
+	switch (f->cud_type) {
+	case XFS_LI_CUD:	item_name = "CUD"; break;
+	case XFS_LI_CUD_RT:	item_name = "CUD_RT"; break;
+	}
+
 	*ptr += len;
 	if (len >= core_size) {
-		printf(_("CUD:  #regs: %d	                 id: 0x%llx\n"),
-			f->cud_size,
-			(unsigned long long)f->cud_cui_id);
+		printf(_("%s:  #regs: %d	                 id: 0x%llx\n"),
+				item_name, f->cud_size,
+				(unsigned long long)f->cud_cui_id);
 
 		/* don't print extents as they are not used */
 

