Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F13C8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8tgwLsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CDAC433C8;
	Sun, 31 Dec 2023 23:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063703;
	bh=nP59wd2fTh4a4t4EGPSs/QbLmccKAfn2v0+ASIX0OMY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b8tgwLsLQ0Nu2AggoE+5A9cTyb+SYrR/5iXKzPjNsNfGcOMRKB+j/uM+6/VHQkQBU
	 7LieWwEttn06i0Qh0AuB5TtYpDaoMH59KQcRHkSoflb5KUZUwdSElvwwaDQ+aHNJmK
	 xYh9ugDAepDZlb8+n85XIONa0xmqWrzl/hJyB+Qf4h2uehdQFITPhKMe2/YbCXA4fC
	 dYIfKH2BnpPJDNjDB8NY8CbUPNLadsURx5LIwR63qPlCIw02JESXMEEboeoRabnuKE
	 dcmM2oCQ8Sm+9GYEqVLXDRdFSXDI1faFnb7GdvYKYGPgTIa6EHWa9um25rsDgLwybr
	 Hi5ZzzyzKVBbw==
Date: Sun, 31 Dec 2023 15:01:43 -0800
Subject: [PATCH 3/4] xfs_repair: allow sysadmins to add reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405004090.1801995.14364421802726298307.stgit@frogsfrogsfrogs>
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
to support the reference count btree, and therefore reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    6 ++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   31 +++++++++++++++++++++++++++++++
 repair/rmap.c        |    4 ++--
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index efe2ce45fc2..3af201cadc3 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -163,6 +163,12 @@ allocation on old filesystems.
 This upgrade can fail if any AG has less than 1% free space remaining.
 The filesystem cannot be downgraded after this feature is enabled.
 This feature was added to Linux 3.16.
+.TP 0.4i
+.B reflink
+Enable sharing of file data blocks.
+This upgrade can fail if any AG has less than 2% free space remaining.
+The filesystem cannot be downgraded after this feature is enabled.
+This feature was added to Linux 4.9.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index 960dff28fba..f0754393ba2 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -53,6 +53,7 @@ bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
 bool	add_finobt;		/* add free inode btrees */
+bool	add_reflink;		/* add reference count btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 4ec68ecd896..4013d8f0d24 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -94,6 +94,7 @@ extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
 extern bool	add_finobt;		/* add free inode btrees */
+extern bool	add_reflink;		/* add reference count btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 5d2bb859514..9a8bf411333 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -204,6 +204,33 @@ set_finobt(
 	return true;
 }
 
+static bool
+set_reflink(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (xfs_has_reflink(mp)) {
+		printf(_("Filesystem already supports reflink.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Reflink feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_realtime(mp)) {
+		printf(_("Reflink feature not supported with realtime.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding reflink support to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -373,6 +400,8 @@ need_check_fs_free_space(
 {
 	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
 		return true;
+	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
+		return true;
 	return false;
 }
 
@@ -450,6 +479,8 @@ upgrade_filesystem(
 		dirty |= set_nrext64(mp, &new_sb);
 	if (add_finobt)
 		dirty |= set_finobt(mp, &new_sb);
+	if (add_reflink)
+		dirty |= set_reflink(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 8895377aa2a..91a87d418e2 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -52,7 +52,7 @@ bool
 rmap_needs_work(
 	struct xfs_mount	*mp)
 {
-	return xfs_has_reflink(mp) ||
+	return xfs_has_reflink(mp) || add_reflink ||
 	       xfs_has_rmapbt(mp);
 }
 
@@ -1526,7 +1526,7 @@ check_refcounts(
 	int				i;
 	int				error;
 
-	if (!xfs_has_reflink(mp))
+	if (!xfs_has_reflink(mp) || add_reflink)
 		return;
 	if (refcbt_suspect) {
 		if (no_modify && agno == 0)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index b61af185c38..d53db25e618 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -70,6 +70,7 @@ enum c_opt_nums {
 	CONVERT_BIGTIME,
 	CONVERT_NREXT64,
 	CONVERT_FINOBT,
+	CONVERT_REFLINK,
 	C_MAX_OPTS,
 };
 
@@ -79,6 +80,7 @@ static char *c_opts[] = {
 	[CONVERT_BIGTIME]	= "bigtime",
 	[CONVERT_NREXT64]	= "nrext64",
 	[CONVERT_FINOBT]	= "finobt",
+	[CONVERT_REFLINK]	= "reflink",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -347,6 +349,15 @@ process_args(int argc, char **argv)
 		_("-c finobt only supports upgrades\n"));
 					add_finobt = true;
 					break;
+				case CONVERT_REFLINK:
+					if (!val)
+						do_abort(
+		_("-c reflink requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c reflink only supports upgrades\n"));
+					add_reflink = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

