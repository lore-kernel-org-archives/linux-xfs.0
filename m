Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFA3C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSssc1sQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BC2C433C8;
	Sun, 31 Dec 2023 23:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064673;
	bh=bMZRAJvhpdnlLaDySPy1Bj4yNueN3SRvbuAGkTHa57A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YSssc1sQRo44Xpm0kSB8fXOen3+XfBvDp7h+txoUhtiQdZ2NXhiNT/yDeVwYt/SDA
	 vcjuHhViLmpAFxkZVFv6oDasmUi/iNn67Cbhb8m2zqYdVtE8Pf/13HvaSA/SZeUZrU
	 yVxejeGQVP7Mn+Q7svBVF3AiTNR5JUt6Mkyj8ESbIVDzNcqmlSgeOxLmuYJdyzN61j
	 /ybxctMJ0XQYuVMFn+1TR0shtpNJLtamo89ItI4Bg+51wi1UNf0L6GZHV78BbPXtQ6
	 XCdRV7mxBqA+kCXtQBrsILtgn173CPj12eHHMxXopaj/I5DAFI0Th3CofjRf2kSxMb
	 RApry450rMhvA==
Date: Sun, 31 Dec 2023 15:17:52 -0800
Subject: [PATCH 17/18] xfs_repair: upgrade an existing filesystem to have
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405007089.1805510.9426014403189395470.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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

Upgrade an existing filesystem to have parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    8 ++++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   39 +++++++++++++++++++++++++++++++++++++++
 repair/pptr.c        |   15 ++++++++++++++-
 repair/xfs_repair.c  |   11 +++++++++++
 6 files changed, 74 insertions(+), 1 deletion(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 467fb2dfd0a..28f28b6dd8f 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -177,6 +177,14 @@ and online repairs to space usage metadata.
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
index cff620e8f0e..7d95e210e8e 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -55,6 +55,7 @@ bool	add_nrext64;
 bool	add_finobt;		/* add free inode btrees */
 bool	add_reflink;		/* add reference count btrees */
 bool	add_rmapbt;		/* add reverse mapping btrees */
+bool	add_parent;		/* add parent pointers */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 76d22fd3b2c..71a64b94365 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -96,6 +96,7 @@ extern bool	add_nrext64;
 extern bool	add_finobt;		/* add free inode btrees */
 extern bool	add_reflink;		/* add reference count btrees */
 extern bool	add_rmapbt;		/* add reverse mapping btrees */
+extern bool	add_parent;		/* add parent pointers */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index be0d791a8b5..a58fa7d8a7b 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -265,6 +265,28 @@ set_rmapbt(
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
@@ -406,6 +428,19 @@ check_fs_free_space(
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
@@ -438,6 +473,8 @@ need_check_fs_free_space(
 		return true;
 	if (xfs_has_rmapbt(mp) && !(old->features & XFS_FEAT_RMAPBT))
 		return true;
+	if (xfs_has_parent(mp) && !(old->features & XFS_FEAT_PARENT))
+		return true;
 	return false;
 }
 
@@ -519,6 +556,8 @@ upgrade_filesystem(
 		dirty |= set_reflink(mp, &new_sb);
 	if (add_rmapbt)
 		dirty |= set_rmapbt(mp, &new_sb);
+	if (add_parent)
+		dirty |= set_parent(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/pptr.c b/repair/pptr.c
index 46a214f205e..77f49dbcb84 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -809,7 +809,7 @@ add_missing_parent_ptr(
 				ag_pptr->namelen,
 				name);
 		return;
-	} else {
+	} else if (!add_parent) {
 		do_warn(
  _("adding missing ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
 				(unsigned long long)ip->i_ino,
@@ -817,6 +817,19 @@ add_missing_parent_ptr(
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
index e94b0a79378..32c28a980ff 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -72,6 +72,7 @@ enum c_opt_nums {
 	CONVERT_FINOBT,
 	CONVERT_REFLINK,
 	CONVERT_RMAPBT,
+	CONVERT_PARENT,
 	C_MAX_OPTS,
 };
 
@@ -83,6 +84,7 @@ static char *c_opts[] = {
 	[CONVERT_FINOBT]	= "finobt",
 	[CONVERT_REFLINK]	= "reflink",
 	[CONVERT_RMAPBT]	= "rmapbt",
+	[CONVERT_PARENT]	= "parent",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -369,6 +371,15 @@ process_args(int argc, char **argv)
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

