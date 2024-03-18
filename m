Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64781535D3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798496; cv=none; b=SvqdToa1Gp6+H0XUvIAOoWy5wTbBZsRoaM8WrcO8H59AHJr7IMEiAkmYMptwfJpmQgBDoM6X7vJ+HUzXiWIBvqL+uDkqMTnLyb/xOby3yMk0D03nJR0Ctzcrwcr03pdxCjidlS0xbzKiPAzOGB77MqP4Xl3Cn4thMgEoJWyv0vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798496; c=relaxed/simple;
	bh=+6MQe/jFn5+pTTSC6NrQB5RObTG42do+qPxr5bF47ts=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NElRH5RRQOKKasWDLBudUyU504sfWAj1Dm29GPCbczb/TSx6o02srMYjn4Auh5chnx+wXT6DHVsxLuk9NsVHQqDm0VOZutxvpTCsCPUdeHKpewQ4fbHXGqf8h6pHqjUYO+cXh4W1MQIEPBPS7ofXV9Hg/qyHsPMQ0wImWfxEWWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XF6DCI4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XF6DCI4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54EBC433F1;
	Mon, 18 Mar 2024 21:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798495;
	bh=+6MQe/jFn5+pTTSC6NrQB5RObTG42do+qPxr5bF47ts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XF6DCI4fxNVsg0G883/P7b67XTGjkK4zdqliplHJv/oBLSvgfOowmXW6XSetnejO1
	 3LBOwslAEya1VMdR0D7OJC4XSWUEfxR9AF5zCok40Klj3iljRizL/9sqKJtMQOvQkD
	 HHoFZhW63O6hBZOj6clbTbX79pmbmIFubB+q+fGK1cQtp8S6wOq5FOwb0jGRcWS05b
	 5l5Le76LiQ+gP8mz0Nv5KdsijvEOeUb80t8a0djMU5/YaE1Bz5SEaWWZa9w/wr/JUm
	 OFQvq6ifrVV1KaCx4OedSQo9awtdiaQcJn8vN/gtDu3zDYf2UWOgE56crDJHqdERt1
	 1vare4MzPPL3A==
Date: Mon, 18 Mar 2024 14:48:15 -0700
Subject: [PATCH 01/23] xfs: check dirents have parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802711.3808642.9840816764752307950.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_parent.c |   54 +++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |   10 ++++
 fs/xfs/scrub/dir.c         |  122 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 48a2dfcc465fa..09495eb368e2b 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -366,3 +366,57 @@ xfs_parent_irec_hashname(
 
 	irec->p_namehash = xfs_dir2_hashname(mp, &dname);
 }
+
+static inline void
+xfs_parent_scratch_init(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.op_flags	= XFS_DA_OP_NVLOOKUP;
+	scr->args.trans		= tp;
+	scr->args.value		= (void *)pptr->p_name;
+	scr->args.valuelen	= pptr->p_namelen;
+	scr->args.whichfork	= XFS_ATTR_FORK;
+	scr->args.hashval	= xfs_da_hashname((const void *)&scr->rec,
+					sizeof(struct xfs_parent_name_rec));
+}
+
+/*
+ * Look up the @name associated with the parent pointer (@pptr) of @ip.
+ * Caller must hold at least ILOCK_SHARED.  Returns 0 if the pointer is found,
+ * -ENOATTR if there is no match, or a negative errno.  The scratchpad need not
+ * be initialized.
+ */
+int
+xfs_parent_lookup(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	int				error;
+
+	/*
+	 * Make sure the attr fork iext tree is loaded in transaction context
+	 * before we start down the rest of the call path.
+	 */
+	if (xfs_inode_hasattr(ip)) {
+		error = xfs_iread_extents(tp, ip, XFS_ATTR_FORK);
+		if (error)
+			return error;
+	}
+
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(tp, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_OKNOENT;
+
+	return xfs_attr_get_ilocked(&scr->args);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index e43ae5a7df826..e4443da1d86f2 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -152,4 +152,14 @@ void xfs_parent_irec_hashname(struct xfs_mount *mp,
 bool xfs_parent_verify_irec(struct xfs_mount *mp,
 		const struct xfs_parent_name_irec *irec);
 
+/* Scratchpad memory so that raw parent operations don't burn stack space. */
+struct xfs_parent_scratch {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 3fe6ffcf9c062..88370804025c4 100644
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
@@ -41,6 +43,20 @@ xchk_setup_directory(
 
 /* Directories */
 
+struct xchk_dir {
+	struct xfs_scrub	*sc;
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_parent_name_irec pptr;
+
+	/* xattr key and da args for parent pointer validation. */
+	struct xfs_parent_scratch pptr_scratch;
+
+	/* Name buffer for dirent revalidation. */
+	uint8_t			namebuf[MAXNAMELEN];
+
+};
+
 /* Scrub a directory entry. */
 
 /* Check that an inode's mode matches a given XFS_DIR3_FT_* type. */
@@ -63,6 +79,94 @@ xchk_dir_check_ftype(
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
+	sd->pptr.p_ino = sc->ip->i_ino;
+	sd->pptr.p_gen = VFS_I(sc->ip)->i_generation;
+	sd->pptr.p_namelen = name->len;
+	memcpy(sd->pptr.p_name, name->name, name->len);
+	xfs_parent_irec_hashname(sc->mp, &sd->pptr);
+
+	error = xfs_parent_lookup(sc->tp, ip, &sd->pptr, &sd->pptr_scratch);
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
@@ -80,6 +184,7 @@ xchk_dir_actor(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip;
+	struct xchk_dir		*sd = priv;
 	xfs_ino_t		lookup_ino;
 	xfs_dablk_t		offset;
 	int			error = 0;
@@ -146,6 +251,14 @@ xchk_dir_actor(
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
@@ -767,6 +880,7 @@ int
 xchk_directory(
 	struct xfs_scrub	*sc)
 {
+	struct xchk_dir		*sd;
 	int			error;
 
 	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
@@ -799,8 +913,14 @@ xchk_directory(
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
 

