Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299EA1F16B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895611; cv=none; b=h6uvniF+qBPKxRCzcQQWydyk+MKD0NBUThotyAs/l8To2z8nUpINh9/P04lACajvA7UnkibaDeoy2S/smfR/pn6kemIkw08hudbB+X1eEBKP8iSmSeKMvnlJ4risSG1iL5Z6Eo39K4g3nNI+6Hdzxew6E0nfRLbs0Dyl907hX3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895611; c=relaxed/simple;
	bh=0onmB/swJMwDFIP0tlRFMilv9LYSQdLqtDQkzWPSaZ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YfKz1VXcu0a6+I5pLVSEf6U2Bvsw4ZzODjCYQtqyv74IbWuOE+LRxCpI5VPIZoICUtu/WKYKv3ZEWY0KerPbjIevjKjj39wP6eywX6W0ER53GXX7bYweYwGFwLmZfBdT2jFdwU1NghCSUn0EEJ9CG7nUIc40egtIPUCyvmQodow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaaCqH40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaaCqH40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DB6C19425;
	Thu, 19 Mar 2026 04:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895610;
	bh=0onmB/swJMwDFIP0tlRFMilv9LYSQdLqtDQkzWPSaZ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KaaCqH40/eKSxcdeE0z7Z+g7XNvAiSRfKG+rNxPx+VrNjy70c1Lyc0EfaqnLgUGSG
	 CIC788hqoGEOpVx+oyhg91xtjKBecip9JXl0/Fi0kILeCegBTGC8wgUoMviXH+E5FV
	 LWKOsie9fislMHsHJJMqbWcOls7/0g9ddqBfGpVuf2EBf6rS9MLbEXk8CAmPK8jVQn
	 /S2XMoeQcq/AxUiVLLdLmA8ZmY4UCIRYf/gO9TCXrpLB+id/t397qY2gsxSIQPikd5
	 tMtlZe1FpYLK+OU1OJHR4qNMTcpr6b8rTeAAvrF3VHIhhE07d/7Ir/fuf5t6QWqjcj
	 WavY/iiq3mEkQ==
Date: Wed, 18 Mar 2026 21:46:50 -0700
Subject: [PATCH 05/22] xfs_scrub: fix i18n of the decode_special_owner return
 value
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177389507032.3681140.1351596709774895251.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The function decode_special_owner turns a special fsmap owner into a
printable string value.  However, it does not query the gettext catalog
for a local language translation, which leads to annoying multilanguage
failure messages.  Fix that by adding the appropriate wrappers.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: b364a9c008fc04 ("xfs_scrub: scrub file data blocks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 590e5d23e6b267..41b41aab7e2578 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -123,16 +123,16 @@ struct owner_decode {
 };
 
 static const struct owner_decode special_owners[] = {
-	{XFS_FMR_OWN_FREE,	"free space"},
-	{XFS_FMR_OWN_UNKNOWN,	"unknown owner"},
-	{XFS_FMR_OWN_FS,	"static FS metadata"},
-	{XFS_FMR_OWN_LOG,	"journalling log"},
-	{XFS_FMR_OWN_AG,	"per-AG metadata"},
-	{XFS_FMR_OWN_INOBT,	"inode btree blocks"},
-	{XFS_FMR_OWN_INODES,	"inodes"},
-	{XFS_FMR_OWN_REFC,	"refcount btree"},
-	{XFS_FMR_OWN_COW,	"CoW staging"},
-	{XFS_FMR_OWN_DEFECTIVE,	"bad blocks"},
+	{XFS_FMR_OWN_FREE,	N_("free space")},
+	{XFS_FMR_OWN_UNKNOWN,	N_("unknown owner")},
+	{XFS_FMR_OWN_FS,	N_("static FS metadata")},
+	{XFS_FMR_OWN_LOG,	N_("journalling log")},
+	{XFS_FMR_OWN_AG,	N_("per-AG metadata")},
+	{XFS_FMR_OWN_INOBT,	N_("inode btree blocks")},
+	{XFS_FMR_OWN_INODES,	N_("inodes")},
+	{XFS_FMR_OWN_REFC,	N_("refcount btree")},
+	{XFS_FMR_OWN_COW,	N_("CoW staging")},
+	{XFS_FMR_OWN_DEFECTIVE,	N_("bad blocks")},
 	{0, NULL},
 };
 
@@ -145,7 +145,7 @@ decode_special_owner(
 
 	while (od->descr) {
 		if (od->owner == owner)
-			return od->descr;
+			return _(od->descr);
 		od++;
 	}
 

