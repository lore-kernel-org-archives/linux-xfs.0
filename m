Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F8C8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Taf/gjJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF69C433C8;
	Sun, 31 Dec 2023 23:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063688;
	bh=teyOIB43hjqYx5XSnbny2s26geySX5NtiXNxAizjD4k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Taf/gjJgSlTM4o0yE2OQxduETo5Itg07VEQ5c08IEbnbqQLk92zyTxges1RPDQQ0b
	 z0OTiGEgTABY8zHvIMgiah125giUcXU/GxnX+mkYdaHlDRCif5UE1IeGvkHsfD8+lk
	 VoTcLsK6phVEjNxnawgFG94ebzVqSSHaYjxLdjc0yQOqC+XyJ2iAbQWh2kIN84NYpQ
	 7/LtJLnqV3aXCjNpLsNHXHL1MwQna1wcU8f70537Cmh2lSXQDSJzQSriiHLmAJb46E
	 IAPcvjJ+pVnQRB7DXa0ONxwWaRUFgzXuq8GAt5D9xZdcMXEALNHt+C5im8nVU/CYar
	 dkUyx+nxrk0Lg==
Date: Sun, 31 Dec 2023 15:01:27 -0800
Subject: [PATCH 2/4] xfs_repair: allow sysadmins to add free inode btree
 indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405004077.1801995.14834194376025235922.stgit@frogsfrogsfrogs>
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
to support the free inode btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    7 +++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   26 ++++++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 46 insertions(+)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 4794d6774ed..efe2ce45fc2 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -156,6 +156,13 @@ data fork extent count will be 2^48 - 1, while the maximum attribute fork
 extent count will be 2^32 - 1. The filesystem cannot be downgraded after this
 feature is enabled. Once enabled, the filesystem will not be mountable by
 older kernels.  This feature was added to Linux 5.19.
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
index a68929bdc01..960dff28fba 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -52,6 +52,7 @@ bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
+bool	add_finobt;		/* add free inode btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index a67e384a626..4ec68ecd896 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -93,6 +93,7 @@ extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
+extern bool	add_finobt;		/* add free inode btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 36eb0c21de5..5d2bb859514 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -182,6 +182,28 @@ set_nrext64(
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
@@ -349,6 +371,8 @@ need_check_fs_free_space(
 	struct xfs_mount		*mp,
 	const struct check_state	*old)
 {
+	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
+		return true;
 	return false;
 }
 
@@ -424,6 +448,8 @@ upgrade_filesystem(
 		dirty |= set_bigtime(mp, &new_sb);
 	if (add_nrext64)
 		dirty |= set_nrext64(mp, &new_sb);
+	if (add_finobt)
+		dirty |= set_finobt(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index bf02beba375..b61af185c38 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -69,6 +69,7 @@ enum c_opt_nums {
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
 	CONVERT_NREXT64,
+	CONVERT_FINOBT,
 	C_MAX_OPTS,
 };
 
@@ -77,6 +78,7 @@ static char *c_opts[] = {
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
 	[CONVERT_NREXT64]	= "nrext64",
+	[CONVERT_FINOBT]	= "finobt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -336,6 +338,15 @@ process_args(int argc, char **argv)
 		_("-c nrext64 only supports upgrades\n"));
 					add_nrext64 = true;
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

