Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755142AbcI0SKa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Sep 2016 14:10:30 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libxfs: remove unused libxfs_iget arg
Message-ID: <355fec5f-f7ef-8472-c71b-7bfa9d9ab8bd@redhat.com>
Date: Tue, 27 Sep 2016 13:10:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs <linux-xfs@vger.kernel.org>

libxfs_iget() is always called with bno == 0.
Which is probably a good thing, because it then passes
bno to xfs_iread as iget_flags!

So remove the libxfs_iget arg, and explicitly pass
0 to xfs_iread for flags.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(or should we just rename/re-type bno to a flags arg?)

diff --git a/db/attrset.c b/db/attrset.c
index ec9da5a..ad3c8f3 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -151,7 +151,7 @@ attr_set_f(
 		value = NULL;
 	}
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip, 0)) {
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
@@ -226,7 +226,7 @@ attr_remove_f(
 
 	name = argv[optind];
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip, 0)) {
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 8141d97..0a8edeb 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -139,7 +139,7 @@ extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
 /* Inode Cache Interfaces */
 extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-				uint, struct xfs_inode **, xfs_daddr_t);
+				uint, struct xfs_inode **);
 extern void	libxfs_iput(struct xfs_inode *);
 
 #define IRELE(ip) libxfs_iput(ip)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index aa30522..1103e2c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1330,7 +1330,7 @@ extern kmem_zone_t	*xfs_inode_zone;
 
 int
 libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
-		xfs_inode_t **ipp, xfs_daddr_t bno)
+		xfs_inode_t **ipp)
 {
 	xfs_inode_t	*ip;
 	int		error = 0;
@@ -1341,7 +1341,7 @@ libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
 
 	ip->i_ino = ino;
 	ip->i_mount = mp;
-	error = xfs_iread(mp, tp, ip, bno);
+	error = xfs_iread(mp, tp, ip, 0);
 	if (error) {
 		kmem_zone_free(xfs_inode_zone, ip);
 		*ipp = NULL;
diff --git a/libxfs/trans.c b/libxfs/trans.c
index a4d9782..ea60d03 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -224,9 +224,9 @@ libxfs_trans_iget(
 	xfs_inode_log_item_t	*iip;
 
 	if (tp == NULL)
-		return libxfs_iget(mp, tp, ino, lock_flags, ipp, 0);
+		return libxfs_iget(mp, tp, ino, lock_flags, ipp);
 
-	error = libxfs_iget(mp, tp, ino, lock_flags, &ip, 0);
+	error = libxfs_iget(mp, tp, ino, lock_flags, &ip);
 	if (error)
 		return error;
 	ASSERT(ip != NULL);
diff --git a/repair/phase6.c b/repair/phase6.c
index 5507af4..06eed16 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -929,7 +929,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * would have been cleared in phase3 and phase4.
 	 */
 
-	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip, 0)))
+	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip)))
 		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
 			i, ORPHANAGE);
 
@@ -953,7 +953,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * use iget/ijoin instead of trans_iget because the ialloc
 	 * wrapper can commit the transaction and start a new one
 	 */
-/*	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip, 0)))
+/*	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip)))
 		do_error(_("%d - couldn't iget root inode to make %s\n"),
 			i, ORPHANAGE);*/
 
@@ -1067,7 +1067,7 @@ mv_orphanage(
 	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
 				(unsigned long long)ino);
 
-	err = -libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip, 0);
+	err = -libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip);
 	if (err)
 		do_error(_("%d - couldn't iget orphanage inode\n"), err);
 	/*
@@ -1079,7 +1079,7 @@ mv_orphanage(
 		xname.len = snprintf((char *)fname, sizeof(fname), "%llu.%d",
 					(unsigned long long)ino, ++incr);
 
-	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, 0)))
+	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p)))
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
 	xname.type = xfs_mode_to_ftype[(VFS_I(ino_p)->i_mode & S_IFMT)>>S_SHIFT];
@@ -2820,7 +2820,7 @@ process_dir_inode(
 
 	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip, 0);
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
 	if (error) {
 		if (!no_modify)
 			do_error(

