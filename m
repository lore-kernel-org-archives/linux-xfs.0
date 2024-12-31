Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5289029415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689207; cv=none; b=KqxnzrqNC3tOxJxk8pMRWqUOKtWI4zvFiy7jEjnNASGwqmyjCIp+0Dz7Bt0S/kfan9HdyjzrSj6wjkceY+Pje1hh+if+/UvA01H287YNxN7aWJ1yARSWFwubFR0uVeSuw9HIXcyqAPwt4EYADNUi/5FuSvrT9hksRdB2VlxIlpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689207; c=relaxed/simple;
	bh=w60tYK2jzdoYZUyA6gHs9YUSfTF6fop1OxP4IVuqBH0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rWqoNdMGH1MuyQfvOQGk4pl6NDZNJiku9ugc3HHRmp7MZ/e2FKQuSzz41hTorijmseDuNbh0NafYfm9IjjstvW5KIrw3MY29XrasOyRFFgRZW9hedboAUKClV8+HSdE6Jk3NFaJo9t1tZTAQuXcUXb2cPpgd6aS3KucJEwJ55Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4XvWT/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4XvWT/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303A1C4CED7;
	Tue, 31 Dec 2024 23:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689207;
	bh=w60tYK2jzdoYZUyA6gHs9YUSfTF6fop1OxP4IVuqBH0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X4XvWT/0yaJ0oJiSstFmcsX7eytKT6qmtULCw4ux3EyN7QBXA8x5Qbcem8eNdQMFo
	 3xSB112B6sBBoF1egA90bYfNbP1GjzWsY/iGB5WClEg0teOLNnwA4FMfvEG0HcFQxK
	 KBkSsf1taWWghP5c6kYfFEz/onga4ttSKOUU5kk8KOeDRKT6+chHQsZRDVjwngKFTC
	 HMpi5SxHRVC0b1jauHaOqfDJuNtpgeTgvGV14Wk3jRNdXZ3k4ybULNLEYTAKHo5p1M
	 RgAb43dTGpBSkUq7m0q9YZCd7+I+0s18O4c8mths8GCGEuVkQpYm/Jl/3aG2beUoDM
	 pNxKDQ7oCabKQ==
Date: Tue, 31 Dec 2024 15:53:26 -0800
Subject: [PATCH 01/10] xfs_repair: allow sysadmins to add free inode btree
 indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779151.2710949.17310084377052885141.stgit@frogsfrogsfrogs>
In-Reply-To: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
References: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
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
to support the free inode btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    7 +++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   28 +++++++++++++++++++++++++++-
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 47 insertions(+), 1 deletion(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 63f8ee90307b30..e07fc3ddb3fb82 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -163,6 +163,13 @@ .SH OPTIONS
 extended attributes, symbolic links, and realtime free space metadata.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be mountable by older kernels.
+.TP 0.4i
+.B finobt
+Track free inodes through a separate free inode btree index to speed up inode
+allocation on old filesystems.
+This upgrade can fail if any AG has less than 1% free space remaining.
+The filesystem cannot be downgraded after this feature is enabled.
+This feature was added to Linux 3.16.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index 143b4a8beb53f4..f13497c3121d6b 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -53,6 +53,7 @@ bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
 bool	add_exchrange;		/* add file content exchange support */
+bool	add_finobt;		/* add free inode btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 8bb9bbaeca4fb0..c5b27d9a60cf2e 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -94,6 +94,7 @@ extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
 extern bool	add_exchrange;		/* add file content exchange support */
+extern bool	add_finobt;		/* add free inode btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 71576f5806e473..1bb7cd19025be7 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -123,7 +123,7 @@ set_inobtcount(
 		exit(0);
 	}
 
-	if (!xfs_has_finobt(mp)) {
+	if (!xfs_has_finobt(mp) && !add_finobt) {
 		printf(
 	_("Inode btree count feature requires free inode btree.\n"));
 		exit(0);
@@ -212,6 +212,28 @@ set_exchrange(
 	return true;
 }
 
+static bool
+set_finobt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (xfs_has_finobt(mp)) {
+		printf(_("Filesystem already supports free inode btrees.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Free inode btree feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding free inode btrees to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -378,6 +400,8 @@ need_check_fs_free_space(
 	struct xfs_mount		*mp,
 	const struct check_state	*old)
 {
+	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
+		return true;
 	return false;
 }
 
@@ -455,6 +479,8 @@ upgrade_filesystem(
 		dirty |= set_nrext64(mp, &new_sb);
 	if (add_exchrange)
 		dirty |= set_exchrange(mp, &new_sb);
+	if (add_finobt)
+		dirty |= set_finobt(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 7bf75c09b94542..d8f92b52b66f3a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -71,6 +71,7 @@ enum c_opt_nums {
 	CONVERT_BIGTIME,
 	CONVERT_NREXT64,
 	CONVERT_EXCHRANGE,
+	CONVERT_FINOBT,
 	C_MAX_OPTS,
 };
 
@@ -80,6 +81,7 @@ static char *c_opts[] = {
 	[CONVERT_BIGTIME]	= "bigtime",
 	[CONVERT_NREXT64]	= "nrext64",
 	[CONVERT_EXCHRANGE]	= "exchange",
+	[CONVERT_FINOBT]	= "finobt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -372,6 +374,15 @@ process_args(int argc, char **argv)
 		_("-c exchange only supports upgrades\n"));
 					add_exchrange = true;
 					break;
+				case CONVERT_FINOBT:
+					if (!val)
+						do_abort(
+		_("-c finobt requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c finobt only supports upgrades\n"));
+					add_finobt = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

