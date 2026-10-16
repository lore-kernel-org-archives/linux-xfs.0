Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3689331EBE
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179494; cv=none; b=fWTu5UDdAipyPIitlNiqDa0DCbYhCf7hB4oqW24UvsNDdMeH3u8DqaI6I2E+RLKHsu3btbO9xDHuphOcXAA+sCVNJ3UJNDQq0FiRK1VzWrdzr8pcg+lQopVX5HgjZ1p0dw6PmzpZC3RDO0e//rXjeKVrylVM8ipgLVSsc2iOCa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179494; c=relaxed/simple;
	bh=WMXv3F5UzI7ePEfBSfooiwO8K86QOtr4I06Pc2dGhrQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYZkG8DeeXleGesdDWNDgYTvEThFDcMdToVwlKrpChBq7VGgprC5TNh53bFpi3Ngks9dI+uicBWxZpey+5si+ocMqAIlhoQnwRCsKM8DPlRXesMw5K2UWJhE89++pICMc1zyUqRgBWZ9duGn0J68+SOuPZxikQBxFDGMtPTqWyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDzt5tzJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDzt5tzJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 249651F000C4;
	Fri, 16 Oct 2026 19:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179487;
	bh=cZX9EMx6VDJZsVggqV3+RV55E8+xViAOenDuGASktxc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HDzt5tzJoSEt4Yir4EfYjI/8xKMJJDkAppTgckyLOLujBikId+7gnpywCgfWNUOHJ
	 g6yj/1GC4OjoNzgBaJ2aDqbra3DxXWZy2dI4K+uGW3yvVX4jqhQqrKTkH9S0AhzmT7
	 K8lp3X6QEqmq8NP0JZ7s5htpr2k+mt4Fx+Fx6E3d/HQwLiPhIAo/7NsxB/Gg2l4B7A
	 Ub55XRxf+wU8xd3zCoYWqEQtDOeH6qYRINKCAVE+Qmf/nYGRpE3GvlIDcxssDAhtIE
	 JGEbrSxJn+bYFF86YPmHYuvSVvXfzGYLWYBZzTuLC6m/7VzCBjcmgrCo2sPPsEledo
	 dySfXVYXczpqA==
Date: Fri, 16 Oct 2026 12:38:06 -0700
Subject: [PATCH 01/10] xfs_repair: allow sysadmins to add free inode btree
 indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942755.717548.11162627077553457989.stgit@frogsfrogsfrogs>
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
to support the free inode btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.h     |    1 +
 man/man8/xfs_admin.8 |    7 +++++++
 repair/globals.c     |    1 +
 repair/phase2.c      |   28 +++++++++++++++++++++++++++-
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 47 insertions(+), 1 deletion(-)


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
 
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index b118b338fb53aa..1cf3d3d6aed721 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -171,6 +171,13 @@ .SH OPTIONS
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
 
diff --git a/repair/phase2.c b/repair/phase2.c
index ee166e62a00211..caedd51ff28aa7 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -125,7 +125,7 @@ set_inobtcount(
 		exit(0);
 	}
 
-	if (!xfs_has_finobt(mp)) {
+	if (!xfs_has_finobt(mp) && !add_finobt) {
 		printf(
 	_("Inode btree count feature requires free inode btree.\n"));
 		exit(0);
@@ -214,6 +214,28 @@ set_exchrange(
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
@@ -376,6 +398,8 @@ need_check_fs_free_space(
 	struct xfs_mount		*mp,
 	const struct check_state	*old)
 {
+	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
+		return true;
 	return false;
 }
 
@@ -453,6 +477,8 @@ upgrade_filesystem(
 		dirty |= set_nrext64(mp, &new_sb);
 	if (add_exchrange)
 		dirty |= set_exchrange(mp, &new_sb);
+	if (add_finobt)
+		dirty |= set_finobt(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2ad1ee8b4aa788..b87227d388276c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -72,6 +72,7 @@ enum c_opt_nums {
 	CONVERT_BIGTIME,
 	CONVERT_NREXT64,
 	CONVERT_EXCHRANGE,
+	CONVERT_FINOBT,
 	C_MAX_OPTS,
 };
 
@@ -81,6 +82,7 @@ static char *c_opts[] = {
 	[CONVERT_BIGTIME]	= "bigtime",
 	[CONVERT_NREXT64]	= "nrext64",
 	[CONVERT_EXCHRANGE]	= "exchange",
+	[CONVERT_FINOBT]	= "finobt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -373,6 +375,15 @@ process_args(int argc, char **argv)
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

