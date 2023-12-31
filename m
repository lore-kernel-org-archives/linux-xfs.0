Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9229C8CF
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gkroau72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C193C433C7;
	Sun, 31 Dec 2023 23:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063719;
	bh=TW9oLFSOvSXv9oo7a4qGE0AR3iBUPKWHMI7GYpgfSFE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gkroau720slhvMAjShVFbjJtyZvZMtTVXD4ouqu9vX3c48RhvfUrKv6L4pBsGTSqP
	 fC7WbmSiXSmWnzKL0xdCw5M0ZcSR37/tCq81AyvFNf5sSf9ECSZnPYzxs2bzbJ2g0p
	 jrZ8cbHqadZEp9xTI9Ye3oP4qgM2rxcPc2DuSWIRprSJj/WSBEIJyuXIcz6+669XEU
	 52ocj9GCx4R0NK7dbpaAjLbHoe3WkOoa5yGU5xMnOmPSx0eIjwEdjJBPGuuUTtrDt4
	 D8YigayhDrexIQ8xcGMm1yE/rLtYXndRMLWlhHAVasTYcJIcRrBS2617QkoN8Xn0mS
	 8FcyVDovWYgEw==
Date: Sun, 31 Dec 2023 15:01:58 -0800
Subject: [PATCH 4/4] xfs_repair: allow sysadmins to add reverse mapping
 indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405004103.1801995.2350289897517322770.stgit@frogsfrogsfrogs>
In-Reply-To: <170405004048.1801995.14994710798555736563.stgit@frogsfrogsfrogs>
References: <170405004048.1801995.14994710798555736563.stgit@frogsfrogsfrogs>
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

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the reverse mapping btree index.  This is needed for online
fsck.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    8 ++++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   38 ++++++++++++++++++++++++++++++++++++++
 repair/rmap.c        |    4 ++--
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 61 insertions(+), 2 deletions(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 3af201cadc3..467fb2dfd0a 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -169,6 +169,14 @@ Enable sharing of file data blocks.
 This upgrade can fail if any AG has less than 2% free space remaining.
 The filesystem cannot be downgraded after this feature is enabled.
 This feature was added to Linux 4.9.
+.TP 0.4i
+.B rmapbt
+Store an index of the owners of on-disk blocks.
+This enables much stronger cross-referencing of various metadata structures
+and online repairs to space usage metadata.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if any AG has less than 5% free space remaining.
+This feature was added to Linux 4.8.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index f0754393ba2..cff620e8f0e 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -54,6 +54,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
 bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
+bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 4013d8f0d24..76d22fd3b2c 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -95,6 +95,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
 extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
+extern bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 9a8bf411333..be0d791a8b5 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -231,6 +231,40 @@ set_reflink(
 	return true;
 }
 
+static bool
+set_rmapbt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (xfs_has_rmapbt(mp)) {
+		printf(_("Filesystem already supports reverse mapping btrees.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Reverse mapping btree feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_realtime(mp)) {
+		printf(
+	_("Reverse mapping btree feature not supported with realtime.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_reflink(mp)) {
+		printf(
+	_("Reverse mapping btrees cannot be added when reflink is enabled.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding reverse mapping btrees to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -402,6 +436,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
 		return true;
+	if (xfs_has_rmapbt(mp) && !(old->features & XFS_FEAT_RMAPBT))
+		return true;
 	return false;
 }
 
@@ -481,6 +517,8 @@ upgrade_filesystem(
 		dirty |= set_finobt(mp, &new_sb);
 	if (add_reflink)
 		dirty |= set_reflink(mp, &new_sb);
+	if (add_rmapbt)
+		dirty |= set_rmapbt(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 91a87d418e2..37fcf923644 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -53,7 +53,7 @@ rmap_needs_work(
 	struct xfs_mount	*mp)
 {
 	return xfs_has_reflink(mp) || add_reflink ||
-	       xfs_has_rmapbt(mp);
+	       xfs_has_rmapbt(mp) || add_rmapbt;
 }
 
 /* Destroy an in-memory rmap btree. */
@@ -1156,7 +1156,7 @@ rmaps_verify_btree(
 	int			have;
 	int			error;
 
-	if (!xfs_has_rmapbt(mp))
+	if (!xfs_has_rmapbt(mp) || add_rmapbt)
 		return;
 	if (rmapbt_suspect) {
 		if (no_modify && agno == 0)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d53db25e618..e94b0a79378 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -71,6 +71,7 @@ enum c_opt_nums {
 	CONVERT_NREXT64,
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
+	CONVERT_RMAPBT,
 	C_MAX_OPTS,
 };
 
@@ -81,6 +82,7 @@ static char *c_opts[] = {
 	[CONVERT_NREXT64]	= "nrext64",
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
+	[CONVERT_RMAPBT]	= "rmapbt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -358,6 +360,15 @@ process_args(int argc, char **argv)
 		_("-c reflink only supports upgrades\n"));
 					add_reflink = true;
 					break;
+				case CONVERT_RMAPBT:
+					if (!val)
+						do_abort(
+		_("-c rmapbt requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c rmapbt only supports upgrades\n"));
+					add_rmapbt = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

