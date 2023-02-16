Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A152C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjBPUt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjBPUt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:49:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CBE4BEB7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11FCEB82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F5FC433D2;
        Thu, 16 Feb 2023 20:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580592;
        bh=nU8MZIkA/59rap4/jMUE8cSiAeB2ujtnNvbww7B9t+k=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jqRePH0iyjc3P1S1MD+f1SSiMU3mfUMumPCRlyxQVNM4SYGHA6Q9khOND00B+jpMm
         m3h0Ber0bgUbzC34Ynwt8H5j0Nd4au8dBR5FeZmLpv7DdG16jQJF2/xGVAREyYqsJV
         QybS7judzxB4CZ1mqjJN2UURm1jZczTLHpc985ebcVsc9CaHwdX8q5py//kCwaEoSY
         EVxqjcOSrMqlyy9gr9rO8PnMhr1LKfw1zJCO5n0d2cyt3s+rBWedCwrH0Pqtj5jNkx
         D+c64YtUwOGpJ2wlwRf64Wm/m0qegQQzb6UOBElnuvSoRCeQSPeTbvHAZuo01Vxdjn
         PhVWO6FUQtC4g==
Date:   Thu, 16 Feb 2023 12:49:52 -0800
Subject: [PATCH 1/2] xfs: scrub parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874879.3475106.6130523299352387443.stgit@magnolia>
In-Reply-To: <167657874864.3475106.13930268587808485264.stgit@magnolia>
References: <167657874864.3475106.13930268587808485264.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Actually check parent pointers now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent.c |  291 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h  |   33 ++++++
 2 files changed, 324 insertions(+)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index d59184a59671..1bb196f2c1b2 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -14,9 +14,13 @@
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/readdir.h"
+#include "scrub/listxattr.h"
+#include "scrub/trace.h"
 
 /* Set us up to scrub parents. */
 int
@@ -231,6 +235,8 @@ xchk_parent_validate(
 	return error;
 }
 
+STATIC int xchk_parent_pptr(struct xfs_scrub *sc);
+
 /* Scrub a parent pointer. */
 int
 xchk_parent(
@@ -240,6 +246,9 @@ xchk_parent(
 	xfs_ino_t		parent_ino;
 	int			error;
 
+	if (xfs_has_parent(mp))
+		return xchk_parent_pptr(sc);
+
 	/*
 	 * If we're a directory, check that the '..' link points up to
 	 * a directory that has one entry pointing to us.
@@ -282,3 +291,285 @@ xchk_parent(
 
 	return xchk_parent_validate(sc, parent_ino);
 }
+
+/*
+ * Checking of Parent Pointers
+ * ===========================
+ *
+ * On filesystems with directory parent pointers, we check the referential
+ * integrity by visiting each parent pointer of a child file and checking that
+ * the directory referenced by the pointer actually has a dirent pointing back
+ * to the child file.
+ */
+
+struct xchk_pptrs {
+	struct xfs_scrub	*sc;
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_parent_name_irec pptr;
+
+	/* Parent of this directory. */
+	xfs_ino_t		parent_ino;
+};
+
+/* Look up the dotdot entry so that we can check it as we walk the pptrs. */
+STATIC int
+xchk_parent_dotdot(
+	struct xchk_pptrs	*pp)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	int			error;
+
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		pp->parent_ino = NULLFSINO;
+		return 0;
+	}
+
+	/* Look up '..' */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &pp->parent_ino,
+			NULL);
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		return error;
+	if (!xfs_verify_dir_ino(sc->mp, pp->parent_ino)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
+	/* Is this the root dir?  Then '..' must point to itself. */
+	if (sc->ip == sc->mp->m_rootip && sc->ip->i_ino != pp->parent_ino)
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	return 0;
+}
+
+/*
+ * Try to lock a parent directory for checking dirents.  Returns the inode
+ * flags for the locks we now hold, or zero if we failed.
+ */
+STATIC unsigned int
+xchk_parent_lock_dir(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp)
+{
+	if (!xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED))
+		return 0;
+
+	if (!xfs_ilock_nowait(dp, XFS_ILOCK_SHARED)) {
+		xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+		return 0;
+	}
+
+	if (!xfs_need_iread_extents(&dp->i_df))
+		return XFS_IOLOCK_SHARED | XFS_ILOCK_SHARED;
+
+	xfs_iunlock(dp, XFS_ILOCK_SHARED);
+
+	if (!xfs_ilock_nowait(dp, XFS_ILOCK_EXCL)) {
+		xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+		return 0;
+	}
+
+	return XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL;
+}
+
+/* Check the forward link (dirent) associated with this parent pointer. */
+STATIC int
+xchk_parent_dirent(
+	struct xchk_pptrs	*pp,
+	struct xfs_inode	*dp)
+{
+	struct xfs_name		xname = {
+		.name		= pp->pptr.p_name,
+		.len		= pp->pptr.p_namelen,
+	};
+	struct xfs_scrub	*sc = pp->sc;
+	xfs_ino_t		child_ino;
+	xfs_dir2_dataptr_t	child_diroffset;
+	int			error;
+
+	/*
+	 * Use the name attached to this parent pointer to look up the
+	 * directory entry in the alleged parent.
+	 */
+	error = xchk_dir_lookup(sc, dp, &xname, &child_ino, &child_diroffset);
+	if (error == -ENOENT) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		return error;
+
+	/* Does the inode number match? */
+	if (child_ino != sc->ip->i_ino) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+
+	/* Does the directory offset match? */
+	if (pp->pptr.p_diroffset != child_diroffset) {
+		trace_xchk_parent_bad_dapos(sc->ip, pp->pptr.p_diroffset,
+				dp->i_ino, child_diroffset, xname.name,
+				xname.len);
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+
+	/*
+	 * If we're scanning a directory, we should only ever encounter a
+	 * single parent pointer, and it should match the dotdot entry.  We set
+	 * the parent_ino from the dotdot entry before the scan, so compare it
+	 * now.
+	 */
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
+		return 0;
+
+	if (pp->parent_ino != dp->i_ino) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+
+	pp->parent_ino = NULLFSINO;
+	return 0;
+}
+
+/* Try to grab a parent directory. */
+STATIC int
+xchk_parent_iget(
+	struct xchk_pptrs		*pp,
+	struct xfs_inode		**dpp)
+{
+	struct xfs_scrub		*sc = pp->sc;
+	struct xfs_inode		*ip;
+	int				error;
+
+	/* Validate inode number. */
+	error = xfs_dir_ino_validate(sc->mp, pp->pptr.p_ino);
+	if (error) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	error = xchk_iget(sc, pp->pptr.p_ino, &ip);
+	if (error == -EINVAL || error == -ENOENT) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		return error;
+
+	/* The parent must be a directory. */
+	if (!S_ISDIR(VFS_I(ip)->i_mode)) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		goto out_rele;
+	}
+
+	/* Validate generation number. */
+	if (VFS_I(ip)->i_generation != pp->pptr.p_gen) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		goto out_rele;
+	}
+
+	*dpp = ip;
+	return 0;
+out_rele:
+	xchk_irele(sc, ip);
+	return 0;
+}
+
+/*
+ * Walk an xattr of a file.  If this xattr is a parent pointer, follow it up
+ * to a parent directory and check that the parent has a dirent pointing back
+ * to us.
+ */
+STATIC int
+xchk_parent_scan_attr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xchk_pptrs	*pp = priv;
+	struct xfs_inode	*dp = NULL;
+	const struct xfs_parent_name_rec *rec = (const void *)name;
+	unsigned int		lockmode;
+	int			error;
+
+	/* Ignore incomplete xattrs */
+	if (attr_flags & XFS_ATTR_INCOMPLETE)
+		return 0;
+
+	/* Ignore anything that isn't a parent pointer. */
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	/* Does the ondisk parent pointer structure make sense? */
+	if (!xfs_parent_namecheck(sc->mp, rec, namelen, attr_flags)) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	if (!xfs_parent_valuecheck(sc->mp, value, valuelen)) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	xfs_parent_irec_from_disk(&pp->pptr, rec, value, valuelen);
+
+	error = xchk_parent_iget(pp, &dp);
+	if (error)
+		return error;
+	if (!dp)
+		return 0;
+
+	/* Try to lock the inode. */
+	lockmode = xchk_parent_lock_dir(sc, dp);
+	if (!lockmode) {
+		xchk_set_incomplete(sc);
+		error = -ECANCELED;
+		goto out_rele;
+	}
+
+	error = xchk_parent_dirent(pp, dp);
+	if (error)
+		goto out_unlock;
+
+out_unlock:
+	xfs_iunlock(dp, lockmode);
+out_rele:
+	xchk_irele(sc, dp);
+	return error;
+}
+
+/* Check parent pointers of a file. */
+STATIC int
+xchk_parent_pptr(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_pptrs	*pp;
+	int			error;
+
+	pp = kvzalloc(sizeof(struct xchk_pptrs), XCHK_GFP_FLAGS);
+	if (!pp)
+		return -ENOMEM;
+	pp->sc = sc;
+
+	error = xchk_parent_dotdot(pp);
+	if (error)
+		goto out_pp;
+
+	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, pp);
+	if (error == -ECANCELED) {
+		error = 0;
+		goto out_pp;
+	}
+	if (error)
+		goto out_pp;
+
+out_pp:
+	kvfree(pp);
+	return error;
+}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 81d26be0ef3b..ac21759fc3e1 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -896,6 +896,39 @@ TRACE_EVENT(xchk_nlinks_live_update,
 		  __get_str(name))
 );
 
+TRACE_EVENT(xchk_parent_bad_dapos,
+	TP_PROTO(struct xfs_inode *ip, unsigned int p_diroffset,
+		 xfs_ino_t parent_ino, unsigned int dapos,
+		 const char *name, unsigned int namelen),
+	TP_ARGS(ip, p_diroffset, parent_ino, dapos, name, namelen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, p_diroffset)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, dapos)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->p_diroffset = p_diroffset;
+		__entry->parent_ino = parent_ino;
+		__entry->dapos = dapos;
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx p_diroff 0x%x parent_ino 0x%llx parent_diroff 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->p_diroffset,
+		  __entry->parent_ino,
+		  __entry->dapos,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 

