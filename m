Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164767ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDKOOsXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CECBC433C7;
	Mon,  1 Jan 2024 00:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068550;
	bh=8IkLoAwl6yWWkx8Hf2xx1/ye7/kxAdBVC7LJVxanusU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oDKOOsXhROYwSo0i2iG17xKq8uajRqTQjCq5JH7642qNigrVEpi+NRnUrEMsbEms4
	 E0Yl6HdSZFPB2YQGHB3EuFjudazWjSeCoOVMiLhTqDmX+SnyqKKOLjZ+tp7fAD/HcF
	 dcBHm0zpHu1lPbMWIcSxvPgiH2zAgEFbdkNqvokmIHYoAzXrTd/PddU5aekiAWKTgR
	 k+UIbOM1kpIJ4ZMwYjp7VlXqDdlAfDzDvKykH2twI5On1AyarRHnnwIEMeFTf0ImYS
	 OkjAKt+gKMvTkgfBqSTQD3NoCsLss9AAcp7NzxAUttqyTEgo/Qt0hXT1tCC90lJrsm
	 PE0wxf+SaxITw==
Date: Sun, 31 Dec 2023 16:22:30 +9900
Subject: [PATCH 46/47] xfs_logprint: report realtime RUIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015926.1815505.11026140199367054479.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Decode the RUI format just enough to report if an RUI targets the
realtime device or not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_misc.c      |    2 ++
 logprint/log_print_all.c |    8 ++++++++
 logprint/log_redo.c      |   24 +++++++++++++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 9d63f376390..3661b595c53 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1021,12 +1021,14 @@ xlog_print_record(
 					be32_to_cpu(op_head->oh_len));
 			break;
 		    }
+		    case XFS_LI_RUI_RT:
 		    case XFS_LI_RUI: {
 			skip = xlog_print_trans_rui(&ptr,
 					be32_to_cpu(op_head->oh_len),
 					continued);
 			break;
 		    }
+		    case XFS_LI_RUD_RT:
 		    case XFS_LI_RUD: {
 			skip = xlog_print_trans_rud(&ptr,
 					be32_to_cpu(op_head->oh_len));
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index d030efa9efb..e67e2c57f26 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -424,9 +424,11 @@ xlog_recover_print_logitem(
 	case XFS_LI_ATTRI:
 		xlog_recover_print_attri(item);
 		break;
+	case XFS_LI_RUD_RT:
 	case XFS_LI_RUD:
 		xlog_recover_print_rud(item);
 		break;
+	case XFS_LI_RUI_RT:
 	case XFS_LI_RUI:
 		xlog_recover_print_rui(item);
 		break;
@@ -500,6 +502,12 @@ xlog_recover_print_item(
 	case XFS_LI_RUI:
 		printf("RUI");
 		break;
+	case XFS_LI_RUD_RT:
+		printf("RUD_RT");
+		break;
+	case XFS_LI_RUI_RT:
+		printf("RUI_RT");
+		break;
 	case XFS_LI_CUD:
 		printf("CUD");
 		break;
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 0cc3cd4ba28..ae6f311f19b 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -274,6 +274,7 @@ xlog_print_trans_rui(
 	uint			src_len,
 	int			continued)
 {
+	const char		*item_name = "RUI?";
 	struct xfs_rui_log_format	*src_f, *f = NULL;
 	uint			dst_len;
 	uint			nextents;
@@ -318,8 +319,14 @@ xlog_print_trans_rui(
 		goto error;
 	}
 
-	printf(_("RUI:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
-		f->rui_size, f->rui_nextents, (unsigned long long)f->rui_id);
+	switch (f->rui_type) {
+	case XFS_LI_RUI:	item_name = "RUI"; break;
+	case XFS_LI_RUI_RT:	item_name = "RUI_RT"; break;
+	}
+
+	printf(_("%s:  #regs: %d	num_extents: %d  id: 0x%llx\n"),
+			item_name, f->rui_size, f->rui_nextents,
+			(unsigned long long)f->rui_id);
 
 	if (continued) {
 		printf(_("RUI extent data skipped (CONTINUE set, no space)\n"));
@@ -359,6 +366,7 @@ xlog_print_trans_rud(
 	char				**ptr,
 	uint				len)
 {
+	const char			*item_name = "RUD?";
 	struct xfs_rud_log_format	*f;
 	struct xfs_rud_log_format	lbuf;
 
@@ -371,11 +379,17 @@ xlog_print_trans_rud(
 	 */
 	memmove(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
+
+	switch (f->rud_type) {
+	case XFS_LI_RUD:	item_name = "RUD"; break;
+	case XFS_LI_RUD_RT:	item_name = "RUD_RT"; break;
+	}
+
 	*ptr += len;
 	if (len >= core_size) {
-		printf(_("RUD:  #regs: %d	                 id: 0x%llx\n"),
-			f->rud_size,
-			(unsigned long long)f->rud_rui_id);
+		printf(_("%s:  #regs: %d	                 id: 0x%llx\n"),
+				item_name, f->rud_size,
+				(unsigned long long)f->rud_rui_id);
 
 		/* don't print extents as they are not used */
 

