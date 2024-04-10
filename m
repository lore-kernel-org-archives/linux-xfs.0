Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9011A55
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710927; cv=none; b=CyTEFTMsziZPrdUNTP+wA6LnIAJAYIzu4LGWRLgUPk0n5SuRExY4PTbFedB6RSZhFmXjUcgg9b/BgDaIXoNUs0GQ9opzoDx9EboHzVVbVQ03uDPMfnBOnqnJMQVz3ZAeS976Hg7AomN4AL1CgjYmGC63stXCjrONX1sLh9JYRCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710927; c=relaxed/simple;
	bh=Cv5SNt81jjSd0Z1cPwJiMil+3I6ch3ixDBMnc8l6TO0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ihySk2WHMES1mWUm+qX9mc/n4czVAYIR03KNCfrE4UHqvILhwGv5Qtr8snSBQ+WihXdZWpjJsKD26uiF9rd6iITV+kiPa/JH5tU0uzYfOMyYUI3nrR0FIaMh6CyjermWZTVlIXgaoxyyg0bvULovFcu12c6ZURQPAaiWJvzqG9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtpr2DZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtpr2DZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFDAC433F1;
	Wed, 10 Apr 2024 01:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710927;
	bh=Cv5SNt81jjSd0Z1cPwJiMil+3I6ch3ixDBMnc8l6TO0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jtpr2DZENJdmxzUmddAthmmkcOVRyvUe66zoPEfVaJ4b5qbKCIxsUW7X5RBhsNOxz
	 uM10nW/JVxJa/xdNSLDVa+dUDas/ECVzVQc/O8+YEw9jTIB9vgIWamAtPLbLigoP7c
	 vnxedsIstCF43II880AP1tyAOGvUVKpV5DjgiOqChRSve9FOZXEa6AX4HQH4cLma0s
	 W0OlwCGRg+aTmE2HyJDtSFZ8Fm3EgeSlAyiJcNMdh49hn6ZxIz2gTafjokn0Hq3U2V
	 Z/h6SPKikZcs/9PeFsYLvo7l1hHmKWiPxFl67qP8Bnr1w32RzLvermIMjO66LPxEaz
	 Pc1rDlcMPazWQ==
Date: Tue, 09 Apr 2024 18:02:07 -0700
Subject: [PATCH 1/7] xfs: check dirents have parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970483.3632713.2430218014853007760.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
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

If the fs has parent pointers, we need to check that each child dirent
points to a file that has a parent pointer pointing back at us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_parent.c |   22 +++++++++
 fs/xfs/libxfs/xfs_parent.h |    5 ++
 fs/xfs/scrub/dir.c         |  112 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 138 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index db8cfad0b968e..5898dc1ebff02 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -294,3 +294,25 @@ xfs_parent_from_xattr(
 		*parent_gen = be32_to_cpu(rec->p_gen);
 	return 1;
 }
+
+/*
+ * Look up a parent pointer record (@parent_name -> @pptr) of @ip.
+ *
+ * Caller must hold at least ILOCK_SHARED.  The scratchpad need not be
+ * initialized.
+ *
+ * Returns 0 if the pointer is found, -ENOATTR if there is no match, or a
+ * negative errno.
+ */
+int
+xfs_parent_lookup(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_name		*parent_name,
+	struct xfs_parent_rec		*pptr,
+	struct xfs_da_args		*scratch)
+{
+	memset(scratch, 0, sizeof(struct xfs_da_args));
+	xfs_parent_da_args_init(scratch, tp, pptr, ip, ip->i_ino, parent_name);
+	return xfs_attr_get_ilocked(scratch);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 3003ab496f854..b063312a61acb 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -96,4 +96,9 @@ int xfs_parent_from_xattr(struct xfs_mount *mp, unsigned int attr_flags,
 		const void *value, unsigned int valuelen,
 		xfs_ino_t *parent_ino, uint32_t *parent_gen);
 
+/* Repair functions */
+int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
+		const struct xfs_name *name, struct xfs_parent_rec *pptr,
+		struct xfs_da_args *scratch);
+
 #endif /* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 3fe6ffcf9c062..e11d73eb89352 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -16,6 +16,8 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_health.h"
+#include "xfs_attr.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
@@ -41,6 +43,14 @@ xchk_setup_directory(
 
 /* Directories */
 
+struct xchk_dir {
+	struct xfs_scrub	*sc;
+
+	/* information for parent pointer validation. */
+	struct xfs_parent_rec	pptr_rec;
+	struct xfs_da_args	pptr_args;
+};
+
 /* Scrub a directory entry. */
 
 /* Check that an inode's mode matches a given XFS_DIR3_FT_* type. */
@@ -63,6 +73,90 @@ xchk_dir_check_ftype(
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 }
 
+/*
+ * Try to lock a child file for checking parent pointers.  Returns the inode
+ * flags for the locks we now hold, or zero if we failed.
+ */
+STATIC unsigned int
+xchk_dir_lock_child(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+		return 0;
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		return 0;
+	}
+
+	if (!xfs_inode_has_attr_fork(ip) || !xfs_need_iread_extents(&ip->i_af))
+		return XFS_IOLOCK_SHARED | XFS_ILOCK_SHARED;
+
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		return 0;
+	}
+
+	return XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL;
+}
+
+/* Check the backwards link (parent pointer) associated with this dirent. */
+STATIC int
+xchk_dir_parent_pointer(
+	struct xchk_dir		*sd,
+	const struct xfs_name	*name,
+	struct xfs_inode	*ip)
+{
+	struct xfs_scrub	*sc = sd->sc;
+	int			error;
+
+	xfs_inode_to_parent_rec(&sd->pptr_rec, sc->ip);
+	error = xfs_parent_lookup(sc->tp, ip, name, &sd->pptr_rec,
+			&sd->pptr_args);
+	if (error == -ENOATTR)
+		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	return 0;
+}
+
+/* Look for a parent pointer matching this dirent, if the child isn't busy. */
+STATIC int
+xchk_dir_check_pptr_fast(
+	struct xchk_dir		*sd,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	struct xfs_inode	*ip)
+{
+	struct xfs_scrub	*sc = sd->sc;
+	unsigned int		lockmode;
+	int			error;
+
+	/* dot and dotdot entries do not have parent pointers */
+	if (xfs_dir2_samename(name, &xfs_name_dot) ||
+	    xfs_dir2_samename(name, &xfs_name_dotdot))
+		return 0;
+
+	/* No self-referential non-dot or dotdot dirents. */
+	if (ip == sc->ip) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return -ECANCELED;
+	}
+
+	/* Try to lock the inode. */
+	lockmode = xchk_dir_lock_child(sc, ip);
+	if (!lockmode) {
+		xchk_set_incomplete(sc);
+		return -ECANCELED;
+	}
+
+	error = xchk_dir_parent_pointer(sd, name, ip);
+	xfs_iunlock(ip, lockmode);
+	return error;
+}
+
 /*
  * Scrub a single directory entry.
  *
@@ -80,6 +174,7 @@ xchk_dir_actor(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip;
+	struct xchk_dir		*sd = priv;
 	xfs_ino_t		lookup_ino;
 	xfs_dablk_t		offset;
 	int			error = 0;
@@ -146,6 +241,14 @@ xchk_dir_actor(
 		goto out;
 
 	xchk_dir_check_ftype(sc, offset, ip, name->type);
+
+	if (xfs_has_parent(mp)) {
+		error = xchk_dir_check_pptr_fast(sd, dapos, name, ip);
+		if (error)
+			goto out_rele;
+	}
+
+out_rele:
 	xchk_irele(sc, ip);
 out:
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -767,6 +870,7 @@ int
 xchk_directory(
 	struct xfs_scrub	*sc)
 {
+	struct xchk_dir		*sd;
 	int			error;
 
 	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
@@ -799,8 +903,14 @@ xchk_directory(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return 0;
 
+	sd = kvzalloc(sizeof(struct xchk_dir), XCHK_GFP_FLAGS);
+	if (!sd)
+		return -ENOMEM;
+	sd->sc = sc;
+
 	/* Look up every name in this directory by hash. */
-	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, NULL);
+	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, sd);
+	kvfree(sd);
 	if (error && error != -ECANCELED)
 		return error;
 

