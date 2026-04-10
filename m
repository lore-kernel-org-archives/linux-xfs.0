Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7975B346AFB
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801921; cv=none; b=ISA4GmbwgBZvyVjlxj6PNEfOf8VuPOAODVS1QSJRw6iJp4oPbWNplWkkth1Gk+zf2V36f//H9e73Wz3RRPFWmwwQjzLFMcJZMAbcNyF5dPdIer5OOeL1JJ9SPrY3tDd+r1oV7+ZB8E7MYM+76z1WQYvpe4k3UKLcfen5CNoTQYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801921; c=relaxed/simple;
	bh=JcWX8RD6DM5US2raP0DKRvzWIXSFOs96/prJECmowEc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oD6TMlaQHp/fq+N8PLp8WxbOyg3Ea/TNgzrB+3a49qZ/i/JfbikfK1MhGS6frxo30BtrgFOf+xPXMAukagcsGHYO2qC+zjawK8g3MX2dwEKhFmprMllNuLDry14b/2FgxNcM1Ba7FHmaXuvj+a9zm1a/K7NwF8k7BFVKWJjNnaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKvudpJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKvudpJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A10C19421;
	Fri, 10 Apr 2026 06:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801921;
	bh=JcWX8RD6DM5US2raP0DKRvzWIXSFOs96/prJECmowEc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kKvudpJWEkK1OqTgU50VaCULr6MpAOrBU8b2a7PFbYvRDZEUGp5IvNtJkCJpIzqH6
	 +RUk38T49k4WJOHwSozZCwKVV5cHlf0uz7nuGSgOkn9hzFQGaF6e+Kq1cMSi+FervJ
	 27iGBb6o4C3smwgmCX/awtGCfFVLsb3yqImghgPbS22sAGF/AON8w7Vb2RwmOSK2jl
	 q2HJkGddwIAzWTPbV6PuWGXQ5+dKu04LVTRHoTlxabcSXOiavY620pRIxbu8pCBPZg
	 JWD5Xia16C3AbAimIWOVl+Hhubia98I3rt+JwGS2CtXc9EUa1NNrSesRkPWZiNfydg
	 YJDtczjOdGi0A==
Date: Thu, 09 Apr 2026 23:18:40 -0700
Subject: [PATCH 05/21] xfs_scrub: fix i18n of the decode_special_owner return
 value
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177577385123.2090237.10289248469451350626.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

