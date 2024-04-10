Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97AB38B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710192; cv=none; b=j95/K87gXKcmeKnfd6hMMZEvd2ZYbp/hkf4ibtkRphYc49pMYx5emR4mm8e7BVkkQ64BpCs3oTer+4cLBQbmyzyAec3si6699HHmenlXdyaYd03Lvk7lHNhBTxiIi3uR5Zc8vuQ/m3ktN/6CDFbfKaLis7bUN7TwKapK30vW4pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710192; c=relaxed/simple;
	bh=6dj3WvNSfJX3+YnPTEoTeoCD49moa4qraMIDCLswJn8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gA/5OLzK4POeFbTPFf4XhuP2L16GrydLeaub3rshVgAOFqjQgb1uiM22hpVfd4Wf2Xgq0nQT9EjUQqQFOcl/ae+poZAtdyqtnxNU48LGXvPnCliElwbquyNlZ/ZQKcZDHRlq2Osgl4yvMCGZLxZsVauChhTojqEYT5Y83qh8s/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPUNhKws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPUNhKws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEE5C43394;
	Wed, 10 Apr 2024 00:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710192;
	bh=6dj3WvNSfJX3+YnPTEoTeoCD49moa4qraMIDCLswJn8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CPUNhKwsChVdZWphULHj24TfGoF7hrI1IPqz7c9QQBntmH44H/HctR6Ec5zdM5pky
	 F7CCQkb+HkglrhNUnPHdFaVsXFTryVnwi1aRW1X5Ajyeho4RUz9ydCiMiubf6SemTn
	 jXtymDy6gvnRHxl8o1nQb29trf7Snsll6bPSEOZIB1WIsYzr2SkpTJCPsYfrVsMdyX
	 QI1u8WzoSJA6SC+yKG37MZ//glKzE9tCh1J7f4aDT0DJnjKXG95i74Qo9o8KjmqAYJ
	 Mcg0rwnFnySx+IaTgno5pePFeRjUhSjSv7x+RFy2zbNYYIAZL4EEwB1tmTrMh5ksGI
	 WJjf8CF44Z10g==
Date: Tue, 09 Apr 2024 17:49:51 -0700
Subject: [PATCH 2/4] xfs: remove XFS_DA_OP_NOTIME
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968418.3631393.17581873522746080377.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
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

The only user of this flag sets it prior to an xfs_attr_get_ilocked
call, which doesn't update anything.  Get rid of the flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c     |    5 ++---
 fs/xfs/libxfs/xfs_da_btree.h |    6 ++----
 fs/xfs/scrub/attr.c          |    1 -
 3 files changed, 4 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 05d22c5e38855..30e6084122d8b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -365,7 +365,7 @@ xfs_attr_try_sf_addname(
 	 * Commit the shortform mods, and we're done.
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
-	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
+	if (!error)
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	if (xfs_has_wsync(dp->i_mount))
@@ -1033,8 +1033,7 @@ xfs_attr_set(
 	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(args->trans);
 
-	if (!(args->op_flags & XFS_DA_OP_NOTIME))
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
 	 * Commit the last in the sequence of transactions.
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 76e764080d994..b04a3290ffacc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -90,9 +90,8 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	(1u << 2) /* this is an add operation */
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
-#define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
-#define XFS_DA_OP_RECOVERY	(1u << 6) /* Log recovery operation */
-#define XFS_DA_OP_LOGGED	(1u << 7) /* Use intent items to track op */
+#define XFS_DA_OP_RECOVERY	(1u << 5) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 6) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -100,7 +99,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
 	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 8853e4d0eee3d..5b855d7c98211 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -173,7 +173,6 @@ xchk_xattr_actor(
 	void			*priv)
 {
 	struct xfs_da_args		args = {
-		.op_flags		= XFS_DA_OP_NOTIME,
 		.attr_filter		= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.geo			= sc->mp->m_attr_geo,
 		.whichfork		= XFS_ATTR_FORK,

