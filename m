Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089AB2417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882577; cv=none; b=RWNMy+OmklPWY+zmgQxZuDj1nmf6WduZLUlTZ7IMXCbVP1QalmRxjtAIkZ8l7LEJamFWs0YS8ANdqp/YO5j40HdzRewKsYi1Cf/MyqkmWb2YGd1Xj5WYzt2ixPM8O20yigoK9IE7NwX9zleoJVaasNTzHNZvzz283S3nDwjFR10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882577; c=relaxed/simple;
	bh=CyuAJ9CPsPHyGwUH/7oXh2nQiXX1a/48gMByVJTDrXw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjO6sKHD/ob7k7kdLbWJoQYrKsFzzvRBLQr+goWzwC+KNfU28nn64sr+hlNTt4/uad9MZ/nkfLlexkOU5S2lkcUd8XDJbhd+gk+DMuzufkwW2N+WkGF/3asGZ203i7H5PGcC+PplsO+EddhoJA3vOnotP38mmqGojrnOr17R9IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWuTNHAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWuTNHAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F717C4CEDD;
	Thu,  6 Feb 2025 22:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882575;
	bh=CyuAJ9CPsPHyGwUH/7oXh2nQiXX1a/48gMByVJTDrXw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TWuTNHAABB0ioEM9QzNtPgJ9iQ1tnDbz/mjLVsdSReaXaMM8buH16vT8hu4j1QyjN
	 W6pagrHGCu0UkTaD+2aZKlQaxjTeueB5+oZfGcT7ng386MTXR7jD1UBaVmNwyquBMx
	 t0or7jbX3MTXy7Q0mN1XujUwiCi2R9Wlsgjq726Rr/F6Sze3yfottbI3/KeW49w8TC
	 Of0lj94/55PiR26uMm6ABzuJ+VCSGYGqSqNtE+hAzkKYo65XL7pBcP54nEUfYF7h/u
	 xxmPi5WwbqFrjS5pcfi3cQ41R1wPItAwcDzG/QcOswKB3Wnb+eujYhIbVE6fCM8Wuu
	 F3fnVV6fgwrYQ==
Date: Thu, 06 Feb 2025 14:56:15 -0800
Subject: [PATCH 25/27] xfs_logprint: report realtime RUIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088479.2741033.18274174802899432825.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 logprint/log_misc.c      |    2 ++
 logprint/log_print_all.c |    8 ++++++++
 logprint/log_redo.c      |   24 +++++++++++++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8336f26e093310..aaa9598616a308 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1014,12 +1014,14 @@ xlog_print_record(
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
index ed5f234975ccad..56e765d64f2df4 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -422,9 +422,11 @@ xlog_recover_print_logitem(
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
@@ -498,6 +500,12 @@ xlog_recover_print_item(
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
index 41e7c94a52dc21..a0cc558499ae0b 100644
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
 

