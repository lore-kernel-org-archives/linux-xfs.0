Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4223BCD1A
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179522; cv=none; b=HNZo0ML+XfseECp+7LZPkYckDXNAV/aDzwsuflU9cRS46bElXBVlOzP1NIIccVVg2gbfX12qYONDm53cjOHXbzm61FCDI0I5R+NEoBvvYZbqKEt5FBF3oszVhT20ArupMUv+OPSyJ0+fNm7Jvv5B4jr8nskl3Z3z8I1wVvBl8gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179522; c=relaxed/simple;
	bh=D3ljXGAOC1p+t2hfVjS2O29WrfS6LJkNJS4jQTHJ+Xs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EuWgVNXdGkAUoojb2b+LnpxkRGxymKHBwf0pv3muFKNvNb67Sp0Dw5HTJCgxJRYJj18o6WU5FBXWAanf93WaQQtvW7faqj+DFiKkbb44CER70T68y7OZP6PFnWnlMoN8PnCBy918hSfwCl5jlkX6+WXJ79cvuN1ZNsJvmgX5cuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L75vu9cR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L75vu9cR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 75D971F000C4;
	Fri, 16 Oct 2026 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179518;
	bh=WOMEdvgl7bA5n3zKo1W0VCQL4B52XfVZKUKtJm2V37Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=L75vu9cRCJSVVySIjG2egk7wjf+xf/yjuu/SsIJJjk3OT9mJen1dmOYt0oeOLKHsM
	 nvCNImFCjh5oUd1TnUtJh0wSsZ3LHzbGK8SOaEH1oNABpp9tt/eG5zjmum4s/46oLt
	 Lx1/fzbeCHMYXohcIn7LGm+5xXQuEB0akYukwpFFQ1peSW+Z755j3bZtVNucjtDo/p
	 61OhCNqfCq1NlxC4pmvAKxFN211qI2p+LXxaoyfznrTa1LjD8m6V04ohcqEhP1Y8i+
	 uK8rauQ9E1SFv9FqMwPk8cIaJ37L61QQD2QoePMpSeD7BOlcMdvoVWEU9X7ZqyDmmJ
	 /ZgP7MDP+ItLQ==
Date: Fri, 16 Oct 2026 12:38:37 -0700
Subject: [PATCH 03/10] xfs_repair: allow sysadmins to add reverse mapping
 indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942792.717548.13552902913921667962.stgit@frogsfrogsfrogs>
In-Reply-To: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
References: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.h     |    1 +
 man/man8/xfs_admin.8 |    8 ++++++++
 repair/globals.c     |    1 +
 repair/phase2.c      |   38 ++++++++++++++++++++++++++++++++++++++
 repair/rmap.c        |    6 +++---
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 62 insertions(+), 3 deletions(-)


diff --git a/repair/globals.h b/repair/globals.h
index efbb8db79bc080..d8c2aae23d8f0a 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -96,6 +96,7 @@ extern bool	add_nrext64;
 extern bool	add_exchrange;		/* add file content exchange support */
 extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
+extern bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 20ca6d2fee9483..19dde611891dbc 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -184,6 +184,14 @@ .SH OPTIONS
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
index cf4421e34dec84..dd7c422bb922e4 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -55,6 +55,7 @@ bool	add_nrext64;
 bool	add_exchrange;		/* add file content exchange support */
 bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
+bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index d308087aab9568..399a03a171e3a3 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -268,6 +268,40 @@ set_reflink(
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
+	if (xfs_has_reflink(mp) && !add_reflink) {
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
@@ -434,6 +468,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
 		return true;
+	if (xfs_has_rmapbt(mp) && !(old->features & XFS_FEAT_RMAPBT))
+		return true;
 	return false;
 }
 
@@ -515,6 +551,8 @@ upgrade_filesystem(
 		dirty |= set_finobt(mp, &new_sb);
 	if (add_reflink)
 		dirty |= set_reflink(mp, &new_sb);
+	if (add_rmapbt)
+		dirty |= set_rmapbt(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 803731632f6b5f..40a3718c053ac9 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -69,7 +69,7 @@ rmap_needs_work(
 	struct xfs_mount	*mp)
 {
 	return xfs_has_reflink(mp) || add_reflink ||
-	       xfs_has_rmapbt(mp);
+	       xfs_has_rmapbt(mp) || add_rmapbt;
 }
 
 static inline bool rmaps_has_observations(const struct xfs_ag_rmap *ag_rmap)
@@ -1337,7 +1337,7 @@ rmaps_verify_btree(
 	struct xfs_perag	*pag = NULL;
 	int			error;
 
-	if (!xfs_has_rmapbt(mp))
+	if (!xfs_has_rmapbt(mp) || add_rmapbt)
 		return;
 	if (rmapbt_suspect) {
 		if (no_modify && agno == 0)
@@ -1396,7 +1396,7 @@ rtrmaps_verify_btree(
 	struct xfs_inode	*ip = NULL;
 	int			error;
 
-	if (!xfs_has_rmapbt(mp))
+	if (!xfs_has_rmapbt(mp) || add_rmapbt)
 		return;
 	if (rmapbt_suspect) {
 		if (no_modify && rgno == 0)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 89daaa34867d14..b6c7043bb1091a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -74,6 +74,7 @@ enum c_opt_nums {
 	CONVERT_EXCHRANGE,
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
+	CONVERT_RMAPBT,
 	C_MAX_OPTS,
 };
 
@@ -85,6 +86,7 @@ static char *c_opts[] = {
 	[CONVERT_EXCHRANGE]	= "exchange",
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
+	[CONVERT_RMAPBT]	= "rmapbt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -395,6 +397,15 @@ process_args(int argc, char **argv)
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

