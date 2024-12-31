Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3609C29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689254; cv=none; b=hOBZ1MmYjJSg39m4nZ1tKfKthuXBwcCSJyAPeRmlfJqKTitXPlRPvHqajnYJ4Aj3lji8cauAlyt//Z0QMBJSC6KsEww0HXLWO0cyxMCfKJiCJAxALBh5KkSHQvlqmWw3DU2DrgJMhlRn7ol9iGTqu/9a5F8Z4LcpDFIj5kOaDwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689254; c=relaxed/simple;
	bh=d6K66dHoTlG5bT0Hs4rnmYy8y184dxMN3jdboHGmU+Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9OJX7fMI1iHIAUvW2TDxMy3Ozc+GIyykvtVUjHV+AP/kn6+4QhLUHjtzz51jAde8APxzAfb1kfkivvo1BHr9Syg6Fjpqb+YC+ncU/N3SVmrtGyQL58XaCPex85bGuPspZ+1kgTz/JSjvQE3IEby+c675bJvGbsnrtz0p7dW5R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCVz72Jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCVz72Jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E18C4CED2;
	Tue, 31 Dec 2024 23:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689254;
	bh=d6K66dHoTlG5bT0Hs4rnmYy8y184dxMN3jdboHGmU+Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eCVz72JyVgnP8pXSc4w5DCIh/w2Mt2JhTCjk6dOBUjBSqxRbwkRgs7eX9uyJ585VT
	 kCxgGkzP5fd9GbuVLLOQRp/KspKk3h/jLjgH/vJqxLNX7QHQ7XExVkH+l89QA2JV+T
	 NciY4BSxgIdyNdU6tgei0evL9Tdj1GJuDbJz7MKsfECKSdiBWumDsbS8Bj3E/B3g5G
	 SLY3frapSLvzl58TxJNRqoqYJE7wBpcJRApiArL8imEAwgHm/jEq5ZbgolklXeUQfA
	 5cdMNsSAH/EZWDBu354sCYXPogPLp6vGpa1mGnDaXAVZgRpsE3zbNcKiLMcQjKJrPX
	 p9tlypUSrAIag==
Date: Tue, 31 Dec 2024 15:54:13 -0800
Subject: [PATCH 04/10] xfs_repair: upgrade an existing filesystem to have
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779195.2710949.139844435210923982.stgit@frogsfrogsfrogs>
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

Upgrade an existing filesystem to have parent pointers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    8 ++++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   39 +++++++++++++++++++++++++++++++++++++++
 repair/pptr.c        |   15 ++++++++++++++-
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 74 insertions(+), 1 deletion(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 74a400dcfeb557..a25e599e5f8e2c 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -184,6 +184,14 @@ .SH OPTIONS
 The filesystem cannot be downgraded after this feature is enabled.
 This upgrade can fail if any AG has less than 5% free space remaining.
 This feature was added to Linux 4.8.
+.TP 0.4i
+.B parent
+Store in each child file a mirror a pointing back to the parent directory.
+This enables much stronger cross-referencing and online repairs of the
+directory tree.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if the filesystem has less than 25% free space remaining.
+This feature is not upstream yet.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index dd7c422bb922e4..320fcf6cfd701e 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -56,6 +56,7 @@ bool	add_exchrange;		/* add file content exchange support */
 bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
 bool	add_rmapbt;		/* add reverse mapping btrees */
+bool	add_parent;		/* add parent pointers */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index d8c2aae23d8f0a..77d5d110048713 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -97,6 +97,7 @@ extern bool	add_exchrange;		/* add file content exchange support */
 extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
 extern bool	add_rmapbt;		/* add reverse mapping btrees */
+extern bool	add_parent;		/* add parent pointers */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 9dd37e7fc5c111..763cffdfe9d8d2 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -295,6 +295,28 @@ set_rmapbt(
 	return true;
 }
 
+static bool
+set_parent(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (xfs_has_parent(mp)) {
+		printf(_("Filesystem already supports parent pointers.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Parent pointer feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding parent pointers to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_PARENT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -435,6 +457,19 @@ check_fs_free_space(
 		libxfs_trans_cancel(tp);
 	}
 
+	/*
+	 * If we're adding parent pointers, we need at least 25% free since
+	 * scanning the entire filesystem to guesstimate the overhead is
+	 * prohibitively expensive.
+	 */
+	if (xfs_has_parent(mp) && !(old->features & XFS_FEAT_PARENT)) {
+		if (mp->m_sb.sb_fdblocks < mp->m_sb.sb_dblocks / 4) {
+			printf(
+ _("Filesystem does not have enough space to add parent pointers.\n"));
+			exit(1);
+		}
+	}
+
 	/*
 	 * Would the post-upgrade filesystem have enough free space on the data
 	 * device after making per-AG reservations?
@@ -467,6 +502,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_rmapbt(mp) && !(old->features & XFS_FEAT_RMAPBT))
 		return true;
+	if (xfs_has_parent(mp) && !(old->features & XFS_FEAT_PARENT))
+		return true;
 	return false;
 }
 
@@ -550,6 +587,8 @@ upgrade_filesystem(
 		dirty |= set_reflink(mp, &new_sb);
 	if (add_rmapbt)
 		dirty |= set_rmapbt(mp, &new_sb);
+	if (add_parent)
+		dirty |= set_parent(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/pptr.c b/repair/pptr.c
index ac0a9c618bc87d..a8156e55f1fdfc 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -793,7 +793,7 @@ add_missing_parent_ptr(
 				ag_pptr->namelen,
 				name);
 		return;
-	} else {
+	} else if (!add_parent) {
 		do_warn(
  _("adding missing ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
 				(unsigned long long)ip->i_ino,
@@ -801,6 +801,19 @@ add_missing_parent_ptr(
 				ag_pptr->parent_gen,
 				ag_pptr->namelen,
 				name);
+	} else {
+		static bool		warned = false;
+		static pthread_mutex_t	lock = PTHREAD_MUTEX_INITIALIZER;
+
+		if (!warned) {
+			pthread_mutex_lock(&lock);
+			if (!warned) {
+				do_warn(
+ _("setting parent pointers to upgrade filesystem\n"));
+				warned = true;
+			}
+			pthread_mutex_unlock(&lock);
+		}
 	}
 
 	error = add_file_pptr(ip, ag_pptr, name);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ca72c65f9d772a..189665a07d6892 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -74,6 +74,7 @@ enum c_opt_nums {
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
+	CONVERT_PARENT,
 	C_MAX_OPTS,
 };
 
@@ -86,6 +87,7 @@ static char *c_opts[] = {
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
+	[CONVERT_PARENT]	= "parent",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -405,6 +407,15 @@ process_args(int argc, char **argv)
 		_("-c rmapbt only supports upgrades\n"));
 					add_rmapbt = true;
 					break;
+				case CONVERT_PARENT:
+					if (!val)
+						do_abort(
+		_("-c parent requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c parent only supports upgrades\n"));
+					add_parent = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

