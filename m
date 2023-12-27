Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6891373
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1ZFkLob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD90DC433C7;
	Mon,  1 Jan 2024 00:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069395;
	bh=v+u+mPyISQVZtBUzvFdpQ9ets9AQy3Xm5xJsGa6Q17k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D1ZFkLobI77vNmRm+X3XSCxqoJx+2HEk896muWLN+vKS2nvkVr7MD6okBY6GMDtFv
	 N3ysIGnxpFN1qfM7UfE7hDOV68/aYc0SdXZ27xc1DeiYoj8ZgBgRCFv5ilGa++756m
	 /Ikh56kX6zqoHYpmOCrtyXftSvmMyB4ZpoAykH6C8KsdD/+7Duw87N/hY91rMzIXIv
	 +m97nL988RQ8oamotjLCxiwZVXZfih4F0Wd297J+B7gMY6Tl6EErnXZ5CbaQdZPXMI
	 NKvyOkYkXg/QzkYomAwnWREdFCNkf2s8Ann7nMaiPODcUnNktMde8SJ7mlm4dbhtlc
	 oXKYUdWJQ6KUg==
Date: Sun, 31 Dec 2023 16:36:35 +9900
Subject: [PATCH 40/42] xfs_logprint: report realtime CUIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017660.1817107.5977266260181482154.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Decode the CUI format just enough to report if an CUI targets the
realtime device or not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_misc.c      |    2 ++
 logprint/log_print_all.c |    8 ++++++++
 logprint/log_redo.c      |   24 +++++++++++++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 3661b595c53..6dad686d3b2 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1034,12 +1034,14 @@ xlog_print_record(
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
index e67e2c57f26..2ae642ac000 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -432,9 +432,11 @@ xlog_recover_print_logitem(
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
@@ -514,6 +516,12 @@ xlog_recover_print_item(
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
index ae6f311f19b..381e819ceb7 100644
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
 

