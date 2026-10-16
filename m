Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0F73CB542
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179538; cv=none; b=WaXr61O6hihX/QPZ+snv/5nUyrJN71PW+icm2JVbMmBEsVwyqoN21ZBgnB9SUS+Z8QZkWA+bXehsWRDWchHV1NHamRg55hKWsZlFCRvc/TFVduHi7IMX1QHQCI99Y/OpwaREgoAncSQiaRgWpnRrhZMzy9n8t3l5bDoFtlZWkWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179538; c=relaxed/simple;
	bh=yN8QIXZOsSnknL8svMCP30NFTAFbuey+VI2tDv8bGSQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edANXacIqftxSnGgvwVbc8XgMm3Vf3qh0t9QTbx7JRLHoYxbVvI/QLhEHQaB3Wj7MCB0elcZVQF1Yd8jWXHN+okHIdMDz3sBaG1cKEYjgpjOdKRqYOojGzmzHWXGsIOGMuWg3FK1xDLWi5xSGMmBhx/dbDpLYGoIK8NtGbFKHp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUOwO4ol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUOwO4ol"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 21E9E1F000C4;
	Fri, 16 Oct 2026 19:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179534;
	bh=hz5uzSjSXLDcBrIkG7Y0j2wXpipi5aqLma3q2ohMc/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kUOwO4ol3tyGMSRhV0SxBQ7b64eAy6H8YIfr5jow0eCxc5dZfr5xGBj6XR15gGCr8
	 aYmsHQRJvwTAGKDlaLEROxBL2jsyF/kF3KtCI6hMIxrIAFKqcnx9P9huhusZJgNQAt
	 D7IXzefnj15/Bi3fg3rq7dtj978zG2cw5Xmx22QdKOb4ABcTqqfAnMZrJIEmGb2+8A
	 tKfU8xeyc3dczeMB1F8VovVh4gd2szl4pfW7xhXbVK3TjRbpCmThfGfn8Il0UhHWvt
	 mRCdBcLbSBYDvmVPaWND+KnmIyt+FxrAw8dGNdcaOGJYn9Yg4le57bHbgUHPOALtaA
	 Ro7LsZT1YGF7A==
Date: Fri, 16 Oct 2026 12:38:53 -0700
Subject: [PATCH 04/10] xfs_repair: upgrade an existing filesystem to have
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942811.717548.12956795659543748299.stgit@frogsfrogsfrogs>
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

Upgrade an existing filesystem to have parent pointers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.h     |    1 +
 man/man8/xfs_admin.8 |    8 ++++++++
 repair/globals.c     |    1 +
 repair/phase2.c      |   39 +++++++++++++++++++++++++++++++++++++++
 repair/pptr.c        |   15 ++++++++++++++-
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 74 insertions(+), 1 deletion(-)


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
 
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 19dde611891dbc..edb22544d4276a 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -192,6 +192,14 @@ .SH OPTIONS
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
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 399a03a171e3a3..600901e5b5f106 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -302,6 +302,28 @@ set_rmapbt(
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
@@ -438,6 +460,19 @@ check_fs_free_space(
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
+ _("Not enough free space to add parent pointers.\n"));
+			exit(1);
+		}
+	}
+
 	/*
 	 * Would the post-upgrade filesystem have enough free space on the data
 	 * device after making per-AG reservations?
@@ -470,6 +505,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_rmapbt(mp) && !(old->features & XFS_FEAT_RMAPBT))
 		return true;
+	if (xfs_has_parent(mp) && !(old->features & XFS_FEAT_PARENT))
+		return true;
 	return false;
 }
 
@@ -553,6 +590,8 @@ upgrade_filesystem(
 		dirty |= set_reflink(mp, &new_sb);
 	if (add_rmapbt)
 		dirty |= set_rmapbt(mp, &new_sb);
+	if (add_parent)
+		dirty |= set_parent(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/pptr.c b/repair/pptr.c
index 84cd27d62b7c0b..dd8db4f40e9aac 100644
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
 				(unsigned long long)I_INO(ip),
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
index b6c7043bb1091a..2337f707cc24dc 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -75,6 +75,7 @@ enum c_opt_nums {
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
+	CONVERT_PARENT,
 	C_MAX_OPTS,
 };
 
@@ -87,6 +88,7 @@ static char *c_opts[] = {
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
+	[CONVERT_PARENT]	= "parent",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -406,6 +408,15 @@ process_args(int argc, char **argv)
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

