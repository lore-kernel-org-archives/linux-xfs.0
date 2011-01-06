Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p065jHKs018824 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 23:45:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97685FAD019
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 21:47:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	mArB8PdIY10urf0k for <xfs@oss.sgi.com>;
	Wed, 05 Jan 2011 21:47:13 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52140407-1927428
	for <xfs@oss.sgi.com>; Thu, 06 Jan 2011 16:16:50 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PaigS-0004v9-3q
	for xfs@oss.sgi.com; Thu, 06 Jan 2011 16:46:48 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Paig8-0003Gt-4z
	for xfs@oss.sgi.com; Thu, 06 Jan 2011 16:46:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] libxfs: sync files with 2.6.38 kernel code
Date: Thu,  6 Jan 2011 16:46:28 +1100
Message-Id: <1294292788-12547-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Bring the libxfs headers and code into sync with the 2.6.37 kernel code.
Update the rest of xfsprogs to work with the new code.

Note: this does not convert xfsprogs to the kernel xfs_trans_ijoin\ijoin_ref
interface, it maintains the older ijoin/ihold interface because of the
different way the inode reference counting works in libxfs. More work will be
needed to change it over to a manner compatible with the current kernel API.

Note: log sector size handling needs to be sorted out. Specifically,
initialising l_sectbb_log/l_sectBBsize correctly and removing the hacks in
xlog_bread and friends (libxlog/xfs_log_recover.c) to work around the fact they
are not initialised correctly. (FWIW, I don't think xfsprogs handles large log
sector size correctly as a result, and especially not if the log device sector
size is different to the data device sector size).

Testing:

Currently passes xfstests on x86_64 w/ 4k block sizes. On 512 byte block/2k
directory block filesystems repair is giving this additional output on test
033:

+cache_purge: shake on cache 0x67a060 left 1 nodes!?

The same test run saw test 104 generating:

+_check_xfs_filesystem: filesystem on /dev/vdb is inconsistent (c) (see 104.full)

which appears to be due to this output:

*** xfs_check output ***
XFS: Invalid block length (0x2000) given for buffer

Which may be a result of the above xlog_bread issues. I haven't confirmed
whether this is a regression or not yet.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/attr.c                  |   16 +-
 db/attrset.c               |    5 +-
 db/bmap.c                  |   18 +-
 db/bmap.h                  |    4 +-
 db/check.c                 |   50 +-
 db/convert.c               |    6 +-
 db/dir2sf.c                |    6 +-
 db/field.c                 |    2 +-
 db/frag.c                  |    6 +-
 db/inode.c                 |  124 ++--
 db/metadump.c              |   20 +-
 include/Makefile           |    5 +-
 include/atomic.h           |   31 +
 include/libxfs.h           |   44 +-
 include/libxlog.h          |   16 +-
 include/list.h             |   11 +
 include/radix-tree.h       |   76 ++
 include/xfs_ag.h           |  100 ++-
 include/xfs_alloc.h        |   58 +-
 include/xfs_arch.h         |   32 -
 include/xfs_attr_leaf.h    |   12 -
 include/xfs_attr_sf.h      |   42 +-
 include/xfs_bit.h          |   10 +-
 include/xfs_bmap.h         |  133 ++--
 include/xfs_bmap_btree.h   |   20 +-
 include/xfs_btree.h        |   31 +-
 include/xfs_btree_trace.h  |   17 -
 include/xfs_buf_item.h     |   51 +-
 include/xfs_da_btree.h     |   21 +-
 include/xfs_dfrag.h        |    5 +-
 include/xfs_dinode.h       |  149 ++---
 include/xfs_dir2.h         |    4 +-
 include/xfs_dir2_data.h    |    2 +-
 include/xfs_dir2_node.h    |    2 -
 include/xfs_dir2_sf.h      |    7 -
 include/xfs_extfree_item.h |   17 +-
 include/xfs_fs.h           |   30 +-
 include/xfs_ialloc.h       |   30 +-
 include/xfs_ialloc_btree.h |   23 +-
 include/xfs_imap.h         |   38 -
 include/xfs_inode.h        |  210 +++---
 include/xfs_inode_item.h   |   32 +-
 include/xfs_inum.h         |    1 -
 include/xfs_log.h          |   70 +-
 include/xfs_log_priv.h     |  331 +++++++--
 include/xfs_log_recover.h  |   25 +-
 include/xfs_mount.h        |  259 ++-----
 include/xfs_quota.h        |  160 ++--
 include/xfs_rtalloc.h      |   19 +-
 include/xfs_sb.h           |  168 +++--
 include/xfs_trace.h        |   85 +++
 include/xfs_trans.h        |  648 +++--------------
 include/xfs_trans_space.h  |    2 +-
 include/xfs_types.h        |   18 +-
 libxfs/Makefile            |    2 +-
 libxfs/init.c              |  133 +++-
 libxfs/logitem.c           |  371 +---------
 libxfs/radix-tree.c        |  805 ++++++++++++++++++++
 libxfs/trans.c             |  211 ++----
 libxfs/util.c              |   75 +-
 libxfs/xfs.h               |   49 +-
 libxfs/xfs_alloc.c         |  599 ++++++++--------
 libxfs/xfs_alloc_btree.c   |   46 +-
 libxfs/xfs_attr.c          |  138 ++--
 libxfs/xfs_attr_leaf.c     |  135 ++--
 libxfs/xfs_bmap.c          | 1773 ++++++++++++++++++++++----------------------
 libxfs/xfs_bmap_btree.c    |  129 ++--
 libxfs/xfs_btree.c         |   96 ++-
 libxfs/xfs_da_btree.c      |   48 +-
 libxfs/xfs_dir2.c          |   31 +-
 libxfs/xfs_dir2_block.c    |   28 +-
 libxfs/xfs_dir2_leaf.c     |   21 +-
 libxfs/xfs_dir2_node.c     |   29 +-
 libxfs/xfs_dir2_sf.c       |   24 +-
 libxfs/xfs_ialloc.c        | 1157 +++++++++++++++--------------
 libxfs/xfs_ialloc_btree.c  |   35 +-
 libxfs/xfs_inode.c         |  277 ++++----
 libxfs/xfs_mount.c         |  123 +---
 libxfs/xfs_trans.c         |  492 +++++++++++--
 libxlog/xfs_log_recover.c  |  606 ++++++++-------
 logprint/log_misc.c        |    2 +-
 logprint/log_print_all.c   |   13 +-
 logprint/log_print_trans.c |    4 +-
 mkfs/proto.c               |   18 +-
 mkfs/xfs_mkfs.c            |    3 +-
 repair/attr_repair.c       |   14 +-
 repair/dino_chunks.c       |   12 +-
 repair/dinode.c            |  275 ++++----
 repair/dir.c               |   18 +-
 repair/dir2.c              |   22 +-
 repair/incore.h            |    3 +
 repair/phase6.c            |   76 +-
 repair/prefetch.c          |   29 +-
 repair/rt.c                |    2 +-
 94 files changed, 5826 insertions(+), 5400 deletions(-)
 create mode 100644 include/atomic.h
 create mode 100644 include/radix-tree.h
 delete mode 100644 include/xfs_imap.h
 create mode 100644 include/xfs_trace.h
 create mode 100644 libxfs/radix-tree.c

diff --git a/db/attr.c b/db/attr.c
index f15d408..74bf411 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -219,7 +219,7 @@ attr_leaf_name_local_name_count(
 		e = &block->entries[i];
 		if (be16_to_cpu(e->nameidx) == off) {
 			if (e->flags & XFS_ATTR_LOCAL) {
-				l = XFS_ATTR_LEAF_NAME_LOCAL(block, i);
+				l = xfs_attr_leaf_name_local(block, i);
 				return l->namelen;
 			} else
 				return 0;
@@ -248,7 +248,7 @@ attr_leaf_name_local_value_count(
 		e = &block->entries[i];
 		if (be16_to_cpu(e->nameidx) == off) {
 			if (e->flags & XFS_ATTR_LOCAL) {
-				l = XFS_ATTR_LEAF_NAME_LOCAL(block, i);
+				l = xfs_attr_leaf_name_local(block, i);
 				return be16_to_cpu(l->valuelen);
 			} else
 				return 0;
@@ -285,7 +285,7 @@ attr_leaf_name_local_value_offset(
 	if (i >= be16_to_cpu(block->hdr.count)) 
 		return 0;
 
-	l = XFS_ATTR_LEAF_NAME_LOCAL(block, i);
+	l = xfs_attr_leaf_name_local(block, i);
 	vp = (char *)&l->nameval[l->namelen];
 	return (int)bitize(vp - (char *)l);
 }
@@ -333,7 +333,7 @@ attr_leaf_name_remote_name_count(
 		e = &block->entries[i];
 		if (be16_to_cpu(e->nameidx) == off) {
 			if (!(e->flags & XFS_ATTR_LOCAL)) {
-				r = XFS_ATTR_LEAF_NAME_REMOTE(block, i);
+				r = xfs_attr_leaf_name_remote(block, i);
 				return r->namelen;
 			} else
 				return 0;
@@ -360,12 +360,12 @@ attr_leaf_name_size(
 		return 0;
 	e = &block->entries[idx];
 	if (e->flags & XFS_ATTR_LOCAL) {
-		l = XFS_ATTR_LEAF_NAME_LOCAL(block, idx);
-		return (int)bitize(XFS_ATTR_LEAF_ENTSIZE_LOCAL(l->namelen,
+		l = xfs_attr_leaf_name_local(block, idx);
+		return (int)bitize(xfs_attr_leaf_entsize_local(l->namelen,
 					be16_to_cpu(l->valuelen)));
 	} else {
-		r = XFS_ATTR_LEAF_NAME_REMOTE(block, idx);
-		return (int)bitize(XFS_ATTR_LEAF_ENTSIZE_REMOTE(r->namelen));
+		r = xfs_attr_leaf_name_remote(block, idx);
+		return (int)bitize(xfs_attr_leaf_entsize_remote(r->namelen));
 	}
 }
 
diff --git a/db/attrset.c b/db/attrset.c
index 35fea11..cbecbe9 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -158,7 +158,8 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, name, value, valuelen, flags)) {
+	if (libxfs_attr_set(ip, (unsigned char *)name,
+				(unsigned char *)value, valuelen, flags)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
@@ -233,7 +234,7 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, name, flags)) {
+	if (libxfs_attr_remove(ip, (unsigned char *)name, flags)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/db/bmap.c b/db/bmap.c
index 5abad68..ddad49c 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -29,7 +29,7 @@
 #include "init.h"
 
 static int		bmap_f(int argc, char **argv);
-static int		bmap_one_extent(xfs_bmbt_rec_64_t *ep,
+static int		bmap_one_extent(xfs_bmbt_rec_t *ep,
 					xfs_dfiloff_t *offp, xfs_dfiloff_t eoff,
 					int *idxp, bmap_ext_t *bep);
 static xfs_fsblock_t	select_child(xfs_dfiloff_t off, xfs_bmbt_key_t *kp,
@@ -52,7 +52,7 @@ bmap(
 	xfs_dfiloff_t		curoffset;
 	xfs_dinode_t		*dip;
 	xfs_dfiloff_t		eoffset;
-	xfs_bmbt_rec_64_t	*ep;
+	xfs_bmbt_rec_t		*ep;
 	xfs_dinode_fmt_t	fmt;
 	int			fsize;
 	xfs_bmbt_key_t		*kp;
@@ -63,7 +63,7 @@ bmap(
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmdr_block_t	*rblock;
 	typnm_t			typ;
-	xfs_bmbt_rec_64_t	*xp;
+	xfs_bmbt_rec_t		*xp;
 
 	push_cur();
 	set_cur_inode(iocur_top->ino);
@@ -81,7 +81,7 @@ bmap(
 		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
 		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
-		xp = (xfs_bmbt_rec_64_t *)XFS_DFORK_PTR(dip, whichfork);
+		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
 				break;
@@ -110,7 +110,7 @@ bmap(
 		for (;;) {
 			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 			nextents = be16_to_cpu(block->bb_numrecs);
-			xp = (xfs_bmbt_rec_64_t *)
+			xp = (xfs_bmbt_rec_t *)
 				XFS_BMBT_REC_ADDR(mp, block, 1);
 			for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 				if (!bmap_one_extent(ep, &curoffset, eoffset,
@@ -171,9 +171,9 @@ bmap_f(
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (be32_to_cpu(dip->di_core.di_nextents))
+		if (be32_to_cpu(dip->di_nextents))
 			dfork = 1;
-		if (be16_to_cpu(dip->di_core.di_anextents))
+		if (be16_to_cpu(dip->di_anextents))
 			afork = 1;
 		pop_cur();
 	}
@@ -233,7 +233,7 @@ bmap_init(void)
 
 static int
 bmap_one_extent(
-	xfs_bmbt_rec_64_t	*ep,
+	xfs_bmbt_rec_t		*ep,
 	xfs_dfiloff_t		*offp,
 	xfs_dfiloff_t		eoff,
 	int			*idxp,
@@ -271,7 +271,7 @@ bmap_one_extent(
 
 void
 convert_extent(
-	xfs_bmbt_rec_64_t	*rp,
+	xfs_bmbt_rec_t		*rp,
 	xfs_dfiloff_t		*op,
 	xfs_dfsbno_t		*sp,
 	xfs_dfilblks_t		*cp,
diff --git a/db/bmap.h b/db/bmap.h
index 878acc0..2895287 100644
--- a/db/bmap.h
+++ b/db/bmap.h
@@ -17,7 +17,7 @@
  */
 
 struct	bbmap;
-struct	xfs_bmbt_rec_64;
+struct	xfs_bmbt_rec;
 
 typedef struct bmap_ext {
 	xfs_dfiloff_t	startoff;
@@ -29,6 +29,6 @@ typedef struct bmap_ext {
 extern void	bmap(xfs_dfiloff_t offset, xfs_dfilblks_t len, int whichfork,
 		     int *nexp, bmap_ext_t *bep);
 extern void	bmap_init(void);
-extern void	convert_extent(struct xfs_bmbt_rec_64 *rp, xfs_dfiloff_t *op,
+extern void	convert_extent(struct xfs_bmbt_rec *rp, xfs_dfiloff_t *op,
 			       xfs_dfsbno_t *sp, xfs_dfilblks_t *cp, int *fp);
 extern void	make_bbmap(struct bbmap *bbmap, int nex, bmap_ext_t *bmp);
diff --git a/db/check.c b/db/check.c
index a8939a4..e601e0a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2317,7 +2317,7 @@ process_data_dir_v2(
 		tag_err += be16_to_cpu(*tagp) != (char *)dep - (char *)data;
 		addr = xfs_dir2_db_off_to_dataptr(mp, db,
 			(char *)dep - (char *)data);
-		xname.name = (char *)dep->name;
+		xname.name = dep->name;
 		xname.len = dep->namelen;
 		dir_hash_add(mp->m_dirnameops->hashname(&xname), addr);
 		ptr += xfs_dir2_data_entsize(dep->namelen);
@@ -2508,23 +2508,23 @@ process_dir_v1(
 	inodata_t	*id,
 	xfs_ino_t	*parent)
 {
-	xfs_fsize_t	size = be64_to_cpu(dip->di_core.di_size);
+	xfs_fsize_t	size = be64_to_cpu(dip->di_size);
 
 	if (size <= XFS_DFORK_DSIZE(dip, mp) && 
-				dip->di_core.di_format == XFS_DINODE_FMT_LOCAL)
+				dip->di_format == XFS_DINODE_FMT_LOCAL)
 		*parent = process_shortform_dir_v1(dip, dot, dotdot, id);
 	else if (size == XFS_LBSIZE(mp) &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE))
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE))
 		*parent = process_leaf_dir_v1(blkmap, dot, dotdot, id);
 	else if (size >= XFS_LBSIZE(mp) &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE))
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE))
 		*parent = process_node_dir_v1(blkmap, dot, dotdot, id);
 	else  {
 		dbprintf(_("bad size (%lld) or format (%d) for directory inode "
 			 "%lld\n"),
-			size, dip->di_core.di_format, id->ino);
+			size, dip->di_format, id->ino);
 		error++;
 		return 1;
 	}
@@ -2541,25 +2541,25 @@ process_dir_v2(
 	xfs_ino_t	*parent)
 {
 	xfs_fileoff_t	last = 0;
-	xfs_fsize_t	size = be64_to_cpu(dip->di_core.di_size);
+	xfs_fsize_t	size = be64_to_cpu(dip->di_size);
 
 	if (blkmap)
 		last = blkmap_last_off(blkmap);
 	if (size <= XFS_DFORK_DSIZE(dip, mp) &&
-				dip->di_core.di_format == XFS_DINODE_FMT_LOCAL)
+				dip->di_format == XFS_DINODE_FMT_LOCAL)
 		*parent = process_sf_dir_v2(dip, dot, dotdot, id);
 	else if (last == mp->m_dirblkfsbs &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE))
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE))
 		*parent = process_block_dir_v2(blkmap, dot, dotdot, id);
 	else if (last >= mp->m_dirleafblk + mp->m_dirblkfsbs &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE))
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE))
 		*parent = process_leaf_node_dir_v2(blkmap, dot, dotdot, id, size);
 	else  {
 		dbprintf(_("bad size (%lld) or format (%d) for directory inode "
 			 "%lld\n"),
-			size, dip->di_core.di_format, id->ino);
+			size, dip->di_format, id->ino);
 		error++;
 		return 1;
 	}
@@ -2646,7 +2646,7 @@ process_inode(
 		"dev", "local", "extents", "btree", "uuid"
 	};
 
-	libxfs_dinode_from_disk(&idic, &dip->di_core);
+	libxfs_dinode_from_disk(&idic, dip);
 
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
 	if (!isfree) {
@@ -2677,7 +2677,7 @@ process_inode(
 					idic.di_nblocks, ino);
 			error++;
 		}
-		if (idic.di_version == XFS_DINODE_VERSION_1)
+		if (idic.di_version == 1)
 			nlink = idic.di_onlink;
 		else
 			nlink = idic.di_nlink;
@@ -2782,7 +2782,7 @@ process_inode(
 		type = DBM_UNKNOWN;
 		break;
 	}
-	if (idic.di_version == XFS_DINODE_VERSION_1)
+	if (idic.di_version == 1)
 		setlink_inode(id, idic.di_onlink, type == DBM_DIR, security);
 	else {
 		sbversion |= XFS_SB_VERSION_NLINKBIT;
@@ -2910,12 +2910,12 @@ process_lclinode(
 	xfs_fsblock_t		bno;
 
 	bno = XFS_INO_TO_FSB(mp, id->ino);
-	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_core.di_size) >
+	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_size) >
 						XFS_DFORK_DSIZE(dip, mp)) {
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf(_("local inode %lld data is too large (size "
 				 "%lld)\n"),
-				id->ino, be64_to_cpu(dip->di_core.di_size));
+				id->ino, be64_to_cpu(dip->di_size));
 		error++;
 	}
 	else if (whichfork == XFS_ATTR_FORK) {
@@ -3647,7 +3647,7 @@ process_sf_dir_v2(
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	for (i = sf->hdr.count - 1, i8 = 0; i >= 0; i--) {
 		if ((__psint_t)sfe + xfs_dir2_sf_entsize_byentry(sf, sfe) -
-		    (__psint_t)sf > be64_to_cpu(dip->di_core.di_size)) {
+		    (__psint_t)sf > be64_to_cpu(dip->di_size)) {
 			if (!sflag)
 				dbprintf(_("dir %llu bad size in entry at %d\n"),
 					id->ino,
@@ -3689,10 +3689,10 @@ process_sf_dir_v2(
 		sfe = xfs_dir2_sf_nextentry(sf, sfe);
 	}
 	if (i < 0 && (__psint_t)sfe - (__psint_t)sf != 
-					be64_to_cpu(dip->di_core.di_size)) {
+					be64_to_cpu(dip->di_size)) {
 		if (!sflag)
 			dbprintf(_("dir %llu size is %lld, should be %u\n"),
-				id->ino, be64_to_cpu(dip->di_core.di_size),
+				id->ino, be64_to_cpu(dip->di_size),
 				(uint)((char *)sfe - (char *)sf));
 		error++;
 	}
@@ -3769,9 +3769,9 @@ process_shortform_dir_v1(
 				sfe->namelen, sfe->namelen, sfe->name, lino);
 		sfe = xfs_dir_sf_nextentry(sfe);
 	}
-	if ((__psint_t)sfe - (__psint_t)sf != be64_to_cpu(dip->di_core.di_size))
+	if ((__psint_t)sfe - (__psint_t)sf != be64_to_cpu(dip->di_size))
 		dbprintf(_("dir %llu size is %lld, should be %d\n"),
-			id->ino, be64_to_cpu(dip->di_core.di_size),
+			id->ino, be64_to_cpu(dip->di_size),
 			(int)((char *)sfe - (char *)sf));
 	lino = XFS_GET_DIR_INO8(sf->hdr.parent);
 	cid = find_inode(lino, 1);
diff --git a/db/convert.c b/db/convert.c
index 070ac1a..1fa094b 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -210,14 +210,14 @@ convert_f(int argc, char **argv)
 	}
 	switch (wtype) {
 	case CT_AGBLOCK:
-		v = XFS_DADDR_TO_AGBNO(mp, v >> BBSHIFT);
+		v = xfs_daddr_to_agbno(mp, v >> BBSHIFT);
 		break;
 	case CT_AGINO:
 		v = (v >> mp->m_sb.sb_inodelog) %
 		    (mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog);
 		break;
 	case CT_AGNUMBER:
-		v = XFS_DADDR_TO_AGNO(mp, v >> BBSHIFT);
+		v = xfs_daddr_to_agno(mp, v >> BBSHIFT);
 		break;
 	case CT_BBOFF:
 		v &= BBMASK;
@@ -234,7 +234,7 @@ convert_f(int argc, char **argv)
 		v = XFS_DADDR_TO_FSB(mp, v >> BBSHIFT);
 		break;
 	case CT_INO:
-		v = XFS_AGINO_TO_INO(mp, XFS_DADDR_TO_AGNO(mp, v >> BBSHIFT),
+		v = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, v >> BBSHIFT),
 			(v >> mp->m_sb.sb_inodelog) %
 			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));
 		break;
diff --git a/db/dir2sf.c b/db/dir2sf.c
index 426ad16..b2db088 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -76,7 +76,7 @@ dir2_inou_i4_count(
 	xfs_dir2_sf_t	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = &((xfs_dinode_t *)obj)->di_u.di_dir2sf;
+	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(obj);
 	return sf->hdr.i8count == 0;
 }
 
@@ -89,7 +89,7 @@ dir2_inou_i8_count(
 	xfs_dir2_sf_t	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = &((xfs_dinode_t *)obj)->di_u.di_dir2sf;
+	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(obj);
 	return sf->hdr.i8count != 0;
 }
 
@@ -104,7 +104,7 @@ dir2_inou_size(
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	sf = &((xfs_dinode_t *)obj)->di_u.di_dir2sf;
+	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(obj);
 	return bitize(sf->hdr.i8count ?
 		      (uint)sizeof(xfs_dir2_ino8_t) :
 		      (uint)sizeof(xfs_dir2_ino4_t));
diff --git a/db/field.c b/db/field.c
index 5cf97e1..6903898 100644
--- a/db/field.c
+++ b/db/field.c
@@ -151,7 +151,7 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_DINODE_A, "dinode_a", NULL, (char *)inode_a_flds, inode_a_size,
 	  FTARG_SIZE|FTARG_OKEMPTY, NULL, inode_a_flds },
 	{ FLDT_DINODE_CORE, "dinode_core", NULL, (char *)inode_core_flds,
-	  SI(bitsz(xfs_dinode_core_t)), 0, NULL, inode_core_flds },
+	  SI(bitsz(xfs_dinode_t)), 0, NULL, inode_core_flds },
 	{ FLDT_DINODE_FMT, "dinode_fmt", fp_dinode_fmt, NULL,
 	  SI(bitsz(__int8_t)), 0, NULL, NULL },
 	{ FLDT_DINODE_U, "dinode_u", NULL, (char *)inode_u_flds, inode_u_size,
diff --git a/db/frag.c b/db/frag.c
index 305bef1..23ccfa5 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -307,20 +307,18 @@ process_inode(
 	xfs_dinode_t		*dip)
 {
 	__uint64_t		actual;
-	xfs_dinode_core_t	*dic;
 	__uint64_t		ideal;
 	xfs_ino_t		ino;
 	int			skipa;
 	int			skipd;
 
-	dic = &dip->di_core;
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
-	switch (be16_to_cpu(dic->di_mode) & S_IFMT) {
+	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
 	case S_IFDIR:
 		skipd = !dflag;
 		break;
 	case S_IFREG:
-		if (!rflag && (be16_to_cpu(dic->di_flags) & XFS_DIFLAG_REALTIME))
+		if (!rflag && (be16_to_cpu(dip->di_flags) & XFS_DIFLAG_REALTIME))
 			skipd = 1;
 		else if (!Rflag &&
 			 (ino == mp->m_sb.sb_rbmino ||
diff --git a/db/inode.c b/db/inode.c
index 6f8592a..bd08d80 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -40,6 +40,7 @@ static int	inode_core_onlink_count(void *obj, int startoff);
 static int	inode_core_projid_count(void *obj, int startoff);
 static int	inode_core_nlinkv1_count(void *obj, int startoff);
 static int	inode_f(int argc, char **argv);
+static int	inode_u_offset(void *obj, int startoff, int idx);
 static int	inode_u_bmbt_count(void *obj, int startoff);
 static int	inode_u_bmx_count(void *obj, int startoff);
 static int	inode_u_c_count(void *obj, int startoff);
@@ -58,18 +59,17 @@ const field_t	inode_hfld[] = {
 	{ NULL }
 };
 
+/* XXX: fix this up! */
 #define	OFF(f)	bitize(offsetof(xfs_dinode_t, di_ ## f))
 const field_t	inode_flds[] = {
-	{ "core", FLDT_DINODE_CORE, OI(OFF(core)), C1, 0, TYP_NONE },
-	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
-	  TYP_INODE },
-	{ "u", FLDT_DINODE_U, OI(OFF(u)), C1, 0, TYP_NONE },
+	{ "core", FLDT_DINODE_CORE, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "u", FLDT_DINODE_U, inode_u_offset, C1, FLD_OFFSET, TYP_NONE },
 	{ "a", FLDT_DINODE_A, inode_a_offset, inode_a_count,
 	  FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
 };
 
-#define	COFF(f)	bitize(offsetof(xfs_dinode_core_t, di_ ## f))
+#define	COFF(f)	bitize(offsetof(xfs_dinode_t, di_ ## f))
 const field_t	inode_core_flds[] = {
 	{ "magic", FLDT_UINT16X, OI(COFF(magic)), C1, 0, TYP_NONE },
 	{ "mode", FLDT_UINT16O, OI(COFF(mode)), C1, 0, TYP_NONE },
@@ -147,6 +147,8 @@ const field_t	inode_core_flds[] = {
 	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_FILESTREAM_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "gen", FLDT_UINT32D, OI(COFF(gen)), C1, 0, TYP_NONE },
+	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
+	  TYP_INODE },
 	{ NULL }
 };
 
@@ -228,7 +230,7 @@ inode_a_bmbt_count(
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_core.di_aformat == XFS_DINODE_FMT_BTREE;
+	return dip->di_aformat == XFS_DINODE_FMT_BTREE;
 }
 
 static int
@@ -244,8 +246,8 @@ inode_a_bmx_count(
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_core.di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		be16_to_cpu(dip->di_core.di_anextents) : 0;
+	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
+		be16_to_cpu(dip->di_anextents) : 0;
 }
 
 static int
@@ -288,7 +290,7 @@ inode_a_sfattr_count(
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_core.di_aformat == XFS_DINODE_FMT_LOCAL;
+	return dip->di_aformat == XFS_DINODE_FMT_LOCAL;
 }
 
 int
@@ -303,12 +305,12 @@ inode_a_size(
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
 	dip = obj;
-	switch (dip->di_core.di_aformat) {
+	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be16_to_cpu(dip->di_core.di_anextents) * 
+		return (int)be16_to_cpu(dip->di_anextents) * 
 							bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
@@ -319,54 +321,54 @@ inode_a_size(
 
 static int
 inode_core_nlinkv1_count(
-	void			*obj,
-	int			startoff)
+	void		*obj,
+	int		startoff)
 {
-	xfs_dinode_core_t	*dic;
+	xfs_dinode_t	*dic;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
 	dic = obj;
-	return dic->di_version == XFS_DINODE_VERSION_1;
+	return dic->di_version == 1;
 }
 
 static int
 inode_core_nlinkv2_count(
-	void			*obj,
-	int			startoff)
+	void		*obj,
+	int		startoff)
 {
-	xfs_dinode_core_t	*dic;
+	xfs_dinode_t	*dic;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
 	dic = obj;
-	return dic->di_version == XFS_DINODE_VERSION_2;
+	return dic->di_version == 2;
 }
 
 static int
 inode_core_onlink_count(
-	void			*obj,
-	int			startoff)
+	void		*obj,
+	int		startoff)
 {
-	xfs_dinode_core_t	*dic;
+	xfs_dinode_t	*dic;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
 	dic = obj;
-	return dic->di_version == XFS_DINODE_VERSION_2;
+	return dic->di_version == 2;
 }
 
 static int
 inode_core_projid_count(
-	void			*obj,
-	int			startoff)
+	void		*obj,
+	int		startoff)
 {
-	xfs_dinode_core_t	*dic;
+	xfs_dinode_t	*dic;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
 	dic = obj;
-	return dic->di_version == XFS_DINODE_VERSION_2;
+	return dic->di_version == 2;
 }
 
 static int
@@ -430,6 +432,20 @@ inode_size(
 }
 
 static int
+inode_u_offset(
+	void		*obj,
+	int		startoff,
+	int		idx)
+{
+	xfs_dinode_t	*dip;
+
+	ASSERT(startoff == 0);
+	ASSERT(idx == 0);
+	dip = obj;
+	return bitize((int)((char *)XFS_DFORK_DPTR(dip) - (char *)dip));
+}
+
+static int
 inode_u_bmbt_count(
 	void		*obj,
 	int		startoff)
@@ -439,8 +455,8 @@ inode_u_bmbt_count(
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_BTREE;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_BTREE;
 }
 
 static int
@@ -453,9 +469,9 @@ inode_u_bmx_count(
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ?
-		be32_to_cpu(dip->di_core.di_nextents) : 0;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
+		be32_to_cpu(dip->di_nextents) : 0;
 }
 
 static int
@@ -468,10 +484,10 @@ inode_u_c_count(
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_LOCAL &&
-	       (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFREG ?
-		(int)be64_to_cpu(dip->di_core.di_size) : 0;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFREG ?
+		(int)be64_to_cpu(dip->di_size) : 0;
 }
 
 static int
@@ -484,8 +500,8 @@ inode_u_dev_count(
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_DEV;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_DEV;
 }
 
 static int
@@ -498,8 +514,8 @@ inode_u_muuid_count(
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_UUID;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_UUID;
 }
 
 static int
@@ -512,9 +528,9 @@ inode_u_sfdir_count(
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_LOCAL &&
-	       (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFDIR
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR
 	       && !xfs_sb_version_hasdirv2(&mp->m_sb);
 }
 
@@ -528,9 +544,9 @@ inode_u_sfdir2_count(
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_LOCAL &&
-	       (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFDIR &&
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR &&
 	       xfs_sb_version_hasdirv2(&mp->m_sb);
 }
 
@@ -545,13 +561,13 @@ inode_u_size(
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
 	dip = obj;
-	switch (dip->di_core.di_format) {
+	switch (dip->di_format) {
 	case XFS_DINODE_FMT_DEV:
 		return bitsz(xfs_dev_t);
 	case XFS_DINODE_FMT_LOCAL:
-		return bitize((int)be64_to_cpu(dip->di_core.di_size));
+		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be32_to_cpu(dip->di_core.di_nextents) * 
+		return (int)be32_to_cpu(dip->di_nextents) * 
 						bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
@@ -572,10 +588,10 @@ inode_u_symlink_count(
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_LOCAL &&
-	       (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFLNK ?
-		(int)be64_to_cpu(dip->di_core.di_size) : 0;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFLNK ?
+		(int)be64_to_cpu(dip->di_size) : 0;
 }
 
 void
@@ -611,7 +627,7 @@ set_cur_inode(
 	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
 	dip = iocur_top->data;
 	iocur_top->ino = ino;
-	iocur_top->mode = be16_to_cpu(dip->di_core.di_mode);
+	iocur_top->mode = be16_to_cpu(dip->di_mode);
 	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
 		iocur_top->dirino = ino;
 
diff --git a/db/metadump.c b/db/metadump.c
index ef6e571..884d338 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -502,8 +502,8 @@ obfuscate_sf_dir(
 	__uint64_t		ino_dir_size;
 	int			i;
 
-	sfp = &dip->di_u.di_dir2sf;
-	ino_dir_size = be64_to_cpu(dip->di_core.di_size);
+	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
+	ino_dir_size = be64_to_cpu(dip->di_size);
 	if (ino_dir_size > XFS_DFORK_DSIZE(dip, mp)) {
 		ino_dir_size = XFS_DFORK_DSIZE(dip, mp);
 		if (show_warnings)
@@ -555,8 +555,9 @@ obfuscate_sf_symlink(
 	xfs_dinode_t		*dip)
 {
 	__uint64_t		len;
+	char			*buf;
 
-	len = be64_to_cpu(dip->di_core.di_size);
+	len = be64_to_cpu(dip->di_size);
 	if (len > XFS_DFORK_DSIZE(dip, mp)) {
 		if (show_warnings)
 			print_warning("invalid size (%d) in symlink inode %llu",
@@ -564,8 +565,9 @@ obfuscate_sf_symlink(
 		len = XFS_DFORK_DSIZE(dip, mp);
 	}
 
+	buf = (char *)XFS_DFORK_DPTR(dip);
 	while (len > 0)
-		dip->di_u.di_symlink[--len] = random() % 127 + 1;
+		buf[--len] = random() % 127 + 1;
 }
 
 static void
@@ -841,7 +843,7 @@ obfuscate_attr_blocks(
 				break;
 			}
 			if (entry->flags & XFS_ATTR_LOCAL) {
-				local = XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
+				local = xfs_attr_leaf_name_local(leaf, i);
 				if (local->namelen == 0) {
 					if (show_warnings)
 						print_warning("zero length for "
@@ -854,7 +856,7 @@ obfuscate_attr_blocks(
 				memset(&local->nameval[local->namelen], 0,
 					be16_to_cpu(local->valuelen));
 			} else {
-				remote = XFS_ATTR_LEAF_NAME_REMOTE(leaf, i);
+				remote = xfs_attr_leaf_name_remote(leaf, i);
 				if (remote->namelen == 0 ||
 						remote->valueblk == 0) {
 					if (show_warnings)
@@ -1143,7 +1145,7 @@ process_inode_data(
 	xfs_dinode_t		*dip,
 	typnm_t			itype)
 {
-	switch (dip->di_core.di_format) {
+	switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			if (!dont_obfuscate)
 				switch (itype) {
@@ -1180,7 +1182,7 @@ process_inode(
 	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
 	/* copy appropriate data fork metadata */
-	switch (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) {
+	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
 		case S_IFDIR:
 			memset(&dir_data, 0, sizeof(dir_data));
 			success = process_inode_data(dip, TYP_DIR2);
@@ -1198,7 +1200,7 @@ process_inode(
 	/* copy extended attributes if they exist and forkoff is valid */
 	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
 		attr_data.remote_val_count = 0;
-		switch (dip->di_core.di_aformat) {
+		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
 				if (!dont_obfuscate)
 					obfuscate_sf_attr(dip);
diff --git a/include/Makefile b/include/Makefile
index 912f1ba..a84963c 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -19,7 +19,8 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 QAHFILES = libxfs.h libxlog.h \
-	bitops.h cache.h kmem.h list.h parent.h swab.h \
+	atomic.h bitops.h cache.h kmem.h list.h hlist.h parent.h radix-tree.h \
+	swab.h \
 	xfs_ag.h xfs_alloc.h xfs_alloc_btree.h xfs_arch.h xfs_attr_leaf.h \
 	xfs_attr_sf.h xfs_bit.h xfs_bmap.h xfs_bmap_btree.h xfs_btree.h \
 	xfs_btree_trace.h xfs_buf_item.h xfs_da_btree.h xfs_dinode.h \
@@ -28,7 +29,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
 	xfs_imap.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
 	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
-	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h \
+	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h xfs_trace.h \
 	xfs_trans.h xfs_trans_space.h xfs_types.h xfs_dfrag.h
 
 HFILES = handle.h jdm.h xqm.h xfs.h xfs_fs.h
diff --git a/include/atomic.h b/include/atomic.h
new file mode 100644
index 0000000..bdf1083
--- /dev/null
+++ b/include/atomic.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2011 RedHat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __ATOMIC_H__
+#define __ATOMIC_H__
+
+typedef	int32_t	atomic_t;
+typedef	int64_t	atomic64_t;
+
+#define atomic_inc_return(x)	(++(*(x)))
+#define atomic_dec_return(x)	(--(*(x)))
+
+#define atomic64_read(x)	*(x)
+#define atomic64_set(x, v)	(*(x) = v)
+
+#endif /* __ATOMIC_H__ */
+
diff --git a/include/libxfs.h b/include/libxfs.h
index e7199c7..9740fbd 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -25,10 +25,13 @@
 #include <xfs/platform_defs.h>
 
 #include <xfs/list.h>
+#include <xfs/hlist.h>
 #include <xfs/cache.h>
 #include <xfs/bitops.h>
 #include <xfs/kmem.h>
 #include <xfs/swab.h>
+#include <xfs/atomic.h>
+#include <xfs/radix-tree.h>
 
 #include <xfs/xfs_fs.h>
 #include <xfs/xfs_types.h>
@@ -54,6 +57,7 @@
 #include <xfs/xfs_btree.h>
 #include <xfs/xfs_btree_trace.h>
 #include <xfs/xfs_bmap.h>
+#include <xfs/xfs_trace.h>
 
 
 #ifndef XFS_SUPER_MAGIC
@@ -62,6 +66,10 @@
 
 #define xfs_isset(a,i)	((a)[(i)/(sizeof((a))*NBBY)] & (1<<((i)%(sizeof((a))*NBBY))))
 
+#define __round_mask(x, y) ((__typeof__(x))((y)-1))
+#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
+#define round_down(x, y) ((x) & ~__round_mask(x, y))
+
 /*
  * Argument structure for libxfs_init().
  */
@@ -164,7 +172,7 @@ typedef struct xfs_mount {
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
-	xfs_perag_t		*m_perag;	/* per-ag accounting info */
+	struct radix_tree_root	m_perag_tree;
 	uint			m_flags;	/* global mount flags */
 	uint			m_qflags;	/* quota status flags */
 	uint			m_attroffset;	/* inode attribute offset */
@@ -240,8 +248,11 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define XFS_BUF_SIZE(bp)		((bp)->b_bcount)
 #define XFS_BUF_COUNT(bp)		((bp)->b_bcount)
 #define XFS_BUF_TARGET(bp)		((bp)->b_dev)
-#define XFS_BUF_SET_PTR(bp,p,cnt)	((bp)->b_addr = (char *)(p)); \
-						XFS_BUF_SET_COUNT(bp,cnt)
+#define XFS_BUF_SET_PTR(bp,p,cnt)	({	\
+	(bp)->b_addr = (char *)(p);		\
+	XFS_BUF_SET_COUNT(bp,cnt);		\
+})
+
 #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_blkno = (blk))
 #define XFS_BUF_SET_COUNT(bp,cnt)	((bp)->b_bcount = (cnt))
 
@@ -329,6 +340,7 @@ typedef struct xfs_inode_log_item {
 	unsigned short		ili_flags;		/* misc flags */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
 	xfs_inode_log_format_t	ili_format;		/* logged structure */
+	int			ili_lock_flags;
 } xfs_inode_log_item_t;
 
 typedef struct xfs_buf_log_item {
@@ -352,7 +364,7 @@ typedef struct xfs_trans {
 	long		t_fdblocks_delta;	/* superblock fdblocks chg */
 	long		t_frextents_delta;	/* superblock freextents chg */
 	unsigned int	t_items_free;		/* log item descs free */
-	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
+	struct list_head	t_items;	/* first log item desc chunk */
 } xfs_trans_t;
 
 extern xfs_trans_t	*libxfs_trans_alloc (xfs_mount_t *, int);
@@ -368,6 +380,7 @@ extern int	libxfs_trans_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
 extern void	libxfs_trans_iput(xfs_trans_t *, struct xfs_inode *, uint);
 extern void	libxfs_trans_ijoin (xfs_trans_t *, struct xfs_inode *, uint);
 extern void	libxfs_trans_ihold (xfs_trans_t *, struct xfs_inode *);
+extern void	libxfs_trans_ijoin_ref(xfs_trans_t *, struct xfs_inode *, int);
 extern void	libxfs_trans_log_inode (xfs_trans_t *, struct xfs_inode *,
 				uint);
 
@@ -390,10 +403,8 @@ typedef struct xfs_inode {
 	struct cache_node	i_node;
 	xfs_mount_t		*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
-	xfs_daddr_t		i_blkno;	/* blkno of inode buffer */
+	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 	dev_t			i_dev;		/* dev for this inode */
-	ushort			i_len;		/* len of inode buffer */
-	ushort			i_boffset;	/* off of inode in buffer */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
 	xfs_ifork_t		i_df;		/* data fork */
 	xfs_trans_t		*i_transp;	/* ptr to owning transaction */
@@ -418,7 +429,8 @@ extern int	libxfs_inode_alloc (xfs_trans_t **, xfs_inode_t *, mode_t,
 				struct fsxattr *, xfs_inode_t **);
 extern void	libxfs_trans_inode_alloc_buf (xfs_trans_t *, xfs_buf_t *);
 
-extern void	libxfs_ichgtime (xfs_inode_t *, int);
+extern void	libxfs_trans_ichgtime(struct xfs_trans *,
+					struct xfs_inode *, int);
 extern int	libxfs_iflush_int (xfs_inode_t *, xfs_buf_t *);
 extern int	libxfs_iread (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
 				xfs_inode_t *, xfs_daddr_t);
@@ -431,6 +443,9 @@ extern int	libxfs_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
 				uint, xfs_inode_t **, xfs_daddr_t);
 extern void	libxfs_iput (xfs_inode_t *, uint);
 
+extern int	xfs_imap_to_bp(xfs_mount_t *mp, xfs_trans_t *tp, struct xfs_imap *imap,
+			xfs_buf_t **bpp, uint buf_flags, uint iget_flags);
+
 #include <xfs/xfs_dir_leaf.h>	/* dirv1 support in db & repair */ 
 #include <xfs/xfs_dir2_data.h>
 #include <xfs/xfs_dir2_leaf.h>
@@ -466,12 +481,14 @@ extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
 #include <xfs/xfs_attr_leaf.h>
 #include <xfs/xfs_quota.h>
 #include <xfs/xfs_trans_space.h>
-#include <xfs/xfs_imap.h>
 #include <xfs/xfs_log.h>
 #include <xfs/xfs_log_priv.h>
 
+#define XFS_INOBT_CLR_FREE(rp,i)	((rp)->ir_free &= ~XFS_INOBT_MASK(i))
+#define XFS_INOBT_SET_FREE(rp,i)	((rp)->ir_free |= XFS_INOBT_MASK(i))
 #define XFS_INOBT_IS_FREE_DISK(rp,i)		\
 			((be64_to_cpu((rp)->ir_free) & XFS_INOBT_MASK(i)) != 0)
+
 /*
  * public xfs kernel routines to be called as libxfs_*
  */
@@ -480,14 +497,17 @@ extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
 int libxfs_alloc_fix_freelist(xfs_alloc_arg_t *, int);
 
 /* xfs_attr.c */
-int libxfs_attr_get(struct xfs_inode *, const char *, char *, int *, int);
-int libxfs_attr_set(struct xfs_inode *, const char *, char *, int, int);
-int libxfs_attr_remove(struct xfs_inode *, const char *, int);
+int libxfs_attr_get(struct xfs_inode *, const unsigned char *,
+					unsigned char *, int *, int);
+int libxfs_attr_set(struct xfs_inode *, const unsigned char *,
+					unsigned char *, int, int);
+int libxfs_attr_remove(struct xfs_inode *, const unsigned char *, int);
 
 /* xfs_bmap.c */
 xfs_bmbt_rec_host_t *xfs_bmap_search_extents(xfs_inode_t *, xfs_fileoff_t,
 				int, int *, xfs_extnum_t *, xfs_bmbt_irec_t *,
 				xfs_bmbt_irec_t	*);
+void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 
 /* xfs_attr_leaf.h */
 #define libxfs_attr_leaf_newentsize	xfs_attr_leaf_newentsize
diff --git a/include/libxlog.h b/include/libxlog.h
index 2a8a251..d1142ab 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -39,13 +39,12 @@ typedef struct log {
 	int		l_iclog_size;	 /* size of log in bytes */
 	int		l_iclog_size_log;/* log power size of log */
 	int		l_iclog_bufs;	 /* number of iclog buffers */
-	int		l_grant_reserve_cycle;	/* */
-	int		l_grant_reserve_bytes;	/* */
-	int		l_grant_write_cycle;	/* */
-	int		l_grant_write_bytes;	/* */
+	atomic64_t	l_grant_reserve_head;
+	atomic64_t	l_grant_write_head;
 	uint		l_sectbb_log;   /* log2 of sector size in bbs */
 	uint		l_sectbb_mask;  /* sector size (in BBs)
 					 * alignment mask */
+	int		l_sectBBsize;   /* size of log sector in 512 byte chunks */
 } xlog_t;
 
 #include <xfs/xfs_log_recover.h>
@@ -91,7 +90,10 @@ extern libxfs_init_t	x;
 
 extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
 extern void	xlog_put_bp(struct xfs_buf *);
-extern int	xlog_bread(xlog_t *, xfs_daddr_t, int, struct xfs_buf *);
+extern int	xlog_bread(xlog_t *log, xfs_daddr_t blk_no, int nbblks,
+				xfs_buf_t *bp, xfs_caddr_t *offset);
+extern int	xlog_bread_noalign(xlog_t *log, xfs_daddr_t blk_no, int nbblks,
+				xfs_buf_t *bp);
 
 extern int	xlog_find_zeroed(xlog_t *log, xfs_daddr_t *blk_no);
 extern int	xlog_find_cycle_start(xlog_t *log, xfs_buf_t *bp,
@@ -110,7 +112,7 @@ extern int	xlog_print_find_oldest(xlog_t *log, xfs_daddr_t *last_blk);
 /* for transactional view */
 extern void	xlog_recover_print_trans_head(xlog_recover_t *tr);
 extern void	xlog_recover_print_trans(xlog_recover_t *trans,
-				xlog_recover_item_t *itemq, int print);
+				struct list_head *itemq, int print);
 extern int	xlog_do_recovery_pass(xlog_t *log, xfs_daddr_t head_blk,
 				xfs_daddr_t tail_blk, int pass);
 extern int	xlog_recover_do_trans(xlog_t *log, xlog_recover_t *trans,
@@ -120,4 +122,6 @@ extern int	xlog_header_check_recover(xfs_mount_t *mp,
 extern int	xlog_header_check_mount(xfs_mount_t *mp,
 				xlog_rec_header_t *head);
 
+#define xlog_assign_atomic_lsn(l,a,b) ((void) 0)
+#define xlog_assign_grant_head(l,a,b) ((void) 0)
 #endif	/* LIBXLOG_H */
diff --git a/include/list.h b/include/list.h
index 2389a6c..3f087a4 100644
--- a/include/list.h
+++ b/include/list.h
@@ -27,6 +27,12 @@ struct list_head {
 	struct list_head *prev;
 };
 
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+		struct list_head name = LIST_HEAD_INIT(name)
+
+#define INIT_LIST_HEAD(list) list_head_init(list)
 static inline void list_head_init(struct list_head *list)
 {
 	list->next = list->prev = list;
@@ -68,6 +74,11 @@ static inline void list_del_init(struct list_head *entry)
 	list_head_init(entry);
 }
 
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+}
+
 static inline void list_move(struct list_head *list, struct list_head *head)
 {
 	__list_del(list->prev, list->next);
diff --git a/include/radix-tree.h b/include/radix-tree.h
new file mode 100644
index 0000000..e16e08d
--- /dev/null
+++ b/include/radix-tree.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) 2001 Momchil Velikov
+ * Portions Copyright (C) 2001 Christoph Hellwig
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef __XFS_SUPPORT_RADIX_TREE_H__
+#define __XFS_SUPPORT_RADIX_TREE_H__
+
+#define RADIX_TREE_TAGS
+
+struct radix_tree_root {
+	unsigned int		height;
+	struct radix_tree_node	*rnode;
+};
+
+#define RADIX_TREE_INIT(mask)	{					\
+	.height = 0,							\
+	.rnode = NULL,							\
+}
+
+#define RADIX_TREE(name, mask) \
+	struct radix_tree_root name = RADIX_TREE_INIT(mask)
+
+#define INIT_RADIX_TREE(root, mask)					\
+do {									\
+	(root)->height = 0;						\
+	(root)->rnode = NULL;						\
+} while (0)
+
+#ifdef RADIX_TREE_TAGS
+#define RADIX_TREE_MAX_TAGS 2
+#endif
+
+int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
+void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
+void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
+void *radix_tree_lookup_first(struct radix_tree_root *, unsigned long *);
+void *radix_tree_delete(struct radix_tree_root *, unsigned long);
+unsigned int
+radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned int max_items);
+unsigned int
+radix_tree_gang_lookup_ex(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned long last_index,
+			unsigned int max_items);
+
+void radix_tree_init(void);
+
+#ifdef RADIX_TREE_TAGS
+void *radix_tree_tag_set(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag);
+void *radix_tree_tag_clear(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag);
+int radix_tree_tag_get(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag);
+unsigned int
+radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned int max_items,
+			unsigned int tag);
+int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
+#endif
+
+#endif /* __XFS_SUPPORT_RADIX_TREE_H__ */
diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index 729ee3e..5adce91 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
@@ -86,11 +86,27 @@ typedef struct xfs_agf {
 #define	XFS_AGF_NUM_BITS	12
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
+#define XFS_AGF_FLAGS \
+	{ XFS_AGF_MAGICNUM,	"MAGICNUM" }, \
+	{ XFS_AGF_VERSIONNUM,	"VERSIONNUM" }, \
+	{ XFS_AGF_SEQNO,	"SEQNO" }, \
+	{ XFS_AGF_LENGTH,	"LENGTH" }, \
+	{ XFS_AGF_ROOTS,	"ROOTS" }, \
+	{ XFS_AGF_LEVELS,	"LEVELS" }, \
+	{ XFS_AGF_FLFIRST,	"FLFIRST" }, \
+	{ XFS_AGF_FLLAST,	"FLLAST" }, \
+	{ XFS_AGF_FLCOUNT,	"FLCOUNT" }, \
+	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
+	{ XFS_AGF_LONGEST,	"LONGEST" }, \
+	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }
+
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
 #define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
 
+extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
+			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 
 /*
  * Size of the unlinked inode hash table in the agi.
@@ -142,6 +158,9 @@ typedef struct xfs_agi {
 #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
 #define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)XFS_BUF_PTR(bp))
 
+extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
+				xfs_agnumber_t agno, struct xfs_buf **bpp);
+
 /*
  * The third a.g. block contains the a.g. freelist, an array
  * of block pointers to blocks owned by the allocation btree code.
@@ -156,29 +175,33 @@ typedef struct xfs_agfl {
 } xfs_agfl_t;
 
 /*
- * Busy block/extent entry.  Used in perag to mark blocks that have been freed
- * but whose transactions aren't committed to disk yet.
+ * Busy block/extent entry.  Indexed by a rbtree in perag to mark blocks that
+ * have been freed but whose transactions aren't committed to disk yet.
+ *
+ * Note that we use the transaction ID to record the transaction, not the
+ * transaction structure itself. See xfs_alloc_busy_insert() for details.
  */
-typedef struct xfs_perag_busy {
-	xfs_agblock_t	busy_start;
-	xfs_extlen_t	busy_length;
-	struct xfs_trans *busy_tp;	/* transaction that did the free */
-} xfs_perag_busy_t;
+struct xfs_busy_extent {
+#ifdef __KERNEL__
+	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
+#endif
+	struct list_head list;		/* transaction busy extent list */
+	xfs_agnumber_t	agno;
+	xfs_agblock_t	bno;
+	xfs_extlen_t	length;
+	xlog_tid_t	tid;		/* transaction that created this */
+};
 
 /*
  * Per-ag incore structure, copies of information in agf and agi,
  * to improve the performance of allocation group selection.
- *
- * pick sizes which fit in allocation buckets well
  */
-#if (BITS_PER_LONG == 32)
-#define XFS_PAGB_NUM_SLOTS	84
-#elif (BITS_PER_LONG == 64)
 #define XFS_PAGB_NUM_SLOTS	128
-#endif
 
-typedef struct xfs_perag
-{
+typedef struct xfs_perag {
+	struct xfs_mount *pag_mount;	/* owner filesystem */
+	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
+	atomic_t	pag_ref;	/* perag reference count */
 	char		pagf_init;	/* this agf's entry is initialized */
 	char		pagi_init;	/* this agi's entry is initialized */
 	char		pagf_metadata;	/* the agf is preferred to be metadata */
@@ -191,19 +214,44 @@ typedef struct xfs_perag
 	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
 	xfs_agino_t	pagi_freecount;	/* number of free inodes */
 	xfs_agino_t	pagi_count;	/* number of allocated inodes */
-	int		pagb_count;	/* pagb slots in use */
-	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+
+	/*
+	 * Inode allocation search lookup optimisation.
+	 * If the pagino matches, the search for new inodes
+	 * doesn't need to search the near ones again straight away
+	 */
+	xfs_agino_t	pagl_pagino;
+	xfs_agino_t	pagl_leftrec;
+	xfs_agino_t	pagl_rightrec;
 #ifdef __KERNEL__
-	spinlock_t	pagb_lock;	/* lock for pagb_list */
+	spinlock_t	pagb_lock;	/* lock for pagb_tree */
+	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
 
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
-	int		pag_ici_init;	/* incore inode cache initialised */
-	rwlock_t	pag_ici_lock;	/* incore inode lock */
+	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
+	int		pag_ici_reclaimable;	/* reclaimable inodes */
+	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
+	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
+
+	/* buffer cache index */
+	spinlock_t	pag_buf_lock;	/* lock for pag_buf_tree */
+	struct rb_root	pag_buf_tree;	/* ordered tree of active buffers */
+
+	/* for rcu-safe freeing */
+	struct rcu_head	rcu_head;
 #endif
+	int		pagb_count;	/* pagb slots in use */
 } xfs_perag_t;
 
+/*
+ * tags for inode radix tree
+ */
+#define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
+					   in xfs_inode_ag_iterator */
+#define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
+
 #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
 #define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
 	(MIN(bl + 1, XFS_AG_MAXLEVELS(mp)) + MIN(cl + 1, XFS_AG_MAXLEVELS(mp)))
@@ -213,15 +261,15 @@ typedef struct xfs_perag
 		be32_to_cpu((a)->agf_levels[XFS_BTNUM_CNTi]), mp))
 #define	XFS_MIN_FREELIST_PAG(pag,mp)	\
 	(XFS_MIN_FREELIST_RAW(		\
-		(uint_t)(pag)->pagf_levels[XFS_BTNUM_BNOi], \
-		(uint_t)(pag)->pagf_levels[XFS_BTNUM_CNTi], mp))
+		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_BNOi], \
+		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_CNTi], mp))
 
 #define XFS_AGB_TO_FSB(mp,agno,agbno)	\
 	(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))
 #define	XFS_FSB_TO_AGNO(mp,fsbno)	\
 	((xfs_agnumber_t)((fsbno) >> (mp)->m_sb.sb_agblklog))
 #define	XFS_FSB_TO_AGBNO(mp,fsbno)	\
-	((xfs_agblock_t)((fsbno) & XFS_MASK32LO((mp)->m_sb.sb_agblklog)))
+	((xfs_agblock_t)((fsbno) & xfs_mask32lo((mp)->m_sb.sb_agblklog)))
 #define	XFS_AGB_TO_DADDR(mp,agno,agbno)	\
 	((xfs_daddr_t)XFS_FSB_TO_BB(mp, \
 		(xfs_fsblock_t)(agno) * (mp)->m_sb.sb_agblocks + (agbno)))
@@ -234,8 +282,8 @@ typedef struct xfs_perag
 #define	XFS_AG_CHECK_DADDR(mp,d,len)	\
 	((len) == 1 ? \
 	    ASSERT((d) == XFS_SB_DADDR || \
-		   XFS_DADDR_TO_AGBNO(mp, d) != XFS_SB_DADDR) : \
-	    ASSERT(XFS_DADDR_TO_AGNO(mp, d) == \
-		   XFS_DADDR_TO_AGNO(mp, (d) + (len) - 1)))
+		   xfs_daddr_to_agbno(mp, d) != XFS_SB_DADDR) : \
+	    ASSERT(xfs_daddr_to_agno(mp, d) == \
+		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
 #endif	/* __XFS_AG_H__ */
diff --git a/include/xfs_alloc.h b/include/xfs_alloc.h
index 5881727..895009a 100644
--- a/include/xfs_alloc.h
+++ b/include/xfs_alloc.h
@@ -22,20 +22,30 @@ struct xfs_buf;
 struct xfs_mount;
 struct xfs_perag;
 struct xfs_trans;
+struct xfs_busy_extent;
 
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
-typedef enum xfs_alloctype
-{
-	XFS_ALLOCTYPE_ANY_AG,		/* allocate anywhere, use rotor */
-	XFS_ALLOCTYPE_FIRST_AG,		/* ... start at ag 0 */
-	XFS_ALLOCTYPE_START_AG,		/* anywhere, start in this a.g. */
-	XFS_ALLOCTYPE_THIS_AG,		/* anywhere in this a.g. */
-	XFS_ALLOCTYPE_START_BNO,	/* near this block else anywhere */
-	XFS_ALLOCTYPE_NEAR_BNO,		/* in this a.g. and near this block */
-	XFS_ALLOCTYPE_THIS_BNO		/* at exactly this block */
-} xfs_alloctype_t;
+#define XFS_ALLOCTYPE_ANY_AG	0x01	/* allocate anywhere, use rotor */
+#define XFS_ALLOCTYPE_FIRST_AG	0x02	/* ... start at ag 0 */
+#define XFS_ALLOCTYPE_START_AG	0x04	/* anywhere, start in this a.g. */
+#define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
+#define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
+#define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
+#define XFS_ALLOCTYPE_THIS_BNO	0x40	/* at exactly this block */
+
+/* this should become an enum again when the tracing code is fixed */
+typedef unsigned int xfs_alloctype_t;
+
+#define XFS_ALLOC_TYPES \
+	{ XFS_ALLOCTYPE_ANY_AG,		"ANY_AG" }, \
+	{ XFS_ALLOCTYPE_FIRST_AG,	"FIRST_AG" }, \
+	{ XFS_ALLOCTYPE_START_AG,	"START_AG" }, \
+	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
+	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
+	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
+	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
 
 /*
  * Flags for xfs_alloc_fix_freelist.
@@ -100,37 +110,23 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_USERDATA		1	/* allocation is for user data*/
 #define XFS_ALLOC_INITIAL_USER_DATA	2	/* special case start of file */
 
-
-#ifdef __KERNEL__
-
-#if defined(XFS_ALLOC_TRACE)
 /*
- * Allocation tracing buffer size.
+ * Find the length of the longest extent in an AG.
  */
-#define	XFS_ALLOC_TRACE_SIZE	4096
-extern ktrace_t *xfs_alloc_trace_buf;
+xfs_extlen_t
+xfs_alloc_longest_free_extent(struct xfs_mount *mp,
+		struct xfs_perag *pag);
 
-/*
- * Types for alloc tracing.
- */
-#define	XFS_ALLOC_KTRACE_ALLOC	1
-#define	XFS_ALLOC_KTRACE_FREE	2
-#define	XFS_ALLOC_KTRACE_MODAGF	3
-#define	XFS_ALLOC_KTRACE_BUSY	4
-#define	XFS_ALLOC_KTRACE_UNBUSY	5
-#define	XFS_ALLOC_KTRACE_BUSYSEARCH	6
-#endif
+#ifdef __KERNEL__
 
 void
-xfs_alloc_mark_busy(xfs_trans_t *tp,
+xfs_alloc_busy_insert(xfs_trans_t *tp,
 		xfs_agnumber_t agno,
 		xfs_agblock_t bno,
 		xfs_extlen_t len);
 
 void
-xfs_alloc_clear_busy(xfs_trans_t *tp,
-		xfs_agnumber_t ag,
-		int idx);
+xfs_alloc_busy_clear(struct xfs_mount *mp, struct xfs_busy_extent *busyp);
 
 #endif	/* __KERNEL__ */
 
diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 53d5e70..0902249 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -73,28 +73,6 @@ static inline void be64_add_cpu(__be64 *a, __s64 b)
 
 #endif	/* __KERNEL__ */
 
-/* do we need conversion? */
-#define ARCH_NOCONVERT 1
-#ifdef XFS_NATIVE_HOST
-# define ARCH_CONVERT	ARCH_NOCONVERT
-#else
-# define ARCH_CONVERT	0
-#endif
-
-/* generic swapping macros */
-
-#ifndef HAVE_SWABMACROS
-#define INT_SWAP16(type,var) ((typeof(type))(__swab16((__u16)(var))))
-#define INT_SWAP32(type,var) ((typeof(type))(__swab32((__u32)(var))))
-#define INT_SWAP64(type,var) ((typeof(type))(__swab64((__u64)(var))))
-#endif
-
-#define INT_SWAP(type, var) \
-    ((sizeof(type) == 8) ? INT_SWAP64(type,var) : \
-    ((sizeof(type) == 4) ? INT_SWAP32(type,var) : \
-    ((sizeof(type) == 2) ? INT_SWAP16(type,var) : \
-    (var))))
-
 /*
  * get and set integers from potentially unaligned locations
  */
@@ -107,16 +85,6 @@ static inline void be64_add_cpu(__be64 *a, __s64 b)
 	((__u8*)(pointer))[1] = (((value)     ) & 0xff); \
     }
 
-/* does not return a value */
-#define INT_SET(reference,arch,valueref) \
-    (__builtin_constant_p(valueref) ? \
-	(void)( (reference) = ( ((arch) != ARCH_NOCONVERT) ? (INT_SWAP((reference),(valueref))) : (valueref)) ) : \
-	(void)( \
-	    ((reference) = (valueref)), \
-	    ( ((arch) != ARCH_NOCONVERT) ? (reference) = INT_SWAP((reference),(reference)) : 0 ) \
-	) \
-    )
-
 /*
  * In directories inode numbers are stored as unaligned arrays of unsigned
  * 8bit integers on disk.
diff --git a/include/xfs_attr_leaf.h b/include/xfs_attr_leaf.h
index 83e9af4..9c7d22f 100644
--- a/include/xfs_attr_leaf.h
+++ b/include/xfs_attr_leaf.h
@@ -151,8 +151,6 @@ typedef struct xfs_attr_leafblock {
 /*
  * Cast typed pointers for "local" and "remote" name/value structs.
  */
-#define XFS_ATTR_LEAF_NAME_REMOTE(leafp,idx)	\
-	xfs_attr_leaf_name_remote(leafp,idx)
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
@@ -160,8 +158,6 @@ xfs_attr_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 		&((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
 }
 
-#define XFS_ATTR_LEAF_NAME_LOCAL(leafp,idx)	\
-	xfs_attr_leaf_name_local(leafp,idx)
 static inline xfs_attr_leaf_name_local_t *
 xfs_attr_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
 {
@@ -169,8 +165,6 @@ xfs_attr_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
 		&((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
 }
 
-#define XFS_ATTR_LEAF_NAME(leafp,idx)		\
-	xfs_attr_leaf_name(leafp,idx)
 static inline char *xfs_attr_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 {
 	return &((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
@@ -181,24 +175,18 @@ static inline char *xfs_attr_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
  * a "local" name/value structure, a "remote" name/value structure, and
  * a pointer which might be either.
  */
-#define XFS_ATTR_LEAF_ENTSIZE_REMOTE(nlen)	\
-	xfs_attr_leaf_entsize_remote(nlen)
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
 	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
 		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
 }
 
-#define XFS_ATTR_LEAF_ENTSIZE_LOCAL(nlen,vlen)	\
-	xfs_attr_leaf_entsize_local(nlen,vlen)
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
 {
 	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
 		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
 }
 
-#define XFS_ATTR_LEAF_ENTSIZE_LOCAL_MAX(bsize)	\
-	xfs_attr_leaf_entsize_local_max(bsize)
 static inline int xfs_attr_leaf_entsize_local_max(int bsize)
 {
 	return (((bsize) >> 1) + ((bsize) >> 2));
diff --git a/include/xfs_attr_sf.h b/include/xfs_attr_sf.h
index ea22839..919756e 100644
--- a/include/xfs_attr_sf.h
+++ b/include/xfs_attr_sf.h
@@ -25,8 +25,6 @@
  * to fit into the literal area of the inode.
  */
 
-struct xfs_inode;
-
 /*
  * Entries are packed toward the top as tight as possible.
  */
@@ -54,7 +52,7 @@ typedef struct xfs_attr_sf_sort {
 	__uint8_t	valuelen;	/* length of value */
 	__uint8_t	flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
-	char		*name;		/* name value, pointer into buffer */
+	unsigned char	*name;		/* name value, pointer into buffer */
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
@@ -69,42 +67,4 @@ typedef struct xfs_attr_sf_sort {
 	(be16_to_cpu(((xfs_attr_shortform_t *)	\
 		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
 
-#if defined(XFS_ATTR_TRACE)
-/*
- * Kernel tracing support for attribute lists
- */
-struct xfs_attr_list_context;
-struct xfs_da_intnode;
-struct xfs_da_node_entry;
-struct xfs_attr_leafblock;
-
-#define	XFS_ATTR_TRACE_SIZE	4096	/* size of global trace buffer */
-extern ktrace_t	*xfs_attr_trace_buf;
-
-/*
- * Trace record types.
- */
-#define	XFS_ATTR_KTRACE_L_C	1	/* context */
-#define	XFS_ATTR_KTRACE_L_CN	2	/* context, node */
-#define	XFS_ATTR_KTRACE_L_CB	3	/* context, btree */
-#define	XFS_ATTR_KTRACE_L_CL	4	/* context, leaf */
-
-void xfs_attr_trace_l_c(char *where, struct xfs_attr_list_context *context);
-void xfs_attr_trace_l_cn(char *where, struct xfs_attr_list_context *context,
-			      struct xfs_da_intnode *node);
-void xfs_attr_trace_l_cb(char *where, struct xfs_attr_list_context *context,
-			      struct xfs_da_node_entry *btree);
-void xfs_attr_trace_l_cl(char *where, struct xfs_attr_list_context *context,
-			      struct xfs_attr_leafblock *leaf);
-void xfs_attr_trace_enter(int type, char *where,
-			     struct xfs_attr_list_context *context,
-			     __psunsigned_t a13, __psunsigned_t a14,
-			     __psunsigned_t a15);
-#else
-#define	xfs_attr_trace_l_c(w,c)
-#define	xfs_attr_trace_l_cn(w,c,n)
-#define	xfs_attr_trace_l_cb(w,c,b)
-#define	xfs_attr_trace_l_cl(w,c,l)
-#endif /* XFS_ATTR_TRACE */
-
 #endif	/* __XFS_ATTR_SF_H__ */
diff --git a/include/xfs_bit.h b/include/xfs_bit.h
index bca7b24..f1e3c90 100644
--- a/include/xfs_bit.h
+++ b/include/xfs_bit.h
@@ -23,24 +23,16 @@
  */
 
 /*
- * masks with n high/low bits set, 32-bit values & 64-bit values
+ * masks with n high/low bits set, 64-bit values
  */
-#define	XFS_MASK32HI(n)		xfs_mask32hi(n)
-static inline __uint32_t xfs_mask32hi(int n)
-{
-	return (__uint32_t)-1 << (32 - (n));
-}
-#define	XFS_MASK64HI(n)		xfs_mask64hi(n)
 static inline __uint64_t xfs_mask64hi(int n)
 {
 	return (__uint64_t)-1 << (64 - (n));
 }
-#define	XFS_MASK32LO(n)		xfs_mask32lo(n)
 static inline __uint32_t xfs_mask32lo(int n)
 {
 	return ((__uint32_t)1 << (n)) - 1;
 }
-#define	XFS_MASK64LO(n)		xfs_mask64lo(n)
 static inline __uint64_t xfs_mask64lo(int n)
 {
 	return ((__uint64_t)1 << (n)) - 1;
diff --git a/include/xfs_bmap.h b/include/xfs_bmap.h
index 7c9d12c..3651191 100644
--- a/include/xfs_bmap.h
+++ b/include/xfs_bmap.h
@@ -28,20 +28,6 @@ struct xfs_trans;
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
 /*
- * DELTA: describe a change to the in-core extent list.
- *
- * Internally the use of xed_blockount is somewhat funky.
- * xed_blockcount contains an offset much of the time because this
- * makes merging changes easier.  (xfs_fileoff_t and xfs_filblks_t are
- * the same underlying type).
- */
-typedef struct xfs_extdelta
-{
-	xfs_fileoff_t		xed_startoff;	/* offset of range */
-	xfs_filblks_t		xed_blockcount;	/* blocks in range */
-} xfs_extdelta_t;
-
-/*
  * List of extents to be free "later".
  * The list is kept sorted on xbf_startblock.
  */
@@ -82,20 +68,32 @@ typedef	struct xfs_bmap_free
 #define XFS_BMAPI_DELAY		0x002	/* delayed write operation */
 #define XFS_BMAPI_ENTIRE	0x004	/* return entire extent, not trimmed */
 #define XFS_BMAPI_METADATA	0x008	/* mapping metadata not user data */
-#define XFS_BMAPI_EXACT		0x010	/* allocate only to spec'd bounds */
-#define XFS_BMAPI_ATTRFORK	0x020	/* use attribute fork not data */
-#define XFS_BMAPI_ASYNC		0x040	/* bunmapi xactions can be async */
-#define XFS_BMAPI_RSVBLOCKS	0x080	/* OK to alloc. reserved data blocks */
-#define	XFS_BMAPI_PREALLOC	0x100	/* preallocation op: unwritten space */
-#define	XFS_BMAPI_IGSTATE	0x200	/* Ignore state - */
+#define XFS_BMAPI_ATTRFORK	0x010	/* use attribute fork not data */
+#define XFS_BMAPI_RSVBLOCKS	0x020	/* OK to alloc. reserved data blocks */
+#define	XFS_BMAPI_PREALLOC	0x040	/* preallocation op: unwritten space */
+#define	XFS_BMAPI_IGSTATE	0x080	/* Ignore state - */
 					/* combine contig. space */
-#define	XFS_BMAPI_CONTIG	0x400	/* must allocate only one extent */
-/*	XFS_BMAPI_DIRECT_IO	0x800	*/
-#define XFS_BMAPI_CONVERT	0x1000	/* unwritten extent conversion - */
-					/* need write cache flushing and no */
-					/* additional allocation alignments */
+#define	XFS_BMAPI_CONTIG	0x100	/* must allocate only one extent */
+/*
+ * unwritten extent conversion - this needs write cache flushing and no additional
+ * allocation alignments. When specified with XFS_BMAPI_PREALLOC it converts
+ * from written to unwritten, otherwise convert from unwritten to written.
+ */
+#define XFS_BMAPI_CONVERT	0x200
+
+#define XFS_BMAPI_FLAGS \
+	{ XFS_BMAPI_WRITE,	"WRITE" }, \
+	{ XFS_BMAPI_DELAY,	"DELAY" }, \
+	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
+	{ XFS_BMAPI_METADATA,	"METADATA" }, \
+	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
+	{ XFS_BMAPI_RSVBLOCKS,	"RSVBLOCKS" }, \
+	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
+	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
+	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
+	{ XFS_BMAPI_CONVERT,	"CONVERT" }
+
 
-#define	XFS_BMAPI_AFLAG(w)	xfs_bmapi_aflag(w)
 static inline int xfs_bmapi_aflag(int w)
 {
 	return (w == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK : 0);
@@ -107,7 +105,6 @@ static inline int xfs_bmapi_aflag(int w)
 #define	DELAYSTARTBLOCK		((xfs_fsblock_t)-1LL)
 #define	HOLESTARTBLOCK		((xfs_fsblock_t)-2LL)
 
-#define	XFS_BMAP_INIT(flp,fbp)	xfs_bmap_init(flp,fbp)
 static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 {
 	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
@@ -127,7 +124,7 @@ typedef struct xfs_bmalloca {
 	struct xfs_bmbt_irec	*gotp;	/* extent after, or delayed */
 	xfs_extlen_t		alen;	/* i/o length asked/allocated */
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
-	xfs_extlen_t		minlen;	/* mininum allocation size (blocks) */
+	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
 	char			eof;	/* set if allocating past last extent */
 	char			wasdel;	/* replacing a delayed allocation */
@@ -137,36 +134,43 @@ typedef struct xfs_bmalloca {
 	char			conv;	/* overwriting unwritten extents */
 } xfs_bmalloca_t;
 
-#if defined(__KERNEL__) && defined(XFS_BMAP_TRACE)
 /*
- * Trace operations for bmap extent tracing
+ * Flags for xfs_bmap_add_extent*.
  */
-#define	XFS_BMAP_KTRACE_DELETE	1
-#define	XFS_BMAP_KTRACE_INSERT	2
-#define	XFS_BMAP_KTRACE_PRE_UP	3
-#define	XFS_BMAP_KTRACE_POST_UP	4
-
-#define	XFS_BMAP_TRACE_SIZE	4096	/* size of global trace buffer */
-#define	XFS_BMAP_KTRACE_SIZE	32	/* size of per-inode trace buffer */
-extern ktrace_t	*xfs_bmap_trace_buf;
+#define BMAP_LEFT_CONTIG	(1 << 0)
+#define BMAP_RIGHT_CONTIG	(1 << 1)
+#define BMAP_LEFT_FILLING	(1 << 2)
+#define BMAP_RIGHT_FILLING	(1 << 3)
+#define BMAP_LEFT_DELAY		(1 << 4)
+#define BMAP_RIGHT_DELAY	(1 << 5)
+#define BMAP_LEFT_VALID		(1 << 6)
+#define BMAP_RIGHT_VALID	(1 << 7)
+#define BMAP_ATTRFORK		(1 << 8)
+
+#define XFS_BMAP_EXT_FLAGS \
+	{ BMAP_LEFT_CONTIG,	"LC" }, \
+	{ BMAP_RIGHT_CONTIG,	"RC" }, \
+	{ BMAP_LEFT_FILLING,	"LF" }, \
+	{ BMAP_RIGHT_FILLING,	"RF" }, \
+	{ BMAP_ATTRFORK,	"ATTR" }
 
 /*
  * Add bmap trace insert entries for all the contents of the extent list.
+ *
+ * Quite excessive tracing.  Only do this for debug builds.
  */
+#if defined(__KERNEL) && defined(DEBUG)
 void
 xfs_bmap_trace_exlist(
-	const char		*fname,		/* function name */
 	struct xfs_inode	*ip,		/* incore inode pointer */
 	xfs_extnum_t		cnt,		/* count of entries in list */
-	int			whichfork);	/* data or attr fork */
+	int			whichfork,
+	unsigned long		caller_ip);	/* data or attr fork */
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
-	xfs_bmap_trace_exlist(__func__,ip,c,w)
-
-#else	/* __KERNEL__ && XFS_BMAP_TRACE */
-
+	xfs_bmap_trace_exlist(ip,c,w, _THIS_IP_)
+#else
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
-
-#endif	/* __KERNEL__ && XFS_BMAP_TRACE */
+#endif
 
 /*
  * Convert inode from non-attributed to attributed.
@@ -290,9 +294,7 @@ xfs_bmapi(
 	xfs_extlen_t		total,		/* total blocks needed */
 	struct xfs_bmbt_irec	*mval,		/* output: map values */
 	int			*nmap,		/* i/o: mval size/count */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	xfs_extdelta_t		*delta);	/* o: change made to incore
-						   extents */
+	xfs_bmap_free_t		*flist);	/* i/o: list extents to free */
 
 /*
  * Map file blocks to filesystem blocks, simple version.
@@ -326,8 +328,6 @@ xfs_bunmapi(
 	xfs_fsblock_t		*firstblock,	/* first allocated block
 						   controls a.g. for allocs */
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	xfs_extdelta_t		*delta,		/* o: change made to incore
-						   extents */
 	int			*done);		/* set if not done yet */
 
 /*
@@ -340,6 +340,10 @@ xfs_check_nostate_extents(
 	xfs_extnum_t		idx,
 	xfs_extnum_t		num);
 
+uint
+xfs_default_attroffset(
+	struct xfs_inode	*ip);
+
 #ifdef __KERNEL__
 
 /*
@@ -356,15 +360,18 @@ xfs_bmap_finish(
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
 	int			*committed);	/* xact committed or not */
 
+/* bmap to userspace formatter - copy to user & advance pointer */
+typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
+
 /*
- * Fcntl interface to xfs_bmapi.
+ * Get inode's extents as described in bmv, and format for output.
  */
 int						/* error code */
 xfs_getbmap(
 	xfs_inode_t		*ip,
-	struct getbmap		*bmv,		/* user bmap structure */
-	void			__user *ap,	/* pointer to user's array */
-	int			iflags);	/* interface flags */
+	struct getbmapx		*bmv,		/* user bmap structure */
+	xfs_bmap_format_t	formatter,	/* format to user */
+	void			*arg);		/* formatter arg */
 
 /*
  * Check if the endoff is outside the last extent. If so the caller will grow
@@ -387,17 +394,11 @@ xfs_bmap_count_blocks(
 	int			whichfork,
 	int			*count);
 
-/*
- * Search the extent records for the entry containing block bno.
- * If bno lies in a hole, point to the next entry.  If bno lies
- * past eof, *eofp will be set, and *prevp will contain the last
- * entry (null if none).  Else, *lastxp will be set to the index
- * of the found entry; *gotp will contain the entry.
- */
-xfs_bmbt_rec_host_t *
-xfs_bmap_search_multi_extents(struct xfs_ifork *, xfs_fileoff_t, int *,
-			xfs_extnum_t *, xfs_bmbt_irec_t *, xfs_bmbt_irec_t *);
-
+int
+xfs_bmap_punch_delalloc_range(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		length);
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
index a4555ab..0e66c4e 100644
--- a/include/xfs_bmap_btree.h
+++ b/include/xfs_bmap_btree.h
@@ -46,20 +46,12 @@ typedef struct xfs_bmdr_block {
 #define BMBT_STARTBLOCK_BITLEN	52
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
-
-#define BMBT_USE_64	1
-
-typedef struct xfs_bmbt_rec_32
-{
-	__uint32_t		l0, l1, l2, l3;
-} xfs_bmbt_rec_32_t;
-typedef struct xfs_bmbt_rec_64
-{
+typedef struct xfs_bmbt_rec {
 	__be64			l0, l1;
-} xfs_bmbt_rec_64_t;
+} xfs_bmbt_rec_t;
 
 typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
-typedef xfs_bmbt_rec_64_t xfs_bmbt_rec_t, xfs_bmdr_rec_t;
+typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
 
 typedef struct xfs_bmbt_rec_host {
 	__uint64_t		l0, l1;
@@ -76,26 +68,22 @@ typedef struct xfs_bmbt_rec_host {
 #define DSTARTBLOCKMASK		\
 	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
 
-#define ISNULLSTARTBLOCK(x)	isnullstartblock(x)
 static inline int isnullstartblock(xfs_fsblock_t x)
 {
 	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
 }
 
-#define ISNULLDSTARTBLOCK(x)	isnulldstartblock(x)
 static inline int isnulldstartblock(xfs_dfsbno_t x)
 {
 	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
 }
 
-#define NULLSTARTBLOCK(k)	nullstartblock(k)
 static inline xfs_fsblock_t nullstartblock(int k)
 {
 	ASSERT(k < (1 << STARTBLOCKVALBITS));
 	return STARTBLOCKMASK | (k);
 }
 
-#define STARTBLOCKVAL(x)	startblockval(x)
 static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
 {
 	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
@@ -224,7 +212,6 @@ extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
 extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
 
-extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 
@@ -236,7 +223,6 @@ extern void xfs_bmbt_set_startblock(xfs_bmbt_rec_host_t *r, xfs_fsblock_t v);
 extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_host_t *r, xfs_fileoff_t v);
 extern void xfs_bmbt_set_state(xfs_bmbt_rec_host_t *r, xfs_exntst_t v);
 
-extern void xfs_bmbt_disk_set_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 extern void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
 
diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index 789fffd..82fafc6 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -41,7 +41,7 @@ extern kmem_zone_t	*xfs_btree_cur_zone;
 /*
  * Generic btree header.
  *
- * This is a comination of the actual format used on disk for short and long
+ * This is a combination of the actual format used on disk for short and long
  * format btrees.  The first three fields are shared by both format, but
  * the pointers are different and should be used with care.
  *
@@ -152,9 +152,7 @@ struct xfs_btree_ops {
 
 	/* update btree root pointer */
 	void	(*set_root)(struct xfs_btree_cur *cur,
-				union xfs_btree_ptr *nptr, int level_change);
-	int	(*kill_root)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
-				int level, union xfs_btree_ptr *newroot);
+			    union xfs_btree_ptr *nptr, int level_change);
 
 	/* block allocation / freeing */
 	int	(*alloc_block)(struct xfs_btree_cur *cur,
@@ -379,20 +377,6 @@ xfs_btree_read_bufl(
 	int			refval);/* ref count value for buffer */
 
 /*
- * Get a buffer for the block, return it read in.
- * Short-form addressing.
- */
-int					/* error */
-xfs_btree_read_bufs(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	xfs_agblock_t		agbno,	/* allocation group block number */
-	uint			lock,	/* lock flags for read_buf */
-	struct xfs_buf		**bpp,	/* buffer for agno/agbno */
-	int			refval);/* ref count value for buffer */
-
-/*
  * Read-ahead the block, don't wait for it, don't return a buffer.
  * Long-form addressing.
  */
@@ -413,16 +397,6 @@ xfs_btree_reada_bufs(
 	xfs_agblock_t		agbno,	/* allocation group block number */
 	xfs_extlen_t		count);	/* count of filesystem blocks */
 
-/*
- * Set the buffer for level "lev" in the cursor to bp, releasing
- * any previous buffer.
- */
-void
-xfs_btree_setbuf(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			lev,	/* level in btree */
-	struct xfs_buf		*bp);	/* new buffer to set */
-
 
 /*
  * Common btree core entry points.
@@ -432,7 +406,6 @@ int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
 int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
 int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
-int xfs_btree_kill_iroot(struct xfs_btree_cur *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
diff --git a/include/xfs_btree_trace.h b/include/xfs_btree_trace.h
index b3f5eb3..2d8a309 100644
--- a/include/xfs_btree_trace.h
+++ b/include/xfs_btree_trace.h
@@ -58,8 +58,6 @@ void xfs_btree_trace_argbi(const char *, struct xfs_btree_cur *,
 		struct xfs_buf *, int, int);
 void xfs_btree_trace_argbii(const char *, struct xfs_btree_cur *,
 		struct xfs_buf *, int, int, int);
-void xfs_btree_trace_argfffi(const char *, struct xfs_btree_cur *,
-		xfs_dfiloff_t, xfs_dfsbno_t, xfs_dfilblks_t, int, int);
 void xfs_btree_trace_argi(const char *, struct xfs_btree_cur *, int, int);
 void xfs_btree_trace_argipk(const char *, struct xfs_btree_cur *, int,
 		union xfs_btree_ptr, union xfs_btree_key *, int);
@@ -71,24 +69,10 @@ void xfs_btree_trace_argr(const char *, struct xfs_btree_cur *,
 		union xfs_btree_rec *, int);
 void xfs_btree_trace_cursor(const char *, struct xfs_btree_cur *, int, int);
 
-
-#define XFS_ALLOCBT_TRACE_SIZE	4096	/* size of global trace buffer */
-extern ktrace_t	*xfs_allocbt_trace_buf;
-
-#define XFS_INOBT_TRACE_SIZE	4096	/* size of global trace buffer */
-extern ktrace_t	*xfs_inobt_trace_buf;
-
-#define XFS_BMBT_TRACE_SIZE	4096	/* size of global trace buffer */
-#define XFS_BMBT_KTRACE_SIZE	32	/* size of per-inode trace buffer */
-extern ktrace_t	*xfs_bmbt_trace_buf;
-
-
 #define	XFS_BTREE_TRACE_ARGBI(c, b, i)	\
 	xfs_btree_trace_argbi(__func__, c, b, i, __LINE__)
 #define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)	\
 	xfs_btree_trace_argbii(__func__, c, b, i, j, __LINE__)
-#define	XFS_BTREE_TRACE_ARGFFFI(c, o, b, i, j)	\
-	xfs_btree_trace_argfffi(__func__, c, o, b, i, j, __LINE__)
 #define	XFS_BTREE_TRACE_ARGI(c, i)	\
 	xfs_btree_trace_argi(__func__, c, i, __LINE__)
 #define	XFS_BTREE_TRACE_ARGIPK(c, i, p, k)	\
@@ -104,7 +88,6 @@ extern ktrace_t	*xfs_bmbt_trace_buf;
 #else
 #define	XFS_BTREE_TRACE_ARGBI(c, b, i)
 #define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
-#define	XFS_BTREE_TRACE_ARGFFFI(c, o, b, i, j)
 #define	XFS_BTREE_TRACE_ARGI(c, i)
 #define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
 #define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
index 5a41c34..b6ecd20 100644
--- a/include/xfs_buf_item.h
+++ b/include/xfs_buf_item.h
@@ -26,7 +26,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
  * have been logged.
  * For 6.2 and beyond, this is XFS_LI_BUF.  We use this to log everything.
  */
-typedef struct xfs_buf_log_format_t {
+typedef struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
 	unsigned short	blf_size;	/* size of this item */
 	ushort		blf_flags;	/* misc state */
@@ -41,22 +41,22 @@ typedef struct xfs_buf_log_format_t {
  * This flag indicates that the buffer contains on disk inodes
  * and requires special recovery handling.
  */
-#define	XFS_BLI_INODE_BUF	0x1
+#define	XFS_BLF_INODE_BUF	0x1
 /*
  * This flag indicates that the buffer should not be replayed
  * during recovery because its blocks are being freed.
  */
-#define	XFS_BLI_CANCEL		0x2
+#define	XFS_BLF_CANCEL		0x2
 /*
  * This flag indicates that the buffer contains on disk
  * user or group dquots and may require special recovery handling.
  */
-#define	XFS_BLI_UDQUOT_BUF	0x4
-#define XFS_BLI_PDQUOT_BUF	0x8
-#define	XFS_BLI_GDQUOT_BUF	0x10
+#define	XFS_BLF_UDQUOT_BUF	0x4
+#define XFS_BLF_PDQUOT_BUF	0x8
+#define	XFS_BLF_GDQUOT_BUF	0x10
 
-#define	XFS_BLI_CHUNK		128
-#define	XFS_BLI_SHIFT		7
+#define	XFS_BLF_CHUNK		128
+#define	XFS_BLF_SHIFT		7
 #define	BIT_TO_WORD_SHIFT	5
 #define	NBWORD			(NBBY * sizeof(unsigned int))
 
@@ -69,23 +69,24 @@ typedef struct xfs_buf_log_format_t {
 #define	XFS_BLI_LOGGED		0x08
 #define	XFS_BLI_INODE_ALLOC_BUF	0x10
 #define XFS_BLI_STALE_INODE	0x20
+#define	XFS_BLI_INODE_BUF	0x40
+
+#define XFS_BLI_FLAGS \
+	{ XFS_BLI_HOLD,		"HOLD" }, \
+	{ XFS_BLI_DIRTY,	"DIRTY" }, \
+	{ XFS_BLI_STALE,	"STALE" }, \
+	{ XFS_BLI_LOGGED,	"LOGGED" }, \
+	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
+	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
+	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }
 
 
 #ifdef __KERNEL__
 
 struct xfs_buf;
-struct ktrace;
 struct xfs_mount;
 struct xfs_buf_log_item;
 
-#if defined(XFS_BLI_TRACE)
-#define	XFS_BLI_TRACE_SIZE	32
-
-void	xfs_buf_item_trace(char *, struct xfs_buf_log_item *);
-#else
-#define	xfs_buf_item_trace(id, bip)
-#endif
-
 /*
  * This is the in core log item structure used to track information
  * needed to log buffers.  It tracks how many times the lock has been
@@ -97,9 +98,6 @@ typedef struct xfs_buf_log_item {
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* lock recursion count */
 	atomic_t		bli_refcount;	/* cnt of tp refs */
-#ifdef XFS_BLI_TRACE
-	struct ktrace		*bli_trace;	/* event trace buf */
-#endif
 #ifdef XFS_TRANS_DEBUG
 	char			*bli_orig;	/* original buffer copy */
 	char			*bli_logged;	/* bytes logged (bitmap) */
@@ -107,17 +105,6 @@ typedef struct xfs_buf_log_item {
 	xfs_buf_log_format_t	bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
-/*
- * This structure is used during recovery to record the buf log
- * items which have been canceled and should not be replayed.
- */
-typedef struct xfs_buf_cancel {
-	xfs_daddr_t		bc_blkno;
-	uint			bc_len;
-	int			bc_refcount;
-	struct xfs_buf_cancel	*bc_next;
-} xfs_buf_cancel_t;
-
 void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_relse(struct xfs_buf *);
 void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
@@ -126,7 +113,7 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      void(*)(struct xfs_buf *, xfs_log_item_t *),
 			      xfs_log_item_t *);
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
-void	xfs_buf_iodone(struct xfs_buf *, xfs_buf_log_item_t *);
+void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 
 #ifdef XFS_TRANS_DEBUG
 void
diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index 70b710c..fe9f5a8 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -91,9 +91,9 @@ enum xfs_dacmp {
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
-	const uchar_t	*name;		/* string (maybe not NULL terminated) */
+	const __uint8_t	*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
-	uchar_t		*value;		/* set of bytes (maybe contain NULLs) */
+	__uint8_t	*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
@@ -125,6 +125,13 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 
+#define XFS_DA_OP_FLAGS \
+	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
+	{ XFS_DA_OP_RENAME,	"RENAME" }, \
+	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
+	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
+	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }
+
 /*
  * Structure to describe buffer(s) for a block.
  * This is needed in the directory version 2 format case, when
@@ -185,7 +192,7 @@ typedef struct xfs_da_state {
 	unsigned char		inleaf;		/* insert into 1->lf, 0->splf */
 	unsigned char		extravalid;	/* T/F: extrablk is in use */
 	unsigned char		extraafter;	/* T/F: extrablk is after new */
-	xfs_da_state_blk_t	extrablk;	/* for double-splits on leafs */
+	xfs_da_state_blk_t	extrablk;	/* for double-splits on leaves */
 						/* for dirv2 extrablk is data */
 } xfs_da_state_t;
 
@@ -202,7 +209,8 @@ typedef struct xfs_da_state {
  */
 struct xfs_nameops {
 	xfs_dahash_t	(*hashname)(struct xfs_name *);
-	enum xfs_dacmp	(*compname)(struct xfs_da_args *, const char *, int);
+	enum xfs_dacmp	(*compname)(struct xfs_da_args *,
+					const unsigned char *, int);
 };
 
 
@@ -251,9 +259,9 @@ xfs_daddr_t	xfs_da_reada_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  xfs_dabuf_t *dead_buf);
 
-uint xfs_da_hashname(const uchar_t *name_string, int name_length);
+uint xfs_da_hashname(const __uint8_t *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
-				const char *name, int len);
+				const unsigned char *name, int len);
 
 
 xfs_da_state_t *xfs_da_state_alloc(void);
@@ -268,5 +276,6 @@ xfs_daddr_t xfs_da_blkno(xfs_dabuf_t *dabuf);
 
 extern struct kmem_zone *xfs_da_state_zone;
 extern struct kmem_zone *xfs_dabuf_zone;
+extern const struct xfs_nameops xfs_default_nameops;
 
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/include/xfs_dfrag.h b/include/xfs_dfrag.h
index da17820..20bdd93 100644
--- a/include/xfs_dfrag.h
+++ b/include/xfs_dfrag.h
@@ -46,10 +46,7 @@ typedef struct xfs_swapext
 /*
  * Syscall interface for xfs_swapext
  */
-int	xfs_swapext(struct xfs_swapext __user *sx);
-
-int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
-		struct xfs_swapext *sxp);
+int	xfs_swapext(struct xfs_swapext *sx);
 
 #endif	/* __KERNEL__ */
 
diff --git a/include/xfs_dinode.h b/include/xfs_dinode.h
index f28c088..dffba9b 100644
--- a/include/xfs_dinode.h
+++ b/include/xfs_dinode.h
@@ -18,32 +18,29 @@
 #ifndef __XFS_DINODE_H__
 #define	__XFS_DINODE_H__
 
-struct xfs_buf;
-struct xfs_mount;
+#define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
+#define XFS_DINODE_GOOD_VERSION(v)	(((v) == 1 || (v) == 2))
 
-#define	XFS_DINODE_VERSION_1	1
-#define	XFS_DINODE_VERSION_2	2
-#define XFS_DINODE_GOOD_VERSION(v)	\
-	(((v) == XFS_DINODE_VERSION_1 || (v) == XFS_DINODE_VERSION_2))
-#define	XFS_DINODE_MAGIC	0x494e	/* 'IN' */
-
-/*
- * Disk inode structure.
- * This is just the header; the inode is expanded to fill a variable size
- * with the last field expanding.  It is split into the core and "other"
- * because we only need the core part in the in-core inode.
- */
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
 } xfs_timestamp_t;
 
 /*
- * Note: Coordinate changes to this structure with the XFS_DI_* #defines
- * below, the offsets table in xfs_ialloc_log_di() and struct xfs_icdinode
- * in xfs_inode.h.
+ * On-disk inode structure.
+ *
+ * This is just the header or "dinode core", the inode is expanded to fill a
+ * variable size the leftover area split into a data and an attribute fork.
+ * The format of the data and attribute fork depends on the format of the
+ * inode as indicated by di_format and di_aformat.  To access the data and
+ * attribute use the XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR macros
+ * below.
+ *
+ * There is a very similar struct icdinode in xfs_inode which matches the
+ * layout of the first 96 bytes of this structure, but is kept in native
+ * format instead of big endian.
  */
-typedef struct xfs_dinode_core {
+typedef struct xfs_dinode {
 	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__be16		di_mode;	/* mode and type of file */
 	__u8		di_version;	/* inode version */
@@ -70,33 +67,12 @@ typedef struct xfs_dinode_core {
 	__be16		di_dmstate;	/* DMIG state info */
 	__be16		di_flags;	/* random flags, XFS_DIFLAG_... */
 	__be32		di_gen;		/* generation number */
-} xfs_dinode_core_t;
 
-#define DI_MAX_FLUSH 0xffff
+	/* di_next_unlinked is the only non-core field in the old dinode */
+	__be32		di_next_unlinked;/* agi unlinked list ptr */
+} __attribute__((packed)) xfs_dinode_t;
 
-typedef struct xfs_dinode
-{
-	xfs_dinode_core_t	di_core;
-	/*
-	 * In adding anything between the core and the union, be
-	 * sure to update the macros like XFS_LITINO below.
-	 */
-	__be32			di_next_unlinked;/* agi unlinked list ptr */
-	union {
-		xfs_bmdr_block_t di_bmbt;	/* btree root block */
-		xfs_bmbt_rec_32_t di_bmx[1];	/* extent list */
-		xfs_dir2_sf_t	di_dir2sf;	/* shortform directory v2 */
-		char		di_c[1];	/* local contents */
-		__be32		di_dev;		/* device for S_IFCHR/S_IFBLK */
-		uuid_t		di_muuid;	/* mount point value */
-		char		di_symlink[1];	/* local symbolic link */
-	}		di_u;
-	union {
-		xfs_bmdr_block_t di_abmbt;	/* btree root block */
-		xfs_bmbt_rec_32_t di_abmx[1];	/* extent list */
-		xfs_attr_shortform_t di_attrsf;	/* shortform attribute list */
-	}		di_a;
-} xfs_dinode_t;
+#define DI_MAX_FLUSH 0xffff
 
 /*
  * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
@@ -107,50 +83,14 @@ typedef struct xfs_dinode
 #define	XFS_MAXLINK_1		65535U
 
 /*
- * Bit names for logging disk inodes only
- */
-#define	XFS_DI_MAGIC		0x0000001
-#define	XFS_DI_MODE		0x0000002
-#define	XFS_DI_VERSION		0x0000004
-#define	XFS_DI_FORMAT		0x0000008
-#define	XFS_DI_ONLINK		0x0000010
-#define	XFS_DI_UID		0x0000020
-#define	XFS_DI_GID		0x0000040
-#define	XFS_DI_NLINK		0x0000080
-#define	XFS_DI_PROJID		0x0000100
-#define	XFS_DI_PAD		0x0000200
-#define	XFS_DI_ATIME		0x0000400
-#define	XFS_DI_MTIME		0x0000800
-#define	XFS_DI_CTIME		0x0001000
-#define	XFS_DI_SIZE		0x0002000
-#define	XFS_DI_NBLOCKS		0x0004000
-#define	XFS_DI_EXTSIZE		0x0008000
-#define	XFS_DI_NEXTENTS		0x0010000
-#define	XFS_DI_NAEXTENTS	0x0020000
-#define	XFS_DI_FORKOFF		0x0040000
-#define	XFS_DI_AFORMAT		0x0080000
-#define	XFS_DI_DMEVMASK		0x0100000
-#define	XFS_DI_DMSTATE		0x0200000
-#define	XFS_DI_FLAGS		0x0400000
-#define	XFS_DI_GEN		0x0800000
-#define	XFS_DI_NEXT_UNLINKED	0x1000000
-#define	XFS_DI_U		0x2000000
-#define	XFS_DI_A		0x4000000
-#define	XFS_DI_NUM_BITS		27
-#define	XFS_DI_ALL_BITS		((1 << XFS_DI_NUM_BITS) - 1)
-#define	XFS_DI_CORE_BITS	(XFS_DI_ALL_BITS & ~(XFS_DI_U|XFS_DI_A))
-
-/*
  * Values for di_format
  */
-typedef enum xfs_dinode_fmt
-{
-	XFS_DINODE_FMT_DEV,		/* CHR, BLK: di_dev */
-	XFS_DINODE_FMT_LOCAL,		/* DIR, REG: di_c */
-					/* LNK: di_symlink */
-	XFS_DINODE_FMT_EXTENTS,		/* DIR, REG, LNK: di_bmx */
-	XFS_DINODE_FMT_BTREE,		/* DIR, REG, LNK: di_bmbt */
-	XFS_DINODE_FMT_UUID		/* MNT: di_uuid */
+typedef enum xfs_dinode_fmt {
+	XFS_DINODE_FMT_DEV,		/* xfs_dev_t */
+	XFS_DINODE_FMT_LOCAL,		/* bulk data */
+	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
+	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
+	XFS_DINODE_FMT_UUID		/* uuid_t */
 } xfs_dinode_fmt_t;
 
 /*
@@ -164,15 +104,17 @@ typedef enum xfs_dinode_fmt
 /*
  * Inode size for given fs.
  */
-#define	XFS_LITINO(mp)	((mp)->m_litino)
+#define XFS_LITINO(mp) \
+	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
+
 #define	XFS_BROOT_SIZE_ADJ	\
 	(XFS_BTREE_LBLOCK_LEN - sizeof(xfs_bmdr_block_t))
 
 /*
  * Inode data & attribute fork sizes, per inode.
  */
-#define XFS_DFORK_Q(dip)		((dip)->di_core.di_forkoff != 0)
-#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_core.di_forkoff << 3))
+#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
+#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
@@ -187,23 +129,42 @@ typedef enum xfs_dinode_fmt
 		XFS_DFORK_DSIZE(dip, mp) : \
 		XFS_DFORK_ASIZE(dip, mp))
 
-#define XFS_DFORK_DPTR(dip)		    ((dip)->di_u.di_c)
+/*
+ * Return pointers to the data or attribute forks.
+ */
+#define XFS_DFORK_DPTR(dip) \
+	((char *)(dip) + sizeof(struct xfs_dinode))
 #define XFS_DFORK_APTR(dip)	\
-	((dip)->di_u.di_c + XFS_DFORK_BOFF(dip))
+	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
 	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
+
 #define XFS_DFORK_FORMAT(dip,w) \
 	((w) == XFS_DATA_FORK ? \
-		(dip)->di_core.di_format : \
-		(dip)->di_core.di_aformat)
+		(dip)->di_format : \
+		(dip)->di_aformat)
 #define XFS_DFORK_NEXTENTS(dip,w) \
 	((w) == XFS_DATA_FORK ? \
-	 	be32_to_cpu((dip)->di_core.di_nextents) : \
-	 	be16_to_cpu((dip)->di_core.di_anextents))
+		be32_to_cpu((dip)->di_nextents) : \
+		be16_to_cpu((dip)->di_anextents))
 
 #define	XFS_BUF_TO_DINODE(bp)	((xfs_dinode_t *)XFS_BUF_PTR(bp))
 
 /*
+ * For block and character special files the 32bit dev_t is stored at the
+ * beginning of the data fork.
+ */
+static inline xfs_dev_t xfs_dinode_get_rdev(struct xfs_dinode *dip)
+{
+	return be32_to_cpu(*(__be32 *)XFS_DFORK_DPTR(dip));
+}
+
+static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
+{
+	*(__be32 *)XFS_DFORK_DPTR(dip) = cpu_to_be32(rdev);
+}
+
+/*
  * Values for di_flags
  * There should be a one-to-one correspondence between these flags and the
  * XFS_XFLAG_s.
diff --git a/include/xfs_dir2.h b/include/xfs_dir2.h
index 1d9ef96..74a3b10 100644
--- a/include/xfs_dir2.h
+++ b/include/xfs_dir2.h
@@ -100,7 +100,7 @@ extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_dabuf *bp);
 
-extern int xfs_dir_cilookup_result(struct xfs_da_args *args, const char *name,
-				int len);
+extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
+				const unsigned char *name, int len);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/include/xfs_dir2_data.h b/include/xfs_dir2_data.h
index b816e02..efbc290 100644
--- a/include/xfs_dir2_data.h
+++ b/include/xfs_dir2_data.h
@@ -38,7 +38,7 @@ struct xfs_trans;
 
 /*
  * Directory address space divided into sections,
- * spaces separated by 32gb.
+ * spaces separated by 32GB.
  */
 #define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
 #define	XFS_DIR2_DATA_SPACE	0
diff --git a/include/xfs_dir2_node.h b/include/xfs_dir2_node.h
index dde72db..82dfe71 100644
--- a/include/xfs_dir2_node.h
+++ b/include/xfs_dir2_node.h
@@ -75,8 +75,6 @@ xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
 	return ((db) % XFS_DIR2_MAX_FREE_BESTS(mp));
 }
 
-extern void xfs_dir2_free_log_bests(struct xfs_trans *tp, struct xfs_dabuf *bp,
-				    int first, int last);
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 				 struct xfs_dabuf *lbp);
 extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_dabuf *bp, int *count);
diff --git a/include/xfs_dir2_sf.h b/include/xfs_dir2_sf.h
index deecc9d..6ac44b5 100644
--- a/include/xfs_dir2_sf.h
+++ b/include/xfs_dir2_sf.h
@@ -34,13 +34,6 @@ struct xfs_mount;
 struct xfs_trans;
 
 /*
- * Maximum size of a shortform directory.
- */
-#define	XFS_DIR2_SF_MAX_SIZE	\
-	(XFS_DINODE_MAX_SIZE - (uint)sizeof(xfs_dinode_core_t) - \
-	 (uint)sizeof(xfs_agino_t))
-
-/*
  * Inode number stored as 8 8-bit values.
  */
 typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
diff --git a/include/xfs_extfree_item.h b/include/xfs_extfree_item.h
index 2f049f6..375f68e 100644
--- a/include/xfs_extfree_item.h
+++ b/include/xfs_extfree_item.h
@@ -33,12 +33,10 @@ typedef struct xfs_extent {
  * conversion routine.
  */
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_extent_32 {
 	__uint64_t	ext_start;
 	__uint32_t	ext_len;
 } __attribute__((packed)) xfs_extent_32_t;
-#endif
 
 typedef struct xfs_extent_64 {
 	__uint64_t	ext_start;
@@ -59,7 +57,6 @@ typedef struct xfs_efi_log_format {
 	xfs_extent_t		efi_extents[1];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_efi_log_format_32 {
 	__uint16_t		efi_type;	/* efi log item type */
 	__uint16_t		efi_size;	/* size of this item */
@@ -67,7 +64,6 @@ typedef struct xfs_efi_log_format_32 {
 	__uint64_t		efi_id;		/* efi identifier */
 	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
-#endif
 
 typedef struct xfs_efi_log_format_64 {
 	__uint16_t		efi_type;	/* efi log item type */
@@ -90,7 +86,6 @@ typedef struct xfs_efd_log_format {
 	xfs_extent_t		efd_extents[1];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_efd_log_format_32 {
 	__uint16_t		efd_type;	/* efd log item type */
 	__uint16_t		efd_size;	/* size of this item */
@@ -98,7 +93,6 @@ typedef struct xfs_efd_log_format_32 {
 	__uint64_t		efd_efi_id;	/* id of corresponding efi */
 	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
-#endif
 
 typedef struct xfs_efd_log_format_64 {
 	__uint16_t		efd_type;	/* efd log item type */
@@ -117,11 +111,10 @@ typedef struct xfs_efd_log_format_64 {
 #define	XFS_EFI_MAX_FAST_EXTENTS	16
 
 /*
- * Define EFI flags.
+ * Define EFI flag bits. Manipulated by set/clear/test_bit operators.
  */
-#define	XFS_EFI_RECOVERED	0x1
-#define	XFS_EFI_COMMITTED	0x2
-#define	XFS_EFI_CANCELED	0x4
+#define	XFS_EFI_RECOVERED	1
+#define	XFS_EFI_COMMITTED	2
 
 /*
  * This is the "extent free intention" log item.  It is used
@@ -131,8 +124,8 @@ typedef struct xfs_efd_log_format_64 {
  */
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
-	uint			efi_flags;	/* misc flags */
-	uint			efi_next_extent;
+	atomic_t		efi_next_extent;
+	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
 } xfs_efi_log_item_t;
 
diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index 47c1e93..faac5af 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -113,22 +113,16 @@ struct getbmapx {
 #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
 #define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
-#define BMV_IF_VALID	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC)
-#ifdef __KERNEL__
-#define BMV_IF_EXTENDED 0x40000000	/* getpmapx if set */
-#endif
+#define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
+#define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
+#define BMV_IF_VALID	\
+	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
+	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES)
 
-/*	bmv_oflags values - returned for for each non-header segment */
+/*	bmv_oflags values - returned for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
-
-/*	Convert getbmap <-> getbmapx - move fields from p1 to p2. */
-#define GETBMAP_CONVERT(p1,p2) {	\
-	p2.bmv_offset = p1.bmv_offset;	\
-	p2.bmv_block = p1.bmv_block;	\
-	p2.bmv_length = p1.bmv_length;	\
-	p2.bmv_count = p1.bmv_count;	\
-	p2.bmv_entries = p1.bmv_entries;  }
-
+#define BMV_OF_DELALLOC		0x2	/* segment = delayed allocation */
+#define BMV_OF_LAST		0x4	/* segment is the last in the file */
 
 /*
  * Structure for XFS_IOC_FSSETDM.
@@ -300,7 +294,7 @@ typedef struct xfs_bstat {
 	__s32		bs_extents;	/* number of extents		*/
 	__u32		bs_gen;		/* generation count		*/
 	__u16		bs_projid_lo;	/* lower part of project id	*/
-#define	bs_projid	bs_projid_lo
+#define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
 	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
 	__u16		bs_projid_hi;	/* higher part of project id	*/
 	unsigned char	bs_pad[10];	/* pad space, unused		*/
@@ -432,10 +426,6 @@ typedef struct xfs_handle {
 #define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
 #define XFS_IOC_SETXFLAGS	FS_IOC_SETFLAGS
 #define XFS_IOC_GETVERSION	FS_IOC_GETVERSION
-/* 32-bit compat counterparts */
-#define XFS_IOC32_GETXFLAGS	FS_IOC32_GETFLAGS
-#define XFS_IOC32_SETXFLAGS	FS_IOC32_SETFLAGS
-#define XFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
 
 /*
  * ioctl commands that replace IRIX fcntl()'s
@@ -484,6 +474,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
+/*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
+/*	XFS_IOC_THAW		  -- FITHAW     120	 */
 #define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
 #define XFS_IOC_THAW		     _IOWR('X', 120, int)
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index ccf554a..bb53854 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -20,6 +20,7 @@
 
 struct xfs_buf;
 struct xfs_dinode;
+struct xfs_imap;
 struct xfs_mount;
 struct xfs_trans;
 
@@ -38,7 +39,6 @@ struct xfs_trans;
 /*
  * Make an inode pointer out of the buffer/offset.
  */
-#define	XFS_MAKE_IPTR(mp,b,o)		xfs_make_iptr(mp,b,o)
 static inline struct xfs_dinode *
 xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 {
@@ -49,7 +49,6 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 /*
  * Find a free (set) bit in the inode bitmask.
  */
-#define	XFS_IALLOC_FIND_FREE(fp)	xfs_ialloc_find_free(fp)
 static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
 {
 	return xfs_lowbit64(*fp);
@@ -104,17 +103,14 @@ xfs_difree(
 	xfs_ino_t	*first_ino);	/* first inode in deleted cluster */
 
 /*
- * Return the location of the inode in bno/len/off,
- * for mapping it into a buffer.
+ * Return the location of the inode in imap, for mapping it into a buffer.
  */
 int
-xfs_dilocate(
+xfs_imap(
 	struct xfs_mount *mp,		/* file system mount structure */
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	ino,		/* inode to locate */
-	xfs_fsblock_t	*bno,		/* output: block containing inode */
-	int		*len,		/* output: num blocks in cluster*/
-	int		*off,		/* output: index in block of inode */
+	struct xfs_imap	*imap,		/* location map structure */
 	uint		flags);		/* flags for inode btree lookup */
 
 /*
@@ -154,23 +150,15 @@ xfs_ialloc_pagi_init(
         xfs_agnumber_t  agno);		/* allocation group number */
 
 /*
- * Lookup the first record greater than or equal to ino
- * in the btree given by cur.
+ * Lookup a record by ino in the btree given by cur.
  */
-int xfs_inobt_lookup_ge(struct xfs_btree_cur *cur, xfs_agino_t ino,
-		__int32_t fcnt,	xfs_inofree_t free, int *stat);
-
-/*
- * Lookup the first record less than or equal to ino
- * in the btree given by cur.
- */
-int xfs_inobt_lookup_le(struct xfs_btree_cur *cur, xfs_agino_t ino,
-		__int32_t fcnt,	xfs_inofree_t free, int *stat);
+int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
+		xfs_lookup_t dir, int *stat);
 
 /*
  * Get the data from the pointed-to record.
  */
-extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur, xfs_agino_t *ino,
-			     __int32_t *fcnt, xfs_inofree_t *free, int *stat);
+extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
+		xfs_inobt_rec_incore_t *rec, int *stat);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/include/xfs_ialloc_btree.h b/include/xfs_ialloc_btree.h
index 37e5dd0..f782ad0 100644
--- a/include/xfs_ialloc_btree.h
+++ b/include/xfs_ialloc_btree.h
@@ -32,15 +32,14 @@ struct xfs_mount;
 #define	XFS_IBT_MAGIC	0x49414254	/* 'IABT' */
 
 typedef	__uint64_t	xfs_inofree_t;
-#define	XFS_INODES_PER_CHUNK	(NBBY * sizeof(xfs_inofree_t))
+#define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
 #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
-#define	XFS_INOBT_ALL_FREE	((xfs_inofree_t)-1)
+#define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
+#define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
 
-#define	XFS_INOBT_MASKN(i,n)		xfs_inobt_maskn(i,n)
 static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
 {
-	return (((n) >= XFS_INODES_PER_CHUNK ? \
-		(xfs_inofree_t)0 : ((xfs_inofree_t)1 << (n))) - 1) << (i);
+	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
 }
 
 /*
@@ -70,20 +69,6 @@ typedef struct xfs_inobt_key {
 typedef __be32 xfs_inobt_ptr_t;
 
 /*
- * Bit manipulations for ir_free.
- */
-#define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
-#define	XFS_INOBT_IS_FREE(rp,i)		\
-		(((rp)->ir_free & XFS_INOBT_MASK(i)) != 0)
-#define	XFS_INOBT_SET_FREE(rp,i)	((rp)->ir_free |= XFS_INOBT_MASK(i))
-#define	XFS_INOBT_CLR_FREE(rp,i)	((rp)->ir_free &= ~XFS_INOBT_MASK(i))
-
-/*
- * Maximum number of inode btree levels.
- */
-#define	XFS_IN_MAXLEVELS(mp)		((mp)->m_in_maxlevels)
-
-/*
  * block numbers in the AG.
  */
 #define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
diff --git a/include/xfs_imap.h b/include/xfs_imap.h
deleted file mode 100644
index f9ce628..0000000
--- a/include/xfs_imap.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_IMAP_H__
-#define	__XFS_IMAP_H__
-
-/*
- * This is the structure passed to xfs_imap() to map
- * an inode number to its on disk location.
- */
-typedef struct xfs_imap {
-	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
-	uint		im_len;		/* length in BBs of inode chunk */
-	xfs_agblock_t	im_agblkno;	/* logical block of inode chunk in ag */
-	ushort		im_ioffset;	/* inode offset in block in "inodes" */
-	ushort		im_boffset;	/* inode offset in block in bytes */
-} xfs_imap_t;
-
-struct xfs_mount;
-struct xfs_trans;
-int	xfs_imap(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-		 xfs_imap_t *, uint);
-
-#endif	/* __XFS_IMAP_H__ */
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 7e6fc91..ca56544 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -18,8 +18,8 @@
 #ifndef	__XFS_INODE_H__
 #define	__XFS_INODE_H__
 
+struct posix_acl;
 struct xfs_dinode;
-struct xfs_dinode_core;
 struct xfs_inode;
 
 /*
@@ -84,6 +84,16 @@ typedef struct xfs_ifork {
 } xfs_ifork_t;
 
 /*
+ * Inode location information.  Stored in the inode and passed to
+ * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
+ */
+struct xfs_imap {
+	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
+	ushort		im_len;		/* length in BBs of inode chunk */
+	ushort		im_boffset;	/* inode offset in block in bytes */
+};
+
+/*
  * This is the xfs in-core inode structure.
  * Most of the on-disk inode is embedded in the i_d field.
  *
@@ -112,8 +122,8 @@ typedef struct xfs_ictimestamp {
 } xfs_ictimestamp_t;
 
 /*
- * NOTE:  This structure must be kept identical to struct xfs_dinode_core
- * 	  in xfs_dinode.h except for the endianess annotations.
+ * NOTE:  This structure must be kept identical to struct xfs_dinode
+ * 	  in xfs_dinode.h except for the endianness annotations.
  */
 typedef struct xfs_icdinode {
 	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
@@ -159,12 +169,6 @@ typedef struct xfs_icdinode {
 #define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
 
 /*
- * Flags for xfs_itobp(), xfs_imap() and xfs_dilocate().
- */
-#define XFS_IMAP_LOOKUP		0x1
-#define XFS_IMAP_BULKSTAT	0x2
-
-/*
  * Fork handling.
  */
 
@@ -204,7 +208,6 @@ typedef struct xfs_icdinode {
 		((ip)->i_d.di_nextents = (n)) : \
 		((ip)->i_d.di_anextents = (n)))
 
-
 /*
  * Project quota id helpers (previously projid was 16bit only
  * and using two 16bit values to hold new 32bit projid was choosen
@@ -227,8 +230,6 @@ xfs_set_projid(struct xfs_icdinode *i_d,
 #ifdef __KERNEL__
 
 struct bhv_desc;
-struct cred;
-struct ktrace;
 struct xfs_buf;
 struct xfs_bmap_free;
 struct xfs_bmbt_irec;
@@ -237,41 +238,21 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot;
 
-#if defined(XFS_ILOCK_TRACE)
-#define XFS_ILOCK_KTRACE_SIZE	32
-extern ktrace_t *xfs_ilock_trace_buf;
-extern void xfs_ilock_trace(struct xfs_inode *, int, unsigned int, inst_t *);
-#else
-#define	xfs_ilock_trace(i,n,f,ra)
-#endif
-
 typedef struct dm_attrs_s {
 	__uint32_t	da_dmevmask;	/* DMIG event mask */
 	__uint16_t	da_dmstate;	/* DMIG state info */
 	__uint16_t	da_pad;		/* DMIG extra padding */
 } dm_attrs_t;
 
-typedef struct {
-	struct xfs_inode	*ip_mnext;	/* next inode in mount list */
-	struct xfs_inode	*ip_mprev;	/* ptr to prev inode */
-	struct xfs_mount	*ip_mount;	/* fs mount struct ptr */
-} xfs_iptr_t;
-
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
-	struct xfs_inode	*i_mnext;	/* next inode in mount list */
-	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	struct list_head	i_reclaim;	/* reclaim list */
-	struct inode		*i_vnode;	/* vnode backpointer */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
-	xfs_daddr_t		i_blkno;	/* blkno of inode buffer */
-	ushort			i_len;		/* len of inode buffer */
-	ushort			i_boffset;	/* off of inode in buffer */
+	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 
 	/* Extent information. */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
@@ -289,8 +270,6 @@ typedef struct xfs_inode {
 	/* Miscellaneous state. */
 	unsigned short		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */
-	unsigned char		i_update_size;	/* di_size field is dirty */
-	unsigned int		i_gen;		/* generation count */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
@@ -298,25 +277,9 @@ typedef struct xfs_inode {
 	xfs_fsize_t		i_size;		/* in-memory size */
 	xfs_fsize_t		i_new_size;	/* size when write completes */
 	atomic_t		i_iocount;	/* outstanding I/O count */
-	/* Trace buffers per inode. */
-#ifdef XFS_INODE_TRACE
-	struct ktrace		*i_trace;	/* general inode trace */
-#endif
-#ifdef XFS_BMAP_TRACE
-	struct ktrace		*i_xtrace;	/* inode extent list trace */
-#endif
-#ifdef XFS_BTREE_TRACE
-	struct ktrace		*i_btrace;	/* inode bmap btree trace */
-#endif
-#ifdef XFS_RW_TRACE
-	struct ktrace		*i_rwtrace;	/* inode read/write trace */
-#endif
-#ifdef XFS_ILOCK_TRACE
-	struct ktrace		*i_lock_trace;	/* inode lock/unlock trace */
-#endif
-#ifdef XFS_DIR2_TRACE
-	struct ktrace		*i_dir_trace;	/* inode directory trace */
-#endif
+
+	/* VFS inode */
+	struct inode		i_vnode;	/* embedded VFS inode */
 } xfs_inode_t;
 
 #define XFS_ISIZE(ip)	(((ip)->i_d.di_mode & S_IFMT) == S_IFREG) ? \
@@ -325,13 +288,13 @@ typedef struct xfs_inode {
 /* Convert from vfs inode to xfs inode */
 static inline struct xfs_inode *XFS_I(struct inode *inode)
 {
-	return (struct xfs_inode *)inode->i_private;
+	return container_of(inode, struct xfs_inode, i_vnode);
 }
 
 /* convert from xfs inode to vfs inode */
 static inline struct inode *VFS_I(struct xfs_inode *ip)
 {
-	return (struct inode *)ip->i_vnode;
+	return &ip->i_vnode;
 }
 
 /*
@@ -389,6 +352,25 @@ xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
 }
 
 /*
+ * Project quota id helpers (previously projid was 16bit only
+ * and using two 16bit values to hold new 32bit projid was choosen
+ * to retain compatibility with "old" filesystems).
+ */
+static inline prid_t
+xfs_get_projid(struct xfs_inode *ip)
+{
+	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
+}
+
+static inline void
+xfs_set_projid(struct xfs_inode *ip,
+		prid_t projid)
+{
+	ip->i_d.di_projid_hi = (__uint16_t) (projid >> 16);
+	ip->i_d.di_projid_lo = (__uint16_t) (projid & 0xffff);
+}
+
+/*
  * Manage the i_flush queue embedded in the inode.  This completion
  * queue synchronizes processes attempting to flush the in-core
  * inode back to disk.
@@ -411,17 +393,13 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 /*
  * In-core inode flags.
  */
-#define XFS_IGRIO	0x0001  /* inode used for guaranteed rate i/o */
-#define XFS_IUIOSZ	0x0002  /* inode i/o sizes have been explicitly set */
-#define XFS_IQUIESCE    0x0004  /* we have started quiescing for this inode */
-#define XFS_IRECLAIM    0x0008  /* we have started reclaiming this inode    */
-#define XFS_ISTALE	0x0010	/* inode has been staled */
-#define XFS_IRECLAIMABLE 0x0020 /* inode can be reclaimed */
-#define XFS_INEW	0x0040
-#define XFS_IFILESTREAM	0x0080	/* inode is in a filestream directory */
-#define XFS_IMODIFIED	0x0100	/* XFS inode state possibly differs */
-				/* to the Linux inode state. */
-#define XFS_ITRUNCATED	0x0200	/* truncated down so flush-on-close */
+#define XFS_IRECLAIM		0x0001  /* started reclaiming this inode */
+#define XFS_ISTALE		0x0002	/* inode has been staled */
+#define XFS_IRECLAIMABLE	0x0004	/* inode can be reclaimed */
+#define XFS_INEW		0x0008	/* inode has just been allocated */
+#define XFS_IFILESTREAM		0x0010	/* inode is in a filestream directory */
+#define XFS_ITRUNCATED		0x0020	/* truncated down so flush-on-close */
+#define XFS_IDIRTY_RELEASE	0x0040	/* dirty release already seen */
 
 /*
  * Flags for inode locking.
@@ -437,6 +415,14 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
 
+#define XFS_LOCK_FLAGS \
+	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
+	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
+	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
+	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }, \
+	{ XFS_IUNLOCK_NONOTIFY,	"IUNLOCK_NONOTIFY" }
+
+
 /*
  * Flags for lockdep annotations.
  *
@@ -470,15 +456,7 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 #define XFS_IOLOCK_DEP(flags)	(((flags) & XFS_IOLOCK_DEP_MASK) >> XFS_IOLOCK_SHIFT)
 #define XFS_ILOCK_DEP(flags)	(((flags) & XFS_ILOCK_DEP_MASK) >> XFS_ILOCK_SHIFT)
 
-/*
- * Flags for xfs_iflush()
- */
-#define	XFS_IFLUSH_DELWRI_ELSE_SYNC	1
-#define	XFS_IFLUSH_DELWRI_ELSE_ASYNC	2
-#define	XFS_IFLUSH_SYNC			3
-#define	XFS_IFLUSH_ASYNC		4
-#define	XFS_IFLUSH_DELWRI		5
-#define	XFS_IFLUSH_ASYNC_NOBLOCK	6
+extern struct lock_class_key xfs_iolock_reclaimable;
 
 /*
  * Flags for xfs_itruncate_start().
@@ -486,6 +464,10 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 #define	XFS_ITRUNC_DEFINITE	0x1
 #define	XFS_ITRUNC_MAYBE	0x2
 
+#define XFS_ITRUNC_FLAGS \
+	{ XFS_ITRUNC_DEFINITE,	"DEFINITE" }, \
+	{ XFS_ITRUNC_MAYBE,	"MAYBE" }
+
 /*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
@@ -496,22 +478,10 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 	 ((pip)->i_d.di_mode & S_ISGID))
 
 /*
- * Flags for xfs_iget()
- */
-#define XFS_IGET_CREATE		0x1
-#define XFS_IGET_BULKSTAT	0x2
-
-/*
  * xfs_iget.c prototypes.
  */
-void		xfs_ihash_init(struct xfs_mount *);
-void		xfs_ihash_free(struct xfs_mount *);
-xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
-				  struct xfs_trans *);
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-			 uint, uint, xfs_inode_t **, xfs_daddr_t);
-void		xfs_iput(xfs_inode_t *, uint);
-void		xfs_iput_new(xfs_inode_t *, uint);
+			 uint, uint, xfs_inode_t **);
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
@@ -519,18 +489,14 @@ void		xfs_ilock_demote(xfs_inode_t *, uint);
 int		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
 void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
-void		xfs_ireclaim(xfs_inode_t *);
-int		xfs_finish_reclaim(xfs_inode_t *, int, int);
-int		xfs_finish_reclaim_all(struct xfs_mount *, int);
+void		xfs_inode_free(struct xfs_inode *ip);
 
 /*
  * xfs_inode.c prototypes.
  */
-int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-			  xfs_inode_t **, xfs_daddr_t, uint);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
-			   xfs_nlink_t, xfs_dev_t, struct cred *, prid_t,
-			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
+			   xfs_nlink_t, xfs_dev_t, prid_t, int,
+			   struct xfs_buf **, boolean_t *, xfs_inode_t **);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
 uint		xfs_dic2xflags(struct xfs_dinode *);
@@ -541,31 +507,49 @@ int		xfs_itruncate_finish(struct xfs_trans **, xfs_inode_t *,
 				     xfs_fsize_t, int, int);
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 
-struct xfs_inode * xfs_inode_alloc(struct xfs_mount *, xfs_ino_t);
-void		xfs_idestroy(xfs_inode_t *);
-void		xfs_iextract(xfs_inode_t *);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
-void		xfs_ipin(xfs_inode_t *);
-void		xfs_iunpin(xfs_inode_t *);
+void		xfs_iunpin_wait(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
-void		xfs_iflush_all(struct xfs_mount *);
-void		xfs_ichgtime(xfs_inode_t *, int);
-xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
-void		xfs_synchronize_atime(xfs_inode_t *);
+void		xfs_synchronize_times(xfs_inode_t *);
+void		xfs_mark_inode_dirty(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
+#define IHOLD(ip) \
+do { \
+	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
+	ihold(VFS_I(ip)); \
+	trace_xfs_ihold(ip, _THIS_IP_); \
+} while (0)
+
+#define IRELE(ip) \
+do { \
+	trace_xfs_irele(ip, _THIS_IP_); \
+	iput(VFS_I(ip)); \
+} while (0)
+
 #endif /* __KERNEL__ */
 
+/*
+ * Flags for xfs_iget()
+ */
+#define XFS_IGET_CREATE		0x1
+#define XFS_IGET_UNTRUSTED	0x2
+
+int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
+			    xfs_ino_t, struct xfs_dinode **,
+			    struct xfs_buf **, int *, uint);
 int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, struct xfs_dinode **,
-			  struct xfs_buf **, xfs_daddr_t, uint, uint);
-void		xfs_dinode_from_disk(struct xfs_icdinode *,
-				     struct xfs_dinode_core *);
-void		xfs_dinode_to_disk(struct xfs_dinode_core *,
+			  struct xfs_buf **, uint);
+int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
+			  struct xfs_inode *, uint);
+void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
+void		xfs_dinode_from_disk(struct xfs_icdinode *,
+				     struct xfs_dinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *, int, int);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
@@ -573,17 +557,15 @@ int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, xfs_bmbt_rec_t *, int);
 
 xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
-void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
-				xfs_bmbt_irec_t *);
+void		xfs_iext_insert(struct xfs_inode *, xfs_extnum_t, xfs_extnum_t,
+				xfs_bmbt_irec_t *, int);
 void		xfs_iext_add(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_add_indirect_multi(xfs_ifork_t *, int, xfs_extnum_t, int);
-void		xfs_iext_remove(xfs_ifork_t *, xfs_extnum_t, int);
+void		xfs_iext_remove(struct xfs_inode *, xfs_extnum_t, int, int);
 void		xfs_iext_remove_inline(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_realloc_direct(xfs_ifork_t *, int);
-void		xfs_iext_realloc_indirect(xfs_ifork_t *, int);
-void		xfs_iext_indirect_to_direct(xfs_ifork_t *);
 void		xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_inline_to_direct(xfs_ifork_t *, int);
 void		xfs_iext_destroy(xfs_ifork_t *);
diff --git a/include/xfs_inode_item.h b/include/xfs_inode_item.h
index 1ff04cc..d3dee61 100644
--- a/include/xfs_inode_item.h
+++ b/include/xfs_inode_item.h
@@ -40,7 +40,6 @@ typedef struct xfs_inode_log_format {
 	__int32_t		ilf_boffset;	/* off of inode in buffer */
 } xfs_inode_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_inode_log_format_32 {
 	__uint16_t		ilf_type;	/* inode log item type */
 	__uint16_t		ilf_size;	/* size of this item */
@@ -56,7 +55,6 @@ typedef struct xfs_inode_log_format_32 {
 	__int32_t		ilf_len;	/* len of inode buffer */
 	__int32_t		ilf_boffset;	/* off of inode in buffer */
 } __attribute__((packed)) xfs_inode_log_format_32_t;
-#endif
 
 typedef struct xfs_inode_log_format_64 {
 	__uint16_t		ilf_type;	/* inode log item type */
@@ -105,26 +103,16 @@ typedef struct xfs_inode_log_format_64 {
 				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
 				 XFS_ILOG_ABROOT)
 
-#define	XFS_ILI_HOLD		0x1
-#define	XFS_ILI_IOLOCKED_EXCL	0x2
-#define	XFS_ILI_IOLOCKED_SHARED	0x4
-
-#define	XFS_ILI_IOLOCKED_ANY   (XFS_ILI_IOLOCKED_EXCL | XFS_ILI_IOLOCKED_SHARED)
-
-
-#define	XFS_ILOG_FBROOT(w)	xfs_ilog_fbroot(w)
 static inline int xfs_ilog_fbroot(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
 }
 
-#define	XFS_ILOG_FEXT(w)	xfs_ilog_fext(w)
 static inline int xfs_ilog_fext(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
 }
 
-#define	XFS_ILOG_FDATA(w)	xfs_ilog_fdata(w)
 static inline int xfs_ilog_fdata(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
@@ -133,7 +121,7 @@ static inline int xfs_ilog_fdata(int w)
 #ifdef __KERNEL__
 
 struct xfs_buf;
-struct xfs_bmbt_rec_64;
+struct xfs_bmbt_rec;
 struct xfs_inode;
 struct xfs_mount;
 
@@ -143,21 +131,13 @@ typedef struct xfs_inode_log_item {
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
-	unsigned short		ili_ilock_recur;   /* lock recursion count */
-	unsigned short		ili_iolock_recur;  /* lock recursion count */
-	unsigned short		ili_flags;	   /* misc flags */
+	unsigned short		ili_lock_flags;	   /* lock flags */
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
-	struct xfs_bmbt_rec_64	*ili_extents_buf;  /* array of logged
+	struct xfs_bmbt_rec	*ili_extents_buf;  /* array of logged
 						      data exts */
-	struct xfs_bmbt_rec_64	*ili_aextents_buf; /* array of logged
+	struct xfs_bmbt_rec	*ili_aextents_buf; /* array of logged
 						      attr exts */
-	unsigned int            ili_pushbuf_flag;  /* one bit used in push_ail */
-
-#ifdef DEBUG
-	uint64_t                ili_push_owner;    /* one who sets pushbuf_flag
-						      above gets to push the buf */
-#endif
 #ifdef XFS_TRANS_DEBUG
 	int			ili_root_size;
 	char			*ili_orig_root;
@@ -175,8 +155,8 @@ static inline int xfs_inode_clean(xfs_inode_t *ip)
 
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
-extern void xfs_iflush_done(struct xfs_buf *, xfs_inode_log_item_t *);
-extern void xfs_istale_done(struct xfs_buf *, xfs_inode_log_item_t *);
+extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
+extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
 extern void xfs_iflush_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 xfs_inode_log_format_t *);
diff --git a/include/xfs_inum.h b/include/xfs_inum.h
index 7a28191..b8e4ee4 100644
--- a/include/xfs_inum.h
+++ b/include/xfs_inum.h
@@ -72,7 +72,6 @@ struct xfs_mount;
 
 #if XFS_BIG_INUMS
 #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 56) - 1ULL))
-#define	XFS_INO64_OFFSET	((xfs_ino_t)(1ULL << 32))
 #else
 #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 32) - 1ULL))
 #endif
diff --git a/include/xfs_log.h b/include/xfs_log.h
index d47b91f..916eb7d 100644
--- a/include/xfs_log.h
+++ b/include/xfs_log.h
@@ -19,7 +19,6 @@
 #define __XFS_LOG_H__
 
 /* get lsn fields */
-
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
 
@@ -56,28 +55,18 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
 /*
  * Flags to xfs_log_reserve()
  *
- *	XFS_LOG_SLEEP:	 If space is not available, sleep (default)
- *	XFS_LOG_NOSLEEP: If space is not available, return error
  *	XFS_LOG_PERM_RESERV: Permanent reservation.  When writes are
  *		performed against this type of reservation, the reservation
  *		is not decreased.  Long running transactions should use this.
  */
-#define XFS_LOG_SLEEP		0x0
-#define XFS_LOG_NOSLEEP		0x1
 #define XFS_LOG_PERM_RESERV	0x2
 
 /*
  * Flags to xfs_log_force()
  *
  *	XFS_LOG_SYNC:	Synchronous force in-core log to disk
- *	XFS_LOG_FORCE:	Start in-core log write now.
- *	XFS_LOG_URGE:	Start write within some window of time.
- *
- * Note: Either XFS_LOG_FORCE or XFS_LOG_URGE must be set.
  */
 #define XFS_LOG_SYNC		0x1
-#define XFS_LOG_FORCE		0x2
-#define XFS_LOG_URGE		0x4
 
 #endif	/* __KERNEL__ */
 
@@ -110,15 +99,20 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
 #define XLOG_REG_TYPE_TRANSHDR		19
 #define XLOG_REG_TYPE_MAX		19
 
-#define XLOG_VEC_SET_TYPE(vecp, t) ((vecp)->i_type = (t))
-
 typedef struct xfs_log_iovec {
-	xfs_caddr_t		i_addr;		/* beginning address of region */
+	void		*i_addr;	/* beginning address of region */
 	int		i_len;		/* length in bytes of region */
 	uint		i_type;		/* type of region */
 } xfs_log_iovec_t;
 
-typedef void* xfs_log_ticket_t;
+struct xfs_log_vec {
+	struct xfs_log_vec	*lv_next;	/* next lv in build list */
+	int			lv_niovecs;	/* number of iovecs in lv */
+	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+	struct xfs_log_item	*lv_item;	/* owner */
+	char			*lv_buf;	/* formatted buffer */
+	int			lv_buf_len;	/* size of formatted buffer */
+};
 
 /*
  * Structure used to pass callback function and the function's argument
@@ -134,17 +128,33 @@ typedef struct xfs_log_callback {
 #ifdef __KERNEL__
 /* Log manager interfaces */
 struct xfs_mount;
+struct xlog_in_core;
+struct xlog_ticket;
+struct xfs_log_item;
+struct xfs_item_ops;
+struct xfs_trans;
+
+void	xfs_log_item_init(struct xfs_mount	*mp,
+			struct xfs_log_item	*item,
+			int			type,
+			struct xfs_item_ops	*ops);
+
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
-		       xfs_log_ticket_t ticket,
-		       void		**iclog,
+		       struct xlog_ticket *ticket,
+		       struct xlog_in_core **iclog,
 		       uint		flags);
 int	  _xfs_log_force(struct xfs_mount *mp,
-			 xfs_lsn_t	lsn,
 			 uint		flags,
 			 int		*log_forced);
 void	  xfs_log_force(struct xfs_mount	*mp,
-			xfs_lsn_t		lsn,
 			uint			flags);
+int	  _xfs_log_force_lsn(struct xfs_mount *mp,
+			     xfs_lsn_t		lsn,
+			     uint		flags,
+			     int		*log_forced);
+void	  xfs_log_force_lsn(struct xfs_mount	*mp,
+			    xfs_lsn_t		lsn,
+			    uint		flags);
 int	  xfs_log_mount(struct xfs_mount	*mp,
 			struct xfs_buftarg	*log_target,
 			xfs_daddr_t		start_block,
@@ -153,34 +163,38 @@ int	  xfs_log_mount_finish(struct xfs_mount *mp);
 void	  xfs_log_move_tail(struct xfs_mount	*mp,
 			    xfs_lsn_t		tail_lsn);
 int	  xfs_log_notify(struct xfs_mount	*mp,
-			 void			*iclog,
+			 struct xlog_in_core	*iclog,
 			 xfs_log_callback_t	*callback_entry);
 int	  xfs_log_release_iclog(struct xfs_mount *mp,
-			 void			 *iclog_hndl);
+			 struct xlog_in_core	 *iclog);
 int	  xfs_log_reserve(struct xfs_mount *mp,
 			  int		   length,
 			  int		   count,
-			  xfs_log_ticket_t *ticket,
+			  struct xlog_ticket **ticket,
 			  __uint8_t	   clientid,
 			  uint		   flags,
 			  uint		   t_type);
 int	  xfs_log_write(struct xfs_mount *mp,
 			xfs_log_iovec_t  region[],
 			int		 nentries,
-			xfs_log_ticket_t ticket,
+			struct xlog_ticket *ticket,
 			xfs_lsn_t	 *start_lsn);
-int	  xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_unmount_write(struct xfs_mount *mp);
-void      xfs_log_unmount_dealloc(struct xfs_mount *mp);
+void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
 int	  xfs_log_need_covered(struct xfs_mount *mp);
 
 void	  xlog_iodone(struct xfs_buf *);
 
-#endif
-
+struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
+void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
-extern int xlog_debug;		/* set to 1 to enable real log */
+xlog_tid_t xfs_log_get_trans_ident(struct xfs_trans *tp);
 
+int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
+				struct xfs_log_vec *log_vector,
+				xfs_lsn_t *commit_lsn, int flags);
+bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
+#endif
 #endif	/* __XFS_LOG_H__ */
diff --git a/include/xfs_log_priv.h b/include/xfs_log_priv.h
index e7d8f84..d5f8be8 100644
--- a/include/xfs_log_priv.h
+++ b/include/xfs_log_priv.h
@@ -19,10 +19,8 @@
 #define __XFS_LOG_PRIV_H__
 
 struct xfs_buf;
-struct ktrace;
 struct log;
 struct xlog_ticket;
-struct xfs_buf_cancel;
 struct xfs_mount;
 
 /*
@@ -55,7 +53,6 @@ struct xfs_mount;
 	BTOBB(XLOG_MAX_ICLOGS << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
 
-
 static inline xfs_lsn_t xlog_assign_lsn(uint cycle, uint block)
 {
 	return ((xfs_lsn_t)cycle << 32) | block;
@@ -134,7 +131,11 @@ static inline uint xlog_get_client_id(__be32 i)
  */
 #define XLOG_TIC_INITED		0x1	/* has been initialized */
 #define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
-#define XLOG_TIC_IN_Q		0x4
+
+#define XLOG_TIC_FLAGS \
+	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
+	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
+
 #endif	/* __KERNEL__ */
 
 #define XLOG_UNMOUNT_TYPE	0x556e	/* Un for Unmount */
@@ -147,8 +148,6 @@ static inline uint xlog_get_client_id(__be32 i)
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
 					   shutdown */
-typedef __uint32_t xlog_tid_t;
-
 
 #ifdef __KERNEL__
 /*
@@ -241,10 +240,10 @@ typedef struct xlog_res {
 } xlog_res_t;
 
 typedef struct xlog_ticket {
-	sv_t		   t_wait;	 /* ticket wait queue            : 20 */
-	struct xlog_ticket *t_next;	 /*			         :4|8 */
-	struct xlog_ticket *t_prev;	 /*				 :4|8 */
+	wait_queue_head_t  t_wait;	 /* ticket wait queue */
+	struct list_head   t_queue;	 /* reserve/write queue */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
+	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
 	char		   t_ocnt;	 /* original count		 : 1  */
@@ -309,6 +308,16 @@ typedef struct xlog_rec_ext_header {
 } xlog_rec_ext_header_t;
 
 #ifdef __KERNEL__
+
+/*
+ * Quite misnamed, because this union lays out the actual on-disk log buffer.
+ */
+typedef union xlog_in_core2 {
+	xlog_rec_header_t	hic_header;
+	xlog_rec_ext_header_t	hic_xheader;
+	char			hic_sector[XLOG_HEADER_SIZE];
+} xlog_in_core_2_t;
+
 /*
  * - A log record header is 512 bytes.  There is plenty of room to grow the
  *	xlog_rec_header_t into the reserved space.
@@ -338,9 +347,9 @@ typedef struct xlog_rec_ext_header {
  * We'll put all the read-only and l_icloglock fields in the first cacheline,
  * and move everything else out to subsequent cachelines.
  */
-typedef struct xlog_iclog_fields {
-	sv_t			ic_force_wait;
-	sv_t			ic_write_wait;
+typedef struct xlog_in_core {
+	wait_queue_head_t	ic_force_wait;
+	wait_queue_head_t	ic_write_wait;
 	struct xlog_in_core	*ic_next;
 	struct xlog_in_core	*ic_prev;
 	struct xfs_buf		*ic_bp;
@@ -348,11 +357,8 @@ typedef struct xlog_iclog_fields {
 	int			ic_size;
 	int			ic_offset;
 	int			ic_bwritecnt;
-	ushort_t		ic_state;
+	unsigned short		ic_state;
 	char			*ic_datap;	/* pointer to iclog data */
-#ifdef XFS_LOG_TRACE
-	struct ktrace		*ic_trace;
-#endif
 
 	/* Callback structures need their own cacheline */
 	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
@@ -361,39 +367,108 @@ typedef struct xlog_iclog_fields {
 
 	/* reference counts need their own cacheline */
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
-} xlog_iclog_fields_t;
+	xlog_in_core_2_t	*ic_data;
+#define ic_header	ic_data->hic_header
+} xlog_in_core_t;
 
-typedef union xlog_in_core2 {
-	xlog_rec_header_t	hic_header;
-	xlog_rec_ext_header_t	hic_xheader;
-	char			hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
+/*
+ * The CIL context is used to aggregate per-transaction details as well be
+ * passed to the iclog for checkpoint post-commit processing.  After being
+ * passed to the iclog, another context needs to be allocated for tracking the
+ * next set of transactions to be aggregated into a checkpoint.
+ */
+struct xfs_cil;
+
+struct xfs_cil_ctx {
+	struct xfs_cil		*cil;
+	xfs_lsn_t		sequence;	/* chkpt sequence # */
+	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
+	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
+	struct xlog_ticket	*ticket;	/* chkpt ticket */
+	int			nvecs;		/* number of regions */
+	int			space_used;	/* aggregate size of regions */
+	struct list_head	busy_extents;	/* busy extents in chkpt */
+	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
+	xfs_log_callback_t	log_cb;		/* completion callback hook. */
+	struct list_head	committing;	/* ctx committing list */
+};
 
-typedef struct xlog_in_core {
-	xlog_iclog_fields_t	hic_fields;
-	xlog_in_core_2_t	*hic_data;
-} xlog_in_core_t;
+/*
+ * Committed Item List structure
+ *
+ * This structure is used to track log items that have been committed but not
+ * yet written into the log. It is used only when the delayed logging mount
+ * option is enabled.
+ *
+ * This structure tracks the list of committing checkpoint contexts so
+ * we can avoid the problem of having to hold out new transactions during a
+ * flush until we have a the commit record LSN of the checkpoint. We can
+ * traverse the list of committing contexts in xlog_cil_push_lsn() to find a
+ * sequence match and extract the commit LSN directly from there. If the
+ * checkpoint is still in the process of committing, we can block waiting for
+ * the commit LSN to be determined as well. This should make synchronous
+ * operations almost as efficient as the old logging methods.
+ */
+struct xfs_cil {
+	struct log		*xc_log;
+	struct list_head	xc_cil;
+	spinlock_t		xc_cil_lock;
+	struct xfs_cil_ctx	*xc_ctx;
+	struct rw_semaphore	xc_ctx_lock;
+	struct list_head	xc_committing;
+	wait_queue_head_t	xc_commit_wait;
+	xfs_lsn_t		xc_current_sequence;
+};
 
 /*
- * Defines to save our code from this glop.
+ * The amount of log space we allow the CIL to aggregate is difficult to size.
+ * Whatever we choose, we have to make sure we can get a reservation for the
+ * log space effectively, that it is large enough to capture sufficient
+ * relogging to reduce log buffer IO significantly, but it is not too large for
+ * the log or induces too much latency when writing out through the iclogs. We
+ * track both space consumed and the number of vectors in the checkpoint
+ * context, so we need to decide which to use for limiting.
+ *
+ * Every log buffer we write out during a push needs a header reserved, which
+ * is at least one sector and more for v2 logs. Hence we need a reservation of
+ * at least 512 bytes per 32k of log space just for the LR headers. That means
+ * 16KB of reservation per megabyte of delayed logging space we will consume,
+ * plus various headers.  The number of headers will vary based on the num of
+ * io vectors, so limiting on a specific number of vectors is going to result
+ * in transactions of varying size. IOWs, it is more consistent to track and
+ * limit space consumed in the log rather than by the number of objects being
+ * logged in order to prevent checkpoint ticket overruns.
+ *
+ * Further, use of static reservations through the log grant mechanism is
+ * problematic. It introduces a lot of complexity (e.g. reserve grant vs write
+ * grant) and a significant deadlock potential because regranting write space
+ * can block on log pushes. Hence if we have to regrant log space during a log
+ * push, we can deadlock.
+ *
+ * However, we can avoid this by use of a dynamic "reservation stealing"
+ * technique during transaction commit whereby unused reservation space in the
+ * transaction ticket is transferred to the CIL ctx commit ticket to cover the
+ * space needed by the checkpoint transaction. This means that we never need to
+ * specifically reserve space for the CIL checkpoint transaction, nor do we
+ * need to regrant space once the checkpoint completes. This also means the
+ * checkpoint transaction ticket is specific to the checkpoint context, rather
+ * than the CIL itself.
+ *
+ * With dynamic reservations, we can effectively make up arbitrary limits for
+ * the checkpoint size so long as they don't violate any other size rules.
+ * Recovery imposes a rule that no transaction exceed half the log, so we are
+ * limited by that.  Furthermore, the log transaction reservation subsystem
+ * tries to keep 25% of the log free, so we need to keep below that limit or we
+ * risk running out of free log space to start any new transactions.
+ *
+ * In order to keep background CIL push efficient, we will set a lower
+ * threshold at which background pushing is attempted without blocking current
+ * transaction commits.  A separate, higher bound defines when CIL pushes are
+ * enforced to ensure we stay within our maximum checkpoint size bounds.
+ * threshold, yet give us plenty of space for aggregation on large logs.
  */
-#define	ic_force_wait	hic_fields.ic_force_wait
-#define ic_write_wait	hic_fields.ic_write_wait
-#define	ic_next		hic_fields.ic_next
-#define	ic_prev		hic_fields.ic_prev
-#define	ic_bp		hic_fields.ic_bp
-#define	ic_log		hic_fields.ic_log
-#define	ic_callback	hic_fields.ic_callback
-#define	ic_callback_lock hic_fields.ic_callback_lock
-#define	ic_callback_tail hic_fields.ic_callback_tail
-#define	ic_trace	hic_fields.ic_trace
-#define	ic_size		hic_fields.ic_size
-#define	ic_offset	hic_fields.ic_offset
-#define	ic_refcnt	hic_fields.ic_refcnt
-#define	ic_bwritecnt	hic_fields.ic_bwritecnt
-#define	ic_state	hic_fields.ic_state
-#define ic_datap	hic_fields.ic_datap
-#define ic_header	hic_data->hic_header
+#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
+#define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize >> 4))
 
 /*
  * The reservation head lsn is not made up of a cycle number and block number.
@@ -404,17 +479,17 @@ typedef struct xlog_in_core {
 typedef struct log {
 	/* The following fields don't need locking */
 	struct xfs_mount	*l_mp;	        /* mount point */
+	struct xfs_ail		*l_ailp;	/* AIL log is working with */
+	struct xfs_cil		*l_cilp;	/* CIL log is working with */
 	struct xfs_buf		*l_xbuf;        /* extra buffer for log
 						 * wrapping */
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
 	uint			l_flags;
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
-	struct xfs_buf_cancel	**l_buf_cancel_table;
+	struct list_head	*l_buf_cancel_table;
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
-	uint			l_sectbb_log;   /* log2 of sector size in BBs */
-	uint			l_sectbb_mask;  /* sector size (in BBs)
-						 * alignment mask */
+	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
 	int			l_iclog_size;	/* size of log in bytes */
 	int			l_iclog_size_log; /* log power size of log */
 	int			l_iclog_bufs;	/* number of iclog buffers */
@@ -423,33 +498,40 @@ typedef struct log {
 	int			l_logBBsize;    /* size of log in BB chunks */
 
 	/* The following block of fields are changed while holding icloglock */
-	sv_t			l_flush_wait ____cacheline_aligned_in_smp;
+	wait_queue_head_t	l_flush_wait ____cacheline_aligned_in_smp;
 						/* waiting for iclog flush */
 	int			l_covered_state;/* state of "covering disk
 						 * log entries" */
 	xlog_in_core_t		*l_iclog;       /* head log queue	*/
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
-	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
-						 * buffers */
-	xfs_lsn_t		l_last_sync_lsn;/* lsn of last LR on disk */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
 						 * block increment */
 	int			l_curr_block;   /* current logical log block */
 	int			l_prev_block;   /* previous logical log block */
 
-	/* The following block of fields are changed while holding grant_lock */
-	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
-	xlog_ticket_t		*l_reserve_headq;
-	xlog_ticket_t		*l_write_headq;
-	int			l_grant_reserve_cycle;
-	int			l_grant_reserve_bytes;
-	int			l_grant_write_cycle;
-	int			l_grant_write_bytes;
-
-#ifdef XFS_LOG_TRACE
-	struct ktrace		*l_grant_trace;
-#endif
+	/*
+	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
+	 * read without needing to hold specific locks. To avoid operations
+	 * contending with other hot objects, place each of them on a separate
+	 * cacheline.
+	 */
+	/* lsn of last LR on disk */
+	atomic64_t		l_last_sync_lsn ____cacheline_aligned_in_smp;
+	/* lsn of 1st LR with unflushed * buffers */
+	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
+
+	/*
+	 * ticket grant locks, queues and accounting have their own cachlines
+	 * as these are quite hot and can be operated on concurrently.
+	 */
+	spinlock_t		l_grant_reserve_lock ____cacheline_aligned_in_smp;
+	struct list_head	l_reserveq;
+	atomic64_t		l_grant_reserve_head;
+
+	spinlock_t		l_grant_write_lock ____cacheline_aligned_in_smp;
+	struct list_head	l_writeq;
+	atomic64_t		l_grant_write_head;
 
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
@@ -458,30 +540,108 @@ typedef struct log {
 
 } xlog_t;
 
-#define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
+#define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
+	((log)->l_buf_cancel_table + ((__uint64_t)blkno % XLOG_BC_TABLE_SIZE))
 
+#define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
 
 /* common routines */
 extern xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-extern int	 xlog_find_tail(xlog_t	*log,
-				xfs_daddr_t *head_blk,
-				xfs_daddr_t *tail_blk);
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
-extern void	 xlog_recover_process_iunlinks(xlog_t *log);
 
-extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
-extern void	 xlog_put_bp(struct xfs_buf *);
-extern int	 xlog_bread(xlog_t *, xfs_daddr_t, int, struct xfs_buf *);
+extern kmem_zone_t *xfs_log_ticket_zone;
+struct xlog_ticket *xlog_ticket_alloc(struct log *log, int unit_bytes,
+				int count, char client, uint xflags,
+				int alloc_flags);
+
 
-extern kmem_zone_t	*xfs_log_ticket_zone;
+static inline void
+xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
+{
+	*ptr += bytes;
+	*len -= bytes;
+	*off += bytes;
+}
 
-/* iclog tracing */
-#define XLOG_TRACE_GRAB_FLUSH  1
-#define XLOG_TRACE_REL_FLUSH   2
-#define XLOG_TRACE_SLEEP_FLUSH 3
-#define XLOG_TRACE_WAKE_FLUSH  4
+void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
+int	xlog_write(struct log *log, struct xfs_log_vec *log_vector,
+				struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
+				xlog_in_core_t **commit_iclog, uint flags);
+
+/*
+ * When we crack an atomic LSN, we sample it first so that the value will not
+ * change while we are cracking it into the component values. This means we
+ * will always get consistent component values to work from. This should always
+ * be used to smaple and crack LSNs taht are stored and updated in atomic
+ * variables.
+ */
+static inline void
+xlog_crack_atomic_lsn(atomic64_t *lsn, uint *cycle, uint *block)
+{
+	xfs_lsn_t val = atomic64_read(lsn);
+
+	*cycle = CYCLE_LSN(val);
+	*block = BLOCK_LSN(val);
+}
+
+/*
+ * Calculate and assign a value to an atomic LSN variable from component pieces.
+ */
+static inline void
+xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
+{
+	atomic64_set(lsn, xlog_assign_lsn(cycle, block));
+}
+
+/*
+ * When we crack the grant head, we sample it first so that the value will not
+ * change while we are cracking it into the component values. This means we
+ * will always get consistent component values to work from.
+ */
+static inline void
+xlog_crack_grant_head_val(int64_t val, int *cycle, int *space)
+{
+	*cycle = val >> 32;
+	*space = val & 0xffffffff;
+}
+
+static inline void
+xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
+{
+	xlog_crack_grant_head_val(atomic64_read(head), cycle, space);
+}
+
+static inline int64_t
+xlog_assign_grant_head_val(int cycle, int space)
+{
+	return ((int64_t)cycle << 32) | space;
+}
+
+static inline void
+xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
+{
+	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
+}
+
+/*
+ * Committed Item List interfaces
+ */
+int	xlog_cil_init(struct log *log);
+void	xlog_cil_init_post_recovery(struct log *log);
+void	xlog_cil_destroy(struct log *log);
+
+/*
+ * CIL force routines
+ */
+xfs_lsn_t xlog_cil_force_lsn(struct log *log, xfs_lsn_t sequence);
+
+static inline void
+xlog_cil_force(struct log *log)
+{
+	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
+}
 
 /*
  * Unmount record type is used as a pseudo transaction type for the ticket.
@@ -489,6 +649,21 @@ extern kmem_zone_t	*xfs_log_ticket_zone;
  */
 #define XLOG_UNMOUNT_REC_TYPE	(-1U)
 
+/*
+ * Wrapper function for waiting on a wait queue serialised against wakeups
+ * by a spinlock. This matches the semantics of all the wait queues used in the
+ * log code.
+ */
+static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	add_wait_queue_exclusive(wq, &wait);
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	spin_unlock(lock);
+	schedule();
+	remove_wait_queue(wq, &wait);
+}
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/include/xfs_log_recover.h b/include/xfs_log_recover.h
index b225455..1c55ccb 100644
--- a/include/xfs_log_recover.h
+++ b/include/xfs_log_recover.h
@@ -28,29 +28,28 @@
 #define XLOG_RHASH(tid)	\
 	((((__uint32_t)tid)>>XLOG_RHASH_SHIFT) & (XLOG_RHASH_SIZE-1))
 
-#define XLOG_MAX_REGIONS_IN_ITEM   (XFS_MAX_BLOCKSIZE / XFS_BLI_CHUNK / 2 + 1)
+#define XLOG_MAX_REGIONS_IN_ITEM   (XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK / 2 + 1)
 
 
 /*
  * item headers are in ri_buf[0].  Additional buffers follow.
  */
 typedef struct xlog_recover_item {
-	struct xlog_recover_item *ri_next;
-	struct xlog_recover_item *ri_prev;
-	int			 ri_type;
-	int			 ri_cnt;	/* count of regions found */
-	int			 ri_total;	/* total regions */
-	xfs_log_iovec_t		 *ri_buf;	/* ptr to regions buffer */
+	struct list_head	ri_list;
+	int			ri_type;
+	int			ri_cnt;	/* count of regions found */
+	int			ri_total;	/* total regions */
+	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
 } xlog_recover_item_t;
 
 struct xlog_tid;
 typedef struct xlog_recover {
-	struct xlog_recover *r_next;
-	xlog_tid_t	    r_log_tid;		/* log's transaction id */
-	xfs_trans_header_t  r_theader;		/* trans header for partial */
-	int		    r_state;		/* not needed */
-	xfs_lsn_t	    r_lsn;		/* xact lsn */
-	xlog_recover_item_t *r_itemq;		/* q for items */
+	struct hlist_node	r_list;
+	xlog_tid_t		r_log_tid;	/* log's transaction id */
+	xfs_trans_header_t	r_theader;	/* trans header for partial */
+	int			r_state;	/* not needed */
+	xfs_lsn_t		r_lsn;		/* xact lsn */
+	struct list_head	r_itemq;	/* q for items */
 } xlog_recover_t;
 
 #define ITEM_TYPE(i)	(*(ushort *)(i)->ri_buf[0].i_addr)
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index ff200d1..94a02e1 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -18,7 +18,6 @@
 #ifndef __XFS_MOUNT_H__
 #define	__XFS_MOUNT_H__
 
-
 typedef struct xfs_trans_reservations {
 	uint	tr_write;	/* extent alloc trans */
 	uint	tr_itruncate;	/* truncate trans */
@@ -45,14 +44,15 @@ typedef struct xfs_trans_reservations {
 
 #ifndef __KERNEL__
 
-#define XFS_DADDR_TO_AGNO(mp,d) \
+#define xfs_daddr_to_agno(mp,d) \
 	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
-#define XFS_DADDR_TO_AGBNO(mp,d) \
+#define xfs_daddr_to_agbno(mp,d) \
 	((xfs_agblock_t)(XFS_BB_TO_FSBT(mp, d) % (mp)->m_sb.sb_agblocks))
 
 #else /* __KERNEL__ */
 
-struct cred;
+#include "xfs_sync.h"
+
 struct log;
 struct xfs_mount_args;
 struct xfs_inode;
@@ -62,133 +62,9 @@ struct xfs_extdelta;
 struct xfs_swapext;
 struct xfs_mru_cache;
 struct xfs_nameops;
-
-/*
- * Prototypes and functions for the Data Migration subsystem.
- */
-
-typedef int	(*xfs_send_data_t)(int, struct xfs_inode *,
-			xfs_off_t, size_t, int, int *);
-typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
-typedef int	(*xfs_send_destroy_t)(struct xfs_inode *, dm_right_t);
-typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
-			struct xfs_inode *, dm_right_t,
-			struct xfs_inode *, dm_right_t,
-			const char *, const char *, mode_t, int, int);
-typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
-			char *, char *);
-typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, struct xfs_inode *,
-			dm_right_t, mode_t, int, int);
-
-typedef struct xfs_dmops {
-	xfs_send_data_t		xfs_send_data;
-	xfs_send_mmap_t		xfs_send_mmap;
-	xfs_send_destroy_t	xfs_send_destroy;
-	xfs_send_namesp_t	xfs_send_namesp;
-	xfs_send_mount_t	xfs_send_mount;
-	xfs_send_unmount_t	xfs_send_unmount;
-} xfs_dmops_t;
-
-#define XFS_SEND_DATA(mp, ev,ip,off,len,fl,lock) \
-	(*(mp)->m_dm_ops->xfs_send_data)(ev,ip,off,len,fl,lock)
-#define XFS_SEND_MMAP(mp, vma,fl) \
-	(*(mp)->m_dm_ops->xfs_send_mmap)(vma,fl)
-#define XFS_SEND_DESTROY(mp, ip,right) \
-	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
-#define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
-#define XFS_SEND_PREUNMOUNT(mp,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT,mp,b1,r1,b2,r2,n1,n2,mode,rval,fl)
-#define XFS_SEND_MOUNT(mp,right,path,name) \
-	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
-#define XFS_SEND_UNMOUNT(mp, ip,right,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_unmount)(mp,ip,right,mode,rval,fl)
-
-
-/*
- * Prototypes and functions for the Quota Management subsystem.
- */
-
-struct xfs_dquot;
-struct xfs_dqtrxops;
+struct xfs_ail;
 struct xfs_quotainfo;
 
-typedef int	(*xfs_qminit_t)(struct xfs_mount *, uint *, uint *);
-typedef int	(*xfs_qmmount_t)(struct xfs_mount *, uint, uint);
-typedef int	(*xfs_qmunmount_t)(struct xfs_mount *);
-typedef void	(*xfs_qmdone_t)(struct xfs_mount *);
-typedef void	(*xfs_dqrele_t)(struct xfs_dquot *);
-typedef int	(*xfs_dqattach_t)(struct xfs_inode *, uint);
-typedef void	(*xfs_dqdetach_t)(struct xfs_inode *);
-typedef int	(*xfs_dqpurgeall_t)(struct xfs_mount *, uint);
-typedef int	(*xfs_dqvopalloc_t)(struct xfs_mount *,
-			struct xfs_inode *, uid_t, gid_t, prid_t, uint,
-			struct xfs_dquot **, struct xfs_dquot **);
-typedef void	(*xfs_dqvopcreate_t)(struct xfs_trans *, struct xfs_inode *,
-			struct xfs_dquot *, struct xfs_dquot *);
-typedef int	(*xfs_dqvoprename_t)(struct xfs_inode **);
-typedef struct xfs_dquot * (*xfs_dqvopchown_t)(
-			struct xfs_trans *, struct xfs_inode *,
-			struct xfs_dquot **, struct xfs_dquot *);
-typedef int	(*xfs_dqvopchownresv_t)(struct xfs_trans *, struct xfs_inode *,
-			struct xfs_dquot *, struct xfs_dquot *, uint);
-typedef void	(*xfs_dqstatvfs_t)(struct xfs_inode *, bhv_statvfs_t *);
-typedef int	(*xfs_dqsync_t)(struct xfs_mount *, int flags);
-typedef int	(*xfs_quotactl_t)(struct xfs_mount *, int, int, xfs_caddr_t);
-
-typedef struct xfs_qmops {
-	xfs_qminit_t		xfs_qminit;
-	xfs_qmdone_t		xfs_qmdone;
-	xfs_qmmount_t		xfs_qmmount;
-	xfs_qmunmount_t		xfs_qmunmount;
-	xfs_dqrele_t		xfs_dqrele;
-	xfs_dqattach_t		xfs_dqattach;
-	xfs_dqdetach_t		xfs_dqdetach;
-	xfs_dqpurgeall_t	xfs_dqpurgeall;
-	xfs_dqvopalloc_t	xfs_dqvopalloc;
-	xfs_dqvopcreate_t	xfs_dqvopcreate;
-	xfs_dqvoprename_t	xfs_dqvoprename;
-	xfs_dqvopchown_t	xfs_dqvopchown;
-	xfs_dqvopchownresv_t	xfs_dqvopchownresv;
-	xfs_dqstatvfs_t		xfs_dqstatvfs;
-	xfs_dqsync_t		xfs_dqsync;
-	xfs_quotactl_t		xfs_quotactl;
-	struct xfs_dqtrxops	*xfs_dqtrxops;
-} xfs_qmops_t;
-
-#define XFS_QM_INIT(mp, mnt, fl) \
-	(*(mp)->m_qm_ops->xfs_qminit)(mp, mnt, fl)
-#define XFS_QM_MOUNT(mp, mnt, fl) \
-	(*(mp)->m_qm_ops->xfs_qmmount)(mp, mnt, fl)
-#define XFS_QM_UNMOUNT(mp) \
-	(*(mp)->m_qm_ops->xfs_qmunmount)(mp)
-#define XFS_QM_DONE(mp) \
-	(*(mp)->m_qm_ops->xfs_qmdone)(mp)
-#define XFS_QM_DQRELE(mp, dq) \
-	(*(mp)->m_qm_ops->xfs_dqrele)(dq)
-#define XFS_QM_DQATTACH(mp, ip, fl) \
-	(*(mp)->m_qm_ops->xfs_dqattach)(ip, fl)
-#define XFS_QM_DQDETACH(mp, ip) \
-	(*(mp)->m_qm_ops->xfs_dqdetach)(ip)
-#define XFS_QM_DQPURGEALL(mp, fl) \
-	(*(mp)->m_qm_ops->xfs_dqpurgeall)(mp, fl)
-#define XFS_QM_DQVOPALLOC(mp, ip, uid, gid, prid, fl, dq1, dq2) \
-	(*(mp)->m_qm_ops->xfs_dqvopalloc)(mp, ip, uid, gid, prid, fl, dq1, dq2)
-#define XFS_QM_DQVOPCREATE(mp, tp, ip, dq1, dq2) \
-	(*(mp)->m_qm_ops->xfs_dqvopcreate)(tp, ip, dq1, dq2)
-#define XFS_QM_DQVOPRENAME(mp, ip) \
-	(*(mp)->m_qm_ops->xfs_dqvoprename)(ip)
-#define XFS_QM_DQVOPCHOWN(mp, tp, ip, dqp, dq) \
-	(*(mp)->m_qm_ops->xfs_dqvopchown)(tp, ip, dqp, dq)
-#define XFS_QM_DQVOPCHOWNRESV(mp, tp, ip, dq1, dq2, fl) \
-	(*(mp)->m_qm_ops->xfs_dqvopchownresv)(tp, ip, dq1, dq2, fl)
-#define XFS_QM_DQSTATVFS(ip, statp) \
-	(*(ip)->i_mount->m_qm_ops->xfs_dqstatvfs)(ip, statp)
-#define XFS_QM_DQSYNC(mp, flags) \
-	(*(mp)->m_qm_ops->xfs_dqsync)(mp, flags)
-#define XFS_QM_QUOTACTL(mp, cmd, id, addr) \
-	(*(mp)->m_qm_ops->xfs_quotactl)(mp, cmd, id, addr)
-
 #ifdef HAVE_PERCPU_SB
 
 /*
@@ -214,6 +90,8 @@ extern void	xfs_icsb_reinit_counters(struct xfs_mount *);
 extern void	xfs_icsb_destroy_counters(struct xfs_mount *);
 extern void	xfs_icsb_sync_counters(struct xfs_mount *, int);
 extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
+extern int	xfs_icsb_modify_counters(struct xfs_mount *, xfs_sb_field_t,
+						int64_t, int);
 
 #else
 #define xfs_icsb_init_counters(mp)		(0)
@@ -221,20 +99,24 @@ extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
 #define xfs_icsb_reinit_counters(mp)		do { } while (0)
 #define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
 #define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
+#define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
+	xfs_mod_incore_sb(mp, field, delta, rsvd)
 #endif
 
-typedef struct xfs_ail {
-	struct list_head	xa_ail;
-	uint			xa_gen;
-	struct task_struct	*xa_task;
-	xfs_lsn_t		xa_target;
-} xfs_ail_t;
+/* dynamic preallocation free space thresholds, 5% down to 1% */
+enum {
+	XFS_LOWSP_1_PCNT = 0,
+	XFS_LOWSP_2_PCNT,
+	XFS_LOWSP_3_PCNT,
+	XFS_LOWSP_4_PCNT,
+	XFS_LOWSP_5_PCNT,
+	XFS_LOWSP_MAX,
+};
 
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
-	spinlock_t		m_ail_lock;	/* fs AIL mutex */
-	xfs_ail_t		m_ail;		/* fs active log item list */
+	struct xfs_ail		*m_ail;		/* fs active log item list */
 	xfs_sb_t		m_sb;		/* copy of fs superblock */
 	spinlock_t		m_sb_lock;	/* sb counter lock */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
@@ -247,10 +129,6 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	struct xfs_inode	*m_inodes;	/* active inode list */
-	struct list_head	m_del_inodes;	/* inodes to reclaim */
-	mutex_t			m_ilock;	/* inode list mutex */
-	uint			m_ireclaims;	/* count of calls to reclaim*/
 	uint			m_readio_log;	/* min read size log bytes */
 	uint			m_readio_blocks; /* min read size blocks */
 	uint			m_writeio_log;	/* min write size log bytes */
@@ -283,19 +161,17 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* min inobt btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
-	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
-	struct xfs_perag	*m_perag;	/* per-ag accounting info */
-	struct rw_semaphore	m_peraglock;	/* lock for m_perag (pointer) */
+	uint			m_in_maxlevels;	/* max inobt btree levels. */
+	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
+	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_dmevmask;	/* DMI events for this FS */
 	__uint64_t		m_flags;	/* global mount flags */
-	uint			m_attroffset;	/* inode attribute offset */
 	uint			m_dir_node_ents; /* #entries in a dir danode */
 	uint			m_attr_node_ents; /* #entries in attr danode */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
-	int			m_litino;	/* size of inode union area */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
 	uint			m_qflags;	/* quota status flags */
 	xfs_trans_reservations_t m_reservations;/* precomputed res values */
@@ -303,17 +179,12 @@ typedef struct xfs_mount {
 	__uint64_t		m_maxioffset;	/* maximum inode offset */
 	__uint64_t		m_resblks;	/* total reserved blocks */
 	__uint64_t		m_resblks_avail;/* available reserved blocks */
-#if XFS_BIG_INUMS
-	xfs_ino_t		m_inoadd;	/* add value for ino64_offset */
-#endif
+	__uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
 	int			m_sinoalign;	/* stripe unit inode alignment */
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
-	__uint8_t		m_mk_sharedro;	/* mark shared ro on unmount */
-	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes.
-						   field governed by m_ilock */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
@@ -324,23 +195,25 @@ typedef struct xfs_mount {
 	uint			m_chsize;	/* size of next field */
 	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
 						 * hash table */
-	struct xfs_dmops	*m_dm_ops;	/* vector of DMI ops */
-	struct xfs_qmops	*m_qm_ops;	/* vector of XQM ops */
 	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB
-	xfs_icsb_cnts_t		*m_sb_cnts;	/* per-cpu superblock counters */
+	xfs_icsb_cnts_t __percpu *m_sb_cnts;	/* per-cpu superblock counters */
 	unsigned long		m_icsb_counters; /* disabled per-cpu counters */
 	struct notifier_block	m_icsb_notifier; /* hotplug cpu notifier */
 	struct mutex		m_icsb_mutex;	/* balancer sync lock */
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct task_struct	*m_sync_task;	/* generalised sync thread */
-	bhv_vfs_sync_work_t	m_sync_work;	/* work item for VFS_SYNC */
+	xfs_sync_work_t		m_sync_work;	/* work item for VFS_SYNC */
 	struct list_head	m_sync_list;	/* sync thread work item list */
 	spinlock_t		m_sync_lock;	/* work item list lock */
 	int			m_sync_seq;	/* sync thread generation no. */
 	wait_queue_head_t	m_wait_single_sync_task;
-	struct vfsmount		*m_vfsmount;
+	__int64_t		m_update_flags;	/* sb flags we need to update
+						   on the next remount,rw */
+	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
+	int64_t			m_low_space[XFS_LOWSP_MAX];
+						/* low free space thresholds */
 } xfs_mount_t;
 
 /*
@@ -349,8 +222,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
-#define XFS_MOUNT_INO64		(1ULL << 1)
-#define XFS_MOUNT_DMAPI		(1ULL << 2)	/* dmapi is enabled */
+#define XFS_MOUNT_DELAYLOG	(1ULL << 1)	/* delayed logging is enabled */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
@@ -362,10 +234,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
 #define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
 #define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
-#define XFS_MOUNT_SHARED	(1ULL << 11)	/* shared mount */
 #define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
-#define XFS_MOUNT_OSYNCISOSYNC	(1ULL << 13)	/* o_sync is REALLY o_sync */
-						/* osyncisdsync is now default*/
 #define XFS_MOUNT_32BITINODES	(1ULL << 14)	/* do not create inodes above
 						 * 32 bits in size */
 #define XFS_MOUNT_SMALL_INUMS	(1ULL << 15)	/* users wants 32bit inodes */
@@ -378,8 +247,6 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
 #define XFS_MOUNT_COMPAT_IOSIZE	(1ULL << 22)	/* don't report large preferred
 						 * I/O size in stat() */
-#define XFS_MOUNT_NO_PERCPU_SB	(1ULL << 23)	/* don't use per-cpu superblock
-						   counters */
 #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
 						   allocator */
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
@@ -402,8 +269,8 @@ typedef struct xfs_mount {
  * Synchronous read and write sizes.  This should be
  * better for NFSv2 wsync filesystems.
  */
-#define	XFS_WSYNC_READIO_LOG	15	/* 32K */
-#define	XFS_WSYNC_WRITEIO_LOG	14	/* 16K */
+#define	XFS_WSYNC_READIO_LOG	15	/* 32k */
+#define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
 
 /*
  * Allow large block sizes to be reported to userspace programs if the
@@ -439,12 +306,21 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 #define xfs_force_shutdown(m,f)	\
 	xfs_do_force_shutdown(m, f, __FILE__, __LINE__)
 
+#define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
+#define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
+#define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
+#define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
+#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
+#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
+
+#define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)
+#define xfs_wait_for_freeze(mp,l)	vfs_check_frozen((mp)->m_super, (l))
+
 /*
  * Flags for xfs_mountfs
  */
 #define XFS_MFSI_QUIET		0x40	/* Be silent if mount errors found */
 
-#define XFS_DADDR_TO_AGNO(mp,d)         xfs_daddr_to_agno(mp,d)
 static inline xfs_agnumber_t
 xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
 {
@@ -453,7 +329,6 @@ xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
 	return (xfs_agnumber_t) ld;
 }
 
-#define XFS_DADDR_TO_AGBNO(mp,d)        xfs_daddr_to_agbno(mp,d)
 static inline xfs_agblock_t
 xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 {
@@ -462,31 +337,16 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 /*
- * perag get/put wrappers for eventual ref counting
- */
-static inline xfs_perag_t *
-xfs_get_perag(struct xfs_mount *mp, xfs_ino_t ino)
-{
-	return &mp->m_perag[XFS_INO_TO_AGNO(mp, ino)];
-}
-
-static inline void
-xfs_put_perag(struct xfs_mount *mp, xfs_perag_t *pag)
-{
-	/* nothing to see here, move along */
-}
-
-/*
  * Per-cpu superblock locking functions
  */
 #ifdef HAVE_PERCPU_SB
-STATIC_INLINE void
+static inline void
 xfs_icsb_lock(xfs_mount_t *mp)
 {
 	mutex_lock(&mp->m_icsb_mutex);
 }
 
-STATIC_INLINE void
+static inline void
 xfs_icsb_unlock(xfs_mount_t *mp)
 {
 	mutex_unlock(&mp->m_icsb_mutex);
@@ -505,40 +365,39 @@ typedef struct xfs_mod_sb {
 	int64_t		msb_delta;	/* Change to make to specified field */
 } xfs_mod_sb_t;
 
-#define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock))
-#define	XFS_MOUNT_IUNLOCK(mp)	mutex_unlock(&((mp)->m_ilock))
-
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
+extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
-extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
 
 extern void	xfs_unmountfs(xfs_mount_t *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
-extern int	xfs_unmount_flush(xfs_mount_t *, int);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
-extern int	xfs_mod_incore_sb_unlocked(xfs_mount_t *, xfs_sb_field_t,
-			int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);
+extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern int	xfs_fs_writable(xfs_mount_t *);
-extern int	xfs_syncsub(xfs_mount_t *, int, int *);
-extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
-extern int	xfs_dmops_get(struct xfs_mount *, struct xfs_mount_args *);
-extern void	xfs_dmops_put(struct xfs_mount *);
-extern int	xfs_qmops_get(struct xfs_mount *, struct xfs_mount_args *);
-extern void	xfs_qmops_put(struct xfs_mount *);
+extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
-extern struct xfs_dmops xfs_dmcore_xfs;
+extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
 #endif	/* __KERNEL__ */
 
+/*
+ * perag get/put wrappers for ref counting
+ */
+struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
+struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
+					int tag);
+void	xfs_perag_put(struct xfs_perag *pag);
+
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
-extern xfs_agnumber_t	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t);
+extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
+					xfs_agnumber_t *);
 extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 
diff --git a/include/xfs_quota.h b/include/xfs_quota.h
index 12c4ec7..5d1f57d 100644
--- a/include/xfs_quota.h
+++ b/include/xfs_quota.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_QUOTA_H__
 #define __XFS_QUOTA_H__
 
+struct xfs_trans;
+
 /*
  * The ondisk form of a dquot structure.
  */
@@ -84,14 +86,20 @@ typedef struct xfs_dqblk {
 #define XFS_DQ_USER		0x0001		/* a user quota */
 #define XFS_DQ_PROJ		0x0002		/* project quota */
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
-#define XFS_DQ_FLOCKED		0x0008		/* flush lock taken */
-#define XFS_DQ_DIRTY		0x0010		/* dquot is dirty */
-#define XFS_DQ_WANT		0x0020		/* for lookup/reclaim race */
-#define XFS_DQ_INACTIVE		0x0040		/* dq off mplist & hashlist */
-#define XFS_DQ_MARKER		0x0080		/* sentinel */
+#define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
+#define XFS_DQ_WANT		0x0010		/* for lookup/reclaim race */
+#define XFS_DQ_INACTIVE		0x0020		/* dq off mplist & hashlist */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
+#define XFS_DQ_FLAGS \
+	{ XFS_DQ_USER,		"USER" }, \
+	{ XFS_DQ_PROJ,		"PROJ" }, \
+	{ XFS_DQ_GROUP,		"GROUP" }, \
+	{ XFS_DQ_DIRTY,		"DIRTY" }, \
+	{ XFS_DQ_WANT,		"WANT" }, \
+	{ XFS_DQ_INACTIVE,	"INACTIVE" }
+
 /*
  * In the worst case, when both user and group quotas are on,
  * we can have a max of three dquots changing in a single transaction.
@@ -187,18 +195,13 @@ typedef struct xfs_qoff_logformat {
  * to a single function. None of these XFS_QMOPT_* flags are meant to have
  * persistent values (ie. their values can and will change between versions)
  */
-#define XFS_QMOPT_DQLOCK	0x0000001 /* dqlock */
 #define XFS_QMOPT_DQALLOC	0x0000002 /* alloc dquot ondisk if needed */
 #define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
 #define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
 #define XFS_QMOPT_DQSUSER	0x0000020 /* don't cache super users dquot */
 #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
-#define XFS_QMOPT_QUOTAOFF	0x0000080 /* quotas are being turned off */
-#define XFS_QMOPT_UMOUNTING	0x0000100 /* filesys is being unmounted */
-#define XFS_QMOPT_DOLOG		0x0000200 /* log buf changes (in quotacheck) */
 #define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
-#define XFS_QMOPT_ILOCKED	0x0000800 /* inode is already locked (excl) */
 #define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
 #define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
@@ -217,16 +220,9 @@ typedef struct xfs_qoff_logformat {
 #define XFS_QMOPT_RES_INOS	0x0800000
 
 /*
- * flags for dqflush and dqflush_all.
- */
-#define XFS_QMOPT_SYNC		0x1000000
-#define XFS_QMOPT_ASYNC		0x2000000
-#define XFS_QMOPT_DELWRI	0x4000000
-
-/*
  * flags for dqalloc.
  */
-#define XFS_QMOPT_INHERIT	0x8000000
+#define XFS_QMOPT_INHERIT	0x1000000
 
 /*
  * flags to xfs_trans_mod_dquot.
@@ -303,69 +299,77 @@ typedef struct xfs_dqtrx {
 	long		qt_delrtb_delta;  /* delayed RT blk count changes */
 } xfs_dqtrx_t;
 
-/*
- * Dquot transaction functions, used if quota is enabled.
- */
-typedef void	(*qo_dup_dqinfo_t)(struct xfs_trans *, struct xfs_trans *);
-typedef void	(*qo_mod_dquot_byino_t)(struct xfs_trans *,
-				struct xfs_inode *, uint, long);
-typedef void	(*qo_free_dqinfo_t)(struct xfs_trans *);
-typedef void	(*qo_apply_dquot_deltas_t)(struct xfs_trans *);
-typedef void	(*qo_unreserve_and_mod_dquots_t)(struct xfs_trans *);
-typedef int	(*qo_reserve_quota_nblks_t)(
-				struct xfs_trans *, struct xfs_mount *,
-				struct xfs_inode *, long, long, uint);
-typedef int	(*qo_reserve_quota_bydquots_t)(
-				struct xfs_trans *, struct xfs_mount *,
-				struct xfs_dquot *, struct xfs_dquot *,
-				long, long, uint);
-typedef struct xfs_dqtrxops {
-	qo_dup_dqinfo_t			qo_dup_dqinfo;
-	qo_free_dqinfo_t		qo_free_dqinfo;
-	qo_mod_dquot_byino_t		qo_mod_dquot_byino;
-	qo_apply_dquot_deltas_t		qo_apply_dquot_deltas;
-	qo_reserve_quota_nblks_t	qo_reserve_quota_nblks;
-	qo_reserve_quota_bydquots_t	qo_reserve_quota_bydquots;
-	qo_unreserve_and_mod_dquots_t	qo_unreserve_and_mod_dquots;
-} xfs_dqtrxops_t;
-
-#define XFS_DQTRXOP(mp, tp, op, args...) \
-		((mp)->m_qm_ops->xfs_dqtrxops ? \
-		((mp)->m_qm_ops->xfs_dqtrxops->op)(tp, ## args) : 0)
-
-#define XFS_DQTRXOP_VOID(mp, tp, op, args...) \
-		((mp)->m_qm_ops->xfs_dqtrxops ? \
-		((mp)->m_qm_ops->xfs_dqtrxops->op)(tp, ## args) : (void)0)
-
-#define XFS_TRANS_DUP_DQINFO(mp, otp, ntp) \
-	XFS_DQTRXOP_VOID(mp, otp, qo_dup_dqinfo, ntp)
-#define XFS_TRANS_FREE_DQINFO(mp, tp) \
-	XFS_DQTRXOP_VOID(mp, tp, qo_free_dqinfo)
-#define XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, field, delta) \
-	XFS_DQTRXOP_VOID(mp, tp, qo_mod_dquot_byino, ip, field, delta)
-#define XFS_TRANS_APPLY_DQUOT_DELTAS(mp, tp) \
-	XFS_DQTRXOP_VOID(mp, tp, qo_apply_dquot_deltas)
-#define XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, nblks, ninos, fl) \
-	XFS_DQTRXOP(mp, tp, qo_reserve_quota_nblks, mp, ip, nblks, ninos, fl)
-#define XFS_TRANS_RESERVE_QUOTA_BYDQUOTS(mp, tp, ud, gd, nb, ni, fl) \
-	XFS_DQTRXOP(mp, tp, qo_reserve_quota_bydquots, mp, ud, gd, nb, ni, fl)
-#define XFS_TRANS_UNRESERVE_AND_MOD_DQUOTS(mp, tp) \
-	XFS_DQTRXOP_VOID(mp, tp, qo_unreserve_and_mod_dquots)
-
-#define XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp, tp, ip, nblks, ninos, flags) \
-	XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, -(nblks), -(ninos), flags)
-#define XFS_TRANS_RESERVE_QUOTA(mp, tp, ud, gd, nb, ni, f) \
-	XFS_TRANS_RESERVE_QUOTA_BYDQUOTS(mp, tp, ud, gd, nb, ni, \
-				f | XFS_QMOPT_RES_REGBLKS)
-#define XFS_TRANS_UNRESERVE_QUOTA(mp, tp, ud, gd, nb, ni, f) \
-	XFS_TRANS_RESERVE_QUOTA_BYDQUOTS(mp, tp, ud, gd, -(nb), -(ni), \
-				f | XFS_QMOPT_RES_REGBLKS)
-
 extern int xfs_qm_dqcheck(xfs_disk_dquot_t *, xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
-extern struct xfs_qmops xfs_qmcore_xfs;
-
 #endif	/* __KERNEL__ */
 
+#ifdef CONFIG_XFS_QUOTA
+extern void xfs_trans_dup_dqinfo(struct xfs_trans *, struct xfs_trans *);
+extern void xfs_trans_free_dqinfo(struct xfs_trans *);
+extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
+		uint, long);
+extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
+extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
+extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
+		struct xfs_inode *, long, long, uint);
+extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
+		struct xfs_mount *, struct xfs_dquot *,
+		struct xfs_dquot *, long, long, uint);
+
+extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
+		struct xfs_dquot **, struct xfs_dquot **);
+extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
+		struct xfs_dquot *, struct xfs_dquot *);
+extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
+extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
+		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
+extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
+		struct xfs_dquot *, struct xfs_dquot *, uint);
+extern int xfs_qm_dqattach(struct xfs_inode *, uint);
+extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
+extern void xfs_qm_dqdetach(struct xfs_inode *);
+extern void xfs_qm_dqrele(struct xfs_dquot *);
+extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
+extern int xfs_qm_sync(struct xfs_mount *, int);
+extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
+extern void xfs_qm_mount_quotas(struct xfs_mount *);
+extern void xfs_qm_unmount(struct xfs_mount *);
+extern void xfs_qm_unmount_quotas(struct xfs_mount *);
+
+#else
+#define xfs_qm_vop_dqalloc(ip, uid, gid, prid, flags, udqp, gdqp) 	({ \
+	*(udqp) = NULL;		\
+	*(gdqp) = NULL;		\
+	0;			\
+})
+#define xfs_trans_dup_dqinfo(tp, tp2)
+#define xfs_trans_free_dqinfo(tp)
+#define xfs_trans_mod_dquot_byino(tp, ip, fields, delta)
+#define xfs_trans_apply_dquot_deltas(tp)
+#define xfs_trans_unreserve_and_mod_dquots(tp)
+#define xfs_trans_reserve_quota_nblks(tp, ip, blks, inos, flg)		(0)
+#define xfs_trans_reserve_quota_bydquots(tp, mp, uqp, gqp, blks, inos, flg) (0)
+#define xfs_qm_vop_create_dqattach(tp, ip, u, g)
+#define xfs_qm_vop_rename_dqattach(it)					(0)
+#define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
+#define xfs_qm_vop_chown_reserve(tp, ip, u, g, fl)			(0)
+#define xfs_qm_dqattach(ip, fl)						(0)
+#define xfs_qm_dqattach_locked(ip, fl)					(0)
+#define xfs_qm_dqdetach(ip)
+#define xfs_qm_dqrele(d)
+#define xfs_qm_statvfs(ip, s)
+#define xfs_qm_sync(mp, flags)						(0)
+#define xfs_qm_newmount(mp, a, b)					(0)
+#define xfs_qm_mount_quotas(mp)
+#define xfs_qm_unmount(mp)
+#define xfs_qm_unmount_quotas(mp)
+#endif /* CONFIG_XFS_QUOTA */
+
+#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
+	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
+#define xfs_trans_reserve_quota(tp, mp, ud, gd, nb, ni, f) \
+	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
+				f | XFS_QMOPT_RES_REGBLKS)
+
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/include/xfs_rtalloc.h b/include/xfs_rtalloc.h
index 8d8dcd2..ff614c2 100644
--- a/include/xfs_rtalloc.h
+++ b/include/xfs_rtalloc.h
@@ -23,8 +23,8 @@ struct xfs_trans;
 
 /* Min and max rt extent sizes, specified in bytes */
 #define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
-#define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64KB */
-#define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4KB */
+#define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
+#define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
 /*
  * Constants for bit manipulations.
@@ -108,6 +108,9 @@ xfs_rtfree_extent(
 int					/* error */
 xfs_rtmount_init(
 	struct xfs_mount	*mp);	/* file system mount structure */
+void
+xfs_rtunmount_inodes(
+	struct xfs_mount	*mp);
 
 /*
  * Get the bitmap and summary inodes into the mount structure
@@ -144,8 +147,18 @@ xfs_growfs_rt(
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
-# define xfs_rtmount_init(m)    (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+static inline int		/* error */
+xfs_rtmount_init(
+	xfs_mount_t	*mp)	/* file system mount structure */
+{
+	if (mp->m_sb.sb_rblocks == 0)
+		return 0;
+
+	cmn_err(CE_WARN, "XFS: Not built with CONFIG_XFS_RT");
+	return ENOSYS;
+}
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+# define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __KERNEL__ */
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index f88dc32..5dcc2d7 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -299,30 +299,34 @@ typedef enum {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-#ifdef __KERNEL__
 static inline int xfs_sb_good_version(xfs_sb_t *sbp)
 {
-	return (((sbp->sb_versionnum >= XFS_SB_VERSION_1) && \
-		  (sbp->sb_versionnum <= XFS_SB_VERSION_3)) || \
-		   ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		    !((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) || \
-		      ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) && \
-		       (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS))) && \
-	  	    (sbp->sb_shared_vn <= XFS_SB_MAX_SHARED_VN)));
-}
+	/* We always support version 1-3 */
+	if (sbp->sb_versionnum >= XFS_SB_VERSION_1 &&
+	    sbp->sb_versionnum <= XFS_SB_VERSION_3)
+		return 1;
+
+	/* We support version 4 if all feature bits are supported */
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) {
+		if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) ||
+		    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+		     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS)))
+			return 0;
+
+#ifdef __KERNEL__
+		if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
+			return 0;
 #else
-static inline int xfs_sb_good_version(xfs_sb_t *sbp)
-{
-	return (((sbp->sb_versionnum >= XFS_SB_VERSION_1) && \
-		  (sbp->sb_versionnum <= XFS_SB_VERSION_3)) || \
-		   ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		    !((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) || \
-		      ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) && \
-		       (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS))) && \
-		  (!(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) || \
-		   (sbp->sb_shared_vn <= XFS_SB_MAX_SHARED_VN))));
+		if ((sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) &&
+		    sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
+			return 0;
+#endif
+
+		return 1;
+	}
+
+	return 0;
 }
-#endif /* __KERNEL__ */
 
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
@@ -335,123 +339,127 @@ static inline int xfs_sb_has_mismatched_features2(xfs_sb_t *sbp)
 
 static inline unsigned xfs_sb_version_tonew(unsigned v)
 {
-	return ((((v) == XFS_SB_VERSION_1) ? \
-		0 : \
-		(((v) == XFS_SB_VERSION_2) ? \
-			XFS_SB_VERSION_ATTRBIT : \
-			(XFS_SB_VERSION_ATTRBIT | XFS_SB_VERSION_NLINKBIT))) | \
-		XFS_SB_VERSION_4);
+	if (v == XFS_SB_VERSION_1)
+		return XFS_SB_VERSION_4;
+
+	if (v == XFS_SB_VERSION_2)
+		return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
+
+	return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT |
+		XFS_SB_VERSION_NLINKBIT;
 }
 
 static inline unsigned xfs_sb_version_toold(unsigned v)
 {
-	return (((v) & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT)) ? \
-		0 : \
-		(((v) & XFS_SB_VERSION_NLINKBIT) ? \
-			XFS_SB_VERSION_3 : \
-			(((v) & XFS_SB_VERSION_ATTRBIT) ?  \
-				XFS_SB_VERSION_2 : \
-				XFS_SB_VERSION_1)));
+	if (v & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT))
+		return 0;
+	if (v & XFS_SB_VERSION_NLINKBIT)
+		return XFS_SB_VERSION_3;
+	if (v & XFS_SB_VERSION_ATTRBIT)
+		return XFS_SB_VERSION_2;
+	return XFS_SB_VERSION_1;
 }
 
 static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
 {
-	return ((sbp)->sb_versionnum == XFS_SB_VERSION_2) || \
-		 ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
-		 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		  ((sbp)->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
+	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
+		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
+		(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
 }
 
 static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = (((sbp)->sb_versionnum == XFS_SB_VERSION_1) ? \
-		XFS_SB_VERSION_2 : \
-		((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) ? \
-			((sbp)->sb_versionnum | XFS_SB_VERSION_ATTRBIT) : \
-			(XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT)));
+	if (sbp->sb_versionnum == XFS_SB_VERSION_1)
+		sbp->sb_versionnum = XFS_SB_VERSION_2;
+	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	else
+		sbp->sb_versionnum = XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
 }
 
 static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
 {
-	return ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
-		 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		  ((sbp)->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
+	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
+		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
 }
 
 static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = ((sbp)->sb_versionnum <= XFS_SB_VERSION_2 ? \
-		XFS_SB_VERSION_3 : \
-		((sbp)->sb_versionnum | XFS_SB_VERSION_NLINKBIT));
+	if (sbp->sb_versionnum <= XFS_SB_VERSION_2)
+		sbp->sb_versionnum = XFS_SB_VERSION_3;
+	else
+		sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
 }
 
 static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
 }
 
 static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = \
-		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 ? \
-			((sbp)->sb_versionnum | XFS_SB_VERSION_QUOTABIT) : \
-			(xfs_sb_version_tonew((sbp)->sb_versionnum) | \
-			 XFS_SB_VERSION_QUOTABIT));
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
+	else
+		sbp->sb_versionnum = xfs_sb_version_tonew(sbp->sb_versionnum) |
+					XFS_SB_VERSION_QUOTABIT;
 }
 
 static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
 }
 
 static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
 static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
 }
 
 static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 }
 
 static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
 static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
 }
 
 static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
 static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
 		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
 }
 
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
 /*
@@ -466,22 +474,20 @@ static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 
 static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
 {
-	return (xfs_sb_version_hasmorebits(sbp) &&	\
-		((sbp)->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT);
 }
 
 static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
 {
-	return (xfs_sb_version_hasmorebits(sbp)) &&	\
-		((sbp)->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
 }
 
 static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
 {
-	((sbp)->sb_versionnum =	\
-		((sbp)->sb_versionnum | XFS_SB_VERSION_MOREBITSBIT),	\
-	((sbp)->sb_features2 =	\
-		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
 static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
@@ -514,7 +520,7 @@ static inline void xfs_sb_version_addprojid32bit(xfs_sb_t *sbp)
 
 #define	XFS_HDR_BLOCK(mp,d)	((xfs_agblock_t)XFS_BB_TO_FSBT(mp,d))
 #define	XFS_DADDR_TO_FSB(mp,d)	XFS_AGB_TO_FSB(mp, \
-			XFS_DADDR_TO_AGNO(mp,d), XFS_DADDR_TO_AGBNO(mp,d))
+			xfs_daddr_to_agno(mp,d), xfs_daddr_to_agbno(mp,d))
 #define	XFS_FSB_TO_DADDR(mp,fsbno)	XFS_AGB_TO_DADDR(mp, \
 			XFS_FSB_TO_AGNO(mp,fsbno), XFS_FSB_TO_AGBNO(mp,fsbno))
 
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
new file mode 100644
index 0000000..bf82f6e
--- /dev/null
+++ b/include/xfs_trace.h
@@ -0,0 +1,85 @@
+#ifndef __TRACE_H__
+#define __TRACE_H__
+
+#define trace_xfs_alloc_exact_done(a)		((void) 0)
+#define trace_xfs_alloc_exact_notfound(a)	((void) 0)
+#define trace_xfs_alloc_exact_error(a)		((void) 0)
+#define trace_xfs_alloc_near_nominleft(a)	((void) 0)
+#define trace_xfs_alloc_near_first(a)		((void) 0)
+#define trace_xfs_alloc_near_greater(a)		((void) 0)
+#define trace_xfs_alloc_near_lesser(a)		((void) 0)
+#define trace_xfs_alloc_near_error(a)		((void) 0)
+#define trace_xfs_alloc_size_neither(a)		((void) 0)
+#define trace_xfs_alloc_size_noentry(a)		((void) 0)
+#define trace_xfs_alloc_size_nominleft(a)	((void) 0)
+#define trace_xfs_alloc_size_done(a)		((void) 0)
+#define trace_xfs_alloc_size_error(a)		((void) 0)
+#define trace_xfs_alloc_small_freelist(a)	((void) 0)
+#define trace_xfs_alloc_small_notenough(a)	((void) 0)
+#define trace_xfs_alloc_small_done(a)		((void) 0)
+#define trace_xfs_alloc_small_error(a)		((void) 0)
+#define trace_xfs_alloc_vextent_badargs(a)	((void) 0)
+#define trace_xfs_alloc_vextent_nofix(a)	((void) 0)
+#define trace_xfs_alloc_vextent_noagbp(a)	((void) 0)
+#define trace_xfs_alloc_vextent_loopfailed(a)	((void) 0)
+#define trace_xfs_alloc_vextent_allfailed(a)	((void) 0)
+
+#define trace_xfs_log_recover_item_reorder_head(a,b,c,d)	((void) 0)
+#define trace_xfs_log_recover_item_reorder_tail(a,b,c,d)	((void) 0)
+#define trace_xfs_log_recover_item_add_cont(a,b,c,d)	((void) 0)
+#define trace_xfs_log_recover_item_add(a,b,c,d)	((void) 0)
+
+#define trace_xfs_btree_corrupt(a,b)	((void) 0)
+#define trace_xfs_da_btree_corrupt(a,b)	((void) 0)
+
+#define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
+#define trace_xfs_agf(a,b,c,d)		((void) 0)
+
+#define trace_xfs_iext_insert(a,b,c,d,e)	((void) 0)
+#define trace_xfs_iext_remove(a,b,c,d)	((void) 0)
+
+#define trace_xfs_dir2_grow_inode(a,b)	((void) 0)
+#define trace_xfs_dir2_shrink_inode(a,b)	((void) 0)
+
+#define trace_xfs_dir2_leaf_to_node(a)	((void) 0)
+#define trace_xfs_dir2_leaf_to_block(a)	((void) 0)
+#define trace_xfs_dir2_leaf_addname(a)	((void) 0)
+#define trace_xfs_dir2_leaf_lookup(a)	((void) 0)
+#define trace_xfs_dir2_leaf_removename(a)	((void) 0)
+#define trace_xfs_dir2_leaf_replace(a)	((void) 0)
+
+#define trace_xfs_dir2_block_addname(a)	((void) 0)
+#define trace_xfs_dir2_block_to_leaf(a)	((void) 0)
+#define trace_xfs_dir2_block_to_sf(a)	((void) 0)
+#define trace_xfs_dir2_block_lookup(a)	((void) 0)
+#define trace_xfs_dir2_block_removename(a)	((void) 0)
+#define trace_xfs_dir2_block_replace(a)	((void) 0)
+
+#define trace_xfs_dir2_leafn_add(a,b)	((void) 0)
+#define trace_xfs_dir2_leafn_remove(a,b)	((void) 0)
+#define trace_xfs_dir2_leafn_moveents(a,b,c,d)	((void) 0)
+
+#define trace_xfs_dir2_node_to_leaf(a)	((void) 0)
+#define trace_xfs_dir2_node_addname(a)	((void) 0)
+#define trace_xfs_dir2_node_lookup(a)	((void) 0)
+#define trace_xfs_dir2_node_removename(a)	((void) 0)
+#define trace_xfs_dir2_node_replace(a)	((void) 0)
+
+#define trace_xfs_dir2_sf_to_block(a)	((void) 0)
+#define trace_xfs_dir2_sf_addname(a)	((void) 0)
+#define trace_xfs_dir2_sf_create(a)	((void) 0)
+#define trace_xfs_dir2_sf_lookup(a)	((void) 0)
+#define trace_xfs_dir2_sf_removename(a)	((void) 0)
+#define trace_xfs_dir2_sf_replace(a)	((void) 0)
+#define trace_xfs_dir2_sf_toino4(a)	((void) 0)
+#define trace_xfs_dir2_sf_toino8(a)	((void) 0)
+
+#define trace_xfs_bmap_pre_update(a,b,c,d)	((void) 0)
+#define trace_xfs_bmap_post_update(a,b,c,d)	((void) 0)
+#define trace_xfs_extlist(a,b,c,d)	((void) 0)
+#define trace_xfs_bunmap(a,b,c,d,e)	((void) 0)
+
+#define trace_xfs_perag_get(a,b,c,d)	((void) 0)
+#define trace_xfs_perag_put(a,b,c,d)	((void) 0)
+
+#endif /* __TRACE_H__ */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 1d89d50..c2042b7 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -49,6 +49,15 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_DQUOT		0x123d
 #define	XFS_LI_QUOTAOFF		0x123e
 
+#define XFS_LI_TYPE_DESC \
+	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
+	{ XFS_LI_EFD,		"XFS_LI_EFD" }, \
+	{ XFS_LI_IUNLINK,	"XFS_LI_IUNLINK" }, \
+	{ XFS_LI_INODE,		"XFS_LI_INODE" }, \
+	{ XFS_LI_BUF,		"XFS_LI_BUF" }, \
+	{ XFS_LI_DQUOT,		"XFS_LI_DQUOT" }, \
+	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }
+
 /*
  * Transaction types.  Used to distinguish types of buffers.
  */
@@ -68,7 +77,7 @@ typedef struct xfs_trans_header {
 #define XFS_TRANS_GROWFS		14
 #define XFS_TRANS_STRAT_WRITE		15
 #define XFS_TRANS_DIOSTRAT		16
-#define	XFS_TRANS_WRITE_SYNC		17
+/* 17 was XFS_TRANS_WRITE_SYNC */
 #define	XFS_TRANS_WRITEID		18
 #define	XFS_TRANS_ADDAFORK		19
 #define	XFS_TRANS_ATTRINVAL		20
@@ -97,9 +106,54 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_TYPE_MAX		41
+#define	XFS_TRANS_CHECKPOINT		42
+#define	XFS_TRANS_TYPE_MAX		42
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
+#define XFS_TRANS_TYPES \
+	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
+	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
+	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
+	{ XFS_TRANS_CREATE,		"CREATE" }, \
+	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
+	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
+	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
+	{ XFS_TRANS_LINK,		"LINK" }, \
+	{ XFS_TRANS_RENAME,		"RENAME" }, \
+	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
+	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
+	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
+	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
+	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
+	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
+	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
+	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
+	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
+	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
+	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
+	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
+	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
+	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
+	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
+	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
+	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
+	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
+	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
+	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
+	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
+	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
+	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
+	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
+	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
+	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
+	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
+	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
+	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
+	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
+	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
+
 /*
  * This structure is used to track log items associated with
  * a transaction.  It points to the log item and keeps some
@@ -107,106 +161,14 @@ typedef struct xfs_trans_header {
  * the amount of space needed to log the item it describes
  * once we get to commit processing (see xfs_trans_commit()).
  */
-typedef struct xfs_log_item_desc {
+struct xfs_log_item_desc {
 	struct xfs_log_item	*lid_item;
-	ushort		lid_size;
-	unsigned char	lid_flags;
-	unsigned char	lid_index;
-} xfs_log_item_desc_t;
+	ushort			lid_size;
+	unsigned char		lid_flags;
+	struct list_head	lid_trans;
+};
 
 #define XFS_LID_DIRTY		0x1
-#define XFS_LID_PINNED		0x2
-#define XFS_LID_BUF_STALE	0x8
-
-/*
- * This structure is used to maintain a chunk list of log_item_desc
- * structures. The free field is a bitmask indicating which descriptors
- * in this chunk's array are free.  The unused field is the first value
- * not used since this chunk was allocated.
- */
-#define	XFS_LIC_NUM_SLOTS	15
-typedef struct xfs_log_item_chunk {
-	struct xfs_log_item_chunk	*lic_next;
-	ushort				lic_free;
-	ushort				lic_unused;
-	xfs_log_item_desc_t		lic_descs[XFS_LIC_NUM_SLOTS];
-} xfs_log_item_chunk_t;
-
-#define	XFS_LIC_MAX_SLOT	(XFS_LIC_NUM_SLOTS - 1)
-#define	XFS_LIC_FREEMASK	((1 << XFS_LIC_NUM_SLOTS) - 1)
-
-
-/*
- * Initialize the given chunk.  Set the chunk's free descriptor mask
- * to indicate that all descriptors are free.  The caller gets to set
- * lic_unused to the right value (0 matches all free).  The
- * lic_descs.lid_index values are set up as each desc is allocated.
- */
-static inline void xfs_lic_init(xfs_log_item_chunk_t *cp)
-{
-	cp->lic_free = XFS_LIC_FREEMASK;
-}
-
-static inline void xfs_lic_init_slot(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_descs[slot].lid_index = (unsigned char)(slot);
-}
-
-static inline int xfs_lic_vacancy(xfs_log_item_chunk_t *cp)
-{
-	return cp->lic_free & XFS_LIC_FREEMASK;
-}
-
-static inline void xfs_lic_all_free(xfs_log_item_chunk_t *cp)
-{
-	cp->lic_free = XFS_LIC_FREEMASK;
-}
-
-static inline int xfs_lic_are_all_free(xfs_log_item_chunk_t *cp)
-{
-	return ((cp->lic_free & XFS_LIC_FREEMASK) == XFS_LIC_FREEMASK);
-}
-
-static inline int xfs_lic_isfree(xfs_log_item_chunk_t *cp, int slot)
-{
-	return (cp->lic_free & (1 << slot));
-}
-
-static inline void xfs_lic_claim(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_free &= ~(1 << slot);
-}
-
-static inline void xfs_lic_relse(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_free |= 1 << slot;
-}
-
-static inline xfs_log_item_desc_t *
-xfs_lic_slot(xfs_log_item_chunk_t *cp, int slot)
-{
-	return &(cp->lic_descs[slot]);
-}
-
-static inline int xfs_lic_desc_to_slot(xfs_log_item_desc_t *dp)
-{
-	return (uint)dp->lid_index;
-}
-
-/*
- * Calculate the address of a chunk given a descriptor pointer:
- * dp - dp->lid_index give the address of the start of the lic_descs array.
- * From this we subtract the offset of the lic_descs field in a chunk.
- * All of this yields the address of the chunk, which is
- * cast to a chunk pointer.
- */
-static inline xfs_log_item_chunk_t *
-xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
-{
-	return (xfs_log_item_chunk_t*) \
-		(((xfs_caddr_t)((dp) - (dp)->lid_index)) - \
-		(xfs_caddr_t)(((xfs_log_item_chunk_t*)0)->lic_descs));
-}
 
 #define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
 /*
@@ -222,8 +184,6 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 /*
  * Values for call flags parameter.
  */
-#define	XFS_TRANS_NOSLEEP		0x1
-#define	XFS_TRANS_WAIT			0x2
 #define	XFS_TRANS_RELEASE_LOG_RES	0x4
 #define	XFS_TRANS_ABORT			0x8
 
@@ -247,24 +207,6 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 
 
 /*
- * Various log reservation values.
- * These are based on the size of the file system block
- * because that is what most transactions manipulate.
- * Each adds in an additional 128 bytes per item logged to
- * try to account for the overhead of the transaction mechanism.
- *
- * Note:
- * Most of the reservations underestimate the number of allocation
- * groups into which they could free extents in the xfs_bmap_finish()
- * call.  This is because the number in the worst case is quite high
- * and quite unusual.  In order to fix this we need to change
- * xfs_bmap_finish() to free extents in only a single AG at a time.
- * This will require changes to the EFI code as well, however, so that
- * the EFI for the extents not freed is logged again in each transaction.
- * See bug 261917.
- */
-
-/*
  * Per-extent log reservation for the allocation btree changes
  * involved in freeing or allocating an extent.
  * 2 trees * (2 blocks/level * max depth - 1) * block size
@@ -288,429 +230,36 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
 	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
 
-/*
- * In a write transaction we can allocate a maximum of 2
- * extents.  This gives:
- *    the inode getting the new extents: inode size
- *    the inode\'s bmap btree: max depth * block size
- *    the agfs of the ags from which the extents are allocated: 2 * sector
- *    the superblock free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- * And the bmap_finish transaction can free bmap blocks in a join:
- *    the agfs of the ags containing the blocks: 2 * sector size
- *    the agfls of the ags containing the blocks: 2 * sector size
- *    the super block free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define XFS_CALC_WRITE_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + XFS_ALLOCFREE_LOG_COUNT(mp, 2)))),\
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
 
 #define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
-
-/*
- * In truncating a file we free up to two extents at once.  We can modify:
- *    the inode being truncated: inode size
- *    the inode\'s bmap btree: (max depth + 1) * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
- *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_ITRUNCATE_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) + \
-	  (128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)))), \
-	 ((4 * (mp)->m_sb.sb_sectsize) + \
-	  (4 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 4) + \
-	  (128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))) + \
-	  (128 * 5) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	   (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
-	    XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
-
-/*
- * In renaming a files we can modify:
- *    the four inodes involved: 4 * inode size
- *    the two directory btrees: 2 * (max depth + v2) * dir block size
- *    the two directory bmap btrees: 2 * max depth * block size
- * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
- *    the agf for the ags in which the blocks live: 3 * sector size
- *    the agfl for the ags in which the blocks live: 3 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_RENAME_LOG_RES(mp) \
-	(MAX( \
-	 ((4 * (mp)->m_sb.sb_inodesize) + \
-	  (2 * XFS_DIROP_LOG_RES(mp)) + \
-	  (128 * (4 + 2 * XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((3 * (mp)->m_sb.sb_sectsize) + \
-	  (3 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 3) + \
-	  (128 * (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))))))
-
 #define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
-
-/*
- * For creating a link to an inode:
- *    the parent directory inode: inode size
- *    the linked inode: inode size
- *    the directory btree could split: (max depth + v2) * dir block size
- *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free some bmap blocks giving:
- *    the agf for the ag in which the blocks live: sector size
- *    the agfl for the ag in which the blocks live: sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_LINK_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (2 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((mp)->m_sb.sb_sectsize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
-
-/*
- * For removing a directory entry we can modify:
- *    the parent directory inode: inode size
- *    the removed inode: inode size
- *    the directory btree could join: (max depth + v2) * dir block size
- *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free the dir and bmap blocks giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_REMOVE_LOG_RES(mp)	\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (2 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
-
 #define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
-
-/*
- * For symlink we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: 1 block
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode\'s bmap btree: (max depth + v2) * block size
- *    the blocks for the symlink: 1 KB
- * Or in the first xact we allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_SYMLINK_LOG_RES(mp)		\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B(mp, 1) + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  1024 + \
-	  (128 * (4 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 (2 * (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_IALLOC_BLOCKS((mp))) + \
-	  XFS_FSB_TO_B((mp), XFS_IN_MAXLEVELS(mp)) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
-
-/*
- * For create we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: block size
- *    the superblock for the nlink flag: sector size
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode\'s bmap btree: (max depth + v2) * block size
- * Or in the first xact we allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
- *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_CREATE_LOG_RES(mp)		\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B(mp, 1) + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (3 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 (3 * (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_IALLOC_BLOCKS((mp))) + \
-	  XFS_FSB_TO_B((mp), XFS_IN_MAXLEVELS(mp)) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
-
-/*
- * Making a new directory is the same as creating a new file.
- */
-#define	XFS_CALC_MKDIR_LOG_RES(mp)	XFS_CALC_CREATE_LOG_RES(mp)
-
 #define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
-
-/*
- * In freeing an inode we can modify:
- *    the inode being freed: inode size
- *    the super block free inode counter: sector size
- *    the agi hash list and counters: sector size
- *    the inode btree entry: block size
- *    the on disk inode before ours in the agi hash list: inode cluster size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_IFREE_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize + \
-	 (mp)->m_sb.sb_sectsize + \
-	 XFS_FSB_TO_B((mp), 1) + \
-	 MAX((__uint16_t)XFS_FSB_TO_B((mp), 1), XFS_INODE_CLUSTER_SIZE(mp)) + \
-	 (128 * 5) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
-
 #define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
-
-/*
- * When only changing the inode we log the inode and possibly the superblock
- * We also add a bit of slop for the transaction stuff.
- */
-#define	XFS_CALC_ICHANGE_LOG_RES(mp)	((mp)->m_sb.sb_inodesize + \
-					 (mp)->m_sb.sb_sectsize + 512)
-
 #define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
-
-/*
- * Growing the data section of the filesystem.
- *	superblock
- *	agi and agf
- *	allocation btrees
- */
-#define	XFS_CALC_GROWDATA_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize * 3 + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
-
-/*
- * Growing the rt section of the filesystem.
- * In the first set of transactions (ALLOC) we allocate space to the
- * bitmap or summary files.
- *	superblock: sector size
- *	agf of the ag from which the extent is allocated: sector size
- *	bmap btree for bitmap/summary inode: max depth * blocksize
- *	bitmap/summary inode: inode size
- *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
- */
-#define	XFS_CALC_GROWRTALLOC_LOG_RES(mp) \
-	(2 * (mp)->m_sb.sb_sectsize + \
-	 XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) + \
-	 (mp)->m_sb.sb_inodesize + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * \
-	  (3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
-
-/*
- * Growing the rt section of the filesystem.
- * In the second set of transactions (ZERO) we zero the new metadata blocks.
- *	one bitmap/summary block: blocksize
- */
-#define	XFS_CALC_GROWRTZERO_LOG_RES(mp) \
-	((mp)->m_sb.sb_blocksize + 128)
-
 #define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
-
-/*
- * Growing the rt section of the filesystem.
- * In the third set of transactions (FREE) we update metadata without
- * allocating any new blocks.
- *	superblock: sector size
- *	bitmap inode: inode size
- *	summary inode: inode size
- *	one bitmap block: blocksize
- *	summary blocks: new summary size
- */
-#define	XFS_CALC_GROWRTFREE_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize + \
-	 2 * (mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_blocksize + \
-	 (mp)->m_rsumsize + \
-	 (128 * 5))
-
 #define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
-
-/*
- * Logging the inode modification timestamp on a synchronous write.
- *	inode
- */
-#define	XFS_CALC_SWRITE_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + 128)
-
 #define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
-
 /*
  * Logging the inode timestamps on an fsync -- same as SWRITE
  * as long as SWRITE logs the entire inode core
  */
 #define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
-
-/*
- * Logging the inode mode bits when writing a setuid/setgid file
- *	inode
- */
-#define	XFS_CALC_WRITEID_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + 128)
-
 #define	XFS_WRITEID_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
-
-/*
- * Converting the inode from non-attributed to attributed.
- *	the inode being converted: inode size
- *	agf block and superblock (for block allocation)
- *	the new block (directory sized)
- *	bmap blocks for the new directory block
- *	allocation btrees
- */
-#define	XFS_CALC_ADDAFORK_LOG_RES(mp)	\
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize * 2 + \
-	 (mp)->m_dirblksize + \
-	 XFS_FSB_TO_B(mp, (XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1)) + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * (4 + (XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1) + \
-		 XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
-
-/*
- * Removing the attribute fork of a file
- *    the inode being truncated: inode size
- *    the inode\'s bmap btree: max depth * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
- *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_ATTRINVAL_LOG_RES(mp)	\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) + \
-	  (128 * (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))), \
-	 ((4 * (mp)->m_sb.sb_sectsize) + \
-	  (4 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 4) + \
-	  (128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))))))
-
 #define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
-
-/*
- * Setting an attribute.
- *	the inode getting the attribute
- *	the superblock for allocations
- *	the agfs extents are allocated from
- *	the attribute btree * max depth
- *	the inode allocation btree
- * Since attribute transaction space is dependent on the size of the attribute,
- * the calculation is done partially at mount time and partially at runtime.
- */
-#define	XFS_CALC_ATTRSET_LOG_RES(mp)	\
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_DA_NODE_MAXDEPTH) + \
-	  (128 * (2 + XFS_DA_NODE_MAXDEPTH)))
-
 #define	XFS_ATTRSET_LOG_RES(mp, ext)	\
 	((mp)->m_reservations.tr_attrset + \
 	 (ext * (mp)->m_sb.sb_sectsize) + \
 	 (ext * XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))) + \
 	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
-
-/*
- * Removing an attribute.
- *    the inode: inode size
- *    the attribute btree could join: max depth * block size
- *    the inode bmap btree could join or split: max depth * block size
- * And the bmap_finish transaction can free the attr blocks freed giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_ATTRRM_LOG_RES(mp)	\
-	(MAX( \
-	  ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_DA_NODE_MAXDEPTH) + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) + \
-	  (128 * (1 + XFS_DA_NODE_MAXDEPTH + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)))), \
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
-
 #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
-
-/*
- * Clearing a bad agino number in an agi hash bucket.
- */
-#define	XFS_CALC_CLEAR_AGI_BUCKET_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize + 128)
-
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 
 
@@ -745,8 +294,8 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 #define	XFS_ALLOC_BTREE_REF	2
 #define	XFS_BMAP_BTREE_REF	2
 #define	XFS_DIR_BTREE_REF	2
+#define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
-#define	XFS_INO_REF		1
 #define	XFS_DQUOT_REF		1
 
 #ifdef __KERNEL__
@@ -762,12 +311,14 @@ struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot_acct;
+struct xfs_busy_extent;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
 	struct xfs_log_item_desc	*li_desc;	/* ptr to current desc*/
 	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	uint				li_flags;	/* misc flags */
 	struct xfs_log_item		*li_bio_list;	/* buffer item list */
@@ -776,17 +327,25 @@ typedef struct xfs_log_item {
 							/* buffer item iodone */
 							/* callback func */
 	struct xfs_item_ops		*li_ops;	/* function list */
+
+	/* delayed logging */
+	struct list_head		li_cil;		/* CIL pointers */
+	struct xfs_log_vec		*li_lv;		/* active log vector */
+	xfs_lsn_t			li_seq;		/* CIL commit seq */
 } xfs_log_item_t;
 
 #define	XFS_LI_IN_AIL	0x1
 #define XFS_LI_ABORTED	0x2
 
+#define XFS_LI_FLAGS \
+	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
+	{ XFS_LI_ABORTED,	"ABORTED" }
+
 typedef struct xfs_item_ops {
 	uint (*iop_size)(xfs_log_item_t *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
 	void (*iop_pin)(xfs_log_item_t *);
-	void (*iop_unpin)(xfs_log_item_t *, int);
-	void (*iop_unpin_remove)(xfs_log_item_t *, struct xfs_trans *);
+	void (*iop_unpin)(xfs_log_item_t *, int remove);
 	uint (*iop_trylock)(xfs_log_item_t *);
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
@@ -798,8 +357,7 @@ typedef struct xfs_item_ops {
 #define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
 #define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
 #define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
-#define IOP_UNPIN(ip, flags)	(*(ip)->li_ops->iop_unpin)(ip, flags)
-#define IOP_UNPIN_REMOVE(ip,tp) (*(ip)->li_ops->iop_unpin_remove)(ip, tp)
+#define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
 #define IOP_TRYLOCK(ip)		(*(ip)->li_ops->iop_trylock)(ip)
 #define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
 #define IOP_COMMITTED(ip, lsn)	(*(ip)->li_ops->iop_committed)(ip, lsn)
@@ -813,36 +371,7 @@ typedef struct xfs_item_ops {
 #define	XFS_ITEM_SUCCESS	0
 #define	XFS_ITEM_PINNED		1
 #define	XFS_ITEM_LOCKED		2
-#define	XFS_ITEM_FLUSHING	3
-#define XFS_ITEM_PUSHBUF	4
-
-/*
- * This structure is used to maintain a list of block ranges that have been
- * freed in the transaction.  The ranges are listed in the perag[] busy list
- * between when they're freed and the transaction is committed to disk.
- */
-
-typedef struct xfs_log_busy_slot {
-	xfs_agnumber_t		lbc_ag;
-	ushort			lbc_idx;	/* index in perag.busy[] */
-} xfs_log_busy_slot_t;
-
-#define XFS_LBC_NUM_SLOTS	31
-typedef struct xfs_log_busy_chunk {
-	struct xfs_log_busy_chunk	*lbc_next;
-	uint				lbc_free;	/* free slots bitmask */
-	ushort				lbc_unused;	/* first unused */
-	xfs_log_busy_slot_t		lbc_busy[XFS_LBC_NUM_SLOTS];
-} xfs_log_busy_chunk_t;
-
-#define	XFS_LBC_MAX_SLOT	(XFS_LBC_NUM_SLOTS - 1)
-#define	XFS_LBC_FREEMASK	((1U << XFS_LBC_NUM_SLOTS) - 1)
-
-#define	XFS_LBC_INIT(cp)	((cp)->lbc_free = XFS_LBC_FREEMASK)
-#define	XFS_LBC_CLAIM(cp, slot)	((cp)->lbc_free &= ~(1 << (slot)))
-#define	XFS_LBC_SLOT(cp, slot)	(&((cp)->lbc_busy[(slot)]))
-#define	XFS_LBC_VACANCY(cp)	(((cp)->lbc_free) & XFS_LBC_FREEMASK)
-#define	XFS_LBC_ISFREE(cp, slot) ((cp)->lbc_free & (1 << (slot)))
+#define XFS_ITEM_PUSHBUF	3
 
 /*
  * This is the type of function which can be given to xfs_trans_callback()
@@ -863,15 +392,13 @@ typedef struct xfs_trans {
 	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
-	xfs_log_ticket_t	t_ticket;	/* log mgr ticket */
+	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	xfs_lsn_t		t_lsn;		/* log seq num of start of
 						 * transaction. */
 	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of
 						 * transaction. */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
-	xfs_trans_callback_t	t_callback;	/* transaction callback */
-	void			*t_callarg;	/* callback arg */
 	unsigned int		t_flags;	/* misc flags */
 	int64_t			t_icount_delta;	/* superblock icount change */
 	int64_t			t_ifree_delta;	/* superblock ifree change */
@@ -892,11 +419,9 @@ typedef struct xfs_trans {
 	int64_t			t_rblocks_delta;/* superblock rblocks change */
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
-	unsigned int		t_items_free;	/* log item descs free */
-	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
+	struct list_head	t_items;	/* log item descriptors */
 	xfs_trans_header_t	t_header;	/* header for in-log trans */
-	unsigned int		t_busy_free;	/* busy descs free */
-	xfs_log_busy_chunk_t	t_busy;		/* busy/async free blocks */
+	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
 } xfs_trans_t;
 
@@ -923,7 +448,7 @@ typedef struct xfs_trans {
  * XFS transaction mechanism exported interfaces.
  */
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
-xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
+xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
@@ -946,8 +471,9 @@ void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 int		xfs_trans_iget(struct xfs_mount *, xfs_trans_t *,
 			       xfs_ino_t , uint, uint, struct xfs_inode **);
-void		xfs_trans_ijoin(xfs_trans_t *, struct xfs_inode *, uint);
-void		xfs_trans_ihold(xfs_trans_t *, struct xfs_inode *);
+void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
+void		xfs_trans_ijoin_ref(struct xfs_trans *, struct xfs_inode *, uint);
+void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
@@ -970,15 +496,9 @@ int		_xfs_trans_commit(xfs_trans_t *,
 void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
-void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
-xfs_lsn_t	xfs_trans_tail_ail(struct xfs_mount *);
-void		xfs_trans_unlocked_item(struct xfs_mount *,
-					xfs_log_item_t *);
-xfs_log_busy_slot_t *xfs_trans_add_busy(xfs_trans_t *tp,
-					xfs_agnumber_t ag,
-					xfs_extlen_t idx);
 
 extern kmem_zone_t	*xfs_trans_zone;
+extern kmem_zone_t	*xfs_log_item_desc_zone;
 
 #endif	/* __KERNEL__ */
 
diff --git a/include/xfs_trans_space.h b/include/xfs_trans_space.h
index 4ea2e50..7d2c920 100644
--- a/include/xfs_trans_space.h
+++ b/include/xfs_trans_space.h
@@ -47,7 +47,7 @@
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
-	(XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp)-1)
+	(XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels - 1)
 
 /*
  * Space reservation values for various transactions.
diff --git a/include/xfs_types.h b/include/xfs_types.h
index 228b948..26d1867 100644
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -21,14 +21,6 @@
 #ifdef __KERNEL__
 
 /*
- * POSIX Extensions
- */
-typedef unsigned char		uchar_t;
-typedef unsigned short		ushort_t;
-typedef unsigned int		uint_t;
-typedef unsigned long		ulong_t;
-
-/*
  * Additional type declarations for XFS
  */
 typedef signed char		__int8_t;
@@ -45,7 +37,7 @@ typedef __uint32_t		prid_t;		/* project ID */
 typedef __uint32_t		inst_t;		/* an instruction */
 
 typedef __s64			xfs_off_t;	/* <file offset> type */
-typedef __u64			xfs_ino_t;	/* <inode> type */
+typedef unsigned long long	xfs_ino_t;	/* <inode> type */
 typedef __s64			xfs_daddr_t;	/* <disk address> type */
 typedef char *			xfs_caddr_t;	/* <core address> type */
 typedef __u32			xfs_dev_t;
@@ -81,6 +73,8 @@ typedef	__int32_t	xfs_tid_t;	/* transaction identifier */
 typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
 typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
 
+typedef __uint32_t	xlog_tid_t;	/* transaction ID type */
+
 /*
  * These types are 64 bits on disk but are either 32 or 64 bits in memory.
  * Disk based types:
@@ -109,8 +103,6 @@ typedef __uint64_t	xfs_fileoff_t;	/* block number in a file */
 typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
 
-typedef __uint8_t	xfs_arch_t;	/* architecture of an xfs fs */
-
 /*
  * Null values for the types.
  */
@@ -159,8 +151,8 @@ typedef enum {
 } xfs_btnum_t;
 
 struct xfs_name {
-	const char	*name;
-	int		len;
+	const unsigned char	*name;
+	int			len;
 };
 
 #endif	/* __XFS_TYPES_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 990cbf7..dcff031 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -11,7 +11,7 @@ LT_REVISION = 0
 LT_AGE = 0
 
 HFILES = xfs.h init.h
-CFILES = cache.c init.c kmem.c logitem.c rdwr.c trans.c util.c \
+CFILES = cache.c init.c kmem.c logitem.c rdwr.c radix-tree.c trans.c util.c \
 	xfs_alloc.c xfs_ialloc.c xfs_inode.c xfs_btree.c xfs_alloc_btree.c \
 	xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c \
 	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index 75d043e..d59308d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -374,6 +374,7 @@ manage_zones(int release)
 	extern kmem_zone_t	*xfs_da_state_zone;
 	extern kmem_zone_t	*xfs_btree_cur_zone;
 	extern kmem_zone_t	*xfs_bmap_free_item_zone;
+	extern kmem_zone_t	*xfs_log_item_desc_zone;
 	extern void		xfs_dir_startup();
 
 	if (release) {	/* free zone allocation */
@@ -385,6 +386,7 @@ manage_zones(int release)
 		kmem_free(xfs_da_state_zone);
 		kmem_free(xfs_btree_cur_zone);
 		kmem_free(xfs_bmap_free_item_zone);
+		kmem_free(xfs_log_item_desc_zone);
 		return;
 	}
 	/* otherwise initialise zone allocation */
@@ -402,6 +404,8 @@ manage_zones(int release)
 			sizeof(xfs_btree_cur_t), "xfs_btree_cur");
 	xfs_bmap_free_item_zone = kmem_zone_init(
 			sizeof(xfs_bmap_free_item_t), "xfs_bmap_free_item");
+	xfs_log_item_desc_zone = kmem_zone_init(
+			sizeof(struct xfs_log_item_desc), "xfs_log_item_desc");
 	xfs_dir_startup();
 }
 
@@ -509,6 +513,109 @@ libxfs_dirv1_mount(
 	mp->m_dirblkfsbs = 1;
 }
 
+static int
+libxfs_initialize_perag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agcount,
+	xfs_agnumber_t	*maxagi)
+{
+	xfs_agnumber_t	index, max_metadata;
+	xfs_agnumber_t	first_initialised = 0;
+	xfs_perag_t	*pag;
+	xfs_agino_t	agino;
+	xfs_ino_t	ino;
+	xfs_sb_t	*sbp = &mp->m_sb;
+	int		error = -ENOMEM;
+
+	/*
+	 * Walk the current per-ag tree so we don't try to initialise AGs
+	 * that already exist (growfs case). Allocate and insert all the
+	 * AGs we don't find ready for initialisation.
+	 */
+	for (index = 0; index < agcount; index++) {
+		pag = xfs_perag_get(mp, index);
+		if (pag) {
+			xfs_perag_put(pag);
+			continue;
+		}
+		if (!first_initialised)
+			first_initialised = index;
+
+		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
+		if (!pag)
+			goto out_unwind;
+		pag->pag_agno = index;
+		pag->pag_mount = mp;
+
+		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
+			error = -EEXIST;
+			goto out_unwind;
+		}
+	}
+
+	/*
+	 * If we mount with the inode64 option, or no inode overflows
+	 * the legacy 32-bit address space clear the inode32 option.
+	 */
+	agino = XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
+	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
+
+	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
+		mp->m_flags |= XFS_MOUNT_32BITINODES;
+	else
+		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
+
+	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+		/*
+		 * Calculate how much should be reserved for inodes to meet
+		 * the max inode percentage.
+		 */
+		if (mp->m_maxicount) {
+			__uint64_t	icount;
+
+			icount = sbp->sb_dblocks * sbp->sb_imax_pct;
+			do_div(icount, 100);
+			icount += sbp->sb_agblocks - 1;
+			do_div(icount, sbp->sb_agblocks);
+			max_metadata = icount;
+		} else {
+			max_metadata = agcount;
+		}
+
+		for (index = 0; index < agcount; index++) {
+			ino = XFS_AGINO_TO_INO(mp, index, agino);
+			if (ino > XFS_MAXINUMBER_32) {
+				index++;
+				break;
+			}
+
+			pag = xfs_perag_get(mp, index);
+			pag->pagi_inodeok = 1;
+			if (index < max_metadata)
+				pag->pagf_metadata = 1;
+			xfs_perag_put(pag);
+		}
+	} else {
+		for (index = 0; index < agcount; index++) {
+			pag = xfs_perag_get(mp, index);
+			pag->pagi_inodeok = 1;
+			xfs_perag_put(pag);
+		}
+	}
+
+	if (maxagi)
+		*maxagi = index;
+	return 0;
+
+out_unwind:
+	kmem_free(pag);
+	for (; index > first_initialised; index--) {
+		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		kmem_free(pag);
+	}
+	return error;
+}
+
 /*
  * Mount structure initialization, provides a filled-in xfs_mount_t
  * such that the numerous XFS_* macros can be used.  If dev is zero,
@@ -526,7 +633,6 @@ libxfs_mount(
 	xfs_daddr_t	d;
 	xfs_buf_t	*bp;
 	xfs_sb_t	*sbp;
-	size_t		size;
 	int		error;
 
 	mp->m_dev = dev;
@@ -534,6 +640,7 @@ libxfs_mount(
 	mp->m_logdev = logdev;
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	mp->m_sb = *sb;
+	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
 	sbp = &(mp->m_sb);
 
 	xfs_mount_common(mp, sb);
@@ -645,16 +752,13 @@ libxfs_mount(
 			return NULL;
 	}
 
-	/* Allocate and initialize the per-ag data */
-	size = sbp->sb_agcount * sizeof(xfs_perag_t);
-	if (size && (mp->m_perag = calloc(size, 1)) == NULL) {
-		fprintf(stderr, _("%s: failed to alloc %ld bytes: %s\n"),
-			progname, (long)size, strerror(errno));
+	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
+	if (error) {
+		fprintf(stderr, _("%s: perag init failed\n"),
+			progname);
 		exit(1);
 	}
 
-	mp->m_maxagi = xfs_initialize_perag(mp, sbp->sb_agcount);
-
 	/*
 	 * mkfs calls mount before the root inode is allocated.
 	 */
@@ -707,17 +811,16 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
 void
 libxfs_umount(xfs_mount_t *mp)
 {
+	struct xfs_perag	*pag;
+	int			agno;
+
 	libxfs_rtmount_destroy(mp);
 	libxfs_icache_purge();
 	libxfs_bcache_purge();
 
-	if (mp->m_perag) {
-		int     agno;
-		for (agno = 0; agno < mp->m_maxagi; agno++) {
-			if (mp->m_perag[agno].pagb_list)
-				free(mp->m_perag[agno].pagb_list);
-		}
-		free(mp->m_perag);
+	for (agno = 0; agno < mp->m_maxagi; agno++) {
+		pag = radix_tree_delete(&mp->m_perag_tree, agno);
+		kmem_free(pag);
 	}
 }
 
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index d6ef10b..0f2c14b 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -26,215 +26,6 @@ kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
  */
 
 /*
- * This is called to add the given log item to the transaction's
- * list of log items.  It must find a free log item descriptor
- * or allocate a new one and add the item to that descriptor.
- * The function returns a pointer to item descriptor used to point
- * to the new item.  The log item will now point to its new descriptor
- * with its li_desc field.
- */
-xfs_log_item_desc_t *
-xfs_trans_add_item(
-	xfs_trans_t		*tp,
-	xfs_log_item_t		*lip)
-{
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_chunk_t	*licp;
-	int			i = 0;
-
-	/*
-	 * If there are no free descriptors, allocate a new chunk
-	 * of them and put it at the front of the chunk list.
-	 */
-	if (tp->t_items_free == 0) {
-		licp = (xfs_log_item_chunk_t*)
-		       kmem_alloc(sizeof(xfs_log_item_chunk_t), KM_SLEEP);
-		ASSERT(licp != NULL);
-		/*
-		 * Initialize the chunk, and then
-		 * claim the first slot in the newly allocated chunk.
-		 */
-		xfs_lic_init(licp);
-		xfs_lic_claim(licp, 0);
-		licp->lic_unused = 1;
-		xfs_lic_init_slot(licp, 0);
-		lidp = xfs_lic_slot(licp, 0);
-
-		/*
-		 * Link in the new chunk and update the free count.
-		 */
-		licp->lic_next = tp->t_items.lic_next;
-		tp->t_items.lic_next = licp;
-		tp->t_items_free = XFS_LIC_NUM_SLOTS - 1;
-
-		/*
-		 * Initialize the descriptor and the generic portion
-		 * of the log item.
-		 *
-		 * Point the new slot at this item and return it.
-		 * Also point the log item at its currently active
-		 * descriptor and set the item's mount pointer.
-		 */
-		lidp->lid_item = lip;
-		lidp->lid_flags = 0;
-		lidp->lid_size = 0;
-		lip->li_desc = lidp;
-		lip->li_mountp = tp->t_mountp;
-		return lidp;
-	}
-
-	/*
-	 * Find the free descriptor. It is somewhere in the chunklist
-	 * of descriptors.
-	 */
-	licp = &tp->t_items;
-	while (licp != NULL) {
-		if (xfs_lic_vacancy(licp)) {
-			if (licp->lic_unused <= XFS_LIC_MAX_SLOT) {
-				i = licp->lic_unused;
-				ASSERT(xfs_lic_isfree(licp, i));
-				break;
-			}
-			for (i = 0; i <= XFS_LIC_MAX_SLOT; i++) {
-				if (xfs_lic_isfree(licp, i))
-					break;
-			}
-			ASSERT(i <= XFS_LIC_MAX_SLOT);
-			break;
-		}
-		licp = licp->lic_next;
-	}
-	ASSERT(licp != NULL);
-	/*
-	 * If we find a free descriptor, claim it,
-	 * initialize it, and return it.
-	 */
-	xfs_lic_claim(licp, i);
-	if (licp->lic_unused <= i) {
-		licp->lic_unused = i + 1;
-		xfs_lic_init_slot(licp, i);
-	}
-	lidp = xfs_lic_slot(licp, i);
-	tp->t_items_free--;
-	lidp->lid_item = lip;
-	lidp->lid_flags = 0;
-	lidp->lid_size = 0;
-	lip->li_desc = lidp;
-	lip->li_mountp = tp->t_mountp;
-	return lidp;
-}
-
-/*
- * Free the given descriptor.
- *
- * This requires setting the bit in the chunk's free mask corresponding
- * to the given slot.
- */
-void
-xfs_trans_free_item(
-	xfs_trans_t		*tp,
-	xfs_log_item_desc_t	*lidp)
-{
-	uint			slot;
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	**licpp;
-
-	slot = xfs_lic_desc_to_slot(lidp);
-	licp = xfs_lic_desc_to_chunk(lidp);
-	xfs_lic_relse(licp, slot);
-	lidp->lid_item->li_desc = NULL;
-	tp->t_items_free++;
-
-	/*
-	 * If there are no more used items in the chunk and this is not
-	 * the chunk embedded in the transaction structure, then free
-	 * the chunk. First pull it from the chunk list and then
-	 * free it back to the heap.  We didn't bother with a doubly
-	 * linked list here because the lists should be very short
-	 * and this is not a performance path.  It's better to save
-	 * the memory of the extra pointer.
-	 *
-	 * Also decrement the transaction structure's count of free items
-	 * by the number in a chunk since we are freeing an empty chunk.
-	 */
-	if (xfs_lic_are_all_free(licp) && (licp != &(tp->t_items))) {
-		licpp = &(tp->t_items.lic_next);
-		while (*licpp != licp) {
-			ASSERT(*licpp != NULL);
-			licpp = &((*licpp)->lic_next);
-		}
-		*licpp = licp->lic_next;
-		kmem_free(licp);
-		tp->t_items_free -= XFS_LIC_NUM_SLOTS;
-	}
-}
-
-/*
- * This is called to find the descriptor corresponding to the given
- * log item.  It returns a pointer to the descriptor.
- * The log item MUST have a corresponding descriptor in the given
- * transaction.	 This routine does not return NULL, it panics.
- *
- * The descriptor pointer is kept in the log item's li_desc field.
- * Just return it.
- */
-xfs_log_item_desc_t *
-xfs_trans_find_item(
-	xfs_trans_t		*tp,
-	xfs_log_item_t		*lip)
-{
-	ASSERT(lip->li_desc != NULL);
-
-	return lip->li_desc;
-}
-
-/*
- * This is called to unlock all of the items of a transaction and to free
- * all the descriptors of that transaction.
- *
- * It walks the list of descriptors and unlocks each item.  It frees
- * each chunk except that embedded in the transaction as it goes along.
- */
-void
-xfs_trans_free_items(
-	xfs_trans_t		*tp,
-	int			flags)
-{
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
-	int			abort;
-
-	abort = flags & XFS_TRANS_ABORT;
-	licp = &tp->t_items;
-	/*
-	 * Special case the embedded chunk so we don't free it below.
-	 */
-	if (!xfs_lic_are_all_free(licp)) {
-		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
-		xfs_lic_all_free(licp);
-		licp->lic_unused = 0;
-	}
-	licp = licp->lic_next;
-
-	/*
-	 * Unlock each item in each chunk and free the chunks.
-	 */
-	while (licp != NULL) {
-		ASSERT(!xfs_lic_are_all_free(licp));
-		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
-		next_licp = licp->lic_next;
-		kmem_free(licp);
-		licp = next_licp;
-	}
-
-	/*
-	 * Reset the transaction structure's free item count.
-	 */
-	tp->t_items_free = XFS_LIC_NUM_SLOTS;
-	tp->t_items.lic_next = NULL;
-}
-
-/*
  * Following functions from fs/xfs/xfs_trans_buf.c
  */
 
@@ -250,149 +41,21 @@ xfs_trans_buf_item_match(
 	xfs_daddr_t		blkno,
 	int			len)
 {
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_desc_t	*lidp;
-	xfs_buf_log_item_t	*blip;
-	xfs_buf_t		*bp;
-	int			i;
-
-#ifdef LI_DEBUG
-	fprintf(stderr, "buf_item_match (fast) log items for xact %p\n", tp);
-#endif
-
-	bp = NULL;
-	len = BBTOB(len);
-	licp = &tp->t_items;
-	if (!xfs_lic_are_all_free(licp)) {
-		for (i = 0; i < licp->lic_unused; i++) {
-			/*
-			 * Skip unoccupied slots.
-			 */
-			if (xfs_lic_isfree(licp, i)) {
-				continue;
-			}
-
-			lidp = xfs_lic_slot(licp, i);
-			blip = (xfs_buf_log_item_t *)lidp->lid_item;
-#ifdef LI_DEBUG
-			fprintf(stderr,
-				"\tfound log item, xact %p, blip=%p (%d/%d)\n",
-				tp, blip, i, licp->lic_unused);
-#endif
-			if (blip->bli_item.li_type != XFS_LI_BUF) {
-				continue;
-			}
-
-			bp = blip->bli_buf;
-#ifdef LI_DEBUG
-			fprintf(stderr,
-			"\tfound buf %p log item, xact %p, blip=%p (%d)\n",
-				bp, tp, blip, i);
-#endif
-			if ((XFS_BUF_TARGET(bp) == target->dev) &&
-			    (XFS_BUF_ADDR(bp) == blkno) &&
-			    (XFS_BUF_COUNT(bp) == len)) {
-				/*
-				 * We found it.	 Break out and
-				 * return the pointer to the buffer.
-				 */
-#ifdef LI_DEBUG
-				fprintf(stderr,
-					"\tfound REAL buf log item, bp=%p\n",
-					bp);
-#endif
-				break;
-			} else {
-				bp = NULL;
-			}
-		}
-	}
-#ifdef LI_DEBUG
-	if (!bp) fprintf(stderr, "\tfast search - got nothing\n");
-#endif
-	return bp;
+        struct xfs_log_item_desc *lidp;
+        struct xfs_buf_log_item *blip;
+
+        len = BBTOB(len);
+        list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+                blip = (struct xfs_buf_log_item *)lidp->lid_item;
+                if (blip->bli_item.li_type == XFS_LI_BUF &&
+                    XFS_BUF_TARGET(blip->bli_buf) == target->dev &&
+                    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
+                    XFS_BUF_COUNT(blip->bli_buf) == len)
+                        return blip->bli_buf;
+        }
+
+        return NULL;
 }
-
-/*
- * Check to see if a buffer matching the given parameters is already
- * a part of the given transaction.  Check all the chunks, we
- * want to be thorough.
- */
-xfs_buf_t *
-xfs_trans_buf_item_match_all(
-	xfs_trans_t		*tp,
-	xfs_buftarg_t		*target,
-	xfs_daddr_t		blkno,
-	int			len)
-{
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_desc_t	*lidp;
-	xfs_buf_log_item_t	*blip;
-	xfs_buf_t		*bp;
-	int			i;
-
-#ifdef LI_DEBUG
-	fprintf(stderr, "buf_item_match_all (slow) log items for xact %p\n",
-		tp);
-#endif
-
-	bp = NULL;
-	len = BBTOB(len);
-	for (licp = &tp->t_items; licp != NULL; licp = licp->lic_next) {
-		if (xfs_lic_are_all_free(licp)) {
-			ASSERT(licp == &tp->t_items);
-			ASSERT(licp->lic_next == NULL);
-			return NULL;
-		}
-		for (i = 0; i < licp->lic_unused; i++) {
-			/*
-			 * Skip unoccupied slots.
-			 */
-			if (xfs_lic_isfree(licp, i)) {
-				continue;
-			}
-
-			lidp = xfs_lic_slot(licp, i);
-			blip = (xfs_buf_log_item_t *)lidp->lid_item;
-#ifdef LI_DEBUG
-			fprintf(stderr,
-				"\tfound log item, xact %p, blip=%p (%d/%d)\n",
-				tp, blip, i, licp->lic_unused);
-#endif
-			if (blip->bli_item.li_type != XFS_LI_BUF) {
-				continue;
-			}
-
-			bp = blip->bli_buf;
-			ASSERT(bp);
-			ASSERT(XFS_BUF_ADDR(bp));
-#ifdef LI_DEBUG
-			fprintf(stderr,
-			"\tfound buf %p log item, xact %p, blip=%p (%d)\n",
-				bp, tp, blip, i);
-#endif
-			if ((XFS_BUF_TARGET(bp) == target->dev) &&
-			    (XFS_BUF_ADDR(bp) == blkno) &&
-			    (XFS_BUF_COUNT(bp) == len)) {
-				/*
-				 * We found it.	 Break out and
-				 * return the pointer to the buffer.
-				 */
-#ifdef LI_DEBUG
-				fprintf(stderr,
-					"\tfound REAL buf log item, bp=%p\n",
-					bp);
-#endif
-				return bp;
-			}
-		}
-	}
-#ifdef LI_DEBUG
-	if (!bp) fprintf(stderr, "slow search - got nothing\n");
-#endif
-	return NULL;
-}
-
 /*
  * The following are from fs/xfs/xfs_buf_item.c
  */
@@ -493,7 +156,7 @@ xfs_inode_item_init(
 	iip->ili_inode = ip;
 	iip->ili_format.ilf_type = XFS_LI_INODE;
 	iip->ili_format.ilf_ino = ip->i_ino;
-	iip->ili_format.ilf_blkno = ip->i_blkno;
-	iip->ili_format.ilf_len = ip->i_len;
-	iip->ili_format.ilf_boffset = ip->i_boffset;
+	iip->ili_format.ilf_blkno = ip->i_imap.im_blkno;
+	iip->ili_format.ilf_len = ip->i_imap.im_len;
+	iip->ili_format.ilf_boffset = ip->i_imap.im_boffset;
 }
diff --git a/libxfs/radix-tree.c b/libxfs/radix-tree.c
new file mode 100644
index 0000000..36a6324
--- /dev/null
+++ b/libxfs/radix-tree.c
@@ -0,0 +1,805 @@
+/*
+ * Copyright (C) 2001 Momchil Velikov
+ * Portions Copyright (C) 2001 Christoph Hellwig
+ * Copyright (C) 2005 SGI, Christoph Lameter <clameter@sgi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <libxfs.h>
+#include "radix-tree.h"
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
+
+#define RADIX_TREE_MAP_SHIFT	6
+#define RADIX_TREE_MAP_SIZE	(1UL << RADIX_TREE_MAP_SHIFT)
+#define RADIX_TREE_MAP_MASK	(RADIX_TREE_MAP_SIZE-1)
+
+#ifdef RADIX_TREE_TAGS
+#define RADIX_TREE_TAG_LONGS	\
+	((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
+#endif
+
+struct radix_tree_node {
+	unsigned int	count;
+	void		*slots[RADIX_TREE_MAP_SIZE];
+#ifdef RADIX_TREE_TAGS
+	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
+#endif
+};
+
+struct radix_tree_path {
+	struct radix_tree_node *node;
+	int offset;
+};
+
+#define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
+#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
+
+static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH];
+
+/*
+ * Radix tree node cache.
+ */
+
+#define radix_tree_node_alloc(r) 	((struct radix_tree_node *) \
+		calloc(1, sizeof(struct radix_tree_node)))
+#define radix_tree_node_free(n) 	free(n)
+
+#ifdef RADIX_TREE_TAGS
+
+static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	*((__uint32_t *)node->tags[tag] + (offset >> 5)) |= (1 << (offset & 31));
+}
+
+static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	__uint32_t 	*p = (__uint32_t*)node->tags[tag] + (offset >> 5);
+	__uint32_t 	m = 1 << (offset & 31);
+	*p &= ~m;
+}
+
+static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	return 1 & (((const __uint32_t *)node->tags[tag])[offset >> 5] >> (offset & 31));
+}
+
+/*
+ * Returns 1 if any slot in the node has this tag set.
+ * Otherwise returns 0.
+ */
+static inline int any_tag_set(struct radix_tree_node *node, unsigned int tag)
+{
+	int idx;
+	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
+		if (node->tags[tag][idx])
+			return 1;
+	}
+	return 0;
+}
+
+#endif
+
+/*
+ *	Return the maximum key which can be store into a
+ *	radix tree with height HEIGHT.
+ */
+static inline unsigned long radix_tree_maxindex(unsigned int height)
+{
+	return height_to_maxindex[height];
+}
+
+/*
+ *	Extend a radix tree so it can store key @index.
+ */
+static int radix_tree_extend(struct radix_tree_root *root, unsigned long index)
+{
+	struct radix_tree_node *node;
+	unsigned int height;
+#ifdef RADIX_TREE_TAGS
+	char tags[RADIX_TREE_MAX_TAGS];
+	int tag;
+#endif
+
+	/* Figure out what the height should be.  */
+	height = root->height + 1;
+	while (index > radix_tree_maxindex(height))
+		height++;
+
+	if (root->rnode == NULL) {
+		root->height = height;
+		goto out;
+	}
+
+#ifdef RADIX_TREE_TAGS
+	/*
+	 * Prepare the tag status of the top-level node for propagation
+	 * into the newly-pushed top-level node(s)
+	 */
+	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
+		tags[tag] = 0;
+		if (any_tag_set(root->rnode, tag))
+			tags[tag] = 1;
+	}
+#endif
+	do {
+		if (!(node = radix_tree_node_alloc(root)))
+			return -ENOMEM;
+
+		/* Increase the height.  */
+		node->slots[0] = root->rnode;
+
+#ifdef RADIX_TREE_TAGS
+		/* Propagate the aggregated tag info into the new root */
+		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
+			if (tags[tag])
+				tag_set(node, tag, 0);
+		}
+#endif
+		node->count = 1;
+		root->rnode = node;
+		root->height++;
+	} while (height > root->height);
+out:
+	return 0;
+}
+
+/**
+ *	radix_tree_insert    -    insert into a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@item:		item to insert
+ *
+ *	Insert an item into the radix tree at position @index.
+ */
+int radix_tree_insert(struct radix_tree_root *root,
+			unsigned long index, void *item)
+{
+	struct radix_tree_node *node = NULL, *slot;
+	unsigned int height, shift;
+	int offset;
+	int error;
+
+	/* Make sure the tree is high enough.  */
+	if ((!index && !root->rnode) ||
+			index > radix_tree_maxindex(root->height)) {
+		error = radix_tree_extend(root, index);
+		if (error)
+			return error;
+	}
+
+	slot = root->rnode;
+	height = root->height;
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+
+	offset = 0;			/* uninitialised var warning */
+	do {
+		if (slot == NULL) {
+			/* Have to add a child node.  */
+			if (!(slot = radix_tree_node_alloc(root)))
+				return -ENOMEM;
+			if (node) {
+				node->slots[offset] = slot;
+				node->count++;
+			} else
+				root->rnode = slot;
+		}
+
+		/* Go a level down */
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		node = slot;
+		slot = node->slots[offset];
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	} while (height > 0);
+
+	if (slot != NULL)
+		return -EEXIST;
+
+	ASSERT(node);
+	node->count++;
+	node->slots[offset] = item;
+#ifdef RADIX_TREE_TAGS
+	ASSERT(!tag_get(node, 0, offset));
+	ASSERT(!tag_get(node, 1, offset));
+#endif
+	return 0;
+}
+
+static inline void **__lookup_slot(struct radix_tree_root *root,
+				   unsigned long index)
+{
+	unsigned int height, shift;
+	struct radix_tree_node **slot;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		return NULL;
+
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	slot = &root->rnode;
+
+	while (height > 0) {
+		if (*slot == NULL)
+			return NULL;
+
+		slot = (struct radix_tree_node **)
+			((*slot)->slots +
+				((index >> shift) & RADIX_TREE_MAP_MASK));
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	}
+
+	return (void **)slot;
+}
+
+/**
+ *	radix_tree_lookup_slot    -    lookup a slot in a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Lookup the slot corresponding to the position @index in the radix tree
+ *	@root. This is useful for update-if-exists operations.
+ */
+void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
+{
+	return __lookup_slot(root, index);
+}
+
+/**
+ *	radix_tree_lookup    -    perform lookup operation on a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Lookup the item at the position @index in the radix tree @root.
+ */
+void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index)
+{
+	void **slot;
+
+	slot = __lookup_slot(root, index);
+	return slot != NULL ? *slot : NULL;
+}
+
+/**
+ *	raid_tree_first_key - find the first index key in the radix tree
+ *	@root:		radix tree root
+ *	@index:		where the first index will be placed
+ *
+ *	Returns the first entry and index key in the radix tree @root.
+ */
+void *radix_tree_lookup_first(struct radix_tree_root *root, unsigned long *index)
+{
+	unsigned int height, shift;
+	struct radix_tree_node *slot;
+	unsigned long i;
+
+	height = root->height;
+	*index = 0;
+	if (height == 0)
+		return NULL;
+
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	for (; height > 1; height--) {
+		for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
+			if (slot->slots[i] != NULL)
+				break;
+		}
+		ASSERT(i < RADIX_TREE_MAP_SIZE);
+
+		*index |= (i << shift);
+		shift -= RADIX_TREE_MAP_SHIFT;
+		slot = slot->slots[i];
+	}
+	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
+		if (slot->slots[i] != NULL) {
+			*index |= i;
+			return slot->slots[i];
+		}
+	}
+	return NULL;
+}
+
+#ifdef RADIX_TREE_TAGS
+
+/**
+ *	radix_tree_tag_set - set a tag on a radix tree node
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@tag: 		tag index
+ *
+ *	Set the search tag (which must be < RADIX_TREE_MAX_TAGS)
+ *	corresponding to @index in the radix tree.  From
+ *	the root all the way down to the leaf node.
+ *
+ *	Returns the address of the tagged item.   Setting a tag on a not-present
+ *	item is a bug.
+ */
+void *radix_tree_tag_set(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag)
+{
+	unsigned int height, shift;
+	struct radix_tree_node *slot;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		return NULL;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	while (height > 0) {
+		int offset;
+
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		if (!tag_get(slot, tag, offset))
+			tag_set(slot, tag, offset);
+		slot = slot->slots[offset];
+		ASSERT(slot != NULL);
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	}
+
+	return slot;
+}
+
+/**
+ *	radix_tree_tag_clear - clear a tag on a radix tree node
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@tag: 		tag index
+ *
+ *	Clear the search tag (which must be < RADIX_TREE_MAX_TAGS)
+ *	corresponding to @index in the radix tree.  If
+ *	this causes the leaf node to have no tags set then clear the tag in the
+ *	next-to-leaf node, etc.
+ *
+ *	Returns the address of the tagged item on success, else NULL.  ie:
+ *	has the same return value and semantics as radix_tree_lookup().
+ */
+void *radix_tree_tag_clear(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag)
+{
+	struct radix_tree_path path[RADIX_TREE_MAX_PATH], *pathp = path;
+	struct radix_tree_node *slot;
+	unsigned int height, shift;
+	void *ret = NULL;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		goto out;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	pathp->node = NULL;
+	slot = root->rnode;
+
+	while (height > 0) {
+		int offset;
+
+		if (slot == NULL)
+			goto out;
+
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		pathp[1].offset = offset;
+		pathp[1].node = slot;
+		slot = slot->slots[offset];
+		pathp++;
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	}
+
+	ret = slot;
+	if (ret == NULL)
+		goto out;
+
+	do {
+		if (!tag_get(pathp->node, tag, pathp->offset))
+			goto out;
+		tag_clear(pathp->node, tag, pathp->offset);
+		if (any_tag_set(pathp->node, tag))
+			goto out;
+		pathp--;
+	} while (pathp->node);
+out:
+	return ret;
+}
+
+#endif
+
+static unsigned int
+__lookup(struct radix_tree_root *root, void **results, unsigned long index,
+	unsigned int max_items, unsigned long *next_index)
+{
+	unsigned int nr_found = 0;
+	unsigned int shift, height;
+	struct radix_tree_node *slot;
+	unsigned long i;
+
+	height = root->height;
+	if (height == 0)
+		goto out;
+
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	for ( ; height > 1; height--) {
+
+		for (i = (index >> shift) & RADIX_TREE_MAP_MASK ;
+				i < RADIX_TREE_MAP_SIZE; i++) {
+			if (slot->slots[i] != NULL)
+				break;
+			index &= ~((1UL << shift) - 1);
+			index += 1UL << shift;
+			if (index == 0)
+				goto out;	/* 32-bit wraparound */
+		}
+		if (i == RADIX_TREE_MAP_SIZE)
+			goto out;
+
+		shift -= RADIX_TREE_MAP_SHIFT;
+		slot = slot->slots[i];
+	}
+
+	/* Bottom level: grab some items */
+	for (i = index & RADIX_TREE_MAP_MASK; i < RADIX_TREE_MAP_SIZE; i++) {
+		index++;
+		if (slot->slots[i]) {
+			results[nr_found++] = slot->slots[i];
+			if (nr_found == max_items)
+				goto out;
+		}
+	}
+out:
+	*next_index = index;
+	return nr_found;
+}
+
+/**
+ *	radix_tree_gang_lookup - perform multiple lookup on a radix tree
+ *	@root:		radix tree root
+ *	@results:	where the results of the lookup are placed
+ *	@first_index:	start the lookup from this key
+ *	@max_items:	place up to this many items at *results
+ *
+ *	Performs an index-ascending scan of the tree for present items.  Places
+ *	them at *@results and returns the number of items which were placed at
+ *	*@results.
+ *
+ *	The implementation is naive.
+ */
+unsigned int
+radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned int max_items)
+{
+	const unsigned long max_index = radix_tree_maxindex(root->height);
+	unsigned long cur_index = first_index;
+	unsigned int ret = 0;
+
+	while (ret < max_items) {
+		unsigned int nr_found;
+		unsigned long next_index;	/* Index of next search */
+
+		if (cur_index > max_index)
+			break;
+		nr_found = __lookup(root, results + ret, cur_index,
+					max_items - ret, &next_index);
+		ret += nr_found;
+		if (next_index == 0)
+			break;
+		cur_index = next_index;
+	}
+	return ret;
+}
+
+/**
+ *	radix_tree_gang_lookup_ex - perform multiple lookup on a radix tree
+ *	@root:		radix tree root
+ *	@results:	where the results of the lookup are placed
+ *	@first_index:	start the lookup from this key
+ *	@last_index:	don't lookup past this key
+ *	@max_items:	place up to this many items at *results
+ *
+ *	Performs an index-ascending scan of the tree for present items starting
+ *	@first_index until @last_index up to as many as @max_items.  Places
+ *	them at *@results and returns the number of items which were placed
+ *	at *@results.
+ *
+ *	The implementation is naive.
+ */
+unsigned int
+radix_tree_gang_lookup_ex(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned long last_index,
+			unsigned int max_items)
+{
+	const unsigned long max_index = radix_tree_maxindex(root->height);
+	unsigned long cur_index = first_index;
+	unsigned int ret = 0;
+
+	while (ret < max_items && cur_index < last_index) {
+		unsigned int nr_found;
+		unsigned long next_index;	/* Index of next search */
+
+		if (cur_index > max_index)
+			break;
+		nr_found = __lookup(root, results + ret, cur_index,
+					max_items - ret, &next_index);
+		ret += nr_found;
+		if (next_index == 0)
+			break;
+		cur_index = next_index;
+	}
+	return ret;
+}
+
+#ifdef RADIX_TREE_TAGS
+
+static unsigned int
+__lookup_tag(struct radix_tree_root *root, void **results, unsigned long index,
+	unsigned int max_items, unsigned long *next_index, unsigned int tag)
+{
+	unsigned int nr_found = 0;
+	unsigned int shift;
+	unsigned int height = root->height;
+	struct radix_tree_node *slot;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	while (height > 0) {
+		unsigned long i = (index >> shift) & RADIX_TREE_MAP_MASK;
+
+		for ( ; i < RADIX_TREE_MAP_SIZE; i++) {
+			if (tag_get(slot, tag, i)) {
+				ASSERT(slot->slots[i] != NULL);
+				break;
+			}
+			index &= ~((1UL << shift) - 1);
+			index += 1UL << shift;
+			if (index == 0)
+				goto out;	/* 32-bit wraparound */
+		}
+		if (i == RADIX_TREE_MAP_SIZE)
+			goto out;
+		height--;
+		if (height == 0) {	/* Bottom level: grab some items */
+			unsigned long j = index & RADIX_TREE_MAP_MASK;
+
+			for ( ; j < RADIX_TREE_MAP_SIZE; j++) {
+				index++;
+				if (tag_get(slot, tag, j)) {
+					ASSERT(slot->slots[j] != NULL);
+					results[nr_found++] = slot->slots[j];
+					if (nr_found == max_items)
+						goto out;
+				}
+			}
+		}
+		shift -= RADIX_TREE_MAP_SHIFT;
+		slot = slot->slots[i];
+	}
+out:
+	*next_index = index;
+	return nr_found;
+}
+
+/**
+ *	radix_tree_gang_lookup_tag - perform multiple lookup on a radix tree
+ *	                             based on a tag
+ *	@root:		radix tree root
+ *	@results:	where the results of the lookup are placed
+ *	@first_index:	start the lookup from this key
+ *	@max_items:	place up to this many items at *results
+ *	@tag:		the tag index (< RADIX_TREE_MAX_TAGS)
+ *
+ *	Performs an index-ascending scan of the tree for present items which
+ *	have the tag indexed by @tag set.  Places the items at *@results and
+ *	returns the number of items which were placed at *@results.
+ */
+unsigned int
+radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
+		unsigned long first_index, unsigned int max_items,
+		unsigned int tag)
+{
+	const unsigned long max_index = radix_tree_maxindex(root->height);
+	unsigned long cur_index = first_index;
+	unsigned int ret = 0;
+
+	while (ret < max_items) {
+		unsigned int nr_found;
+		unsigned long next_index;	/* Index of next search */
+
+		if (cur_index > max_index)
+			break;
+		nr_found = __lookup_tag(root, results + ret, cur_index,
+					max_items - ret, &next_index, tag);
+		ret += nr_found;
+		if (next_index == 0)
+			break;
+		cur_index = next_index;
+	}
+	return ret;
+}
+
+#endif
+
+/**
+ *	radix_tree_shrink    -    shrink height of a radix tree to minimal
+ *	@root		radix tree root
+ */
+static inline void radix_tree_shrink(struct radix_tree_root *root)
+{
+	/* try to shrink tree height */
+	while (root->height > 1 &&
+			root->rnode->count == 1 &&
+			root->rnode->slots[0]) {
+		struct radix_tree_node *to_free = root->rnode;
+
+		root->rnode = to_free->slots[0];
+		root->height--;
+		/* must only free zeroed nodes into the slab */
+#ifdef RADIX_TREE_TAGS
+		tag_clear(to_free, 0, 0);
+		tag_clear(to_free, 1, 0);
+#endif
+		to_free->slots[0] = NULL;
+		to_free->count = 0;
+		radix_tree_node_free(to_free);
+	}
+}
+
+/**
+ *	radix_tree_delete    -    delete an item from a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Remove the item at @index from the radix tree rooted at @root.
+ *
+ *	Returns the address of the deleted item, or NULL if it was not present.
+ */
+void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
+{
+	struct radix_tree_path path[RADIX_TREE_MAX_PATH], *pathp = path;
+	struct radix_tree_path *orig_pathp;
+	struct radix_tree_node *slot;
+	unsigned int height, shift;
+	void *ret = NULL;
+#ifdef RADIX_TREE_TAGS
+	char tags[RADIX_TREE_MAX_TAGS];
+	int nr_cleared_tags;
+	int tag;
+#endif
+	int offset;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		goto out;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	pathp->node = NULL;
+	slot = root->rnode;
+
+	for ( ; height > 0; height--) {
+		if (slot == NULL)
+			goto out;
+
+		pathp++;
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		pathp->offset = offset;
+		pathp->node = slot;
+		slot = slot->slots[offset];
+		shift -= RADIX_TREE_MAP_SHIFT;
+	}
+
+	ret = slot;
+	if (ret == NULL)
+		goto out;
+
+	orig_pathp = pathp;
+
+#ifdef RADIX_TREE_TAGS
+	/*
+	 * Clear all tags associated with the just-deleted item
+	 */
+	nr_cleared_tags = 0;
+	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
+		tags[tag] = 1;
+		if (tag_get(pathp->node, tag, pathp->offset)) {
+			tag_clear(pathp->node, tag, pathp->offset);
+			if (!any_tag_set(pathp->node, tag)) {
+				tags[tag] = 0;
+				nr_cleared_tags++;
+			}
+		}
+	}
+
+	for (pathp--; nr_cleared_tags && pathp->node; pathp--) {
+		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
+			if (tags[tag])
+				continue;
+
+			tag_clear(pathp->node, tag, pathp->offset);
+			if (any_tag_set(pathp->node, tag)) {
+				tags[tag] = 1;
+				nr_cleared_tags--;
+			}
+		}
+	}
+#endif
+	/* Now free the nodes we do not need anymore */
+	for (pathp = orig_pathp; pathp->node; pathp--) {
+		pathp->node->slots[pathp->offset] = NULL;
+		pathp->node->count--;
+
+		if (pathp->node->count) {
+			if (pathp->node == root->rnode)
+				radix_tree_shrink(root);
+			goto out;
+		}
+
+		/* Node with zero slots in use so free it */
+		radix_tree_node_free(pathp->node);
+	}
+	root->rnode = NULL;
+	root->height = 0;
+out:
+	return ret;
+}
+
+#ifdef RADIX_TREE_TAGS
+/**
+ *	radix_tree_tagged - test whether any items in the tree are tagged
+ *	@root:		radix tree root
+ *	@tag:		tag to test
+ */
+int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag)
+{
+  	struct radix_tree_node *rnode;
+  	rnode = root->rnode;
+  	if (!rnode)
+  		return 0;
+	return any_tag_set(rnode, tag);
+}
+#endif
+
+static unsigned long __maxindex(unsigned int height)
+{
+	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
+	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
+
+	if (tmp >= RADIX_TREE_INDEX_BITS)
+		index = ~0UL;
+	return index;
+}
+
+static void radix_tree_init_maxindex(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(height_to_maxindex); i++)
+		height_to_maxindex[i] = __maxindex(i);
+}
+
+void radix_tree_init(void)
+{
+	radix_tree_init_maxindex();
+}
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 1c60f38..9382c56 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -36,8 +36,7 @@ libxfs_trans_alloc(
 	}
 	ptr->t_mountp = mp;
 	ptr->t_type = type;
-	ptr->t_items_free = XFS_LIC_NUM_SLOTS;
-	xfs_lic_init(&ptr->t_items);
+	INIT_LIST_HEAD(&ptr->t_items);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "allocated new transaction %p\n", ptr);
 #endif
@@ -139,7 +138,6 @@ libxfs_trans_iput(
 	uint			lock_flags)
 {
 	xfs_inode_log_item_t	*iip;
-	xfs_log_item_desc_t	*lidp;
 
 	if (tp == NULL) {
 		libxfs_iput(ip, lock_flags);
@@ -149,12 +147,7 @@ libxfs_trans_iput(
 	ASSERT(ip->i_transp == tp);
 	iip = ip->i_itemp;
 	ASSERT(iip != NULL);
-
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)iip);
-	ASSERT(lidp != NULL);
-	ASSERT(lidp->lid_item == (xfs_log_item_t *)iip);
-	ASSERT(!(lidp->lid_flags & XFS_LID_DIRTY));
-	xfs_trans_free_item(tp, lidp);
+	xfs_trans_del_item(&iip->ili_item);
 
 	libxfs_iput(ip, lock_flags);
 }
@@ -183,6 +176,23 @@ libxfs_trans_ijoin(
 }
 
 void
+libxfs_trans_ijoin_ref(
+	xfs_trans_t		*tp,
+	xfs_inode_t		*ip,
+	int			lock_flags)
+{
+	ASSERT(ip->i_transp == tp);
+	ASSERT(ip->i_itemp != NULL);
+
+	xfs_trans_ijoin(tp, ip, lock_flags);
+	ip->i_itemp->ili_lock_flags = lock_flags;
+
+#ifdef XACT_DEBUG
+	fprintf(stderr, "ijoin_ref'd inode %llu, transaction %p\n", ip->i_ino, tp);
+#endif
+}
+
+void
 libxfs_trans_ihold(
 	xfs_trans_t		*tp,
 	xfs_inode_t		*ip)
@@ -190,7 +200,8 @@ libxfs_trans_ihold(
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 
-	ip->i_itemp->ili_flags |= XFS_ILI_HOLD;
+	ip->i_itemp->ili_lock_flags = 1;
+
 #ifdef XACT_DEBUG
 	fprintf(stderr, "ihold'd inode %llu, transaction %p\n", ip->i_ino, tp);
 #endif
@@ -224,19 +235,14 @@ xfs_trans_log_inode(
 	xfs_inode_t		*ip,
 	uint			flags)
 {
-	xfs_log_item_desc_t	*lidp;
-
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "dirtied inode %llu, transaction %p\n", ip->i_ino, tp);
 #endif
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(ip->i_itemp));
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	ip->i_itemp->ili_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
 	/*
 	 * Always OR in the bits from the ili_last_fields field.
@@ -266,7 +272,6 @@ libxfs_trans_log_buf(
 	uint			last)
 {
 	xfs_buf_log_item_t	*bip;
-	xfs_log_item_desc_t	*lidp;
 
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
@@ -277,11 +282,8 @@ libxfs_trans_log_buf(
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)bip);
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	xfs_buf_item_log(bip, first, last);
 }
 
@@ -291,7 +293,6 @@ libxfs_trans_brelse(
 	xfs_buf_t		*bp)
 {
 	xfs_buf_log_item_t	*bip;
-	xfs_log_item_desc_t	*lidp;
 #ifdef XACT_DEBUG
 	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
 #endif
@@ -304,8 +305,6 @@ libxfs_trans_brelse(
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
-	ASSERT(lidp != NULL);
 	if (bip->bli_recur > 0) {
 		bip->bli_recur--;
 		return;
@@ -313,9 +312,9 @@ libxfs_trans_brelse(
 	/* If dirty/stale, can't release till transaction committed */
 	if (bip->bli_flags & XFS_BLI_STALE)
 		return;
-	if (lidp->lid_flags & XFS_LID_DIRTY)
+	if (bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY)
 		return;
-	xfs_trans_free_item(tp, lidp);
+	xfs_trans_del_item(&bip->bli_item);
 	if (bip->bli_flags & XFS_BLI_HOLD)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
 	XFS_BUF_SET_FSPRIVATE2(bp, NULL);
@@ -327,7 +326,6 @@ libxfs_trans_binval(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
-	xfs_log_item_desc_t	*lidp;
 	xfs_buf_log_item_t	*bip;
 #ifdef XACT_DEBUG
 	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
@@ -337,17 +335,15 @@ libxfs_trans_binval(
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
-	ASSERT(lidp != NULL);
 	if (bip->bli_flags & XFS_BLI_STALE)
 		return;
 	XFS_BUF_UNDELAYWRITE(bp);
 	XFS_BUF_STALE(bp);
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~XFS_BLI_DIRTY;
-	bip->bli_format.blf_flags &= ~XFS_BLI_INODE_BUF;
-	bip->bli_format.blf_flags |= XFS_BLI_CANCEL;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
+	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
@@ -402,10 +398,7 @@ libxfs_trans_get_buf(
 		return libxfs_getbuf(dev, d, len);
 
 	bdev.dev = dev;
-	if (tp->t_items.lic_next == NULL)
-		bp = xfs_trans_buf_item_match(tp, &bdev, d, len);
-	else
-		bp = xfs_trans_buf_item_match_all(tp, &bdev, d, len);
+	bp = xfs_trans_buf_item_match(tp, &bdev, d, len);
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -447,10 +440,7 @@ libxfs_trans_getsb(
 
 	bdev.dev = mp->m_dev;
 	len = XFS_FSS_TO_BB(mp, 1);
-	if (tp->t_items.lic_next == NULL)
-		bp = xfs_trans_buf_item_match(tp, &bdev, XFS_SB_DADDR, len);
-	else
-		bp = xfs_trans_buf_item_match_all(tp, &bdev, XFS_SB_DADDR, len);
+	bp = xfs_trans_buf_item_match(tp, &bdev, XFS_SB_DADDR, len);
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -494,10 +484,7 @@ libxfs_trans_read_buf(
 	}
 
 	bdev.dev = dev;
-	if (tp->t_items.lic_next == NULL)
-		bp = xfs_trans_buf_item_match(tp, &bdev, blkno, len);
-	else
-		bp = xfs_trans_buf_item_match_all(tp, &bdev, blkno, len);
+	bp = xfs_trans_buf_item_match(tp, &bdev, blkno, len);
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
@@ -574,13 +561,11 @@ inode_item_done(
 	xfs_inode_t		*ip;
 	xfs_mount_t		*mp;
 	xfs_buf_t		*bp;
-	int			hold;
 	int			error;
 	extern kmem_zone_t	*xfs_ili_zone;
 
 	ip = iip->ili_inode;
 	mp = iip->ili_item.li_mountp;
-	hold = iip->ili_flags & XFS_ILI_HOLD;
 	ASSERT(ip != NULL);
 
 	if (!(iip->ili_format.ilf_fields & XFS_ILOG_ALL)) {
@@ -592,7 +577,7 @@ inode_item_done(
 	/*
 	 * Get the buffer containing the on-disk inode.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &bp, 0, 0, 0);
+	error = xfs_itobp(mp, NULL, ip, &dip, &bp, 0);
 	if (error) {
 		fprintf(stderr, _("%s: warning - itobp failed (%d)\n"),
 			progname, error);
@@ -613,11 +598,11 @@ inode_item_done(
 	libxfs_writebuf(bp, 0);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "flushing dirty inode %llu, buffer %p (hold=%u)\n",
-			ip->i_ino, bp, hold);
+			ip->i_ino, bp, iip->ili_lock_flags);
 #endif
 ili_done:
-	if (hold) {
-		iip->ili_flags &= ~XFS_ILI_HOLD;
+	if (iip->ili_lock_flags) {
+		iip->ili_lock_flags = 0;
 		return;
 	} else {
 		libxfs_iput(ip, 0);
@@ -659,63 +644,26 @@ buf_item_done(
 	kmem_zone_free(xfs_buf_item_zone, bip);
 }
 
-/*
- * This is called to perform the commit processing for each
- * item described by the given chunk.
- */
 static void
-trans_chunk_committed(
-	xfs_log_item_chunk_t	*licp)
+trans_committed(
+	xfs_trans_t		*tp)
 {
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_t		*lip;
-	int			i;
-
-	lidp = licp->lic_descs;
-	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		if (xfs_lic_isfree(licp, i))
-			continue;
-		lip = lidp->lid_item;
+        struct xfs_log_item_desc *lidp, *next;
+
+        list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
+		struct xfs_log_item *lip = lidp->lid_item;
+
+                xfs_trans_del_item(lip);
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_done((xfs_buf_log_item_t *)lidp->lid_item);
+			buf_item_done((xfs_buf_log_item_t *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
-			inode_item_done((xfs_inode_log_item_t *)lidp->lid_item);
+			inode_item_done((xfs_inode_log_item_t *)lip);
 		else {
 			fprintf(stderr, _("%s: unrecognised log item type\n"),
 				progname);
 			ASSERT(0);
 		}
-	}
-}
-
-/*
- * Calls trans_chunk_committed() to process the items in each chunk.
- */
-static void
-trans_committed(
-	xfs_trans_t		*tp)
-{
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
-
-	/*
-	 * Special case the chunk embedded in the transaction.
-	 */
-	licp = &(tp->t_items);
-	if (!(xfs_lic_are_all_free(licp))) {
-		trans_chunk_committed(licp);
-	}
-
-	/*
-	 * Process the items in each chunk in turn.
-	 */
-	licp = licp->lic_next;
-	while (licp != NULL) {
-		trans_chunk_committed(licp);
-		next_licp = licp->lic_next;
-		kmem_free(licp);
-		licp = next_licp;
-	}
+        }
 }
 
 static void
@@ -729,9 +677,9 @@ buf_item_unlock(
 	XFS_BUF_SET_FSPRIVATE2(bip->bli_buf, NULL);
 
 	hold = bip->bli_flags & XFS_BLI_HOLD;
+	bip->bli_flags &= ~XFS_BLI_HOLD;
 	if (!hold)
 		libxfs_putbuf(bp);
-	bip->bli_flags &= ~XFS_BLI_HOLD;
 }
 
 static void
@@ -739,75 +687,44 @@ inode_item_unlock(
 	xfs_inode_log_item_t	*iip)
 {
 	xfs_inode_t		*ip = iip->ili_inode;
-	uint			hold;
 
 	/* Clear the transaction pointer in the inode. */
 	ip->i_transp = NULL;
 
-	hold = iip->ili_flags & XFS_ILI_HOLD;
-	if (!hold)
-		libxfs_iput(ip, 0);
 	iip->ili_flags = 0;
+	if (!iip->ili_lock_flags) {
+		iip->ili_lock_flags = 0;
+		libxfs_iput(ip, 0);
+	}
 }
 
 /*
- * Unlock each item pointed to by a descriptor in the given chunk.
- * Free descriptors pointing to items which are not dirty if freeing_chunk
- * is zero. If freeing_chunk is non-zero, then we need to unlock all
- * items in the chunk.	Return the number of descriptors freed.
- * Originally based on xfs_trans_unlock_chunk() - adapted for libxfs
- * transactions though.
+ * Unlock all of the items of a transaction and free all the descriptors
+ * of that transaction.
  */
-int
-xfs_trans_unlock_chunk(
-	xfs_log_item_chunk_t	*licp,
-	int			freeing_chunk,
-	int			abort,
-	xfs_lsn_t		commit_lsn)	/* nb: unused */
+void
+xfs_trans_free_items(
+	struct xfs_trans	*tp,
+	int			flags)
 {
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_t		*lip;
-	int			i;
-	int			freed;
-
-	freed = 0;
-	lidp = licp->lic_descs;
-	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		if (xfs_lic_isfree(licp, i)) {
-			continue;
-		}
-		lip = lidp->lid_item;
-		lip->li_desc = NULL;
+	struct xfs_log_item_desc *lidp, *next;
 
-		/*
-		 * Disassociate the logged item from this transaction
-		 */
+	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
+		struct xfs_log_item	*lip = lidp->lid_item;
+
+                xfs_trans_del_item(lip);
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_unlock((xfs_buf_log_item_t *)lidp->lid_item);
+			buf_item_unlock((xfs_buf_log_item_t *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
-			inode_item_unlock((xfs_inode_log_item_t *)lidp->lid_item);
+			inode_item_unlock((xfs_inode_log_item_t *)lip);
 		else {
 			fprintf(stderr, _("%s: unrecognised log item type\n"),
 				progname);
 			ASSERT(0);
 		}
-
-		/*
-		 * Free the descriptor if the item is not dirty
-		 * within this transaction and the caller is not
-		 * going to just free the entire thing regardless.
-		 */
-		if (!(freeing_chunk) &&
-		    (!(lidp->lid_flags & XFS_LID_DIRTY) || abort)) {
-			xfs_lic_relse(licp, i);
-			freed++;
-		}
 	}
-
-	return (freed);
 }
 
-
 /*
  * Commit the changes represented by this transaction
  */
diff --git a/libxfs/util.c b/libxfs/util.c
index 077d2a2..bffbac0 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -28,7 +28,10 @@
  * where it's no longer worth the hassle of maintaining common code.
  */
 void
-libxfs_ichgtime(xfs_inode_t *ip, int flags)
+libxfs_trans_ichgtime(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			flags)
 {
 	struct timespec tv;
 	struct timeval	stv;
@@ -74,22 +77,26 @@ libxfs_iread(
 	ip->i_ino = ino;
 	ip->i_mount = mp;
 
-	/*
-	 * Get pointer's to the on-disk inode and the buffer containing it.
-	 * If the inode number refers to a block outside the file system
-	 * then xfs_itobp() will return NULL.  In this case we should
-	 * return NULL as well.  Set i_blkno to 0 so that xfs_itobp() will
-	 * know that this is a new incore inode.
-	 */
-	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, 0, XFS_BUF_LOCK);
-	if (error) 
-		return error;
+        /*
+         * Fill in the location information in the in-core inode.
+         */
+        error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, 0);
+        if (error)
+                return error;
+
+        /*
+         * Get pointers to the on-disk inode and the buffer containing it.
+         */
+        error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp, XBF_LOCK, 0);
+        if (error)
+                return error;
+        dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	/*
 	 * If we got something that isn't an inode it means someone
 	 * (nfs or dmi) has a stale handle.
 	 */
-	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC) {
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC) {
 		xfs_trans_brelse(tp, bp);
 		return EINVAL;
 	}
@@ -101,18 +108,18 @@ libxfs_iread(
 	 * specific information.
 	 * Otherwise, just get the truly permanent information.
 	 */
-	if (dip->di_core.di_mode) {
-		xfs_dinode_from_disk(&ip->i_d, &dip->di_core);
+	if (dip->di_mode) {
+		xfs_dinode_from_disk(&ip->i_d, dip);
 		error = xfs_iformat(ip, dip);
 		if (error)  {
 			xfs_trans_brelse(tp, bp);
 			return error;
 		}
 	} else {
-		ip->i_d.di_magic = be16_to_cpu(dip->di_core.di_magic);
-		ip->i_d.di_version = dip->di_core.di_version;
-		ip->i_d.di_gen = be32_to_cpu(dip->di_core.di_gen);
-		ip->i_d.di_flushiter = be16_to_cpu(dip->di_core.di_flushiter);
+		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
+		ip->i_d.di_version = dip->di_version;
+		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
+		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 		/*
 		 * Make sure to pull in the mode here as well in
 		 * case the inode is released without being used.
@@ -140,7 +147,7 @@ libxfs_iread(
 	 * the new format. We don't change the version number so that we
 	 * can distinguish this from a real new format inode.
 	 */
-	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
+	if (ip->i_d.di_version == 1) {
 		ip->i_d.di_nlink = ip->i_d.di_onlink;
 		ip->i_d.di_onlink = 0;
 		xfs_set_projid(&ip->i_d, 0);
@@ -229,8 +236,8 @@ libxfs_ialloc(
 	 * here rather than here and in the flush/logging code.
 	 */
 	if (xfs_sb_version_hasnlink(&tp->t_mountp->m_sb) &&
-	    ip->i_d.di_version == XFS_DINODE_VERSION_1) {
-		ip->i_d.di_version = XFS_DINODE_VERSION_2;
+	    ip->i_d.di_version == 1) {
+		ip->i_d.di_version = 2;
 		/*
 		 * old link count, projid_lo/hi field, pad field
 		 * already zeroed
@@ -246,7 +253,7 @@ libxfs_ialloc(
 	ip->i_d.di_size = 0;
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
-	xfs_ichgtime(ip, XFS_ICHGTIME_CHG|XFS_ICHGTIME_MOD);
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG|XFS_ICHGTIME_MOD);
 	/*
 	 * di_gen will have been taken care of in xfs_iread.
 	 */
@@ -398,7 +405,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	mp = ip->i_mount;
 
 	/* set *dip = inode's place in the buffer */
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_boffset);
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	ASSERT(ip->i_d.di_magic == XFS_DINODE_MAGIC);
 	if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
@@ -419,7 +426,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	 * because if the inode is dirty at all the core must
 	 * be.
 	 */
-	xfs_dinode_to_disk(&dip->di_core, &ip->i_d);
+	xfs_dinode_to_disk(dip, &ip->i_d);
 
 	/*
 	 * If this is really an old format inode and the superblock version
@@ -427,28 +434,27 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	 * convert back to the old inode format.  If the superblock version
 	 * has been updated, then make the conversion permanent.
 	 */
-	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1 ||
+	ASSERT(ip->i_d.di_version == 1 ||
 		xfs_sb_version_hasnlink(&mp->m_sb));
-	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
+	if (ip->i_d.di_version == 1) {
 		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
 			/*
 			 * Convert it back.
 			 */
 			ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
-			dip->di_core.di_onlink = cpu_to_be16(ip->i_d.di_nlink);
+			dip->di_onlink = cpu_to_be16(ip->i_d.di_nlink);
 		} else {
 			/*
 			 * The superblock version has already been bumped,
 			 * so just make the conversion to the new inode
 			 * format permanent.
 			 */
-			ip->i_d.di_version = XFS_DINODE_VERSION_2;
-			dip->di_core.di_version =  XFS_DINODE_VERSION_2;
+			ip->i_d.di_version = 2;
+			dip->di_version =  2;
 			ip->i_d.di_onlink = 0;
-			dip->di_core.di_onlink = 0;
+			dip->di_onlink = 0;
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-			memset(&(dip->di_core.di_pad[0]), 0,
-			      sizeof(dip->di_core.di_pad));
+			memset(&(dip->di_pad[0]), 0, sizeof(dip->di_pad));
 			ASSERT(xfs_get_projid(ip->i_d) == 0);
 		}
 	}
@@ -571,10 +577,11 @@ libxfs_alloc_file_space(
 		xfs_trans_ijoin(tp, ip, 0);
 		xfs_trans_ihold(tp, ip);
 
-		XFS_BMAP_INIT(&free_list, &firstfsb);
+		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bmapi(tp, ip, startoffset_fsb, allocatesize_fsb,
 				xfs_bmapi_flags, &firstfsb, 0, imapp,
-				&reccount, &free_list, NULL);
+				&reccount, &free_list);
+
 		if (error)
 			break;
 
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 8e94dad..b3f8378 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -51,9 +51,9 @@ typedef __uint32_t		inst_t;		/* an instruction */
 
 
 #define m_ddev_targp 			m_dev
+#define xfs_error_level			0
 
 #define STATIC				static
-#define STATIC_INLINE			static inline
 
 #define ATTR_ROOT			LIBXFS_ATTR_ROOT
 #define ATTR_SECURE			LIBXFS_ATTR_SECURE
@@ -83,10 +83,6 @@ typedef __uint32_t		inst_t;		/* an instruction */
 #define XFS_WANT_CORRUPTED_RETURN(expr)	\
 		{ if (!(expr)) { return EFSCORRUPTED; } }
 
-#define TRACE_FREE(s,a,b,x,f)		((void) 0)
-#define TRACE_ALLOC(s,a)		((void) 0)
-#define TRACE_MODAGF(a,b,c)		((void) 0)
-
 #ifdef __GNUC__
 #define __return_address	__builtin_return_address(0)
 #endif
@@ -99,6 +95,8 @@ typedef __uint32_t		inst_t;		/* an instruction */
 #define spin_unlock(a)		((void) 0)
 #define likely(x)		(x)
 #define unlikely(x)		(x)
+#define rcu_read_lock()		((void) 0)
+#define rcu_read_unlock()	((void) 0)
 
 /*
  * random32 is used for di_gen inode allocation, it must be zero for libxfs
@@ -108,8 +106,6 @@ typedef __uint32_t		inst_t;		/* an instruction */
 
 #define PAGE_CACHE_SIZE 	getpagesize()
 
-#define INIT_LIST_HEAD(x)
-
 static inline int __do_div(unsigned long long *n, unsigned base)
 {
 	int __res;
@@ -192,6 +188,9 @@ roundup_pow_of_two(uint v)
 /* buffer management */
 #define XFS_BUF_LOCK			0
 #define XFS_BUF_TRYLOCK			0
+#define XBF_LOCK			XFS_BUF_LOCK
+#define XBF_TRYLOCK			XFS_BUF_TRYLOCK
+#define XBF_DONT_BLOCK			0
 #define XFS_BUF_GETERROR(bp)		0
 #define XFS_BUF_DONE(bp)		((bp)->b_flags |= LIBXFS_B_UPTODATE)
 #define XFS_BUF_ISDONE(bp)		((bp)->b_flags & LIBXFS_B_UPTODATE)
@@ -206,14 +205,14 @@ roundup_pow_of_two(uint v)
 #define xfs_read_buf(mp,devp,blkno,len,f,bpp)	\
 					(*(bpp) = libxfs_readbuf((devp), \
 							(blkno), (len), 1), 0)
-#define xfs_buf_get_flags(devp,blkno,len,f)	\
+#define xfs_buf_get(devp,blkno,len,f)	\
 					(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(mp,bp)		libxfs_writebuf((bp), 0)
 
-#define XFS_B_READ			LIBXFS_BREAD
-#define XFS_B_WRITE			LIBXFS_BWRITE
-#define xfs_biomove(bp,off,len,data,f)	libxfs_iomove(bp,off,len,data,f)
-#define xfs_biozero(bp,off,len)		libxfs_iomove(bp,off,len,0,LIBXFS_BZERO)
+#define XBRW_READ			LIBXFS_BREAD
+#define XBRW_WRITE			LIBXFS_BWRITE
+#define xfs_buf_iomove(bp,off,len,data,f)	libxfs_iomove(bp,off,len,data,f)
+#define xfs_buf_zero(bp,off,len)	libxfs_iomove(bp,off,len,0,LIBXFS_BZERO)
 
 /* mount stuff */
 #define XFS_MOUNT_32BITINODES		LIBXFS_MOUNT_32BITINODES
@@ -222,6 +221,9 @@ roundup_pow_of_two(uint v)
 #define XFS_MOUNT_WSYNC			0	/* ignored in userspace */
 #define XFS_MOUNT_NOALIGN		0	/* ignored in userspace */
 
+#define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
+	xfs_mod_incore_sb(mp, field, delta, rsvd)
+
 /*
  * Map XFS kernel routine names to libxfs versions
  */
@@ -236,7 +238,7 @@ roundup_pow_of_two(uint v)
 #define xfs_fs_cmn_err			libxfs_fs_cmn_err
 
 #define xfs_bmap_finish			libxfs_bmap_finish
-#define xfs_ichgtime			libxfs_ichgtime
+#define xfs_trans_ichgtime		libxfs_trans_ichgtime
 #define xfs_mod_incore_sb		libxfs_mod_incore_sb
 
 #define xfs_trans_alloc			libxfs_trans_alloc
@@ -252,6 +254,7 @@ roundup_pow_of_two(uint v)
 #define xfs_trans_iget			libxfs_trans_iget
 #define xfs_trans_ihold			libxfs_trans_ihold
 #define xfs_trans_ijoin			libxfs_trans_ijoin
+#define xfs_trans_ijoin_ref		libxfs_trans_ijoin_ref
 #define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
 #define xfs_trans_log_buf		libxfs_trans_log_buf
 #define xfs_trans_log_inode		libxfs_trans_log_inode
@@ -265,7 +268,7 @@ roundup_pow_of_two(uint v)
 #define	xfs_trans_agflist_delta(tp, d)
 #define	xfs_trans_agbtree_delta(tp, d)
 
-#define xfs_baread(a,b,c)		((void) 0)	/* no readahead */
+#define xfs_buf_readahead(a,b,c)	((void) 0)	/* no readahead */
 #define xfs_btree_reada_bufl(m,fsb,c)	((void) 0)
 #define xfs_btree_reada_bufs(m,fsb,c,x)	((void) 0)
 #define xfs_buftrace(x,y)		((void) 0)	/* debug only */
@@ -289,8 +292,12 @@ roundup_pow_of_two(uint v)
 #define xfs_iunlock(ip,mode)				((void) 0)
 
 /* space allocation */
-#define xfs_alloc_search_busy(tp,ag,b,len)	((void) 0)
-#define xfs_alloc_mark_busy(tp,ag,b,len)	((void) 0)
+#define xfs_alloc_busy_search(tp,ag,b,len)	0
+/* avoid unused variable warning */
+#define xfs_alloc_busy_insert(tp,ag,b,len)	({	\
+	xfs_agnumber_t __foo = ag;			\
+	__foo = 0;					\
+})
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(ENOSYS)
 #define xfs_rtpick_extent(mp,tp,len,p)		(ENOSYS)
@@ -329,10 +336,9 @@ void xfs_mount_common(xfs_mount_t *, xfs_sb_t *);
  */
 
 /* xfs_trans_item.c */
-xfs_log_item_desc_t *xfs_trans_add_item (xfs_trans_t *, xfs_log_item_t *);
-xfs_log_item_desc_t *xfs_trans_find_item (xfs_trans_t *, xfs_log_item_t *);
-void xfs_trans_free_item (xfs_trans_t *, xfs_log_item_desc_t *);
-void xfs_trans_free_items (xfs_trans_t *, int);
+void xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
+void xfs_trans_del_item(struct xfs_log_item *);
+void xfs_trans_free_items(struct xfs_trans *, int);
 
 /* xfs_inode_item.c */
 void xfs_inode_item_init (xfs_inode_t *, xfs_mount_t *);
@@ -344,10 +350,7 @@ void xfs_buf_item_log (xfs_buf_log_item_t *, uint, uint);
 /* xfs_trans_buf.c */
 xfs_buf_t *xfs_trans_buf_item_match (xfs_trans_t *, xfs_buftarg_t *,
 			xfs_daddr_t, int);
-xfs_buf_t *xfs_trans_buf_item_match_all (xfs_trans_t *, xfs_buftarg_t *,
-			xfs_daddr_t, int);
 
 /* local source files */
 int  xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 void xfs_trans_mod_sb(xfs_trans_t *, uint, long);
-int  xfs_trans_unlock_chunk (xfs_log_item_chunk_t *, int, int, xfs_lsn_t);
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 77013ab..a76512d 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -494,9 +494,6 @@ xfs_alloc_ag_vextent(
 	 */
 	if (args->agbno != NULLAGBLOCK) {
 		xfs_agf_t	*agf;	/* allocation group freelist header */
-#ifdef XFS_ALLOC_TRACE
-		xfs_mount_t	*mp = args->mp;
-#endif
 		long		slen = (long)args->len;
 
 		ASSERT(args->len >= args->minlen && args->len <= args->maxlen);
@@ -511,12 +508,18 @@ xfs_alloc_ag_vextent(
 			args->pag->pagf_freeblks -= args->len;
 			ASSERT(be32_to_cpu(agf->agf_freeblks) <=
 				be32_to_cpu(agf->agf_length));
-			TRACE_MODAGF(NULL, agf, XFS_AGF_FREEBLKS);
 			xfs_alloc_log_agf(args->tp, args->agbp,
 						XFS_AGF_FREEBLKS);
-			/* search the busylist for these blocks */
-			xfs_alloc_search_busy(args->tp, args->agno,
-					args->agbno, args->len);
+			/*
+			 * Search the busylist for these blocks and mark the
+			 * transaction as synchronous if blocks are found. This
+			 * avoids the need to block due to a synchronous log
+			 * force to ensure correct ordering as the synchronous
+			 * transaction will guarantee that for us.
+			 */
+			if (xfs_alloc_busy_search(args->mp, args->agno,
+						args->agbno, args->len))
+				xfs_trans_set_sync(args->tp);
 		}
 		if (!args->isfl)
 			xfs_trans_mod_sb(args->tp,
@@ -555,57 +558,53 @@ xfs_alloc_ag_vextent_exact(
 	 * Allocate/initialize a cursor for the by-number freespace btree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO);
+					  args->agno, XFS_BTNUM_BNO);
+
 	/*
 	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
 	 * Look for the closest free block <= bno, it must contain bno
 	 * if any free block does.
 	 */
-	if ((error = xfs_alloc_lookup_le(bno_cur, args->agbno, args->minlen, &i)))
+	error = xfs_alloc_lookup_le(bno_cur, args->agbno, args->minlen, &i);
+	if (error)
 		goto error0;
-	if (!i) {
-		/*
-		 * Didn't find it, return null.
-		 */
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
+	if (!i)
+		goto not_found;
+
 	/*
 	 * Grab the freespace record.
 	 */
-	if ((error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i)))
+	error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
+	if (error)
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	ASSERT(fbno <= args->agbno);
 	minend = args->agbno + args->minlen;
 	maxend = args->agbno + args->maxlen;
 	fend = fbno + flen;
+
 	/*
 	 * Give up if the freespace isn't long enough for the minimum request.
 	 */
-	if (fend < minend) {
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
+	if (fend < minend)
+		goto not_found;
+
 	/*
 	 * End of extent will be smaller of the freespace end and the
 	 * maximal requested end.
-	 */
-	end = XFS_AGBLOCK_MIN(fend, maxend);
-	/*
+	 *
 	 * Fix the length according to mod and prod if given.
 	 */
+	end = XFS_AGBLOCK_MIN(fend, maxend);
 	args->len = end - args->agbno;
 	xfs_alloc_fix_len(args);
-	if (!xfs_alloc_fix_minleft(args)) {
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		return 0;
-	}
+	if (!xfs_alloc_fix_minleft(args))
+		goto not_found;
+
 	rlen = args->len;
 	ASSERT(args->agbno + rlen <= fend);
 	end = args->agbno + rlen;
+
 	/*
 	 * We are allocating agbno for rlen [agbno .. end]
 	 * Allocate/initialize a cursor for the by-size btree.
@@ -614,20 +613,117 @@ xfs_alloc_ag_vextent_exact(
 		args->agno, XFS_BTNUM_CNT);
 	ASSERT(args->agbno + args->len <=
 		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
-			args->agbno, args->len, XFSA_FIXUP_BNO_OK))) {
+	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
+				      args->len, XFSA_FIXUP_BNO_OK);
+	if (error) {
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
 		goto error0;
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-	TRACE_ALLOC("normal", args);
 	args->wasfromfl = 0;
+	trace_xfs_alloc_exact_done(args);
+	return 0;
+
+not_found:
+	/* Didn't find it, return null. */
+	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
+	args->agbno = NULLAGBLOCK;
+	trace_xfs_alloc_exact_notfound(args);
 	return 0;
 
 error0:
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
-	TRACE_ALLOC("error", args);
+	trace_xfs_alloc_exact_error(args);
+	return error;
+}
+
+/*
+ * Search the btree in a given direction via the search cursor and compare
+ * the records found against the good extent we've already found.
+ */
+STATIC int
+xfs_alloc_find_best_extent(
+	struct xfs_alloc_arg	*args,	/* allocation argument structure */
+	struct xfs_btree_cur	**gcur,	/* good cursor */
+	struct xfs_btree_cur	**scur,	/* searching cursor */
+	xfs_agblock_t		gdiff,	/* difference for search comparison */
+	xfs_agblock_t		*sbno,	/* extent found by search */
+	xfs_extlen_t		*slen,
+	xfs_extlen_t		*slena,	/* aligned length */
+	int			dir)	/* 0 = search right, 1 = search left */
+{
+	xfs_agblock_t		bno;
+	xfs_agblock_t		new;
+	xfs_agblock_t		sdiff;
+	int			error;
+	int			i;
+
+	/* The good extent is perfect, no need to  search. */
+	if (!gdiff)
+		goto out_use_good;
+
+	/*
+	 * Look until we find a better one, run out of space or run off the end.
+	 */
+	do {
+		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		xfs_alloc_compute_aligned(*sbno, *slen, args->alignment,
+					  args->minlen, &bno, slena);
+
+		/*
+		 * The good extent is closer than this one.
+		 */
+		if (!dir) {
+			if (bno >= args->agbno + gdiff)
+				goto out_use_good;
+		} else {
+			if (bno <= args->agbno - gdiff)
+				goto out_use_good;
+		}
+
+		/*
+		 * Same distance, compare length and pick the best.
+		 */
+		if (*slena >= args->minlen) {
+			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
+			xfs_alloc_fix_len(args);
+
+			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
+						       args->alignment, *sbno,
+						       *slen, &new);
+
+			/*
+			 * Choose closer size and invalidate other cursor.
+			 */
+			if (sdiff < gdiff)
+				goto out_use_search;
+			goto out_use_good;
+		}
+
+		if (!dir)
+			error = xfs_btree_increment(*scur, 0, &i);
+		else
+			error = xfs_btree_decrement(*scur, 0, &i);
+		if (error)
+			goto error0;
+	} while (i);
+
+out_use_good:
+	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
+	*scur = NULL;
+	return 0;
+
+out_use_search:
+	xfs_btree_del_cursor(*gcur, XFS_BTREE_NOERROR);
+	*gcur = NULL;
+	return 0;
+
+error0:
+	/* caller invalidates cursors */
 	return error;
 }
 
@@ -648,7 +744,7 @@ xfs_alloc_ag_vextent_near(
 	xfs_agblock_t	gtbnoa;		/* aligned ... */
 	xfs_extlen_t	gtdiff;		/* difference to right side entry */
 	xfs_extlen_t	gtlen;		/* length of right side entry */
-	xfs_extlen_t	gtlena;		/* aligned ... */
+	xfs_extlen_t	gtlena = 0;	/* aligned ... */
 	xfs_agblock_t	gtnew;		/* useful start bno of right side */
 	int		error;		/* error code */
 	int		i;		/* result code, temporary */
@@ -656,10 +752,8 @@ xfs_alloc_ag_vextent_near(
 	xfs_agblock_t	ltbno;		/* start bno of left side entry */
 	xfs_agblock_t	ltbnoa;		/* aligned ... */
 	xfs_extlen_t	ltdiff;		/* difference to left side entry */
-	/*REFERENCED*/
-	xfs_agblock_t	ltend;		/* end bno of left side entry */
 	xfs_extlen_t	ltlen;		/* length of left side entry */
-	xfs_extlen_t	ltlena;		/* aligned ... */
+	xfs_extlen_t	ltlena = 0;	/* aligned ... */
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
 	xfs_extlen_t	rlen;		/* length of returned extent */
 #if defined(DEBUG) && defined(__KERNEL__)
@@ -782,12 +876,11 @@ xfs_alloc_ag_vextent_near(
 		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		ltend = ltbno + ltlen;
-		ASSERT(ltend <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 		args->len = blen;
 		if (!xfs_alloc_fix_minleft(args)) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-			TRACE_ALLOC("nominleft", args);
+			trace_xfs_alloc_near_nominleft(args);
 			return 0;
 		}
 		blen = args->len;
@@ -796,7 +889,7 @@ xfs_alloc_ag_vextent_near(
 		 */
 		args->agbno = bnew;
 		ASSERT(bnew >= ltbno);
-		ASSERT(bnew + blen <= ltend);
+		ASSERT(bnew + blen <= ltbno + ltlen);
 		/*
 		 * Set up a cursor for the by-bno tree.
 		 */
@@ -810,7 +903,8 @@ xfs_alloc_ag_vextent_near(
 			goto error0;
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
-		TRACE_ALLOC("first", args);
+
+		trace_xfs_alloc_near_first(args);
 		return 0;
 	}
 	/*
@@ -900,211 +994,55 @@ xfs_alloc_ag_vextent_near(
 			}
 		}
 	} while (bno_cur_lt || bno_cur_gt);
+
 	/*
 	 * Got both cursors still active, need to find better entry.
 	 */
 	if (bno_cur_lt && bno_cur_gt) {
-		/*
-		 * Left side is long enough, look for a right side entry.
-		 */
 		if (ltlena >= args->minlen) {
 			/*
-			 * Fix up the length.
+			 * Left side is good, look for a right side entry.
 			 */
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			rlen = args->len;
-			ltdiff = xfs_alloc_compute_diff(args->agbno, rlen,
+			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
 				args->alignment, ltbno, ltlen, &ltnew);
+
+			error = xfs_alloc_find_best_extent(args,
+						&bno_cur_lt, &bno_cur_gt,
+						ltdiff, &gtbno, &gtlen, &gtlena,
+						0 /* search right */);
+		} else {
+			ASSERT(gtlena >= args->minlen);
+
 			/*
-			 * Not perfect.
-			 */
-			if (ltdiff) {
-				/*
-				 * Look until we find a better one, run out of
-				 * space, or run off the end.
-				 */
-				while (bno_cur_lt && bno_cur_gt) {
-					if ((error = xfs_alloc_get_rec(
-							bno_cur_gt, &gtbno,
-							&gtlen, &i)))
-						goto error0;
-					XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-					xfs_alloc_compute_aligned(gtbno, gtlen,
-						args->alignment, args->minlen,
-						&gtbnoa, &gtlena);
-					/*
-					 * The left one is clearly better.
-					 */
-					if (gtbnoa >= args->agbno + ltdiff) {
-						xfs_btree_del_cursor(
-							bno_cur_gt,
-							XFS_BTREE_NOERROR);
-						bno_cur_gt = NULL;
-						break;
-					}
-					/*
-					 * If we reach a big enough entry,
-					 * compare the two and pick the best.
-					 */
-					if (gtlena >= args->minlen) {
-						args->len =
-							XFS_EXTLEN_MIN(gtlena,
-								args->maxlen);
-						xfs_alloc_fix_len(args);
-						rlen = args->len;
-						gtdiff = xfs_alloc_compute_diff(
-							args->agbno, rlen,
-							args->alignment,
-							gtbno, gtlen, &gtnew);
-						/*
-						 * Right side is better.
-						 */
-						if (gtdiff < ltdiff) {
-							xfs_btree_del_cursor(
-								bno_cur_lt,
-								XFS_BTREE_NOERROR);
-							bno_cur_lt = NULL;
-						}
-						/*
-						 * Left side is better.
-						 */
-						else {
-							xfs_btree_del_cursor(
-								bno_cur_gt,
-								XFS_BTREE_NOERROR);
-							bno_cur_gt = NULL;
-						}
-						break;
-					}
-					/*
-					 * Fell off the right end.
-					 */
-					if ((error = xfs_btree_increment(
-							bno_cur_gt, 0, &i)))
-						goto error0;
-					if (!i) {
-						xfs_btree_del_cursor(
-							bno_cur_gt,
-							XFS_BTREE_NOERROR);
-						bno_cur_gt = NULL;
-						break;
-					}
-				}
-			}
-			/*
-			 * The left side is perfect, trash the right side.
-			 */
-			else {
-				xfs_btree_del_cursor(bno_cur_gt,
-						     XFS_BTREE_NOERROR);
-				bno_cur_gt = NULL;
-			}
-		}
-		/*
-		 * It's the right side that was found first, look left.
-		 */
-		else {
-			/*
-			 * Fix up the length.
+			 * Right side is good, look for a left side entry.
 			 */
 			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
 			xfs_alloc_fix_len(args);
-			rlen = args->len;
-			gtdiff = xfs_alloc_compute_diff(args->agbno, rlen,
+			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
 				args->alignment, gtbno, gtlen, &gtnew);
-			/*
-			 * Right side entry isn't perfect.
-			 */
-			if (gtdiff) {
-				/*
-				 * Look until we find a better one, run out of
-				 * space, or run off the end.
-				 */
-				while (bno_cur_lt && bno_cur_gt) {
-					if ((error = xfs_alloc_get_rec(
-							bno_cur_lt, &ltbno,
-							&ltlen, &i)))
-						goto error0;
-					XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-					xfs_alloc_compute_aligned(ltbno, ltlen,
-						args->alignment, args->minlen,
-						&ltbnoa, &ltlena);
-					/*
-					 * The right one is clearly better.
-					 */
-					if (ltbnoa <= args->agbno - gtdiff) {
-						xfs_btree_del_cursor(
-							bno_cur_lt,
-							XFS_BTREE_NOERROR);
-						bno_cur_lt = NULL;
-						break;
-					}
-					/*
-					 * If we reach a big enough entry,
-					 * compare the two and pick the best.
-					 */
-					if (ltlena >= args->minlen) {
-						args->len = XFS_EXTLEN_MIN(
-							ltlena, args->maxlen);
-						xfs_alloc_fix_len(args);
-						rlen = args->len;
-						ltdiff = xfs_alloc_compute_diff(
-							args->agbno, rlen,
-							args->alignment,
-							ltbno, ltlen, &ltnew);
-						/*
-						 * Left side is better.
-						 */
-						if (ltdiff < gtdiff) {
-							xfs_btree_del_cursor(
-								bno_cur_gt,
-								XFS_BTREE_NOERROR);
-							bno_cur_gt = NULL;
-						}
-						/*
-						 * Right side is better.
-						 */
-						else {
-							xfs_btree_del_cursor(
-								bno_cur_lt,
-								XFS_BTREE_NOERROR);
-							bno_cur_lt = NULL;
-						}
-						break;
-					}
-					/*
-					 * Fell off the left end.
-					 */
-					if ((error = xfs_btree_decrement(
-							bno_cur_lt, 0, &i)))
-						goto error0;
-					if (!i) {
-						xfs_btree_del_cursor(bno_cur_lt,
-							XFS_BTREE_NOERROR);
-						bno_cur_lt = NULL;
-						break;
-					}
-				}
-			}
-			/*
-			 * The right side is perfect, trash the left side.
-			 */
-			else {
-				xfs_btree_del_cursor(bno_cur_lt,
-					XFS_BTREE_NOERROR);
-				bno_cur_lt = NULL;
-			}
+
+			error = xfs_alloc_find_best_extent(args,
+						&bno_cur_gt, &bno_cur_lt,
+						gtdiff, &ltbno, &ltlen, &ltlena,
+						1 /* search left */);
 		}
+
+		if (error)
+			goto error0;
 	}
+
 	/*
 	 * If we couldn't get anything, give up.
 	 */
 	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
-		TRACE_ALLOC("neither", args);
+		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;
 	}
+
 	/*
 	 * At this point we have selected a freespace entry, either to the
 	 * left or to the right.  If it's on the right, copy all the
@@ -1121,14 +1059,14 @@ xfs_alloc_ag_vextent_near(
 		j = 1;
 	} else
 		j = 0;
+
 	/*
 	 * Fix up the length and compute the useful address.
 	 */
-	ltend = ltbno + ltlen;
 	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 	xfs_alloc_fix_len(args);
 	if (!xfs_alloc_fix_minleft(args)) {
-		TRACE_ALLOC("nominleft", args);
+		trace_xfs_alloc_near_nominleft(args);
 		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		return 0;
@@ -1137,19 +1075,24 @@ xfs_alloc_ag_vextent_near(
 	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment, ltbno,
 		ltlen, &ltnew);
 	ASSERT(ltnew >= ltbno);
-	ASSERT(ltnew + rlen <= ltend);
+	ASSERT(ltnew + rlen <= ltbno + ltlen);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 	args->agbno = ltnew;
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
 			ltnew, rlen, XFSA_FIXUP_BNO_OK)))
 		goto error0;
-	TRACE_ALLOC(j ? "gt" : "lt", args);
+
+	if (j)
+		trace_xfs_alloc_near_greater(args);
+	else
+		trace_xfs_alloc_near_lesser(args);
+
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 	xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
 	return 0;
 
  error0:
-	TRACE_ALLOC("error", args);
+	trace_xfs_alloc_near_error(args);
 	if (cnt_cur != NULL)
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
 	if (bno_cur_lt != NULL)
@@ -1200,7 +1143,7 @@ xfs_alloc_ag_vextent_size(
 			goto error0;
 		if (i == 0 || flen == 0) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-			TRACE_ALLOC("noentry", args);
+			trace_xfs_alloc_size_noentry(args);
 			return 0;
 		}
 		ASSERT(i == 1);
@@ -1277,7 +1220,7 @@ xfs_alloc_ag_vextent_size(
 	xfs_alloc_fix_len(args);
 	if (rlen < args->minlen || !xfs_alloc_fix_minleft(args)) {
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-		TRACE_ALLOC("nominleft", args);
+		trace_xfs_alloc_size_nominleft(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;
 	}
@@ -1300,11 +1243,11 @@ xfs_alloc_ag_vextent_size(
 		args->agbno + args->len <=
 			be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
 		error0);
-	TRACE_ALLOC("normal", args);
+	trace_xfs_alloc_size_done(args);
 	return 0;
 
 error0:
-	TRACE_ALLOC("error", args);
+	trace_xfs_alloc_size_error(args);
 	if (cnt_cur)
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
 	if (bno_cur)
@@ -1363,7 +1306,7 @@ xfs_alloc_ag_vextent_small(
 				be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
 				error0);
 			args->wasfromfl = 1;
-			TRACE_ALLOC("freelist", args);
+			trace_xfs_alloc_small_freelist(args);
 			*stat = 0;
 			return 0;
 		}
@@ -1385,17 +1328,17 @@ xfs_alloc_ag_vextent_small(
 	 */
 	if (flen < args->minlen) {
 		args->agbno = NULLAGBLOCK;
-		TRACE_ALLOC("notenough", args);
+		trace_xfs_alloc_small_notenough(args);
 		flen = 0;
 	}
 	*fbnop = fbno;
 	*flenp = flen;
 	*stat = 1;
-	TRACE_ALLOC("normal", args);
+	trace_xfs_alloc_small_done(args);
 	return 0;
 
 error0:
-	TRACE_ALLOC("error", args);
+	trace_xfs_alloc_small_error(args);
 	return error;
 }
 
@@ -1629,26 +1572,25 @@ xfs_free_ag_extent(
 		xfs_agf_t	*agf;
 		xfs_perag_t	*pag;		/* per allocation group data */
 
+		pag = xfs_perag_get(mp, agno);
+		pag->pagf_freeblks += len;
+		xfs_perag_put(pag);
+
 		agf = XFS_BUF_TO_AGF(agbp);
-		pag = &mp->m_perag[agno];
 		be32_add_cpu(&agf->agf_freeblks, len);
 		xfs_trans_agblocks_delta(tp, len);
-		pag->pagf_freeblks += len;
 		XFS_WANT_CORRUPTED_GOTO(
 			be32_to_cpu(agf->agf_freeblks) <=
 			be32_to_cpu(agf->agf_length),
 			error0);
-		TRACE_MODAGF(NULL, agf, XFS_AGF_FREEBLKS);
 		xfs_alloc_log_agf(tp, agbp, XFS_AGF_FREEBLKS);
 		if (!isfl)
 			xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (long)len);
 		XFS_STATS_INC(xs_freex);
 		XFS_STATS_ADD(xs_freeb, len);
 	}
-	TRACE_FREE(haveleft ?
-			(haveright ? "both" : "left") :
-			(haveright ? "right" : "none"),
-		agno, bno, len, isfl);
+
+	trace_xfs_free_extent(mp, agno, bno, len, isfl, haveleft, haveright);
 
 	/*
 	 * Since blocks move to the free list without the coordination
@@ -1661,11 +1603,11 @@ xfs_free_ag_extent(
 	 * when the iclog commits to disk.  If a busy block is allocated,
 	 * the iclog is pushed up to the LSN that freed the block.
 	 */
-	xfs_alloc_mark_busy(tp, agno, bno, len);
+	xfs_alloc_busy_insert(tp, agno, bno, len);
 	return 0;
 
  error0:
-	TRACE_FREE("error", agno, bno, len, isfl);
+	trace_xfs_free_extent(mp, agno, bno, len, isfl, -1, -1);
 	if (bno_cur)
 		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	if (cnt_cur)
@@ -1701,6 +1643,25 @@ xfs_alloc_compute_maxlevels(
 }
 
 /*
+ * Find the length of the longest extent in an AG.
+ */
+xfs_extlen_t
+xfs_alloc_longest_free_extent(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag)
+{
+	xfs_extlen_t		need, delta = 0;
+
+	need = XFS_MIN_FREELIST_PAG(pag, mp);
+	if (need > pag->pagf_flcount)
+		delta = need - pag->pagf_flcount;
+
+	if (pag->pagf_longest > delta)
+		return pag->pagf_longest - delta;
+	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
+}
+
+/*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
  *
@@ -1754,15 +1715,12 @@ xfs_alloc_fix_freelist(
 	}
 
 	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
-		need = XFS_MIN_FREELIST_PAG(pag, mp);
-		delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
 		/*
 		 * If it looks like there isn't a long enough extent, or enough
 		 * total blocks, reject it.
 		 */
-		longest = (pag->pagf_longest > delta) ?
-			(pag->pagf_longest - delta) :
-			(pag->pagf_flcount > 0 || pag->pagf_longest > 0);
+		need = XFS_MIN_FREELIST_PAG(pag, mp);
+		longest = xfs_alloc_longest_free_extent(mp, pag);
 		if ((args->minlen + args->alignment + args->minalignslop - 1) >
 				longest ||
 		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
@@ -1925,10 +1883,12 @@ xfs_alloc_get_freelist(
 	xfs_trans_brelse(tp, agflbp);
 	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
 		agf->agf_flfirst = 0;
-	pag = &mp->m_perag[be32_to_cpu(agf->agf_seqno)];
+
+	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
 	be32_add_cpu(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
+	xfs_perag_put(pag);
 
 	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
 	if (btreeblk) {
@@ -1937,19 +1897,24 @@ xfs_alloc_get_freelist(
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
-	TRACE_MODAGF(NULL, agf, logflags);
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
 
 	/*
-	 * As blocks are freed, they are added to the per-ag busy list
-	 * and remain there until the freeing transaction is committed to
-	 * disk.  Now that we have allocated blocks, this list must be
-	 * searched to see if a block is being reused.  If one is, then
-	 * the freeing transaction must be pushed to disk NOW by forcing
-	 * to disk all iclogs up that transaction's LSN.
-	 */
-	xfs_alloc_search_busy(tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	 * As blocks are freed, they are added to the per-ag busy list and
+	 * remain there until the freeing transaction is committed to disk.
+	 * Now that we have allocated blocks, this list must be searched to see
+	 * if a block is being reused.  If one is, then the freeing transaction
+	 * must be pushed to disk before this transaction.
+	 *
+	 * We do this by setting the current transaction to a sync transaction
+	 * which guarantees that the freeing transaction is on disk before this
+	 * transaction. This is done instead of a synchronous log force here so
+	 * that we don't sit and wait with the AGF locked in the transaction
+	 * during the log force.
+	 */
+	if (xfs_alloc_busy_search(mp, be32_to_cpu(agf->agf_seqno), bno, 1))
+		xfs_trans_set_sync(tp);
 	return 0;
 }
 
@@ -1980,6 +1945,8 @@ xfs_alloc_log_agf(
 		sizeof(xfs_agf_t)
 	};
 
+	trace_xfs_agf(tp->t_mountp, XFS_BUF_TO_AGF(bp), fields, _RET_IP_);
+
 	xfs_btree_offsets(fields, offsets, XFS_AGF_NUM_BITS, &first, &last);
 	xfs_trans_log_buf(tp, bp, (uint)first, (uint)last);
 }
@@ -2033,7 +2000,8 @@ xfs_alloc_put_freelist(
 	be32_add_cpu(&agf->agf_fllast, 1);
 	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
 		agf->agf_fllast = 0;
-	pag = &mp->m_perag[be32_to_cpu(agf->agf_seqno)];
+
+	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
 	be32_add_cpu(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
 	pag->pagf_flcount++;
@@ -2044,14 +2012,13 @@ xfs_alloc_put_freelist(
 		pag->pagf_btreeblks--;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
+	xfs_perag_put(pag);
 
-	TRACE_MODAGF(NULL, agf, logflags);
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp));
 	blockp = &agfl->agfl_bno[be32_to_cpu(agf->agf_fllast)];
 	*blockp = cpu_to_be32(bno);
-	TRACE_MODAGF(NULL, agf, logflags);
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	xfs_trans_log_buf(tp, agflbp,
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
@@ -2064,44 +2031,41 @@ xfs_alloc_put_freelist(
  * Read in the allocation group header (free/alloc section).
  */
 int					/* error */
-xfs_alloc_read_agf(
-	xfs_mount_t	*mp,		/* mount point structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	int		flags,		/* XFS_ALLOC_FLAG_... */
-	xfs_buf_t	**bpp)		/* buffer for the ag freelist header */
+xfs_read_agf(
+	struct xfs_mount	*mp,	/* mount point structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	int			flags,	/* XFS_BUF_ */
+	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
 {
-	xfs_agf_t	*agf;		/* ag freelist header */
+	struct xfs_agf	*agf;		/* ag freelist header */
 	int		agf_ok;		/* set if agf is consistent */
-	xfs_buf_t	*bp;		/* return value */
-	xfs_perag_t	*pag;		/* per allocation group data */
 	int		error;
 
 	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1),
-			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XFS_BUF_TRYLOCK : 0U,
-			&bp);
+			XFS_FSS_TO_BB(mp, 1), flags, bpp);
 	if (error)
 		return error;
-	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
-	if (!bp) {
-		*bpp = NULL;
+	if (!*bpp)
 		return 0;
-	}
+
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	agf = XFS_BUF_TO_AGF(*bpp);
+
 	/*
 	 * Validate the magic number of the agf block.
 	 */
-	agf = XFS_BUF_TO_AGF(bp);
 	agf_ok =
 		be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
 		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
 		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
 		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
+		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
+		be32_to_cpu(agf->agf_seqno) == agno;
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
 		agf_ok = agf_ok && be32_to_cpu(agf->agf_btreeblks) <=
 						be32_to_cpu(agf->agf_length);
@@ -2109,10 +2073,41 @@ xfs_alloc_read_agf(
 			XFS_RANDOM_ALLOC_READ_AGF))) {
 		XFS_CORRUPTION_ERROR("xfs_alloc_read_agf",
 				     XFS_ERRLEVEL_LOW, mp, agf);
-		xfs_trans_brelse(tp, bp);
+		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
-	pag = &mp->m_perag[agno];
+	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGF, XFS_AGF_REF);
+	return 0;
+}
+
+/*
+ * Read in the allocation group header (free/alloc section).
+ */
+int					/* error */
+xfs_alloc_read_agf(
+	struct xfs_mount	*mp,	/* mount point structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	int			flags,	/* XFS_ALLOC_FLAG_... */
+	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
+{
+	struct xfs_agf		*agf;		/* ag freelist header */
+	struct xfs_perag	*pag;		/* per allocation group data */
+	int			error;
+
+	ASSERT(agno != NULLAGNUMBER);
+
+	error = xfs_read_agf(mp, tp, agno,
+			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
+			bpp);
+	if (error)
+		return error;
+	if (!*bpp)
+		return 0;
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+
+	agf = XFS_BUF_TO_AGF(*bpp);
+	pag = xfs_perag_get(mp, agno);
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
@@ -2123,8 +2118,7 @@ xfs_alloc_read_agf(
 		pag->pagf_levels[XFS_BTNUM_CNTi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		spin_lock_init(&pag->pagb_lock);
-		pag->pagb_list = kmem_zalloc(XFS_PAGB_NUM_SLOTS *
-					sizeof(xfs_perag_busy_t), KM_SLEEP);
+		pag->pagb_count = 0;
 		pag->pagf_init = 1;
 	}
 #ifdef DEBUG
@@ -2139,8 +2133,7 @@ xfs_alloc_read_agf(
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
 	}
 #endif
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGF, XFS_AGF_REF);
-	*bpp = bp;
+	xfs_perag_put(pag);
 	return 0;
 }
 
@@ -2187,7 +2180,7 @@ xfs_alloc_vextent(
 	    args->minlen > args->maxlen || args->minlen > agsize ||
 	    args->mod >= args->prod) {
 		args->fsbno = NULLFSBLOCK;
-		TRACE_ALLOC("badargs", args);
+		trace_xfs_alloc_vextent_badargs(args);
 		return 0;
 	}
 	minleft = args->minleft;
@@ -2200,24 +2193,21 @@ xfs_alloc_vextent(
 		 * These three force us into a single a.g.
 		 */
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-		down_read(&mp->m_peraglock);
-		args->pag = &mp->m_perag[args->agno];
+		args->pag = xfs_perag_get(mp, args->agno);
 		args->minleft = 0;
 		error = xfs_alloc_fix_freelist(args, 0);
 		args->minleft = minleft;
 		if (error) {
-			TRACE_ALLOC("nofix", args);
+			trace_xfs_alloc_vextent_nofix(args);
 			goto error0;
 		}
 		if (!args->agbp) {
-			up_read(&mp->m_peraglock);
-			TRACE_ALLOC("noagbp", args);
+			trace_xfs_alloc_vextent_noagbp(args);
 			break;
 		}
 		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		if ((error = xfs_alloc_ag_vextent(args)))
 			goto error0;
-		up_read(&mp->m_peraglock);
 		break;
 	case XFS_ALLOCTYPE_START_BNO:
 		/*
@@ -2269,14 +2259,13 @@ xfs_alloc_vextent(
 		 * Loop over allocation groups twice; first time with
 		 * trylock set, second time without.
 		 */
-		down_read(&mp->m_peraglock);
 		for (;;) {
-			args->pag = &mp->m_perag[args->agno];
+			args->pag = xfs_perag_get(mp, args->agno);
 			if (no_min) args->minleft = 0;
 			error = xfs_alloc_fix_freelist(args, flags);
 			args->minleft = minleft;
 			if (error) {
-				TRACE_ALLOC("nofix", args);
+				trace_xfs_alloc_vextent_nofix(args);
 				goto error0;
 			}
 			/*
@@ -2287,7 +2276,9 @@ xfs_alloc_vextent(
 					goto error0;
 				break;
 			}
-			TRACE_ALLOC("loopfailed", args);
+
+			trace_xfs_alloc_vextent_loopfailed(args);
+
 			/*
 			 * Didn't work, figure out the next iteration.
 			 */
@@ -2314,7 +2305,7 @@ xfs_alloc_vextent(
 			if (args->agno == sagno) {
 				if (no_min == 1) {
 					args->agbno = NULLAGBLOCK;
-					TRACE_ALLOC("allfailed", args);
+					trace_xfs_alloc_vextent_allfailed(args);
 					break;
 				}
 				if (flags == 0) {
@@ -2328,8 +2319,8 @@ xfs_alloc_vextent(
 					}
 				}
 			}
+			xfs_perag_put(args->pag);
 		}
-		up_read(&mp->m_peraglock);
 		if (bump_rotor || (type == XFS_ALLOCTYPE_ANY_AG)) {
 			if (args->agno == sagno)
 				mp->m_agfrotor = (mp->m_agfrotor + 1) %
@@ -2355,9 +2346,10 @@ xfs_alloc_vextent(
 			args->len);
 #endif
 	}
+	xfs_perag_put(args->pag);
 	return 0;
 error0:
-	up_read(&mp->m_peraglock);
+	xfs_perag_put(args->pag);
 	return error;
 }
 
@@ -2382,8 +2374,7 @@ xfs_free_extent(
 	args.agno = XFS_FSB_TO_AGNO(args.mp, bno);
 	ASSERT(args.agno < args.mp->m_sb.sb_agcount);
 	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
-	down_read(&args.mp->m_peraglock);
-	args.pag = &args.mp->m_perag[args.agno];
+	args.pag = xfs_perag_get(args.mp, args.agno);
 	if ((error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING)))
 		goto error0;
 #ifdef DEBUG
@@ -2393,6 +2384,6 @@ xfs_free_extent(
 #endif
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 error0:
-	up_read(&args.mp->m_peraglock);
+	xfs_perag_put(args.pag);
 	return error;
 }
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 4d55caf..b782d9d 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -36,12 +36,14 @@ xfs_allocbt_set_root(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
+	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
 
 	ASSERT(ptr->s != 0);
 
 	agf->agf_roots[btnum] = ptr->s;
 	be32_add_cpu(&agf->agf_levels[btnum], inc);
-	cur->bc_mp->m_perag[seqno].pagf_levels[btnum] += inc;
+	pag->pagf_levels[btnum] += inc;
+	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -91,7 +93,7 @@ xfs_allocbt_free_block(
 	xfs_agblock_t		bno;
 	int			error;
 
-	bno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp));
+	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
 	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
 	if (error)
 		return error;
@@ -107,7 +109,7 @@ xfs_allocbt_free_block(
 	 * disk. If a busy block is allocated, the iclog is pushed up to the
 	 * LSN that freed the block.
 	 */
-	xfs_alloc_mark_busy(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
@@ -125,6 +127,7 @@ xfs_allocbt_update_lastrec(
 {
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	struct xfs_perag	*pag;
 	__be32			len;
 	int			numrecs;
 
@@ -168,7 +171,9 @@ xfs_allocbt_update_lastrec(
 	}
 
 	agf->agf_longest = len;
-	cur->bc_mp->m_perag[seqno].pagf_longest = be32_to_cpu(len);
+	pag = xfs_perag_get(cur->bc_mp, seqno);
+	pag->pagf_longest = be32_to_cpu(len);
+	xfs_perag_put(pag);
 	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
 }
 
@@ -255,38 +260,6 @@ xfs_allocbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
-STATIC int
-xfs_allocbt_kill_root(
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*bp,
-	int			level,
-	union xfs_btree_ptr	*newroot)
-{
-	int			error;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_STATS_INC(cur, killroot);
-
-	/*
-	 * Update the root pointer, decreasing the level by 1 and then
-	 * free the old root.
-	 */
-	xfs_allocbt_set_root(cur, newroot, -1);
-	error = xfs_allocbt_free_block(cur, bp);
-	if (error) {
-		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
-		return error;
-	}
-
-	XFS_BTREE_STATS_INC(cur, free);
-
-	xfs_btree_setbuf(cur, level, NULL);
-	cur->bc_nlevels--;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-	return 0;
-}
-
 #ifdef DEBUG
 STATIC int
 xfs_allocbt_keys_inorder(
@@ -398,7 +371,6 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
-	.kill_root		= xfs_allocbt_kill_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
 	.update_lastrec		= xfs_allocbt_update_lastrec,
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7ab37ff..aaeaec4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -60,12 +60,12 @@ STATIC int xfs_attr_rmtval_remove(xfs_da_args_t *args);
 STATIC int
 xfs_attr_name_to_xname(
 	struct xfs_name	*xname,
-	const char	*aname)
+	const unsigned char *aname)
 {
 	if (!aname)
 		return EINVAL;
 	xname->name = aname;
-	xname->len = strlen(aname);
+	xname->len = strlen((char *)aname);
 	if (xname->len >= MAXNAMELEN)
 		return EFAULT;		/* match IRIX behaviour */
 
@@ -87,9 +87,13 @@ xfs_inode_hasattr(
  * Overall external interface routines.
  *========================================================================*/
 
-int
-xfs_attr_fetch(xfs_inode_t *ip, struct xfs_name *name,
-		char *value, int *valuelenp, int flags)
+STATIC int
+xfs_attr_get_int(
+	struct xfs_inode	*ip,
+	struct xfs_name		*name,
+	unsigned char		*value,
+	int			*valuelenp,
+	int			flags)
 {
 	xfs_da_args_t   args;
 	int             error;
@@ -134,8 +138,8 @@ xfs_attr_fetch(xfs_inode_t *ip, struct xfs_name *name,
 int
 xfs_attr_get(
 	xfs_inode_t	*ip,
-	const char	*name,
-	char		*value,
+	const unsigned char *name,
+	unsigned char	*value,
 	int		*valuelenp,
 	int		flags)
 {
@@ -152,7 +156,7 @@ xfs_attr_get(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_attr_fetch(ip, &xname, value, valuelenp, flags);
+	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return(error);
 }
@@ -160,7 +164,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-int
+STATIC int
 xfs_attr_calc_size(
 	struct xfs_inode 	*ip,
 	int			namelen,
@@ -198,8 +202,12 @@ xfs_attr_calc_size(
 }
 
 STATIC int
-xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
-		char *value, int valuelen, int flags)
+xfs_attr_set_int(
+	struct xfs_inode *dp,
+	struct xfs_name	*name,
+	unsigned char	*value,
+	int		valuelen,
+	int		flags)
 {
 	xfs_da_args_t	args;
 	xfs_fsblock_t	firstblock;
@@ -212,8 +220,9 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	/*
 	 * Attach the dquots to the inode.
 	 */
-	if ((error = XFS_QM_DQATTACH(mp, dp, 0)))
-		return (error);
+	error = xfs_qm_dqattach(dp, 0);
+	if (error)
+		return error;
 
 	/*
 	 * If the inode doesn't have an attribute fork, add one.
@@ -274,7 +283,7 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 
-	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, args.trans, dp, args.total, 0,
+	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
 				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 				       XFS_QMOPT_RES_REGBLKS);
 	if (error) {
@@ -320,16 +329,15 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 			if (mp->m_flags & XFS_MOUNT_WSYNC) {
 				xfs_trans_set_sync(args.trans);
 			}
+
+			if (!error && (flags & ATTR_KERNOTIME) == 0) {
+				xfs_trans_ichgtime(args.trans, dp,
+							XFS_ICHGTIME_CHG);
+			}
 			err2 = xfs_trans_commit(args.trans,
 						 XFS_TRANS_RELEASE_LOG_RES);
 			xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-			/*
-			 * Hit the inode change time.
-			 */
-			if (!error && (flags & ATTR_KERNOTIME) == 0) {
-				xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
-			}
 			return(error == 0 ? err2 : error);
 		}
 
@@ -337,7 +345,7 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		XFS_BMAP_INIT(args.flist, args.firstblock);
+		xfs_bmap_init(args.flist, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error) {
 			error = xfs_bmap_finish(&args.trans, args.flist,
@@ -387,6 +395,9 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 		xfs_trans_set_sync(args.trans);
 	}
 
+	if ((flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
@@ -394,13 +405,6 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-	/*
-	 * Hit the inode change time.
-	 */
-	if (!error && (flags & ATTR_KERNOTIME) == 0) {
-		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
-	}
-
 	return(error);
 
 out:
@@ -414,8 +418,8 @@ out:
 int
 xfs_attr_set(
 	xfs_inode_t	*dp,
-	const char	*name,
-	char		*value,
+	const unsigned char *name,
+	unsigned char	*value,
 	int		valuelen,
 	int		flags)
 {
@@ -464,8 +468,9 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	/*
 	 * Attach the dquots to the inode.
 	 */
-	if ((error = XFS_QM_DQATTACH(mp, dp, 0)))
-		return (error);
+	error = xfs_qm_dqattach(dp, 0);
+	if (error)
+		return error;
 
 	/*
 	 * Start our first transaction of the day.
@@ -534,6 +539,9 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 		xfs_trans_set_sync(args.trans);
 	}
 
+	if ((flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
@@ -541,13 +549,6 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-	/*
-	 * Hit the inode change time.
-	 */
-	if (!error && (flags & ATTR_KERNOTIME) == 0) {
-		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
-	}
-
 	return(error);
 
 out:
@@ -561,7 +562,7 @@ out:
 int
 xfs_attr_remove(
 	xfs_inode_t	*dp,
-	const char	*name,
+	const unsigned char *name,
 	int		flags)
 {
 	int		error;
@@ -586,7 +587,6 @@ xfs_attr_remove(
 	return xfs_attr_remove_int(dp, &xname, flags);
 }
 
-
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
@@ -686,7 +686,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Commit that transaction so that the node_addname() call
 		 * can manage its own transactions.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr_leaf_to_node(args);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -787,7 +787,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * If the result is small enough, shrink it all into the inode.
 		 */
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
@@ -865,7 +865,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	 * If the result is small enough, shrink it all into the inode.
 	 */
 	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error) {
@@ -924,7 +924,6 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	return(error);
 }
 
-
 /*========================================================================
  * External routines when attribute list size > XFS_LBSIZE(mp).
  *========================================================================*/
@@ -992,7 +991,7 @@ restart:
 			 * have been a b-tree.
 			 */
 			xfs_da_state_free(state);
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_node(args);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
@@ -1033,7 +1032,7 @@ restart:
 		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da_split(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1145,7 +1144,7 @@ restart:
 		 * Check to see if the tree needs to be collapsed.
 		 */
 		if (retval && (state->path.active > 1)) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_da_join(state);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
@@ -1281,7 +1280,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	 * Check to see if the tree needs to be collapsed.
 	 */
 	if (retval && (state->path.active > 1)) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da_join(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1332,7 +1331,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 						       == XFS_ATTR_LEAF_MAGIC);
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
@@ -1522,7 +1521,6 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	return(retval);
 }
 
-
 /*========================================================================
  * External routines for manipulating out-of-line attribute values.
  *========================================================================*/
@@ -1537,7 +1535,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 	xfs_bmbt_irec_t map[ATTR_RMTVALUE_MAPSIZE];
 	xfs_mount_t *mp;
 	xfs_daddr_t dblkno;
-	xfs_caddr_t dst;
+	void *dst;
 	xfs_buf_t *bp;
 	int nmap, error, tmp, valuelen, blkcnt, i;
 	xfs_dablk_t lblkno;
@@ -1553,7 +1551,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 		error = xfs_bmapi(args->trans, args->dp, (xfs_fileoff_t)lblkno,
 				  args->rmtblkcnt,
 				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-				  NULL, 0, map, &nmap, NULL, NULL);
+				  NULL, 0, map, &nmap, NULL);
 		if (error)
 			return(error);
 		ASSERT(nmap >= 1);
@@ -1564,13 +1562,14 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_read_buf(mp, mp->m_ddev_targp, dblkno,
-					     blkcnt, XFS_BUF_LOCK, &bp);
+					     blkcnt, XBF_LOCK | XBF_DONT_BLOCK,
+					     &bp);
 			if (error)
 				return(error);
 
 			tmp = (valuelen < XFS_BUF_SIZE(bp))
 				? valuelen : XFS_BUF_SIZE(bp);
-			xfs_biomove(bp, 0, tmp, dst, XFS_B_READ);
+			xfs_buf_iomove(bp, 0, tmp, dst, XBRW_READ);
 			xfs_buf_relse(bp);
 			dst += tmp;
 			valuelen -= tmp;
@@ -1594,7 +1593,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 	xfs_inode_t *dp;
 	xfs_bmbt_irec_t map;
 	xfs_daddr_t dblkno;
-	xfs_caddr_t src;
+	void *src;
 	xfs_buf_t *bp;
 	xfs_dablk_t lblkno;
 	int blkcnt, valuelen, nmap, error, tmp, committed;
@@ -1624,14 +1623,14 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		/*
 		 * Allocate a single extent, up to the size of the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt,
 				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA |
 							XFS_BMAPI_WRITE,
 				  args->firstblock, args->total, &map, &nmap,
-				  args->flist, NULL);
+				  args->flist);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
@@ -1678,13 +1677,13 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(NULL, dp, (xfs_fileoff_t)lblkno,
 				  args->rmtblkcnt,
 				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 				  args->firstblock, 0, &map, &nmap,
-				  NULL, NULL);
+				  NULL);
 		if (error) {
 			return(error);
 		}
@@ -1695,16 +1694,16 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		bp = xfs_buf_get_flags(mp->m_ddev_targp, dblkno,
-							blkcnt, XFS_BUF_LOCK);
+		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
+				 XBF_LOCK | XBF_DONT_BLOCK);
 		ASSERT(bp);
 		ASSERT(!XFS_BUF_GETERROR(bp));
 
 		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
 							XFS_BUF_SIZE(bp);
-		xfs_biomove(bp, 0, tmp, src, XFS_B_WRITE);
+		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
 		if (tmp < XFS_BUF_SIZE(bp))
-			xfs_biozero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
+			xfs_buf_zero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
 		if ((error = xfs_bwrite(mp, bp))) {/* GROT: NOTE: synchronous write */
 			return (error);
 		}
@@ -1743,13 +1742,13 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(NULL, args->dp, (xfs_fileoff_t)lblkno,
 					args->rmtblkcnt,
 					XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 					args->firstblock, 0, &map, &nmap,
-					args->flist, NULL);
+					args->flist);
 		if (error) {
 			return(error);
 		}
@@ -1763,8 +1762,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 		/*
 		 * If the "remote" value is in the cache, remove it.
 		 */
-		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt,
-				XFS_INCORE_TRYLOCK);
+		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt, XBF_TRYLOCK);
 		if (bp) {
 			XFS_BUF_STALE(bp);
 			XFS_BUF_UNDELAYWRITE(bp);
@@ -1784,11 +1782,11 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 				    1, args->firstblock, args->flist,
-				    NULL, &done);
+				    &done);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index f8f926f..d1f7a20 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -45,6 +45,7 @@ STATIC int xfs_attr_leaf_figure_balance(xfs_da_state_t *state,
 					   int *number_entries_in_blk1,
 					   int *number_usedbytes_in_blk1);
 
+
 /*
  * Utility routines.
  */
@@ -63,7 +64,7 @@ STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
  * If namespace bits don't match return 0.
  * If all match then return 1.
  */
-STATIC_INLINE int
+STATIC int
 xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
 {
 	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
@@ -120,7 +121,8 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 		 * minimum offset only needs to be the space required for 
 		 * the btree root.
 		 */ 
-		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes > mp->m_attroffset)
+		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes >
+		    xfs_default_attroffset(dp))
 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		break;
 		
@@ -263,6 +265,26 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 }
 
 /*
+ * After the last attribute is removed revert to original inode format,
+ * making all literal area available to the data fork once more.
+ */
+STATIC void
+xfs_attr_fork_reset(
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp)
+{
+	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+	ip->i_d.di_forkoff = 0;
+	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+
+	ASSERT(ip->i_d.di_anextents == 0);
+	ASSERT(ip->i_afp == NULL);
+
+	ip->i_df.if_ext_max = XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/*
  * Remove an attribute from the shortform attribute list structure.
  */
 int
@@ -309,22 +331,10 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	 */
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
-				!(args->op_flags & XFS_DA_OP_ADDNAME) &&
-				(mp->m_flags & XFS_MOUNT_ATTR2) &&
-				(dp->i_d.di_format != XFS_DINODE_FMT_BTREE)) {
-		/*
-		 * Last attribute now removed, revert to original
-		 * inode format making all literal area available
-		 * to the data fork once more.
-		 */
-		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
-		dp->i_d.di_forkoff = 0;
-		dp->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-		ASSERT(dp->i_d.di_anextents == 0);
-		ASSERT(dp->i_afp == NULL);
-		dp->i_df.if_ext_max =
-			XFS_IFORK_DSIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
-		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+	    (mp->m_flags & XFS_MOUNT_ATTR2) &&
+	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
+	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
+		xfs_attr_fork_reset(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 		dp->i_d.di_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
@@ -476,11 +486,11 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
-		nargs.name = (char *)sfe->nameval;
+		nargs.name = sfe->nameval;
 		nargs.namelen = sfe->namelen;
-		nargs.value = (char *)&sfe->nameval[nargs.namelen];
+		nargs.value = &sfe->nameval[nargs.namelen];
 		nargs.valuelen = sfe->valuelen;
-		nargs.hashval = xfs_da_hashname((char *)sfe->nameval,
+		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
 		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
 		error = xfs_attr_leaf_lookup_int(bp, &nargs); /* set a->index */
@@ -522,7 +532,7 @@ xfs_attr_shortform_allfit(xfs_dabuf_t *bp, xfs_inode_t *dp)
 			continue;		/* don't copy partial entries */
 		if (!(entry->flags & XFS_ATTR_LOCAL))
 			return(0);
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
+		name_loc = xfs_attr_leaf_name_local(leaf, i);
 		if (name_loc->namelen >= XFS_ATTR_SF_ENTSIZE_MAX)
 			return(0);
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
@@ -572,20 +582,7 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *bp, xfs_da_args_t *args, int forkoff)
 	if (forkoff == -1) {
 		ASSERT(dp->i_mount->m_flags & XFS_MOUNT_ATTR2);
 		ASSERT(dp->i_d.di_format != XFS_DINODE_FMT_BTREE);
-
-		/*
-		 * Last attribute was removed, revert to original
-		 * inode format making all literal area available
-		 * to the data fork once more.
-		 */
-		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
-		dp->i_d.di_forkoff = 0;
-		dp->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-		ASSERT(dp->i_d.di_anextents == 0);
-		ASSERT(dp->i_afp == NULL);
-		dp->i_df.if_ext_max =
-			XFS_IFORK_DSIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
-		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+		xfs_attr_fork_reset(dp, args->trans);
 		goto out;
 	}
 
@@ -609,10 +606,10 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *bp, xfs_da_args_t *args, int forkoff)
 		if (!entry->nameidx)
 			continue;
 		ASSERT(entry->flags & XFS_ATTR_LOCAL);
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
-		nargs.name = (char *)name_loc->nameval;
+		name_loc = xfs_attr_leaf_name_local(leaf, i);
+		nargs.name = name_loc->nameval;
 		nargs.namelen = name_loc->namelen;
-		nargs.value = (char *)&name_loc->nameval[nargs.namelen];
+		nargs.value = &name_loc->nameval[nargs.namelen];
 		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
 		nargs.hashval = be32_to_cpu(entry->hashval);
 		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
@@ -927,14 +924,14 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 	 * as part of this transaction (a split operation for example).
 	 */
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, args->index);
+		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
 		name_loc->namelen = args->namelen;
 		name_loc->valuelen = cpu_to_be16(args->valuelen);
 		memcpy((char *)name_loc->nameval, args->name, args->namelen);
 		memcpy((char *)&name_loc->nameval[args->namelen], args->value,
 				   be16_to_cpu(name_loc->valuelen));
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		name_rmt->namelen = args->namelen;
 		memcpy((char *)name_rmt->name, args->name, args->namelen);
 		entry->flags |= XFS_ATTR_INCOMPLETE;
@@ -945,7 +942,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 		args->rmtblkcnt = XFS_B_TO_FSB(mp, args->valuelen);
 	}
 	xfs_da_log_buf(args->trans, bp,
-	     XFS_DA_LOGRANGE(leaf, XFS_ATTR_LEAF_NAME(leaf, args->index),
+	     XFS_DA_LOGRANGE(leaf, xfs_attr_leaf_name(leaf, args->index),
 				   xfs_attr_leaf_entsize(leaf, args->index)));
 
 	/*
@@ -1535,10 +1532,10 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	/*
 	 * Compress the remaining entries and zero out the removed stuff.
 	 */
-	memset(XFS_ATTR_LEAF_NAME(leaf, args->index), 0, entsize);
+	memset(xfs_attr_leaf_name(leaf, args->index), 0, entsize);
 	be16_add_cpu(&hdr->usedbytes, -entsize);
 	xfs_da_log_buf(args->trans, bp,
-	     XFS_DA_LOGRANGE(leaf, XFS_ATTR_LEAF_NAME(leaf, args->index),
+	     XFS_DA_LOGRANGE(leaf, xfs_attr_leaf_name(leaf, args->index),
 				   entsize));
 
 	tmp = (be16_to_cpu(hdr->count) - args->index)
@@ -1771,7 +1768,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp, xfs_da_args_t *args)
 			continue;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
-			name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, probe);
+			name_loc = xfs_attr_leaf_name_local(leaf, probe);
 			if (name_loc->namelen != args->namelen)
 				continue;
 			if (memcmp(args->name, (char *)name_loc->nameval, args->namelen) != 0)
@@ -1781,7 +1778,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp, xfs_da_args_t *args)
 			args->index = probe;
 			return(XFS_ERROR(EEXIST));
 		} else {
-			name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, probe);
+			name_rmt = xfs_attr_leaf_name_remote(leaf, probe);
 			if (name_rmt->namelen != args->namelen)
 				continue;
 			if (memcmp(args->name, (char *)name_rmt->name,
@@ -1821,7 +1818,7 @@ xfs_attr_leaf_getvalue(xfs_dabuf_t *bp, xfs_da_args_t *args)
 
 	entry = &leaf->entries[args->index];
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, args->index);
+		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
 		ASSERT(name_loc->namelen == args->namelen);
 		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
 		valuelen = be16_to_cpu(name_loc->valuelen);
@@ -1836,7 +1833,7 @@ xfs_attr_leaf_getvalue(xfs_dabuf_t *bp, xfs_da_args_t *args)
 		args->valuelen = valuelen;
 		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		ASSERT(name_rmt->namelen == args->namelen);
 		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
 		valuelen = be32_to_cpu(name_rmt->valuelen);
@@ -1929,7 +1926,7 @@ xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
 		 * off for 6.2, should be revisited later.
 		 */
 		if (entry_s->flags & XFS_ATTR_INCOMPLETE) { /* skip partials? */
-			memset(XFS_ATTR_LEAF_NAME(leaf_s, start_s + i), 0, tmp);
+			memset(xfs_attr_leaf_name(leaf_s, start_s + i), 0, tmp);
 			be16_add_cpu(&hdr_s->usedbytes, -tmp);
 			be16_add_cpu(&hdr_s->count, -1);
 			entry_d--;	/* to compensate for ++ in loop hdr */
@@ -1946,11 +1943,11 @@ xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
 			entry_d->flags = entry_s->flags;
 			ASSERT(be16_to_cpu(entry_d->nameidx) + tmp
 							<= XFS_LBSIZE(mp));
-			memmove(XFS_ATTR_LEAF_NAME(leaf_d, desti),
-				XFS_ATTR_LEAF_NAME(leaf_s, start_s + i), tmp);
+			memmove(xfs_attr_leaf_name(leaf_d, desti),
+				xfs_attr_leaf_name(leaf_s, start_s + i), tmp);
 			ASSERT(be16_to_cpu(entry_s->nameidx) + tmp
 							<= XFS_LBSIZE(mp));
-			memset(XFS_ATTR_LEAF_NAME(leaf_s, start_s + i), 0, tmp);
+			memset(xfs_attr_leaf_name(leaf_s, start_s + i), 0, tmp);
 			be16_add_cpu(&hdr_s->usedbytes, -tmp);
 			be16_add_cpu(&hdr_d->usedbytes, tmp);
 			be16_add_cpu(&hdr_s->count, -1);
@@ -2062,12 +2059,12 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
 
 	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
 	if (leaf->entries[index].flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, index);
-		size = XFS_ATTR_LEAF_ENTSIZE_LOCAL(name_loc->namelen,
+		name_loc = xfs_attr_leaf_name_local(leaf, index);
+		size = xfs_attr_leaf_entsize_local(name_loc->namelen,
 						   be16_to_cpu(name_loc->valuelen));
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, index);
-		size = XFS_ATTR_LEAF_ENTSIZE_REMOTE(name_rmt->namelen);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, index);
+		size = xfs_attr_leaf_entsize_remote(name_rmt->namelen);
 	}
 	return(size);
 }
@@ -2083,13 +2080,13 @@ xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize, int *local)
 {
 	int size;
 
-	size = XFS_ATTR_LEAF_ENTSIZE_LOCAL(namelen, valuelen);
-	if (size < XFS_ATTR_LEAF_ENTSIZE_LOCAL_MAX(blocksize)) {
+	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
+	if (size < xfs_attr_leaf_entsize_local_max(blocksize)) {
 		if (local) {
 			*local = 1;
 		}
 	} else {
-		size = XFS_ATTR_LEAF_ENTSIZE_REMOTE(namelen);
+		size = xfs_attr_leaf_entsize_remote(namelen);
 		if (local) {
 			*local = 0;
 		}
@@ -2137,11 +2134,11 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 
 #ifdef DEBUG
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, args->index);
+		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
 		namelen = name_loc->namelen;
 		name = (char *)name_loc->nameval;
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		namelen = name_rmt->namelen;
 		name = (char *)name_rmt->name;
 	}
@@ -2156,7 +2153,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 
 	if (args->rmtblkno) {
 		ASSERT((entry->flags & XFS_ATTR_LOCAL) == 0);
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->valuelen);
 		xfs_da_log_buf(args->trans, bp,
@@ -2203,7 +2200,7 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 	xfs_da_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
 	if ((entry->flags & XFS_ATTR_LOCAL) == 0) {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
 		xfs_da_log_buf(args->trans, bp,
@@ -2276,20 +2273,20 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 
 #ifdef DEBUG
 	if (entry1->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf1, args->index);
+		name_loc = xfs_attr_leaf_name_local(leaf1, args->index);
 		namelen1 = name_loc->namelen;
 		name1 = (char *)name_loc->nameval;
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf1, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf1, args->index);
 		namelen1 = name_rmt->namelen;
 		name1 = (char *)name_rmt->name;
 	}
 	if (entry2->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf2, args->index2);
+		name_loc = xfs_attr_leaf_name_local(leaf2, args->index2);
 		namelen2 = name_loc->namelen;
 		name2 = (char *)name_loc->nameval;
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf2, args->index2);
+		name_rmt = xfs_attr_leaf_name_remote(leaf2, args->index2);
 		namelen2 = name_rmt->namelen;
 		name2 = (char *)name_rmt->name;
 	}
@@ -2306,7 +2303,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 			  XFS_DA_LOGRANGE(leaf1, entry1, sizeof(*entry1)));
 	if (args->rmtblkno) {
 		ASSERT((entry1->flags & XFS_ATTR_LOCAL) == 0);
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf1, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf1, args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->valuelen);
 		xfs_da_log_buf(args->trans, bp1,
@@ -2317,7 +2314,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	xfs_da_log_buf(args->trans, bp2,
 			  XFS_DA_LOGRANGE(leaf2, entry2, sizeof(*entry2)));
 	if ((entry2->flags & XFS_ATTR_LOCAL) == 0) {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf2, args->index2);
+		name_rmt = xfs_attr_leaf_name_remote(leaf2, args->index2);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
 		xfs_da_log_buf(args->trans, bp2,
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cf1123a..5a626b0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -65,7 +65,6 @@ xfs_bmap_add_extent(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork, /* data or attr fork */
 	int			rsvd);	/* OK to allocate reserved blocks */
 
@@ -83,7 +82,6 @@ xfs_bmap_add_extent_delay_real(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd);	/* OK to allocate reserved blocks */
 
 /*
@@ -96,7 +94,6 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp,/* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd);	/* OK to allocate reserved blocks */
 
 /*
@@ -110,7 +107,6 @@ xfs_bmap_add_extent_hole_real(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork); /* data or attr fork */
 
 /*
@@ -123,8 +119,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta); /* Change made to incore extents */
+	int			*logflagsp); /* inode logging flags */
 
 /*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
@@ -161,23 +156,10 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp,/* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork, /* data or attr fork */
 	int			rsvd);	 /* OK to allocate reserved blocks */
 
 /*
- * Remove the entry "free" from the free item list.  Prev points to the
- * previous entry, unless "free" is the head of the list.
- * 
- * Note: this requires user-space public scope for libxfs_iread
- */
-void
-xfs_bmap_del_free(
-	xfs_bmap_free_t		*flist,	/* free item list header */
-	xfs_bmap_free_item_t	*prev,	/* previous item on list, if any */
-	xfs_bmap_free_item_t	*free);	/* list item to be freed */
-
-/*
  * Convert an extents-format file into a btree-format file.
  * The new file will have a root block (in the inode) and a single child block.
  */
@@ -219,71 +201,6 @@ xfs_bmap_isaeof(
 	int             whichfork,	/* data or attribute fork */
 	char		*aeof);		/* return value */
 
-#ifdef XFS_BMAP_TRACE
-/*
- * Add bmap trace entry prior to a call to xfs_iext_remove.
- */
-STATIC void
-xfs_bmap_trace_delete(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry(entries) deleted */
-	xfs_extnum_t	cnt,		/* count of entries deleted, 1 or 2 */
-	int		whichfork);	/* data or attr fork */
-
-/*
- * Add bmap trace entry prior to a call to xfs_iext_insert, or
- * reading in the extents list from the disk (in the btree).
- */
-STATIC void
-xfs_bmap_trace_insert(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry(entries) inserted */
-	xfs_extnum_t	cnt,		/* count of entries inserted, 1 or 2 */
-	xfs_bmbt_irec_t	*r1,		/* inserted record 1 */
-	xfs_bmbt_irec_t	*r2,		/* inserted record 2 or null */
-	int		whichfork);	/* data or attr fork */
-
-/*
- * Add bmap trace entry after updating an extent record in place.
- */
-STATIC void
-xfs_bmap_trace_post_update(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry updated */
-	int		whichfork);	/* data or attr fork */
-
-/*
- * Add bmap trace entry prior to updating an extent record in place.
- */
-STATIC void
-xfs_bmap_trace_pre_update(
-	const char	*fname,		/* function name */
-	char		*desc,		/* operation description */
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_extnum_t	idx,		/* index of entry to be updated */
-	int		whichfork);	/* data or attr fork */
-
-#define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)	\
-	xfs_bmap_trace_delete(__func__,d,ip,i,c,w)
-#define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)	\
-	xfs_bmap_trace_insert(__func__,d,ip,i,c,r1,r2,w)
-#define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)	\
-	xfs_bmap_trace_post_update(__func__,d,ip,i,w)
-#define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)	\
-	xfs_bmap_trace_pre_update(__func__,d,ip,i,w)
-#else
-#define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)
-#define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)
-#define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)
-#define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)
-#endif	/* XFS_BMAP_TRACE */
-
 /*
  * Compute the worst-case number of indirect blocks that will be used
  * for ip's delayed extent of length "len".
@@ -310,18 +227,28 @@ xfs_bmap_validate_ret(
 #define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
 #endif /* DEBUG */
 
-#if defined(XFS_RW_TRACE)
+STATIC int
+xfs_bmap_count_tree(
+	xfs_mount_t     *mp,
+	xfs_trans_t     *tp,
+	xfs_ifork_t	*ifp,
+	xfs_fsblock_t   blockno,
+	int             levelin,
+	int		*count);
+
 STATIC void
-xfs_bunmap_trace(
-	xfs_inode_t		*ip,
-	xfs_fileoff_t		bno,
-	xfs_filblks_t		len,
-	int			flags,
-	inst_t			*ra);
-#else
-#define	xfs_bunmap_trace(ip, bno, len, flags, ra)
-#endif	/* XFS_RW_TRACE */
+xfs_bmap_count_leaves(
+	xfs_ifork_t		*ifp,
+	xfs_extnum_t		idx,
+	int			numrecs,
+	int			*count);
 
+STATIC void
+xfs_bmap_disk_count_leaves(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	int			numrecs,
+	int			*count);
 
 /*
  * Bmap internal routines.
@@ -490,7 +417,6 @@ xfs_bmap_add_extent(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork, /* data or attr fork */
 	int			rsvd)	/* OK to use reserved data blocks */
 {
@@ -515,35 +441,26 @@ xfs_bmap_add_extent(
 	 * already extents in the list.
 	 */
 	if (nextents == 0) {
-		XFS_BMAP_TRACE_INSERT("insert empty", ip, 0, 1, new, NULL,
-			whichfork);
-		xfs_iext_insert(ifp, 0, 1, new);
+		xfs_iext_insert(ip, 0, 1, new,
+				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
+
 		ASSERT(cur == NULL);
 		ifp->if_lastex = 0;
-		if (!ISNULLSTARTBLOCK(new->br_startblock)) {
+		if (!isnullstartblock(new->br_startblock)) {
 			XFS_IFORK_NEXT_SET(ip, whichfork, 1);
-			logflags = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			logflags = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else
 			logflags = 0;
-		/* DELTA: single new extent */
-		if (delta) {
-			if (delta->xed_startoff > new->br_startoff)
-				delta->xed_startoff = new->br_startoff;
-			if (delta->xed_blockcount <
-					new->br_startoff + new->br_blockcount)
-				delta->xed_blockcount = new->br_startoff +
-						new->br_blockcount;
-		}
 	}
 	/*
 	 * Any kind of new delayed allocation goes here.
 	 */
-	else if (ISNULLSTARTBLOCK(new->br_startblock)) {
+	else if (isnullstartblock(new->br_startblock)) {
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
 		if ((error = xfs_bmap_add_extent_hole_delay(ip, idx, new,
-				&logflags, delta, rsvd)))
+				&logflags, rsvd)))
 			goto done;
 	}
 	/*
@@ -554,7 +471,7 @@ xfs_bmap_add_extent(
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
 		if ((error = xfs_bmap_add_extent_hole_real(ip, idx, cur, new,
-				&logflags, delta, whichfork)))
+				&logflags, whichfork)))
 			goto done;
 	} else {
 		xfs_bmbt_irec_t	prev;	/* old extent at offset idx */
@@ -569,27 +486,27 @@ xfs_bmap_add_extent(
 		 * in a delayed or unwritten allocation with a real one, or
 		 * converting real back to unwritten.
 		 */
-		if (!ISNULLSTARTBLOCK(new->br_startblock) &&
+		if (!isnullstartblock(new->br_startblock) &&
 		    new->br_startoff + new->br_blockcount > prev.br_startoff) {
 			if (prev.br_state != XFS_EXT_UNWRITTEN &&
-			    ISNULLSTARTBLOCK(prev.br_startblock)) {
-				da_old = STARTBLOCKVAL(prev.br_startblock);
+			    isnullstartblock(prev.br_startblock)) {
+				da_old = startblockval(prev.br_startblock);
 				if (cur)
 					ASSERT(cur->bc_private.b.flags &
 						XFS_BTCUR_BPRV_WASDEL);
 				if ((error = xfs_bmap_add_extent_delay_real(ip,
 					idx, &cur, new, &da_new, first, flist,
-					&logflags, delta, rsvd)))
+					&logflags, rsvd)))
 					goto done;
 			} else if (new->br_state == XFS_EXT_NORM) {
 				ASSERT(new->br_state == XFS_EXT_NORM);
 				if ((error = xfs_bmap_add_extent_unwritten_real(
-					ip, idx, &cur, new, &logflags, delta)))
+					ip, idx, &cur, new, &logflags)))
 					goto done;
 			} else {
 				ASSERT(new->br_state == XFS_EXT_UNWRITTEN);
 				if ((error = xfs_bmap_add_extent_unwritten_real(
-					ip, idx, &cur, new, &logflags, delta)))
+					ip, idx, &cur, new, &logflags)))
 					goto done;
 			}
 			ASSERT(*curp == cur || *curp == NULL);
@@ -602,7 +519,7 @@ xfs_bmap_add_extent(
 				ASSERT((cur->bc_private.b.flags &
 					XFS_BTCUR_BPRV_WASDEL) == 0);
 			if ((error = xfs_bmap_add_extent_hole_real(ip, idx, cur,
-					new, &logflags, delta, whichfork)))
+					new, &logflags, whichfork)))
 				goto done;
 		}
 	}
@@ -634,7 +551,7 @@ xfs_bmap_add_extent(
 			nblks += cur->bc_private.b.allocated;
 		ASSERT(nblks <= da_old);
 		if (nblks < da_old)
-			xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
+			xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
 				(int64_t)(da_old - nblks), rsvd);
 	}
 	/*
@@ -667,7 +584,6 @@ xfs_bmap_add_extent_delay_real(
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd)	/* OK to use reserved data block allocation */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
@@ -684,26 +600,10 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp=0;	/* value for dnew calculations */
 	xfs_filblks_t		temp2=0;/* value for dnew calculations */
 	int			tmp_rval;	/* partial logging flags */
-	enum {				/* bit number definitions for state */
-		LEFT_CONTIG,	RIGHT_CONTIG,
-		LEFT_FILLING,	RIGHT_FILLING,
-		LEFT_DELAY,	RIGHT_DELAY,
-		LEFT_VALID,	RIGHT_VALID
-	};
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
 #define	PREV		r[2]
-#define	MASK(b)		(1 << (b))
-#define	MASK2(a,b)	(MASK(a) | MASK(b))
-#define	MASK3(a,b,c)	(MASK2(a,b) | MASK(c))
-#define	MASK4(a,b,c,d)	(MASK3(a,b,c) | MASK(d))
-#define	STATE_SET(b,v)	((v) ? (state |= MASK(b)) : (state &= ~MASK(b)))
-#define	STATE_TEST(b)	(state & MASK(b))
-#define	STATE_SET_TEST(b,v)	((v) ? ((state |= MASK(b)), 1) : \
-				       ((state &= ~MASK(b)), 0))
-#define	SWITCH_STATE		\
-	(state & MASK4(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG))
 
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
@@ -715,69 +615,80 @@ xfs_bmap_add_extent_delay_real(
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
 	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
+
 	/*
 	 * Set flags determining what part of the previous delayed allocation
 	 * extent is being replaced by a real allocation.
 	 */
-	STATE_SET(LEFT_FILLING, PREV.br_startoff == new->br_startoff);
-	STATE_SET(RIGHT_FILLING,
-		PREV.br_startoff + PREV.br_blockcount == new_endoff);
+	if (PREV.br_startoff == new->br_startoff)
+		state |= BMAP_LEFT_FILLING;
+	if (PREV.br_startoff + PREV.br_blockcount == new_endoff)
+		state |= BMAP_RIGHT_FILLING;
+
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 */
-	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
+	if (idx > 0) {
+		state |= BMAP_LEFT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(LEFT.br_startblock));
+
+		if (isnullstartblock(LEFT.br_startblock))
+			state |= BMAP_LEFT_DELAY;
 	}
-	STATE_SET(LEFT_CONTIG,
-		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
-		LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
-		LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
-		LEFT.br_state == new->br_state &&
-		LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN);
+
+	if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
+	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
+	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
+	    LEFT.br_state == new->br_state &&
+	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
 	/*
 	 * Check and set flags if this segment has a right neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (STATE_SET_TEST(RIGHT_VALID,
-			idx <
-			ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1)) {
+	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(RIGHT.br_startblock));
+
+		if (isnullstartblock(RIGHT.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
 	}
-	STATE_SET(RIGHT_CONTIG,
-		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
-		new_endoff == RIGHT.br_startoff &&
-		new->br_startblock + new->br_blockcount ==
-		    RIGHT.br_startblock &&
-		new->br_state == RIGHT.br_state &&
-		new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
-		((state & MASK3(LEFT_CONTIG, LEFT_FILLING, RIGHT_FILLING)) !=
-		  MASK3(LEFT_CONTIG, LEFT_FILLING, RIGHT_FILLING) ||
-		 LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-		     <= MAXEXTLEN));
+
+	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
+	    new_endoff == RIGHT.br_startoff &&
+	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
+	    new->br_state == RIGHT.br_state &&
+	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
+		       BMAP_RIGHT_FILLING)) !=
+		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
+		       BMAP_RIGHT_FILLING) ||
+	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
+			<= MAXEXTLEN))
+		state |= BMAP_RIGHT_CONTIG;
+
 	error = 0;
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
 	 */
-	switch (SWITCH_STATE) {
-
-	case MASK4(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
+	switch (state & (BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG |
+			 BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG |
+	     BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_DELETE("LF|RF|LC|RC", ip, idx, 2, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 2);
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
+		xfs_iext_remove(ip, idx, 2, state);
 		ip->i_df.if_lastex = idx - 1;
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
@@ -803,27 +714,20 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		*dnew = 0;
-		/* DELTA: Three in-core extents are replaced by one. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx - 1;
-		XFS_BMAP_TRACE_DELETE("LF|RF|LC", ip, idx, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 1);
+		xfs_iext_remove(ip, idx, 1, state);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -840,25 +744,21 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		*dnew = 0;
-		/* DELTA: Two in-core extents are replaced by one. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, RIGHT_FILLING, RIGHT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|RC", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|RC", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx;
-		XFS_BMAP_TRACE_DELETE("LF|RF|RC", ip, idx + 1, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx + 1, 1);
+		xfs_iext_remove(ip, idx + 1, 1, state);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -875,21 +775,18 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		*dnew = 0;
-		/* DELTA: Two in-core extents are replaced by one. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
-	case MASK2(LEFT_FILLING, RIGHT_FILLING):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -907,24 +804,22 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		*dnew = 0;
-		/* DELTA: The in-core extent described by new changed type. */
-		temp = new->br_startoff;
-		temp2 = new->br_blockcount;
 		break;
 
-	case MASK2(LEFT_FILLING, LEFT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
 		/*
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx - 1, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx - 1, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
 		temp = PREV.br_blockcount - new->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		ip->i_df.if_lastex = idx - 1;
 		if (cur == NULL)
@@ -944,28 +839,22 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock));
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx, XFS_DATA_FORK);
+			startblockval(PREV.br_startblock));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		*dnew = temp;
-		/* DELTA: The boundary between two in-core extents moved. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount;
 		break;
 
-	case MASK(LEFT_FILLING):
+	case BMAP_LEFT_FILLING:
 		/*
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is not contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		temp = PREV.br_blockcount - new->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
-		XFS_BMAP_TRACE_INSERT("LF", ip, idx, 1, new, NULL,
-			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx, 1, new);
+		xfs_iext_insert(ip, idx, 1, new, state);
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -992,31 +881,28 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock) -
+			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx + 1);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx + 1, XFS_DATA_FORK);
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		trace_xfs_bmap_post_update(ip, idx + 1, state, _THIS_IP_);
 		*dnew = temp;
-		/* DELTA: One in-core extent is split in two. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
-	case MASK2(RIGHT_FILLING, RIGHT_CONTIG):
+	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Filling in the last part of a previous delayed allocation.
 		 * The right neighbor is contiguous with the new allocation.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx, XFS_DATA_FORK);
-		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx + 1, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, idx + 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount,
 			RIGHT.br_state);
-		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx + 1, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx + 1, state, _THIS_IP_);
 		ip->i_df.if_lastex = idx + 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1035,27 +921,21 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock));
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx, XFS_DATA_FORK);
+			startblockval(PREV.br_startblock));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		*dnew = temp;
-		/* DELTA: The boundary between two in-core extents moved. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
-	case MASK(RIGHT_FILLING):
+	case BMAP_RIGHT_FILLING:
 		/*
 		 * Filling in the last part of a previous delayed allocation.
 		 * The right neighbor is not contiguous.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("RF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		XFS_BMAP_TRACE_INSERT("RF", ip, idx + 1, 1, new, NULL,
-			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx + 1, 1, new);
+		xfs_iext_insert(ip, idx + 1, 1, new, state);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1082,15 +962,12 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock) -
+			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		*dnew = temp;
-		/* DELTA: One in-core extent is split in two. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
 	case 0:
@@ -1100,7 +977,7 @@ xfs_bmap_add_extent_delay_real(
 		 * This case is avoided almost all the time.
 		 */
 		temp = new->br_startoff - PREV.br_startoff;
-		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		r[0] = *new;
 		r[1].br_state = PREV.br_state;
@@ -1108,9 +985,7 @@ xfs_bmap_add_extent_delay_real(
 		r[1].br_startoff = new_endoff;
 		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		r[1].br_blockcount = temp2;
-		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 2, &r[0], &r[1],
-			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx + 1, 2, &r[0]);
+		xfs_iext_insert(ip, idx + 1, 2, &r[0], state);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1138,10 +1013,11 @@ xfs_bmap_add_extent_delay_real(
 		}
 		temp = xfs_bmap_worst_indlen(ip, temp);
 		temp2 = xfs_bmap_worst_indlen(ip, temp2);
-		diff = (int)(temp + temp2 - STARTBLOCKVAL(PREV.br_startblock) -
+		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
-		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {
+		    xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
+					     -((int64_t)diff), rsvd)) {
 			/*
 			 * Ick gross gag me with a spoon.
 			 */
@@ -1151,67 +1027,51 @@ xfs_bmap_add_extent_delay_real(
 					temp--;
 					diff--;
 					if (!diff ||
-					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
+					    !xfs_icsb_modify_counters(ip->i_mount,
+						    XFS_SBS_FDBLOCKS,
+						    -((int64_t)diff), rsvd))
 						break;
 				}
 				if (temp2) {
 					temp2--;
 					diff--;
 					if (!diff ||
-					    !xfs_mod_incore_sb(ip->i_mount,
-						    XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd))
+					    !xfs_icsb_modify_counters(ip->i_mount,
+						    XFS_SBS_FDBLOCKS,
+						    -((int64_t)diff), rsvd))
 						break;
 				}
 			}
 		}
 		ep = xfs_iext_get_ext(ifp, idx);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, XFS_DATA_FORK);
-		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, idx + 2, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx + 2),
-			NULLSTARTBLOCK((int)temp2));
-		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
+			nullstartblock((int)temp2));
+		trace_xfs_bmap_post_update(ip, idx + 2, state, _THIS_IP_);
 		*dnew = temp + temp2;
-		/* DELTA: One in-core extent is split in three. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK3(RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK2(LEFT_FILLING, RIGHT_CONTIG):
-	case MASK2(RIGHT_FILLING, LEFT_CONTIG):
-	case MASK2(LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK(LEFT_CONTIG):
-	case MASK(RIGHT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_LEFT_CONTIG:
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * These cases are all impossible.
 		 */
 		ASSERT(0);
 	}
 	*curp = cur;
-	if (delta) {
-		temp2 += temp;
-		if (delta->xed_startoff > temp)
-			delta->xed_startoff = temp;
-		if (delta->xed_blockcount < temp2)
-			delta->xed_blockcount = temp2;
-	}
 done:
 	*logflagsp = rval;
 	return error;
 #undef	LEFT
 #undef	RIGHT
 #undef	PREV
-#undef	MASK
-#undef	MASK2
-#undef	MASK3
-#undef	MASK4
-#undef	STATE_SET
-#undef	STATE_TEST
-#undef	STATE_SET_TEST
-#undef	SWITCH_STATE
 }
 
 /*
@@ -1224,8 +1084,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta) /* Change made to incore extents */
+	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
 	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
@@ -1239,29 +1098,10 @@ xfs_bmap_add_extent_unwritten_real(
 					/* left is 0, right is 1, prev is 2 */
 	int			rval=0;	/* return value (logging flags) */
 	int			state = 0;/* state bits, accessed thru macros */
-	xfs_filblks_t		temp=0;
-	xfs_filblks_t		temp2=0;
-	enum {				/* bit number definitions for state */
-		LEFT_CONTIG,	RIGHT_CONTIG,
-		LEFT_FILLING,	RIGHT_FILLING,
-		LEFT_DELAY,	RIGHT_DELAY,
-		LEFT_VALID,	RIGHT_VALID
-	};
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
 #define	PREV		r[2]
-#define	MASK(b)		(1 << (b))
-#define	MASK2(a,b)	(MASK(a) | MASK(b))
-#define	MASK3(a,b,c)	(MASK2(a,b) | MASK(c))
-#define	MASK4(a,b,c,d)	(MASK3(a,b,c) | MASK(d))
-#define	STATE_SET(b,v)	((v) ? (state |= MASK(b)) : (state &= ~MASK(b)))
-#define	STATE_TEST(b)	(state & MASK(b))
-#define	STATE_SET_TEST(b,v)	((v) ? ((state |= MASK(b)), 1) : \
-				       ((state &= ~MASK(b)), 0))
-#define	SWITCH_STATE		\
-	(state & MASK4(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG))
-
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
@@ -1277,68 +1117,78 @@ xfs_bmap_add_extent_unwritten_real(
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
 	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
+
 	/*
 	 * Set flags determining what part of the previous oldext allocation
 	 * extent is being replaced by a newext allocation.
 	 */
-	STATE_SET(LEFT_FILLING, PREV.br_startoff == new->br_startoff);
-	STATE_SET(RIGHT_FILLING,
-		PREV.br_startoff + PREV.br_blockcount == new_endoff);
+	if (PREV.br_startoff == new->br_startoff)
+		state |= BMAP_LEFT_FILLING;
+	if (PREV.br_startoff + PREV.br_blockcount == new_endoff)
+		state |= BMAP_RIGHT_FILLING;
+
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 */
-	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
+	if (idx > 0) {
+		state |= BMAP_LEFT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(LEFT.br_startblock));
+
+		if (isnullstartblock(LEFT.br_startblock))
+			state |= BMAP_LEFT_DELAY;
 	}
-	STATE_SET(LEFT_CONTIG,
-		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
-		LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
-		LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
-		LEFT.br_state == newext &&
-		LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN);
+
+	if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
+	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
+	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
+	    LEFT.br_state == newext &&
+	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
 	/*
 	 * Check and set flags if this segment has a right neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (STATE_SET_TEST(RIGHT_VALID,
-			idx <
-			ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1)) {
+	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(RIGHT.br_startblock));
+		if (isnullstartblock(RIGHT.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
 	}
-	STATE_SET(RIGHT_CONTIG,
-		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
-		new_endoff == RIGHT.br_startoff &&
-		new->br_startblock + new->br_blockcount ==
-		    RIGHT.br_startblock &&
-		newext == RIGHT.br_state &&
-		new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
-		((state & MASK3(LEFT_CONTIG, LEFT_FILLING, RIGHT_FILLING)) !=
-		  MASK3(LEFT_CONTIG, LEFT_FILLING, RIGHT_FILLING) ||
-		 LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-		     <= MAXEXTLEN));
+
+	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
+	    new_endoff == RIGHT.br_startoff &&
+	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
+	    newext == RIGHT.br_state &&
+	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
+		       BMAP_RIGHT_FILLING)) !=
+		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
+		       BMAP_RIGHT_FILLING) ||
+	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
+			<= MAXEXTLEN))
+		state |= BMAP_RIGHT_CONTIG;
+
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
 	 */
-	switch (SWITCH_STATE) {
-
-	case MASK4(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
+	switch (state & (BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG |
+			 BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG |
+	     BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Setting all of a previous oldext extent to newext.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_DELETE("LF|RF|LC|RC", ip, idx, 2, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 2);
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
+		xfs_iext_remove(ip, idx, 2, state);
 		ip->i_df.if_lastex = idx - 1;
 		ip->i_d.di_nextents -= 2;
 		if (cur == NULL)
@@ -1368,27 +1218,20 @@ xfs_bmap_add_extent_unwritten_real(
 				RIGHT.br_blockcount, LEFT.br_state)))
 				goto done;
 		}
-		/* DELTA: Three in-core extents are replaced by one. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
 		/*
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx - 1;
-		XFS_BMAP_TRACE_DELETE("LF|RF|LC", ip, idx, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 1);
+		xfs_iext_remove(ip, idx, 1, state);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1411,27 +1254,20 @@ xfs_bmap_add_extent_unwritten_real(
 				LEFT.br_state)))
 				goto done;
 		}
-		/* DELTA: Two in-core extents are replaced by one. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, RIGHT_FILLING, RIGHT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Setting all of a previous oldext extent to newext.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|RC", ip, idx,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
 		xfs_bmbt_set_state(ep, newext);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|RC", ip, idx,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		ip->i_df.if_lastex = idx;
-		XFS_BMAP_TRACE_DELETE("LF|RF|RC", ip, idx + 1, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx + 1, 1);
+		xfs_iext_remove(ip, idx + 1, 1, state);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1454,23 +1290,18 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
-		/* DELTA: Two in-core extents are replaced by one. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
-	case MASK2(LEFT_FILLING, RIGHT_FILLING):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
 		/*
 		 * Setting all of a previous oldext extent to newext.
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF", ip, idx,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_state(ep, newext);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|RF", ip, idx,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1486,32 +1317,27 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
-		/* DELTA: The in-core extent described by new changed type. */
-		temp = new->br_startoff;
-		temp2 = new->br_blockcount;
 		break;
 
-	case MASK2(LEFT_FILLING, LEFT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
 		/*
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep,
 			new->br_startblock + new->br_blockcount);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx - 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1536,28 +1362,23 @@ xfs_bmap_add_extent_unwritten_real(
 				LEFT.br_state))
 				goto done;
 		}
-		/* DELTA: The boundary between two in-core extents moved. */
-		temp = LEFT.br_startoff;
-		temp2 = LEFT.br_blockcount +
-			PREV.br_blockcount;
 		break;
 
-	case MASK(LEFT_FILLING):
+	case BMAP_LEFT_FILLING:
 		/*
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is not contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		ASSERT(ep && xfs_bmbt_get_state(ep) == oldext);
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
 		xfs_bmbt_set_startblock(ep,
 			new->br_startblock + new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx, XFS_DATA_FORK);
-		XFS_BMAP_TRACE_INSERT("LF", ip, idx, 1, new, NULL,
-			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx, 1, new);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
+		xfs_iext_insert(ip, idx, 1, new, state);
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1580,29 +1401,23 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		/* DELTA: One in-core extent is split in two. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
-	case MASK2(RIGHT_FILLING, RIGHT_CONTIG):
+	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is contiguous with the new allocation.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx,
-			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx + 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, idx + 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount, newext);
-		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx + 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx + 1, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx + 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1626,24 +1441,19 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
-		/* DELTA: The boundary between two in-core extents moved. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount +
-			RIGHT.br_blockcount;
 		break;
 
-	case MASK(RIGHT_FILLING):
+	case BMAP_RIGHT_FILLING:
 		/*
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is not contiguous.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("RF", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
-		XFS_BMAP_TRACE_INSERT("RF", ip, idx + 1, 1, new, NULL,
-			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx + 1, 1, new);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
+		xfs_iext_insert(ip, idx + 1, 1, new, state);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -1670,9 +1480,6 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		/* DELTA: One in-core extent is split in two. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
 	case 0:
@@ -1681,19 +1488,18 @@ xfs_bmap_add_extent_unwritten_real(
 		 * newext.  Contiguity is impossible here.
 		 * One extent becomes three extents.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep,
 			new->br_startoff - PREV.br_startoff);
-		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
 		r[0] = *new;
 		r[1].br_startoff = new_endoff;
 		r[1].br_blockcount =
 			PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		r[1].br_startblock = new->br_startblock + new->br_blockcount;
 		r[1].br_state = oldext;
-		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 2, &r[0], &r[1],
-			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx + 1, 2, &r[0]);
+		xfs_iext_insert(ip, idx + 1, 2, &r[0], state);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents += 2;
 		if (cur == NULL)
@@ -1733,45 +1539,27 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		/* DELTA: One in-core extent is split in three. */
-		temp = PREV.br_startoff;
-		temp2 = PREV.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK3(RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK2(LEFT_FILLING, RIGHT_CONTIG):
-	case MASK2(RIGHT_FILLING, LEFT_CONTIG):
-	case MASK2(LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK(LEFT_CONTIG):
-	case MASK(RIGHT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_LEFT_CONTIG:
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * These cases are all impossible.
 		 */
 		ASSERT(0);
 	}
 	*curp = cur;
-	if (delta) {
-		temp2 += temp;
-		if (delta->xed_startoff > temp)
-			delta->xed_startoff = temp;
-		if (delta->xed_blockcount < temp2)
-			delta->xed_blockcount = temp2;
-	}
 done:
 	*logflagsp = rval;
 	return error;
 #undef	LEFT
 #undef	RIGHT
 #undef	PREV
-#undef	MASK
-#undef	MASK2
-#undef	MASK3
-#undef	MASK4
-#undef	STATE_SET
-#undef	STATE_TEST
-#undef	STATE_SET_TEST
-#undef	SWITCH_STATE
 }
 
 /*
@@ -1785,7 +1573,6 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_extnum_t		idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			rsvd)		/* OK to allocate reserved blocks */
 {
 	xfs_bmbt_rec_host_t	*ep;	/* extent record for idx */
@@ -1796,63 +1583,57 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			state;  /* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
-	xfs_filblks_t		temp2=0;
-	enum {				/* bit number definitions for state */
-		LEFT_CONTIG,	RIGHT_CONTIG,
-		LEFT_DELAY,	RIGHT_DELAY,
-		LEFT_VALID,	RIGHT_VALID
-	};
-
-#define	MASK(b)			(1 << (b))
-#define	MASK2(a,b)		(MASK(a) | MASK(b))
-#define	STATE_SET(b,v)		((v) ? (state |= MASK(b)) : (state &= ~MASK(b)))
-#define	STATE_TEST(b)		(state & MASK(b))
-#define	STATE_SET_TEST(b,v)	((v) ? ((state |= MASK(b)), 1) : \
-				       ((state &= ~MASK(b)), 0))
-#define	SWITCH_STATE		(state & MASK2(LEFT_CONTIG, RIGHT_CONTIG))
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	ep = xfs_iext_get_ext(ifp, idx);
 	state = 0;
-	ASSERT(ISNULLSTARTBLOCK(new->br_startblock));
+	ASSERT(isnullstartblock(new->br_startblock));
+
 	/*
 	 * Check and set flags if this segment has a left neighbor
 	 */
-	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
+	if (idx > 0) {
+		state |= BMAP_LEFT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(left.br_startblock));
+
+		if (isnullstartblock(left.br_startblock))
+			state |= BMAP_LEFT_DELAY;
 	}
+
 	/*
 	 * Check and set flags if the current (right) segment exists.
 	 * If it doesn't exist, we're converting the hole at end-of-file.
 	 */
-	if (STATE_SET_TEST(RIGHT_VALID,
-			   idx <
-			   ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
+	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(ep, &right);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(right.br_startblock));
+
+		if (isnullstartblock(right.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
 	}
+
 	/*
 	 * Set contiguity flags on the left and right neighbors.
 	 * Don't let extents get too large, even if the pieces are contiguous.
 	 */
-	STATE_SET(LEFT_CONTIG,
-		STATE_TEST(LEFT_VALID) && STATE_TEST(LEFT_DELAY) &&
-		left.br_startoff + left.br_blockcount == new->br_startoff &&
-		left.br_blockcount + new->br_blockcount <= MAXEXTLEN);
-	STATE_SET(RIGHT_CONTIG,
-		STATE_TEST(RIGHT_VALID) && STATE_TEST(RIGHT_DELAY) &&
-		new->br_startoff + new->br_blockcount == right.br_startoff &&
-		new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
-		(!STATE_TEST(LEFT_CONTIG) ||
-		 (left.br_blockcount + new->br_blockcount +
-		     right.br_blockcount <= MAXEXTLEN)));
+	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
+	    left.br_startoff + left.br_blockcount == new->br_startoff &&
+	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
+	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
+	    new->br_startoff + new->br_blockcount == right.br_startoff &&
+	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    (!(state & BMAP_LEFT_CONTIG) ||
+	     (left.br_blockcount + new->br_blockcount +
+	      right.br_blockcount <= MAXEXTLEN)))
+		state |= BMAP_RIGHT_CONTIG;
+
 	/*
 	 * Switch out based on the contiguity flags.
 	 */
-	switch (SWITCH_STATE) {
-
-	case MASK2(LEFT_CONTIG, RIGHT_CONTIG):
+	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
 		/*
 		 * New allocation is contiguous with delayed allocations
 		 * on the left and on the right.
@@ -1860,66 +1641,56 @@ xfs_bmap_add_extent_hole_delay(
 		 */
 		temp = left.br_blockcount + new->br_blockcount +
 			right.br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
+
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
-		oldlen = STARTBLOCKVAL(left.br_startblock) +
-			STARTBLOCKVAL(new->br_startblock) +
-			STARTBLOCKVAL(right.br_startblock);
+		oldlen = startblockval(left.br_startblock) +
+			startblockval(new->br_startblock) +
+			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
-			NULLSTARTBLOCK((int)newlen));
-		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
-		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, XFS_DATA_FORK);
-		xfs_iext_remove(ifp, idx, 1);
+			nullstartblock((int)newlen));
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
+		xfs_iext_remove(ip, idx, 1, state);
 		ip->i_df.if_lastex = idx - 1;
-		/* DELTA: Two in-core extents were replaced by one. */
-		temp2 = temp;
-		temp = left.br_startoff;
 		break;
 
-	case MASK(LEFT_CONTIG):
+	case BMAP_LEFT_CONTIG:
 		/*
 		 * New allocation is contiguous with a delayed allocation
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
 		temp = left.br_blockcount + new->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
-		oldlen = STARTBLOCKVAL(left.br_startblock) +
-			STARTBLOCKVAL(new->br_startblock);
+		oldlen = startblockval(left.br_startblock) +
+			startblockval(new->br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
-			NULLSTARTBLOCK((int)newlen));
-		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1,
-			XFS_DATA_FORK);
+			nullstartblock((int)newlen));
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx - 1;
-		/* DELTA: One in-core extent grew into a hole. */
-		temp2 = temp;
-		temp = left.br_startoff;
 		break;
 
-	case MASK(RIGHT_CONTIG):
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * New allocation is contiguous with a delayed allocation
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("RC", ip, idx, XFS_DATA_FORK);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		temp = new->br_blockcount + right.br_blockcount;
-		oldlen = STARTBLOCKVAL(new->br_startblock) +
-			STARTBLOCKVAL(right.br_startblock);
+		oldlen = startblockval(new->br_startblock) +
+			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_allf(ep, new->br_startoff,
-			NULLSTARTBLOCK((int)newlen), temp, right.br_state);
-		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, XFS_DATA_FORK);
+			nullstartblock((int)newlen), temp, right.br_state);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
 		ip->i_df.if_lastex = idx;
-		/* DELTA: One in-core extent grew into a hole. */
-		temp2 = temp;
-		temp = new->br_startoff;
 		break;
 
 	case 0:
@@ -1929,38 +1700,20 @@ xfs_bmap_add_extent_hole_delay(
 		 * Insert a new entry.
 		 */
 		oldlen = newlen = 0;
-		XFS_BMAP_TRACE_INSERT("0", ip, idx, 1, new, NULL,
-			XFS_DATA_FORK);
-		xfs_iext_insert(ifp, idx, 1, new);
+		xfs_iext_insert(ip, idx, 1, new, state);
 		ip->i_df.if_lastex = idx;
-		/* DELTA: A new in-core extent was added in a hole. */
-		temp2 = new->br_blockcount;
-		temp = new->br_startoff;
 		break;
 	}
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
-		xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS,
+		xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
 			(int64_t)(oldlen - newlen), rsvd);
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
 	}
-	if (delta) {
-		temp2 += temp;
-		if (delta->xed_startoff > temp)
-			delta->xed_startoff = temp;
-		if (delta->xed_blockcount < temp2)
-			delta->xed_blockcount = temp2;
-	}
 	*logflagsp = 0;
 	return 0;
-#undef	MASK
-#undef	MASK2
-#undef	STATE_SET
-#undef	STATE_TEST
-#undef	STATE_SET_TEST
-#undef	SWITCH_STATE
 }
 
 /*
@@ -1974,7 +1727,6 @@ xfs_bmap_add_extent_hole_real(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork) /* data or attr fork */
 {
 	xfs_bmbt_rec_host_t	*ep;	/* pointer to extent entry ins. point */
@@ -1985,90 +1737,80 @@ xfs_bmap_add_extent_hole_real(
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
-	xfs_filblks_t		temp=0;
-	xfs_filblks_t		temp2=0;
-	enum {				/* bit number definitions for state */
-		LEFT_CONTIG,	RIGHT_CONTIG,
-		LEFT_DELAY,	RIGHT_DELAY,
-		LEFT_VALID,	RIGHT_VALID
-	};
-
-#define	MASK(b)			(1 << (b))
-#define	MASK2(a,b)		(MASK(a) | MASK(b))
-#define	STATE_SET(b,v)		((v) ? (state |= MASK(b)) : (state &= ~MASK(b)))
-#define	STATE_TEST(b)		(state & MASK(b))
-#define	STATE_SET_TEST(b,v)	((v) ? ((state |= MASK(b)), 1) : \
-				       ((state &= ~MASK(b)), 0))
-#define	SWITCH_STATE		(state & MASK2(LEFT_CONTIG, RIGHT_CONTIG))
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
 	ep = xfs_iext_get_ext(ifp, idx);
 	state = 0;
+
+	if (whichfork == XFS_ATTR_FORK)
+		state |= BMAP_ATTRFORK;
+
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 */
-	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
+	if (idx > 0) {
+		state |= BMAP_LEFT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(left.br_startblock));
+		if (isnullstartblock(left.br_startblock))
+			state |= BMAP_LEFT_DELAY;
 	}
+
 	/*
 	 * Check and set flags if this segment has a current value.
 	 * Not true if we're inserting into the "hole" at eof.
 	 */
-	if (STATE_SET_TEST(RIGHT_VALID,
-			   idx <
-			   ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
+	if (idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(ep, &right);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(right.br_startblock));
+		if (isnullstartblock(right.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
 	}
+
 	/*
 	 * We're inserting a real allocation between "left" and "right".
 	 * Set the contiguity flags.  Don't let extents get too large.
 	 */
-	STATE_SET(LEFT_CONTIG,
-		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
-		left.br_startoff + left.br_blockcount == new->br_startoff &&
-		left.br_startblock + left.br_blockcount == new->br_startblock &&
-		left.br_state == new->br_state &&
-		left.br_blockcount + new->br_blockcount <= MAXEXTLEN);
-	STATE_SET(RIGHT_CONTIG,
-		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
-		new->br_startoff + new->br_blockcount == right.br_startoff &&
-		new->br_startblock + new->br_blockcount ==
-		    right.br_startblock &&
-		new->br_state == right.br_state &&
-		new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
-		(!STATE_TEST(LEFT_CONTIG) ||
-		 left.br_blockcount + new->br_blockcount +
-		     right.br_blockcount <= MAXEXTLEN));
+	if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
+	    left.br_startoff + left.br_blockcount == new->br_startoff &&
+	    left.br_startblock + left.br_blockcount == new->br_startblock &&
+	    left.br_state == new->br_state &&
+	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
+	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
+	    new->br_startoff + new->br_blockcount == right.br_startoff &&
+	    new->br_startblock + new->br_blockcount == right.br_startblock &&
+	    new->br_state == right.br_state &&
+	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    (!(state & BMAP_LEFT_CONTIG) ||
+	     left.br_blockcount + new->br_blockcount +
+	     right.br_blockcount <= MAXEXTLEN))
+		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
 	/*
 	 * Select which case we're in here, and implement it.
 	 */
-	switch (SWITCH_STATE) {
-
-	case MASK2(LEFT_CONTIG, RIGHT_CONTIG):
+	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
 		/*
 		 * New allocation is contiguous with real allocations on the
 		 * left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LC|RC", ip, idx - 1,
-			whichfork);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			left.br_blockcount + new->br_blockcount +
 			right.br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
-			whichfork);
-		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, whichfork);
-		xfs_iext_remove(ifp, idx, 1);
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
+		xfs_iext_remove(ip, idx, 1, state);
 		ifp->if_lastex = idx - 1;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		if (cur == NULL) {
-			rval = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2091,26 +1833,22 @@ xfs_bmap_add_extent_hole_real(
 					left.br_state)))
 				goto done;
 		}
-		/* DELTA: Two in-core extents were replaced by one. */
-		temp = left.br_startoff;
-		temp2 = left.br_blockcount +
-			new->br_blockcount +
-			right.br_blockcount;
 		break;
 
-	case MASK(LEFT_CONTIG):
+	case BMAP_LEFT_CONTIG:
 		/*
 		 * New allocation is contiguous with a real allocation
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("LC", ip, idx - 1, whichfork);
+		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			left.br_blockcount + new->br_blockcount);
-		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1, whichfork);
+		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+
 		ifp->if_lastex = idx - 1;
 		if (cur == NULL) {
-			rval = XFS_ILOG_FEXT(whichfork);
+			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2126,26 +1864,23 @@ xfs_bmap_add_extent_hole_real(
 					left.br_state)))
 				goto done;
 		}
-		/* DELTA: One in-core extent grew. */
-		temp = left.br_startoff;
-		temp2 = left.br_blockcount +
-			new->br_blockcount;
 		break;
 
-	case MASK(RIGHT_CONTIG):
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * New allocation is contiguous with a real allocation
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("RC", ip, idx, whichfork);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_allf(ep, new->br_startoff, new->br_startblock,
 			new->br_blockcount + right.br_blockcount,
 			right.br_state);
-		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, whichfork);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+
 		ifp->if_lastex = idx;
 		if (cur == NULL) {
-			rval = XFS_ILOG_FEXT(whichfork);
+			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2161,10 +1896,6 @@ xfs_bmap_add_extent_hole_real(
 					right.br_state)))
 				goto done;
 		}
-		/* DELTA: One in-core extent grew. */
-		temp = new->br_startoff;
-		temp2 = new->br_blockcount +
-			right.br_blockcount;
 		break;
 
 	case 0:
@@ -2173,13 +1904,12 @@ xfs_bmap_add_extent_hole_real(
 		 * real allocation.
 		 * Insert a new entry.
 		 */
-		XFS_BMAP_TRACE_INSERT("0", ip, idx, 1, new, NULL, whichfork);
-		xfs_iext_insert(ifp, idx, 1, new);
+		xfs_iext_insert(ip, idx, 1, new, state);
 		ifp->if_lastex = idx;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		if (cur == NULL) {
-			rval = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2193,27 +1923,11 @@ xfs_bmap_add_extent_hole_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		/* DELTA: A new extent was added in a hole. */
-		temp = new->br_startoff;
-		temp2 = new->br_blockcount;
 		break;
 	}
-	if (delta) {
-		temp2 += temp;
-		if (delta->xed_startoff > temp)
-			delta->xed_startoff = temp;
-		if (delta->xed_blockcount < temp2)
-			delta->xed_blockcount = temp2;
-	}
 done:
 	*logflagsp = rval;
 	return error;
-#undef	MASK
-#undef	MASK2
-#undef	STATE_SET
-#undef	STATE_TEST
-#undef	STATE_SET_TEST
-#undef	SWITCH_STATE
 }
 
 /*
@@ -2404,10 +2118,10 @@ xfs_bmap_adjacent(
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, ap->firstblock);
 	/*
 	 * If allocating at eof, and there's a previous real block,
-	 * try to use it's last block as our starting point.
+	 * try to use its last block as our starting point.
 	 */
 	if (ap->eof && ap->prevp->br_startoff != NULLFILEOFF &&
-	    !ISNULLSTARTBLOCK(ap->prevp->br_startblock) &&
+	    !isnullstartblock(ap->prevp->br_startblock) &&
 	    ISVALID(ap->prevp->br_startblock + ap->prevp->br_blockcount,
 		    ap->prevp->br_startblock)) {
 		ap->rval = ap->prevp->br_startblock + ap->prevp->br_blockcount;
@@ -2436,7 +2150,7 @@ xfs_bmap_adjacent(
 		 * start block based on it.
 		 */
 		if (ap->prevp->br_startoff != NULLFILEOFF &&
-		    !ISNULLSTARTBLOCK(ap->prevp->br_startblock) &&
+		    !isnullstartblock(ap->prevp->br_startblock) &&
 		    (prevbno = ap->prevp->br_startblock +
 			       ap->prevp->br_blockcount) &&
 		    ISVALID(prevbno, ap->prevp->br_startblock)) {
@@ -2477,7 +2191,7 @@ xfs_bmap_adjacent(
 		 * If there's a following (right) block, select a requested
 		 * start block based on it.
 		 */
-		if (!ISNULLSTARTBLOCK(ap->gotp->br_startblock)) {
+		if (!isnullstartblock(ap->gotp->br_startblock)) {
 			/*
 			 * Calculate gap to start of next block.
 			 */
@@ -2530,25 +2244,134 @@ xfs_bmap_adjacent(
 }
 
 STATIC int
+xfs_bmap_btalloc_nullfb(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		ag, startag;
+	int			notinit = 0;
+	int			error;
+
+	if (ap->userdata && xfs_inode_is_filestream(ap->ip))
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	else
+		args->type = XFS_ALLOCTYPE_START_BNO;
+	args->total = ap->total;
+
+	/*
+	 * Search for an allocation group with a single extent large enough
+	 * for the request.  If one isn't found, then adjust the minimum
+	 * allocation size to the largest space found.
+	 */
+	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	if (startag == NULLAGNUMBER)
+		startag = ag = 0;
+
+	pag = xfs_perag_get(mp, ag);
+	while (*blen < ap->alen) {
+		if (!pag->pagf_init) {
+			error = xfs_alloc_pagf_init(mp, args->tp, ag,
+						    XFS_ALLOC_FLAG_TRYLOCK);
+			if (error) {
+				xfs_perag_put(pag);
+				return error;
+			}
+		}
+
+		/*
+		 * See xfs_alloc_fix_freelist...
+		 */
+		if (pag->pagf_init) {
+			xfs_extlen_t	longest;
+			longest = xfs_alloc_longest_free_extent(mp, pag);
+			if (*blen < longest)
+				*blen = longest;
+		} else
+			notinit = 1;
+
+		if (xfs_inode_is_filestream(ap->ip)) {
+			if (*blen >= ap->alen)
+				break;
+
+			if (ap->userdata) {
+				/*
+				 * If startag is an invalid AG, we've
+				 * come here once before and
+				 * xfs_filestream_new_ag picked the
+				 * best currently available.
+				 *
+				 * Don't continue looping, since we
+				 * could loop forever.
+				 */
+				if (startag == NULLAGNUMBER)
+					break;
+
+				error = xfs_filestream_new_ag(ap, &ag);
+				xfs_perag_put(pag);
+				if (error)
+					return error;
+
+				/* loop again to set 'blen'*/
+				startag = NULLAGNUMBER;
+				pag = xfs_perag_get(mp, ag);
+				continue;
+			}
+		}
+		if (++ag == mp->m_sb.sb_agcount)
+			ag = 0;
+		if (ag == startag)
+			break;
+		xfs_perag_put(pag);
+		pag = xfs_perag_get(mp, ag);
+	}
+	xfs_perag_put(pag);
+
+	/*
+	 * Since the above loop did a BUF_TRYLOCK, it is
+	 * possible that there is space for this request.
+	 */
+	if (notinit || *blen < ap->minlen)
+		args->minlen = ap->minlen;
+	/*
+	 * If the best seen length is less than the request
+	 * length, use the best as the minimum.
+	 */
+	else if (*blen < ap->alen)
+		args->minlen = *blen;
+	/*
+	 * Otherwise we've seen an extent as big as alen,
+	 * use that as the minimum.
+	 */
+	else
+		args->minlen = ap->alen;
+
+	/*
+	 * set the failure fallback case to look in the selected
+	 * AG as the stream may have moved.
+	 */
+	if (xfs_inode_is_filestream(ap->ip))
+		ap->rval = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+
+	return 0;
+}
+
+STATIC int
 xfs_bmap_btalloc(
 	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
 	xfs_extlen_t	align;		/* minimum allocation alignment */
-	xfs_agnumber_t	ag;
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
-	xfs_agnumber_t	startag;
+	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
 	xfs_extlen_t	blen;
-	xfs_extlen_t	delta;
-	xfs_extlen_t	longest;
-	xfs_extlen_t	need;
 	xfs_extlen_t	nextminlen = 0;
-	xfs_perag_t	*pag;
 	int		nullfb;		/* true if ap->firstblock isn't set */
 	int		isaligned;
-	int		notinit;
 	int		tryagain;
 	int		error;
 
@@ -2595,107 +2418,9 @@ xfs_bmap_btalloc(
 	args.firstblock = ap->firstblock;
 	blen = 0;
 	if (nullfb) {
-		if (ap->userdata && xfs_inode_is_filestream(ap->ip))
-			args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		else
-			args.type = XFS_ALLOCTYPE_START_BNO;
-		args.total = ap->total;
-
-		/*
-		 * Search for an allocation group with a single extent
-		 * large enough for the request.
-		 *
-		 * If one isn't found, then adjust the minimum allocation
-		 * size to the largest space found.
-		 */
-		startag = ag = XFS_FSB_TO_AGNO(mp, args.fsbno);
-		if (startag == NULLAGNUMBER)
-			startag = ag = 0;
-		notinit = 0;
-		down_read(&mp->m_peraglock);
-		while (blen < ap->alen) {
-			pag = &mp->m_perag[ag];
-			if (!pag->pagf_init &&
-			    (error = xfs_alloc_pagf_init(mp, args.tp,
-				    ag, XFS_ALLOC_FLAG_TRYLOCK))) {
-				up_read(&mp->m_peraglock);
-				return error;
-			}
-			/*
-			 * See xfs_alloc_fix_freelist...
-			 */
-			if (pag->pagf_init) {
-				need = XFS_MIN_FREELIST_PAG(pag, mp);
-				delta = need > pag->pagf_flcount ?
-					need - pag->pagf_flcount : 0;
-				longest = (pag->pagf_longest > delta) ?
-					(pag->pagf_longest - delta) :
-					(pag->pagf_flcount > 0 ||
-					 pag->pagf_longest > 0);
-				if (blen < longest)
-					blen = longest;
-			} else
-				notinit = 1;
-
-			if (xfs_inode_is_filestream(ap->ip)) {
-				if (blen >= ap->alen)
-					break;
-
-				if (ap->userdata) {
-					/*
-					 * If startag is an invalid AG, we've
-					 * come here once before and
-					 * xfs_filestream_new_ag picked the
-					 * best currently available.
-					 *
-					 * Don't continue looping, since we
-					 * could loop forever.
-					 */
-					if (startag == NULLAGNUMBER)
-						break;
-
-					error = xfs_filestream_new_ag(ap, &ag);
-					if (error) {
-						up_read(&mp->m_peraglock);
-						return error;
-					}
-
-					/* loop again to set 'blen'*/
-					startag = NULLAGNUMBER;
-					continue;
-				}
-			}
-			if (++ag == mp->m_sb.sb_agcount)
-				ag = 0;
-			if (ag == startag)
-				break;
-		}
-		up_read(&mp->m_peraglock);
-		/*
-		 * Since the above loop did a BUF_TRYLOCK, it is
-		 * possible that there is space for this request.
-		 */
-		if (notinit || blen < ap->minlen)
-			args.minlen = ap->minlen;
-		/*
-		 * If the best seen length is less than the request
-		 * length, use the best as the minimum.
-		 */
-		else if (blen < ap->alen)
-			args.minlen = blen;
-		/*
-		 * Otherwise we've seen an extent as big as alen,
-		 * use that as the minimum.
-		 */
-		else
-			args.minlen = ap->alen;
-
-		/*
-		 * set the failure fallback case to look in the selected
-		 * AG as the stream may have moved.
-		 */
-		if (xfs_inode_is_filestream(ap->ip))
-			ap->rval = args.fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+		error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
+		if (error)
+			return error;
 	} else if (ap->low) {
 		if (xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_FIRST_AG;
@@ -2832,7 +2557,7 @@ xfs_bmap_btalloc(
 		 * Adjust the disk quota also. This was reserved
 		 * earlier.
 		 */
-		XFS_TRANS_MOD_DQUOT_BYINO(mp, ap->tp, ap->ip,
+		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
 					XFS_TRANS_DQ_BCOUNT,
 			(long) args.len);
@@ -2903,7 +2628,7 @@ xfs_bmap_btree_to_extents(
 		return error;
 	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
 	ip->i_d.di_nblocks--;
-	XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_bufs[0] == cbp)
 		cur->bc_bufs[0] = NULL;
@@ -2911,7 +2636,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(ifp->if_broot == NULL);
 	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
-	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 	return 0;
 }
 
@@ -2928,7 +2653,6 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
-	xfs_extdelta_t		*delta, /* Change made to incore extents */
 	int			whichfork, /* data or attr fork */
 	int			rsvd)	/* OK to allocate reserved blocks */
 {
@@ -2952,8 +2676,13 @@ xfs_bmap_del_extent(
 	uint			qfield;	/* quota field to update */
 	xfs_filblks_t		temp;	/* for indirect length calculations */
 	xfs_filblks_t		temp2;	/* for indirect length calculations */
+	int			state = 0;
 
 	XFS_STATS_INC(xs_del_exlist);
+
+	if (whichfork == XFS_ATTR_FORK)
+		state |= BMAP_ATTRFORK;
+
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT((idx >= 0) && (idx < ifp->if_bytes /
@@ -2965,8 +2694,8 @@ xfs_bmap_del_extent(
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got.br_startoff + got.br_blockcount;
 	ASSERT(got_endoff >= del_endoff);
-	delay = ISNULLSTARTBLOCK(got.br_startblock);
-	ASSERT(ISNULLSTARTBLOCK(del->br_startblock) == delay);
+	delay = isnullstartblock(got.br_startblock);
+	ASSERT(isnullstartblock(del->br_startblock) == delay);
 	flags = 0;
 	qfield = 0;
 	error = 0;
@@ -3018,7 +2747,7 @@ xfs_bmap_del_extent(
 		}
 		da_old = da_new = 0;
 	} else {
-		da_old = STARTBLOCKVAL(got.br_startblock);
+		da_old = startblockval(got.br_startblock);
 		da_new = 0;
 		nblks = 0;
 		do_fx = 0;
@@ -3033,8 +2762,8 @@ xfs_bmap_del_extent(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
-		XFS_BMAP_TRACE_DELETE("3", ip, idx, 1, whichfork);
-		xfs_iext_remove(ifp, idx, 1);
+		xfs_iext_remove(ip, idx, 1,
+				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
 		ifp->if_lastex = idx;
 		if (delay)
 			break;
@@ -3042,7 +2771,7 @@ xfs_bmap_del_extent(
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		flags |= XFS_ILOG_CORE;
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
@@ -3054,7 +2783,7 @@ xfs_bmap_del_extent(
 		/*
 		 * Deleting the first part of the extent.
 		 */
-		XFS_BMAP_TRACE_PRE_UPDATE("2", ip, idx, whichfork);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_startoff(ep, del_endoff);
 		temp = got.br_blockcount - del->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
@@ -3062,16 +2791,15 @@ xfs_bmap_del_extent(
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-			XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx,
-				whichfork);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 			da_new = temp;
 			break;
 		}
 		xfs_bmbt_set_startblock(ep, del_endblock);
-		XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx, whichfork);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_bmbt_update(cur, del_endoff, del_endblock,
@@ -3085,21 +2813,20 @@ xfs_bmap_del_extent(
 		 * Deleting the last part of the extent.
 		 */
 		temp = got.br_blockcount - del->br_blockcount;
-		XFS_BMAP_TRACE_PRE_UPDATE("1", ip, idx, whichfork);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		ifp->if_lastex = idx;
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-			XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx,
-				whichfork);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 			da_new = temp;
 			break;
 		}
-		XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx, whichfork);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_bmbt_update(cur, got.br_startoff,
@@ -3114,7 +2841,7 @@ xfs_bmap_del_extent(
 		 * Deleting the middle of the extent.
 		 */
 		temp = del->br_startoff - got.br_startoff;
-		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, whichfork);
+		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		new.br_startoff = del_endoff;
 		temp2 = got_endoff - del_endoff;
@@ -3174,22 +2901,22 @@ xfs_bmap_del_extent(
 				}
 				XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			} else
-				flags |= XFS_ILOG_FEXT(whichfork);
+				flags |= xfs_ilog_fext(whichfork);
 			XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		} else {
 			ASSERT(whichfork == XFS_DATA_FORK);
 			temp = xfs_bmap_worst_indlen(ip, temp);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 			temp2 = xfs_bmap_worst_indlen(ip, temp2);
-			new.br_startblock = NULLSTARTBLOCK((int)temp2);
+			new.br_startblock = nullstartblock((int)temp2);
 			da_new = temp + temp2;
 			while (da_new > da_old) {
 				if (temp) {
 					temp--;
 					da_new--;
 					xfs_bmbt_set_startblock(ep,
-						NULLSTARTBLOCK((int)temp));
+						nullstartblock((int)temp));
 				}
 				if (da_new == da_old)
 					break;
@@ -3197,14 +2924,12 @@ xfs_bmap_del_extent(
 					temp2--;
 					da_new--;
 					new.br_startblock =
-						NULLSTARTBLOCK((int)temp2);
+						nullstartblock((int)temp2);
 				}
 			}
 		}
-		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, whichfork);
-		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 1, &new, NULL,
-			whichfork);
-		xfs_iext_insert(ifp, idx + 1, 1, &new);
+		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		xfs_iext_insert(ip, idx + 1, 1, &new, state);
 		ifp->if_lastex = idx + 1;
 		break;
 	}
@@ -3223,23 +2948,16 @@ xfs_bmap_del_extent(
 	 * Adjust quota data.
 	 */
 	if (qfield)
-		XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, qfield, (long)-nblks);
+		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
 	/*
 	 * Account for change in delayed indirect blocks.
 	 * Nothing to do for disk quota accounting here.
 	 */
 	ASSERT(da_old >= da_new);
-	if (da_old > da_new)
-		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, (int64_t)(da_old - da_new),
-			rsvd);
-	if (delta) {
-		/* DELTA: report the original extent. */
-		if (delta->xed_startoff > got.br_startoff)
-			delta->xed_startoff = got.br_startoff;
-		if (delta->xed_blockcount < got.br_startoff+got.br_blockcount)
-			delta->xed_blockcount = got.br_startoff +
-							got.br_blockcount;
+	if (da_old > da_new) {
+		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+			(int64_t)(da_old - da_new), rsvd);
 	}
 done:
 	*logflagsp = flags;
@@ -3249,8 +2967,6 @@ done:
 /*
  * Remove the entry "free" from the free item list.  Prev points to the
  * previous entry, unless "free" is the head of the list.
- *
- * Note: this requires user-space public scope for libxfs_iread
  */
 void
 xfs_bmap_del_free(
@@ -3362,7 +3078,7 @@ xfs_bmap_extents_to_btree(
 	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
 	ip->i_d.di_nblocks++;
-	XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	abp = xfs_btree_get_bufl(mp, tp, args.fsbno, 0);
 	/*
 	 * Fill in the child block.
@@ -3376,7 +3092,7 @@ xfs_bmap_extents_to_btree(
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	for (cnt = i = 0; i < nextents; i++) {
 		ep = xfs_iext_get_ext(ifp, i);
-		if (!ISNULLSTARTBLOCK(xfs_bmbt_get_startblock(ep))) {
+		if (!isnullstartblock(xfs_bmbt_get_startblock(ep))) {
 			arp->l0 = cpu_to_be64(ep->l0);
 			arp->l1 = cpu_to_be64(ep->l1);
 			arp++; cnt++;
@@ -3403,11 +3119,32 @@ xfs_bmap_extents_to_btree(
 	xfs_btree_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	ASSERT(*curp == NULL);
 	*curp = cur;
-	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FBROOT(whichfork);
+	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fbroot(whichfork);
 	return 0;
 }
 
 /*
+ * Calculate the default attribute fork offset for newly created inodes.
+ */
+uint
+xfs_default_attroffset(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	uint			offset;
+
+	if (mp->m_sb.sb_inodesize == 256) {
+		offset = XFS_LITINO(mp) -
+				XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	} else {
+		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
+	}
+
+	ASSERT(offset < XFS_LITINO(mp));
+	return offset;
+}
+
+/*
  * Helper routine to reset inode di_forkoff field when switching
  * attribute fork from local to extent format - we reset it where
  * possible to make space available for inline data fork extents.
@@ -3419,15 +3156,18 @@ xfs_bmap_forkoff_reset(
 	int		whichfork)
 {
 	if (whichfork == XFS_ATTR_FORK &&
-	    (ip->i_d.di_format != XFS_DINODE_FMT_DEV) &&
-	    (ip->i_d.di_format != XFS_DINODE_FMT_UUID) &&
-	    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
-	    ((mp->m_attroffset >> 3) > ip->i_d.di_forkoff)) {
-		ip->i_d.di_forkoff = mp->m_attroffset >> 3;
-		ip->i_df.if_ext_max = XFS_IFORK_DSIZE(ip) /
-					(uint)sizeof(xfs_bmbt_rec_t);
-		ip->i_afp->if_ext_max = XFS_IFORK_ASIZE(ip) /
-					(uint)sizeof(xfs_bmbt_rec_t);
+	    ip->i_d.di_format != XFS_DINODE_FMT_DEV &&
+	    ip->i_d.di_format != XFS_DINODE_FMT_UUID &&
+	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE) {
+		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
+
+		if (dfl_forkoff > ip->i_d.di_forkoff) {
+			ip->i_d.di_forkoff = dfl_forkoff;
+			ip->i_df.if_ext_max =
+				XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t);
+			ip->i_afp->if_ext_max =
+				XFS_IFORK_ASIZE(ip) / sizeof(xfs_bmbt_rec_t);
+		}
 	}
 }
 
@@ -3502,12 +3242,14 @@ xfs_bmap_local_to_extents(
 		xfs_iext_add(ifp, 0, 1);
 		ep = xfs_iext_get_ext(ifp, 0);
 		xfs_bmbt_set_allf(ep, 0, args.fsbno, 1, XFS_EXT_NORM);
-		XFS_BMAP_TRACE_POST_UPDATE("new", ip, 0, whichfork);
+		trace_xfs_bmap_post_update(ip, 0,
+				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0,
+				_THIS_IP_);
 		XFS_IFORK_NEXT_SET(ip, whichfork, 1);
 		ip->i_d.di_nblocks = 1;
-		XFS_TRANS_MOD_DQUOT_BYINO(args.mp, tp, ip,
+		xfs_trans_mod_dquot_byino(tp, ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
-		flags |= XFS_ILOG_FEXT(whichfork);
+		flags |= xfs_ilog_fext(whichfork);
 	} else {
 		ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
 		xfs_bmap_forkoff_reset(ip->i_mount, ip, whichfork);
@@ -3528,7 +3270,7 @@ done:
  * entry (null if none).  Else, *lastxp will be set to the index
  * of the found entry; *gotp will contain the entry.
  */
-xfs_bmbt_rec_host_t *			/* pointer to found extent entry */
+STATIC xfs_bmbt_rec_host_t *		/* pointer to found extent entry */
 xfs_bmap_search_multi_extents(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	xfs_fileoff_t	bno,		/* block number searched for */
@@ -3578,8 +3320,6 @@ xfs_bmap_search_multi_extents(
  * *eofp will be set, and *prevp will contain the last entry (null if none).
  * Else, *lastxp will be set to the index of the found
  * entry; *gotp will contain the entry.
- *
- * Note this is public in libxfs for xfs_repair's phase6.
  */
 xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
 xfs_bmap_search_extents(
@@ -3682,7 +3422,7 @@ xfs_bmap_add_attrfork(
 			XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
 		goto error0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, blks, 0, rsvd ?
+	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 			XFS_QMOPT_RES_REGBLKS);
 	if (error) {
@@ -3700,9 +3440,10 @@ xfs_bmap_add_attrfork(
 		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 	ASSERT(ip->i_d.di_anextents == 0);
-	IHOLD(ip);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_DEV:
 		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
@@ -3715,7 +3456,7 @@ xfs_bmap_add_attrfork(
 	case XFS_DINODE_FMT_BTREE:
 		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
 		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = mp->m_attroffset >> 3;
+			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
 		else if (mp->m_flags & XFS_MOUNT_ATTR2)
 			version = 2;
 		break;
@@ -3732,7 +3473,7 @@ xfs_bmap_add_attrfork(
 		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	XFS_BMAP_INIT(&flist, &firstblock);
+	xfs_bmap_init(&flist, &firstblock);
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &flist,
@@ -3775,7 +3516,7 @@ xfs_bmap_add_attrfork(
 	}
 	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
 		goto error2;
-	error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	ASSERT(ip->i_df.if_ext_max ==
 	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
 	return error;
@@ -3812,7 +3553,7 @@ xfs_bmap_add_free(
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
 	ASSERT(len <= MAXEXTLEN);
-	ASSERT(!ISNULLSTARTBLOCK(bno));
+	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
 	ASSERT(agno < mp->m_sb.sb_agcount);
@@ -3862,12 +3603,12 @@ xfs_bmap_compute_maxlevels(
 	 * (a signed 16-bit number, xfs_aextnum_t).
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that
-	 * the fork offset of all the inodes will be (m_attroffset >> 3)
-	 * because we could have mounted with ATTR2 and then mounted back
-	 * with ATTR1, keeping the di_forkoff's fixed but probably at
-	 * various positions. Therefore, for both ATTR1 and ATTR2
-	 * we have to assume the worst case scenario of a minimum size
-	 * available.
+	 * the fork offset of all the inodes will be
+	 * (xfs_default_attroffset(ip) >> 3) because we could have mounted
+	 * with ATTR2 and then mounted back with ATTR1, keeping the
+	 * di_forkoff's fixed but probably at various positions. Therefore,
+	 * for both ATTR1 and ATTR2 we have to assume the worst case scenario
+	 * of a minimum size available.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
 		maxleafents = MAXEXTNUM;
@@ -4243,6 +3984,74 @@ error0:
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
+#ifdef DEBUG
+/*
+ * Add bmap trace insert entries for all the contents of the extent records.
+ */
+void
+xfs_bmap_trace_exlist(
+	xfs_inode_t	*ip,		/* incore inode pointer */
+	xfs_extnum_t	cnt,		/* count of entries in the list */
+	int		whichfork,	/* data or attr fork */
+	unsigned long	caller_ip)
+{
+	xfs_extnum_t	idx;		/* extent record index */
+	xfs_ifork_t	*ifp;		/* inode fork pointer */
+	int		state = 0;
+
+	if (whichfork == XFS_ATTR_FORK)
+		state |= BMAP_ATTRFORK;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ASSERT(cnt == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)));
+	for (idx = 0; idx < cnt; idx++)
+		trace_xfs_extlist(ip, idx, whichfork, caller_ip);
+}
+
+/*
+ * Validate that the bmbt_irecs being returned from bmapi are valid
+ * given the callers original parameters.  Specifically check the
+ * ranges of the returned irecs to ensure that they only extent beyond
+ * the given parameters if the XFS_BMAPI_ENTIRE flag was set.
+ */
+STATIC void
+xfs_bmap_validate_ret(
+	xfs_fileoff_t		bno,
+	xfs_filblks_t		len,
+	int			flags,
+	xfs_bmbt_irec_t		*mval,
+	int			nmap,
+	int			ret_nmap)
+{
+	int			i;		/* index to map values */
+
+	ASSERT(ret_nmap <= nmap);
+
+	for (i = 0; i < ret_nmap; i++) {
+		ASSERT(mval[i].br_blockcount > 0);
+		if (!(flags & XFS_BMAPI_ENTIRE)) {
+			ASSERT(mval[i].br_startoff >= bno);
+			ASSERT(mval[i].br_blockcount <= len);
+			ASSERT(mval[i].br_startoff + mval[i].br_blockcount <=
+			       bno + len);
+		} else {
+			ASSERT(mval[i].br_startoff < bno + len);
+			ASSERT(mval[i].br_startoff + mval[i].br_blockcount >
+			       bno);
+		}
+		ASSERT(i == 0 ||
+		       mval[i - 1].br_startoff + mval[i - 1].br_blockcount ==
+		       mval[i].br_startoff);
+		if ((flags & XFS_BMAPI_WRITE) && !(flags & XFS_BMAPI_DELAY))
+			ASSERT(mval[i].br_startblock != DELAYSTARTBLOCK &&
+			       mval[i].br_startblock != HOLESTARTBLOCK);
+		ASSERT(mval[i].br_state == XFS_EXT_NORM ||
+		       mval[i].br_state == XFS_EXT_UNWRITTEN);
+	}
+}
+#endif /* DEBUG */
+
+
 /*
  * Map file blocks to filesystem blocks.
  * File range is given by the bno/len pair.
@@ -4268,13 +4077,12 @@ xfs_bmapi(
 	xfs_extlen_t	total,		/* total blocks needed */
 	xfs_bmbt_irec_t	*mval,		/* output: map values */
 	int		*nmap,		/* i/o: mval size/count */
-	xfs_bmap_free_t	*flist,		/* i/o: list extents to free */
-	xfs_extdelta_t	*delta)		/* o: change made to incore extents */
+	xfs_bmap_free_t	*flist)		/* i/o: list extents to free */
 {
 	xfs_fsblock_t	abno;		/* allocated block number */
 	xfs_extlen_t	alen;		/* allocated extent length */
 	xfs_fileoff_t	aoff;		/* allocated file offset */
-	xfs_bmalloca_t	bma;		/* args for xfs_bmap_alloc */
+	xfs_bmalloca_t	bma = { 0 };	/* args for xfs_bmap_alloc */
 	xfs_btree_cur_t	*cur;		/* bmap btree cursor */
 	xfs_fileoff_t	end;		/* end of mapped file region */
 	int		eof;		/* we've hit the end of extents */
@@ -4289,7 +4097,7 @@ xfs_bmapi(
 	xfs_extlen_t	minlen;		/* min allocation size */
 	xfs_mount_t	*mp;		/* xfs mount structure */
 	int		n;		/* current extent index */
-	int		nallocs;	/* number of extents alloc\'d */
+	int		nallocs;	/* number of extents alloc'd */
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	xfs_fileoff_t	obno;		/* old block number (offset) */
 	xfs_bmbt_irec_t	prev;		/* previous file extent record */
@@ -4381,10 +4189,7 @@ xfs_bmapi(
 	end = bno + len;
 	obno = bno;
 	bma.ip = NULL;
-	if (delta) {
-		delta->xed_startoff = NULLFILEOFF;
-		delta->xed_blockcount = 0;
-	}
+
 	while (bno < end && n < *nmap) {
 		/*
 		 * Reading past eof, act as though there's a hole
@@ -4394,7 +4199,7 @@ xfs_bmapi(
 			got.br_startoff = end;
 		inhole = eof || got.br_startoff > bno;
 		wasdelay = wr && !inhole && !(flags & XFS_BMAPI_DELAY) &&
-			ISNULLSTARTBLOCK(got.br_startblock);
+			isnullstartblock(got.br_startblock);
 		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
@@ -4405,19 +4210,13 @@ xfs_bmapi(
 			 * allocate the stuff asked for in this bmap call
 			 * but that wouldn't be as good.
 			 */
-			if (wasdelay && !(flags & XFS_BMAPI_EXACT)) {
+			if (wasdelay) {
 				alen = (xfs_extlen_t)got.br_blockcount;
 				aoff = got.br_startoff;
 				if (lastx != NULLEXTNUM && lastx) {
 					ep = xfs_iext_get_ext(ifp, lastx - 1);
 					xfs_bmbt_get_all(ep, &prev);
 				}
-			} else if (wasdelay) {
-				alen = (xfs_extlen_t)
-					XFS_FILBLKS_MIN(len,
-						(got.br_startoff +
-						 got.br_blockcount) - bno);
-				aoff = bno;
 			} else {
 				alen = (xfs_extlen_t)
 					XFS_FILBLKS_MIN(len, MAXEXTLEN);
@@ -4452,10 +4251,11 @@ xfs_bmapi(
 				 * adjusted later.  We return if we haven't
 				 * allocated blocks already inside this loop.
 				 */
-				if ((error = XFS_TRANS_RESERVE_QUOTA_NBLKS(
-						mp, NULL, ip, (long)alen, 0,
+				error = xfs_trans_reserve_quota_nblks(
+						NULL, ip, (long)alen, 0,
 						rt ? XFS_QMOPT_RES_RTBLKS :
-						     XFS_QMOPT_RES_REGBLKS))) {
+						     XFS_QMOPT_RES_REGBLKS);
+				if (error) {
 					if (n == 0) {
 						*nmap = 0;
 						ASSERT(cur == NULL);
@@ -4478,13 +4278,13 @@ xfs_bmapi(
 							-((int64_t)extsz), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				} else {
-					error = xfs_mod_incore_sb(mp,
+					error = xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
 							-((int64_t)alen), (flags &
 							XFS_BMAPI_RSVBLOCKS));
 				}
 				if (!error) {
-					error = xfs_mod_incore_sb(mp,
+					error = xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
 							-((int64_t)indlen), (flags &
 							XFS_BMAPI_RSVBLOCKS));
@@ -4494,7 +4294,7 @@ xfs_bmapi(
 							(int64_t)extsz, (flags &
 							XFS_BMAPI_RSVBLOCKS));
 					else if (error)
-						xfs_mod_incore_sb(mp,
+						xfs_icsb_modify_counters(mp,
 							XFS_SBS_FDBLOCKS,
 							(int64_t)alen, (flags &
 							XFS_BMAPI_RSVBLOCKS));
@@ -4504,8 +4304,8 @@ xfs_bmapi(
 					if (XFS_IS_QUOTA_ON(mp))
 						/* unreserve the blocks now */
 						(void)
-						XFS_TRANS_UNRESERVE_QUOTA_NBLKS(
-							mp, NULL, ip,
+						xfs_trans_unreserve_quota_nblks(
+							NULL, ip,
 							(long)alen, 0, rt ?
 							XFS_QMOPT_RES_RTBLKS :
 							XFS_QMOPT_RES_REGBLKS);
@@ -4513,7 +4313,7 @@ xfs_bmapi(
 				}
 
 				ip->i_delayed_blks += alen;
-				abno = NULLSTARTBLOCK(indlen);
+				abno = nullstartblock(indlen);
 			} else {
 				/*
 				 * If first time, allocate and fill in
@@ -4615,7 +4415,7 @@ xfs_bmapi(
 					got.br_state = XFS_EXT_UNWRITTEN;
 			}
 			error = xfs_bmap_add_extent(ip, lastx, &cur, &got,
-				firstblock, flist, &tmp_logflags, delta,
+				firstblock, flist, &tmp_logflags,
 				whichfork, (flags & XFS_BMAPI_RSVBLOCKS));
 			logflags |= tmp_logflags;
 			if (error)
@@ -4629,8 +4429,8 @@ xfs_bmapi(
 				aoff + alen);
 #ifdef DEBUG
 			if (flags & XFS_BMAPI_DELAY) {
-				ASSERT(ISNULLSTARTBLOCK(got.br_startblock));
-				ASSERT(STARTBLOCKVAL(got.br_startblock) > 0);
+				ASSERT(isnullstartblock(got.br_startblock));
+				ASSERT(startblockval(got.br_startblock) > 0);
 			}
 			ASSERT(got.br_state == XFS_EXT_NORM ||
 			       got.br_state == XFS_EXT_UNWRITTEN);
@@ -4664,7 +4464,7 @@ xfs_bmapi(
 			ASSERT((bno >= obno) || (n == 0));
 			ASSERT(bno < end);
 			mval->br_startoff = bno;
-			if (ISNULLSTARTBLOCK(got.br_startblock)) {
+			if (isnullstartblock(got.br_startblock)) {
 				ASSERT(!wr || (flags & XFS_BMAPI_DELAY));
 				mval->br_startblock = DELAYSTARTBLOCK;
 			} else
@@ -4686,7 +4486,7 @@ xfs_bmapi(
 			ASSERT(mval->br_blockcount <= len);
 		} else {
 			*mval = got;
-			if (ISNULLSTARTBLOCK(mval->br_startblock)) {
+			if (isnullstartblock(mval->br_startblock)) {
 				ASSERT(!wr || (flags & XFS_BMAPI_DELAY));
 				mval->br_startblock = DELAYSTARTBLOCK;
 			}
@@ -4696,8 +4496,12 @@ xfs_bmapi(
 		 * Check if writing previously allocated but
 		 * unwritten extents.
 		 */
-		if (wr && mval->br_state == XFS_EXT_UNWRITTEN &&
-		    ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_DELAY)) == 0)) {
+		if (wr &&
+		    ((mval->br_state == XFS_EXT_UNWRITTEN &&
+		      ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_DELAY)) == 0)) ||
+		     (mval->br_state == XFS_EXT_NORM &&
+		      ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)) ==
+				(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT))))) {
 			/*
 			 * Modify (by adding) the state flag, if writing.
 			 */
@@ -4709,9 +4513,11 @@ xfs_bmapi(
 					*firstblock;
 				cur->bc_private.b.flist = flist;
 			}
-			mval->br_state = XFS_EXT_NORM;
+			mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
+						? XFS_EXT_NORM
+						: XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent(ip, lastx, &cur, mval,
-				firstblock, flist, &tmp_logflags, delta,
+				firstblock, flist, &tmp_logflags,
 				whichfork, (flags & XFS_BMAPI_RSVBLOCKS));
 			logflags |= tmp_logflags;
 			if (error)
@@ -4801,25 +4607,17 @@ xfs_bmapi(
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE ||
 	       XFS_IFORK_NEXTENTS(ip, whichfork) > ifp->if_ext_max);
 	error = 0;
-	if (delta && delta->xed_startoff != NULLFILEOFF) {
-		/* A change was actually made.
-		 * Note that delta->xed_blockount is an offset at this
-		 * point and needs to be converted to a block count.
-		 */
-		ASSERT(delta->xed_blockcount > delta->xed_startoff);
-		delta->xed_blockcount -= delta->xed_startoff;
-	}
 error0:
 	/*
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
 	 */
-	if ((logflags & XFS_ILOG_FEXT(whichfork)) &&
+	if ((logflags & xfs_ilog_fext(whichfork)) &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-		logflags &= ~XFS_ILOG_FEXT(whichfork);
-	else if ((logflags & XFS_ILOG_FBROOT(whichfork)) &&
+		logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
 		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
-		logflags &= ~XFS_ILOG_FBROOT(whichfork);
+		logflags &= ~xfs_ilog_fbroot(whichfork);
 	/*
 	 * Log whatever the flags say, even if error.  Otherwise we might miss
 	 * detecting a case where the data is changed, there's an error,
@@ -4896,7 +4694,7 @@ xfs_bmapi_single(
 		*fsb = NULLFSBLOCK;
 		return 0;
 	}
-	ASSERT(!ISNULLSTARTBLOCK(got.br_startblock));
+	ASSERT(!isnullstartblock(got.br_startblock));
 	ASSERT(bno < got.br_startoff + got.br_blockcount);
 	*fsb = got.br_startblock + (bno - got.br_startoff);
 	ifp->if_lastex = lastx;
@@ -4920,8 +4718,6 @@ xfs_bunmapi(
 	xfs_fsblock_t		*firstblock,	/* first allocated block
 						   controls a.g. for allocs */
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	xfs_extdelta_t		*delta,		/* o: change made to incore
-						   extents */
 	int			*done)		/* set if not done yet */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -4946,7 +4742,8 @@ xfs_bunmapi(
 	int			rsvd;		/* OK to allocate reserved blocks */
 	xfs_fsblock_t		sum;
 
-	xfs_bunmap_trace(ip, bno, len, flags, (inst_t *)__return_address);
+	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
+
 	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 		XFS_ATTR_FORK : XFS_DATA_FORK;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -4979,10 +4776,7 @@ xfs_bunmapi(
 	bno = start + len - 1;
 	ep = xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got,
 		&prev);
-	if (delta) {
-		delta->xed_startoff = NULLFILEOFF;
-		delta->xed_blockcount = 0;
-	}
+
 	/*
 	 * Check to see if the given block number is past the end of the
 	 * file, back up to the last block if so...
@@ -5028,7 +4822,7 @@ xfs_bunmapi(
 		 */
 		ASSERT(ep != NULL);
 		del = got;
-		wasdel = ISNULLSTARTBLOCK(del.br_startblock);
+		wasdel = isnullstartblock(del.br_startblock);
 		if (got.br_startoff < start) {
 			del.br_startoff = start;
 			del.br_blockcount -= start - got.br_startoff;
@@ -5080,7 +4874,7 @@ xfs_bunmapi(
 			}
 			del.br_state = XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent(ip, lastx, &cur, &del,
-				firstblock, flist, &logflags, delta,
+				firstblock, flist, &logflags,
 				XFS_DATA_FORK, 0);
 			if (error)
 				goto error0;
@@ -5123,7 +4917,7 @@ xfs_bunmapi(
 				xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
 						lastx - 1), &prev);
 				ASSERT(prev.br_state == XFS_EXT_NORM);
-				ASSERT(!ISNULLSTARTBLOCK(prev.br_startblock));
+				ASSERT(!isnullstartblock(prev.br_startblock));
 				ASSERT(del.br_startblock ==
 				       prev.br_startblock + prev.br_blockcount);
 				if (prev.br_startoff < start) {
@@ -5135,7 +4929,7 @@ xfs_bunmapi(
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent(ip, lastx - 1, &cur,
 					&prev, firstblock, flist, &logflags,
-					delta, XFS_DATA_FORK, 0);
+					XFS_DATA_FORK, 0);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5144,14 +4938,14 @@ xfs_bunmapi(
 				del.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent(ip, lastx, &cur,
 					&del, firstblock, flist, &logflags,
-					delta, XFS_DATA_FORK, 0);
+					XFS_DATA_FORK, 0);
 				if (error)
 					goto error0;
 				goto nodelete;
 			}
 		}
 		if (wasdel) {
-			ASSERT(STARTBLOCKVAL(del.br_startblock) > 0);
+			ASSERT(startblockval(del.br_startblock) > 0);
 			/* Update realtime/data freespace, unreserve quota */
 			if (isrt) {
 				xfs_filblks_t rtexts;
@@ -5160,14 +4954,14 @@ xfs_bunmapi(
 				do_div(rtexts, mp->m_sb.sb_rextsize);
 				xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
 						(int64_t)rtexts, rsvd);
-				(void)XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,
-					NULL, ip, -((long)del.br_blockcount), 0,
+				(void)xfs_trans_reserve_quota_nblks(NULL,
+					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
-				xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS,
+				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
 						(int64_t)del.br_blockcount, rsvd);
-				(void)XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,
-					NULL, ip, -((long)del.br_blockcount), 0,
+				(void)xfs_trans_reserve_quota_nblks(NULL,
+					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_REGBLKS);
 			}
 			ip->i_delayed_blks -= del.br_blockcount;
@@ -5197,7 +4991,7 @@ xfs_bunmapi(
 			goto error0;
 		}
 		error = xfs_bmap_del_extent(ip, tp, lastx, flist, cur, &del,
-				&tmp_logflags, delta, whichfork, rsvd);
+				&tmp_logflags, whichfork, rsvd);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
@@ -5254,25 +5048,17 @@ nodelete:
 	ASSERT(ifp->if_ext_max ==
 	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
 	error = 0;
-	if (delta && delta->xed_startoff != NULLFILEOFF) {
-		/* A change was actually made.
-		 * Note that delta->xed_blockount is an offset at this
-		 * point and needs to be converted to a block count.
-		 */
-		ASSERT(delta->xed_blockcount > delta->xed_startoff);
-		delta->xed_blockcount -= delta->xed_startoff;
-	}
 error0:
 	/*
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
 	 */
-	if ((logflags & XFS_ILOG_FEXT(whichfork)) &&
+	if ((logflags & xfs_ilog_fext(whichfork)) &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-		logflags &= ~XFS_ILOG_FEXT(whichfork);
-	else if ((logflags & XFS_ILOG_FBROOT(whichfork)) &&
+		logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
 		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
-		logflags &= ~XFS_ILOG_FBROOT(whichfork);
+		logflags &= ~xfs_ilog_fbroot(whichfork);
 	/*
 	 * Log inode even in the error case, if the transaction
 	 * is dirty we'll need to shut down the filesystem.
@@ -5330,7 +5116,202 @@ xfs_bmap_isaeof(
 	 */
 	*aeof = (off >= s.br_startoff &&
 		 off < s.br_startoff + s.br_blockcount &&
-		 ISNULLSTARTBLOCK(s.br_startblock)) ||
+		 isnullstartblock(s.br_startblock)) ||
 		off >= s.br_startoff + s.br_blockcount;
 	return 0;
 }
+
+/*
+ * Check if the endoff is outside the last extent. If so the caller will grow
+ * the allocation to a stripe unit boundary.
+ */
+int					/* error */
+xfs_bmap_eof(
+	xfs_inode_t	*ip,		/* incore inode pointer */
+	xfs_fileoff_t	endoff,		/* file offset in fsblocks */
+	int		whichfork,	/* data or attribute fork */
+	int		*eof)		/* result value */
+{
+	xfs_fsblock_t	blockcount;	/* extent block count */
+	int		error;		/* error return value */
+	xfs_ifork_t	*ifp;		/* inode fork pointer */
+	xfs_bmbt_rec_host_t *lastrec;	/* extent record pointer */
+	xfs_extnum_t	nextents;	/* number of file extents */
+	xfs_fileoff_t	startoff;	/* extent starting file offset */
+
+	ASSERT(whichfork == XFS_DATA_FORK);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
+	    (error = xfs_iread_extents(NULL, ip, whichfork)))
+		return error;
+	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	if (nextents == 0) {
+		*eof = 1;
+		return 0;
+	}
+	/*
+	 * Go to the last extent
+	 */
+	lastrec = xfs_iext_get_ext(ifp, nextents - 1);
+	startoff = xfs_bmbt_get_startoff(lastrec);
+	blockcount = xfs_bmbt_get_blockcount(lastrec);
+	*eof = endoff >= startoff + blockcount;
+	return 0;
+}
+
+/*
+ * Count fsblocks of the given fork.
+ */
+int						/* error */
+xfs_bmap_count_blocks(
+	xfs_trans_t		*tp,		/* transaction pointer */
+	xfs_inode_t		*ip,		/* incore inode */
+	int			whichfork,	/* data or attr fork */
+	int			*count)		/* out: count of blocks */
+{
+	struct xfs_btree_block	*block;	/* current btree block */
+	xfs_fsblock_t		bno;	/* block # of "block" */
+	xfs_ifork_t		*ifp;	/* fork structure */
+	int			level;	/* btree level, for checking */
+	xfs_mount_t		*mp;	/* file system mount structure */
+	__be64			*pp;	/* pointer to block address */
+
+	bno = NULLFSBLOCK;
+	mp = ip->i_mount;
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
+		xfs_bmap_count_leaves(ifp, 0,
+			ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t),
+			count);
+		return 0;
+	}
+
+	/*
+	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
+	 */
+	block = ifp->if_broot;
+	level = be16_to_cpu(block->bb_level);
+	ASSERT(level > 0);
+	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
+	bno = be64_to_cpu(*pp);
+	ASSERT(bno != NULLDFSBNO);
+	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
+	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
+
+	if (unlikely(xfs_bmap_count_tree(mp, tp, ifp, bno, level, count) < 0)) {
+		XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)", XFS_ERRLEVEL_LOW,
+				 mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	return 0;
+}
+
+/*
+ * Recursively walks each level of a btree
+ * to count total fsblocks is use.
+ */
+STATIC int                                     /* error */
+xfs_bmap_count_tree(
+	xfs_mount_t     *mp,            /* file system mount point */
+	xfs_trans_t     *tp,            /* transaction pointer */
+	xfs_ifork_t	*ifp,		/* inode fork pointer */
+	xfs_fsblock_t   blockno,	/* file system block number */
+	int             levelin,	/* level in btree */
+	int		*count)		/* Count of blocks */
+{
+	int			error;
+	xfs_buf_t		*bp, *nbp;
+	int			level = levelin;
+	__be64			*pp;
+	xfs_fsblock_t           bno = blockno;
+	xfs_fsblock_t		nextbno;
+	struct xfs_btree_block	*block, *nextblock;
+	int			numrecs;
+
+	if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp, XFS_BMAP_BTREE_REF)))
+		return error;
+	*count += 1;
+	block = XFS_BUF_TO_BLOCK(bp);
+
+	if (--level) {
+		/* Not at node above leaves, count this level of nodes */
+		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
+		while (nextbno != NULLFSBLOCK) {
+			if ((error = xfs_btree_read_bufl(mp, tp, nextbno,
+				0, &nbp, XFS_BMAP_BTREE_REF)))
+				return error;
+			*count += 1;
+			nextblock = XFS_BUF_TO_BLOCK(nbp);
+			nextbno = be64_to_cpu(nextblock->bb_u.l.bb_rightsib);
+			xfs_trans_brelse(tp, nbp);
+		}
+
+		/* Dive to the next level */
+		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
+		bno = be64_to_cpu(*pp);
+		if (unlikely((error =
+		     xfs_bmap_count_tree(mp, tp, ifp, bno, level, count)) < 0)) {
+			xfs_trans_brelse(tp, bp);
+			XFS_ERROR_REPORT("xfs_bmap_count_tree(1)",
+					 XFS_ERRLEVEL_LOW, mp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+		xfs_trans_brelse(tp, bp);
+	} else {
+		/* count all level 1 nodes and their leaves */
+		for (;;) {
+			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
+			numrecs = be16_to_cpu(block->bb_numrecs);
+			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
+			xfs_trans_brelse(tp, bp);
+			if (nextbno == NULLFSBLOCK)
+				break;
+			bno = nextbno;
+			if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
+				XFS_BMAP_BTREE_REF)))
+				return error;
+			*count += 1;
+			block = XFS_BUF_TO_BLOCK(bp);
+		}
+	}
+	return 0;
+}
+
+/*
+ * Count leaf blocks given a range of extent records.
+ */
+STATIC void
+xfs_bmap_count_leaves(
+	xfs_ifork_t		*ifp,
+	xfs_extnum_t		idx,
+	int			numrecs,
+	int			*count)
+{
+	int		b;
+
+	for (b = 0; b < numrecs; b++) {
+		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, idx + b);
+		*count += xfs_bmbt_get_blockcount(frp);
+	}
+}
+
+/*
+ * Count leaf blocks given a range of extent records originally
+ * in btree format.
+ */
+STATIC void
+xfs_bmap_disk_count_leaves(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	int			numrecs,
+	int			*count)
+{
+	int		b;
+	xfs_bmbt_rec_t	*frp;
+
+	for (b = 1; b <= numrecs; b++) {
+		frp = XFS_BMBT_REC_ADDR(mp, block, b);
+		*count += xfs_bmbt_disk_get_blockcount(frp);
+	}
+}
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index a7a0805..ff51fdd 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -71,8 +71,7 @@ xfs_bmdr_to_bmbt(
  * This code must be in sync with the routines xfs_bmbt_get_startoff,
  * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
  */
-
-STATIC_INLINE void
+STATIC void
 __xfs_bmbt_get_all(
 		__uint64_t l0,
 		__uint64_t l1,
@@ -83,25 +82,25 @@ __xfs_bmbt_get_all(
 
 	ext_flag = (int)(l0 >> (64 - BMBT_EXNTFLAG_BITLEN));
 	s->br_startoff = ((xfs_fileoff_t)l0 &
-			   XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+			   xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 #if XFS_BIG_BLKNOS
-	s->br_startblock = (((xfs_fsblock_t)l0 & XFS_MASK64LO(9)) << 43) |
+	s->br_startblock = (((xfs_fsblock_t)l0 & xfs_mask64lo(9)) << 43) |
 			   (((xfs_fsblock_t)l1) >> 21);
 #else
 #ifdef DEBUG
 	{
 		xfs_dfsbno_t	b;
 
-		b = (((xfs_dfsbno_t)l0 & XFS_MASK64LO(9)) << 43) |
+		b = (((xfs_dfsbno_t)l0 & xfs_mask64lo(9)) << 43) |
 		    (((xfs_dfsbno_t)l1) >> 21);
-		ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
+		ASSERT((b >> 32) == 0 || isnulldstartblock(b));
 		s->br_startblock = (xfs_fsblock_t)b;
 	}
 #else	/* !DEBUG */
 	s->br_startblock = (xfs_fsblock_t)(((xfs_dfsbno_t)l1) >> 21);
 #endif	/* DEBUG */
 #endif	/* XFS_BIG_BLKNOS */
-	s->br_blockcount = (xfs_filblks_t)(l1 & XFS_MASK64LO(21));
+	s->br_blockcount = (xfs_filblks_t)(l1 & xfs_mask64lo(21));
 	/* This is xfs_extent_state() in-line */
 	if (ext_flag) {
 		ASSERT(s->br_blockcount != 0);	/* saved for DMIG */
@@ -126,7 +125,7 @@ xfs_filblks_t
 xfs_bmbt_get_blockcount(
 	xfs_bmbt_rec_host_t	*r)
 {
-	return (xfs_filblks_t)(r->l1 & XFS_MASK64LO(21));
+	return (xfs_filblks_t)(r->l1 & xfs_mask64lo(21));
 }
 
 /*
@@ -137,15 +136,15 @@ xfs_bmbt_get_startblock(
 	xfs_bmbt_rec_host_t	*r)
 {
 #if XFS_BIG_BLKNOS
-	return (((xfs_fsblock_t)r->l0 & XFS_MASK64LO(9)) << 43) |
+	return (((xfs_fsblock_t)r->l0 & xfs_mask64lo(9)) << 43) |
 	       (((xfs_fsblock_t)r->l1) >> 21);
 #else
 #ifdef DEBUG
 	xfs_dfsbno_t	b;
 
-	b = (((xfs_dfsbno_t)r->l0 & XFS_MASK64LO(9)) << 43) |
+	b = (((xfs_dfsbno_t)r->l0 & xfs_mask64lo(9)) << 43) |
 	    (((xfs_dfsbno_t)r->l1) >> 21);
-	ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
+	ASSERT((b >> 32) == 0 || isnulldstartblock(b));
 	return (xfs_fsblock_t)b;
 #else	/* !DEBUG */
 	return (xfs_fsblock_t)(((xfs_dfsbno_t)r->l1) >> 21);
@@ -161,7 +160,7 @@ xfs_bmbt_get_startoff(
 	xfs_bmbt_rec_host_t	*r)
 {
 	return ((xfs_fileoff_t)r->l0 &
-		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
 xfs_exntst_t
@@ -175,16 +174,6 @@ xfs_bmbt_get_state(
 				ext_flag);
 }
 
-/* Endian flipping versions of the bmbt extraction functions */
-void
-xfs_bmbt_disk_get_all(
-	xfs_bmbt_rec_t	*r,
-	xfs_bmbt_irec_t *s)
-{
-	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
-				get_unaligned_be64(&r->l1), s);
-}
-
 /*
  * Extract the blockcount field from an on disk bmap extent record.
  */
@@ -192,7 +181,7 @@ xfs_filblks_t
 xfs_bmbt_disk_get_blockcount(
 	xfs_bmbt_rec_t	*r)
 {
-	return (xfs_filblks_t)(be64_to_cpu(r->l1) & XFS_MASK64LO(21));
+	return (xfs_filblks_t)(be64_to_cpu(r->l1) & xfs_mask64lo(21));
 }
 
 /*
@@ -203,7 +192,7 @@ xfs_bmbt_disk_get_startoff(
 	xfs_bmbt_rec_t	*r)
 {
 	return ((xfs_fileoff_t)be64_to_cpu(r->l0) &
-		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
 
@@ -221,33 +210,33 @@ xfs_bmbt_set_allf(
 	int		extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
 
 	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
 #if XFS_BIG_BLKNOS
-	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
 	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 		((xfs_bmbt_rec_base_t)startoff << 9) |
 		((xfs_bmbt_rec_base_t)startblock >> 43);
 	r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
 		((xfs_bmbt_rec_base_t)blockcount &
-		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+		(xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(startblock)) {
+	if (isnullstartblock(startblock)) {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9) |
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = XFS_MASK64HI(11) |
+			 (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
+		r->l1 = xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)startblock << 21) |
 			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			   (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	} else {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9);
 		r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
 			 ((xfs_bmbt_rec_base_t)blockcount &
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			 (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -279,11 +268,11 @@ xfs_bmbt_disk_set_allf(
 	int			extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
 
 	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
 #if XFS_BIG_BLKNOS
-	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
 	r->l0 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)extent_flag << 63) |
@@ -292,17 +281,17 @@ xfs_bmbt_disk_set_allf(
 	r->l1 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)startblock << 21) |
 		 ((xfs_bmbt_rec_base_t)blockcount &
-		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(startblock)) {
+	if (isnullstartblock(startblock)) {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			 ((xfs_bmbt_rec_base_t)startoff << 9) |
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
-		r->l1 = cpu_to_be64(XFS_MASK64HI(11) |
+			  (xfs_bmbt_rec_base_t)xfs_mask64lo(9));
+		r->l1 = cpu_to_be64(xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)startblock << 21) |
 			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+			   (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 	} else {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
@@ -310,7 +299,7 @@ xfs_bmbt_disk_set_allf(
 		r->l1 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)startblock << 21) |
 			 ((xfs_bmbt_rec_base_t)blockcount &
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+			  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -318,7 +307,7 @@ xfs_bmbt_disk_set_allf(
 /*
  * Set all the fields in a bmap extent record from the uncompressed form.
  */
-void
+STATIC void
 xfs_bmbt_disk_set_all(
 	xfs_bmbt_rec_t	*r,
 	xfs_bmbt_irec_t *s)
@@ -335,9 +324,9 @@ xfs_bmbt_set_blockcount(
 	xfs_bmbt_rec_host_t *r,
 	xfs_filblks_t	v)
 {
-	ASSERT((v & XFS_MASK64HI(43)) == 0);
-	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(43)) |
-		  (xfs_bmbt_rec_base_t)(v & XFS_MASK64LO(21));
+	ASSERT((v & xfs_mask64hi(43)) == 0);
+	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64hi(43)) |
+		  (xfs_bmbt_rec_base_t)(v & xfs_mask64lo(21));
 }
 
 /*
@@ -349,21 +338,21 @@ xfs_bmbt_set_startblock(
 	xfs_fsblock_t	v)
 {
 #if XFS_BIG_BLKNOS
-	ASSERT((v & XFS_MASK64HI(12)) == 0);
-	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(55)) |
+	ASSERT((v & xfs_mask64hi(12)) == 0);
+	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64hi(55)) |
 		  (xfs_bmbt_rec_base_t)(v >> 43);
-	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)) |
+	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21)) |
 		  (xfs_bmbt_rec_base_t)(v << 21);
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(v)) {
-		r->l0 |= (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = (xfs_bmbt_rec_base_t)XFS_MASK64HI(11) |
+	if (isnullstartblock(v)) {
+		r->l0 |= (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
+		r->l1 = (xfs_bmbt_rec_base_t)xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			  (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	} else {
-		r->l0 &= ~(xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
+		r->l0 &= ~(xfs_bmbt_rec_base_t)xfs_mask64lo(9);
 		r->l1 = ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			  (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -376,10 +365,10 @@ xfs_bmbt_set_startoff(
 	xfs_bmbt_rec_host_t *r,
 	xfs_fileoff_t	v)
 {
-	ASSERT((v & XFS_MASK64HI(9)) == 0);
-	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) XFS_MASK64HI(1)) |
+	ASSERT((v & xfs_mask64hi(9)) == 0);
+	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) xfs_mask64hi(1)) |
 		((xfs_bmbt_rec_base_t)v << 9) |
-		  (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
+		  (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64lo(9));
 }
 
 /*
@@ -392,9 +381,9 @@ xfs_bmbt_set_state(
 {
 	ASSERT(v == XFS_EXT_NORM || v == XFS_EXT_UNWRITTEN);
 	if (v == XFS_EXT_NORM)
-		r->l0 &= XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN);
+		r->l0 &= xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN);
 	else
-		r->l0 |= XFS_MASK64HI(BMBT_EXNTFLAG_BITLEN);
+		r->l0 |= xfs_mask64hi(BMBT_EXNTFLAG_BITLEN);
 }
 
 /*
@@ -563,7 +552,7 @@ xfs_bmbt_alloc_block(
 	cur->bc_private.b.allocated++;
 	cur->bc_private.b.ip->i_d.di_nblocks++;
 	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
-	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
+	xfs_trans_mod_dquot_byino(args.tp, cur->bc_private.b.ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
 
 	new->l = cpu_to_be64(args.fsbno);
@@ -591,7 +580,7 @@ xfs_bmbt_free_block(
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, bp);
 	return 0;
 }
@@ -752,12 +741,6 @@ xfs_bmbt_trace_enter(
 		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
 		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
 		(void *)a8, (void *)a9, (void *)a10);
-	ktrace_enter(ip->i_btrace,
-		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
-		(void *)func, (void *)s, (void *)ip, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
 }
 
 STATIC void
@@ -806,6 +789,16 @@ xfs_bmbt_trace_record(
 }
 #endif /* XFS_BTREE_TRACE */
 
+/* Endian flipping versions of the bmbt extraction functions */
+void
+xfs_bmbt_disk_get_all(
+	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_irec_t *s)
+{
+	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
+				get_unaligned_be64(&r->l1), s);
+}
+
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 83c2114..02854db 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -59,7 +59,7 @@ xfs_btree_check_lblock(
 			XFS_ERRTAG_BTREE_CHECK_LBLOCK,
 			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
 		if (bp)
-			xfs_buftrace("LBTREE ERROR", bp);
+			trace_xfs_btree_corrupt(bp, _RET_IP_);
 		XFS_ERROR_REPORT("xfs_btree_check_lblock", XFS_ERRLEVEL_LOW,
 				 mp);
 		return XFS_ERROR(EFSCORRUPTED);
@@ -97,9 +97,9 @@ xfs_btree_check_sblock(
 			XFS_ERRTAG_BTREE_CHECK_SBLOCK,
 			XFS_RANDOM_BTREE_CHECK_SBLOCK))) {
 		if (bp)
-			xfs_buftrace("SBTREE ERROR", bp);
-		XFS_ERROR_REPORT("xfs_btree_check_sblock", XFS_ERRLEVEL_LOW,
-				 cur->bc_mp);
+			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		XFS_CORRUPTION_ERROR("xfs_btree_check_sblock",
+			XFS_ERRLEVEL_LOW, cur->bc_mp, block);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	return 0;
@@ -199,7 +199,7 @@ xfs_btree_del_cursor(
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
 		if (cur->bc_bufs[i])
-			xfs_btree_setbuf(cur, i, NULL);
+			xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
 		else if (!error)
 			break;
 	}
@@ -670,8 +670,8 @@ xfs_btree_readahead_lblock(
 	struct xfs_btree_block	*block)
 {
 	int			rval = 0;
-	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
-	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+	xfs_dfsbno_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
+	xfs_dfsbno_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
 		xfs_btree_reada_bufl(cur->bc_mp, left, 1);
@@ -747,22 +747,19 @@ xfs_btree_readahead(
  * Set the buffer for level "lev" in the cursor to bp, releasing
  * any previous buffer.
  */
-void
+STATIC void
 xfs_btree_setbuf(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
 	xfs_buf_t		*bp)	/* new buffer to set */
 {
 	struct xfs_btree_block	*b;	/* btree block */
-	xfs_buf_t		*obp;	/* old buffer pointer */
 
-	obp = cur->bc_bufs[lev];
-	if (obp)
-		xfs_trans_brelse(cur->bc_tp, obp);
+	if (cur->bc_bufs[lev])
+		xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[lev]);
 	cur->bc_bufs[lev] = bp;
 	cur->bc_ra[lev] = 0;
-	if (!bp)
-		return;
+
 	b = XFS_BUF_TO_BLOCK(bp);
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (be64_to_cpu(b->bb_u.l.bb_leftsib) == NULLDFSBNO)
@@ -783,7 +780,7 @@ xfs_btree_ptr_is_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
+		return be64_to_cpu(ptr->l) == NULLDFSBNO;
 	else
 		return be32_to_cpu(ptr->s) == NULLAGBLOCK;
 }
@@ -794,7 +791,7 @@ xfs_btree_set_ptr_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		ptr->l = cpu_to_be64(NULLFSBLOCK);
+		ptr->l = cpu_to_be64(NULLDFSBNO);
 	else
 		ptr->s = cpu_to_be32(NULLAGBLOCK);
 }
@@ -858,8 +855,8 @@ xfs_btree_init_block(
 	new->bb_numrecs = cpu_to_be16(numrecs);
 
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
-		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
+		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
+		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
 	} else {
 		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
@@ -900,7 +897,7 @@ xfs_btree_buf_to_ptr(
 		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
 					XFS_BUF_ADDR(bp)));
 	else {
-		ptr->s = cpu_to_be32(XFS_DADDR_TO_AGBNO(cur->bc_mp,
+		ptr->s = cpu_to_be32(xfs_daddr_to_agbno(cur->bc_mp,
 					XFS_BUF_ADDR(bp)));
 	}
 }
@@ -911,7 +908,7 @@ xfs_btree_ptr_to_daddr(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ASSERT(be64_to_cpu(ptr->l) != NULLFSBLOCK);
+		ASSERT(be64_to_cpu(ptr->l) != NULLDFSBNO);
 
 		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
 	} else {
@@ -931,13 +928,13 @@ xfs_btree_set_refs(
 	switch (cur->bc_btnum) {
 	case XFS_BTNUM_BNO:
 	case XFS_BTNUM_CNT:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
+		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
 		break;
 	case XFS_BTNUM_INO:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_INOMAP, XFS_INO_BTREE_REF);
+		XFS_BUF_SET_VTYPE_REF(bp, B_FS_INOMAP, XFS_INO_BTREE_REF);
 		break;
 	case XFS_BTNUM_BMAP:
-		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_BMAP_BTREE_REF);
+		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, XFS_BMAP_BTREE_REF);
 		break;
 	default:
 		ASSERT(0);
@@ -956,7 +953,7 @@ xfs_btree_get_buf_block(
 	xfs_daddr_t		d;
 
 	/* need to sort out how callers deal with failures first */
-	ASSERT(!(flags & XFS_BUF_TRYLOCK));
+	ASSERT(!(flags & XBF_TRYLOCK));
 
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
 	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
@@ -987,7 +984,7 @@ xfs_btree_read_buf_block(
 	int			error;
 
 	/* need to sort out how callers deal with failures first */
-	ASSERT(!(flags & XFS_BUF_TRYLOCK));
+	ASSERT(!(flags & XBF_TRYLOCK));
 
 	d = xfs_btree_ptr_to_daddr(cur, ptr);
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
@@ -1823,7 +1820,7 @@ xfs_btree_lshift(
 
 	/*
 	 * We add one entry to the left side and remove one for the right side.
-	 * Accout for it here, the changes will be updated on disk and logged
+	 * Account for it here, the changes will be updated on disk and logged
 	 * later.
 	 */
 	lrecs++;
@@ -2394,7 +2391,7 @@ xfs_btree_new_iroot(
 	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
 
 	*logflags |=
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork);
 	*stat = 1;
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	return 0;
@@ -2891,7 +2888,7 @@ error0:
  * inode we have to copy the single block it was pointing to into the
  * inode.
  */
-int
+STATIC int
 xfs_btree_kill_iroot(
 	struct xfs_btree_cur	*cur)
 {
@@ -2988,13 +2985,50 @@ xfs_btree_kill_iroot(
 	cur->bc_bufs[level - 1] = NULL;
 	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	cur->bc_nlevels--;
 out0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	return 0;
 }
 
+/*
+ * Kill the current root node, and replace it with it's only child node.
+ */
+STATIC int
+xfs_btree_kill_root(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			level,
+	union xfs_btree_ptr	*newroot)
+{
+	int			error;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, killroot);
+
+	/*
+	 * Update the root pointer, decreasing the level by 1 and then
+	 * free the old root.
+	 */
+	cur->bc_ops->set_root(cur, newroot, -1);
+
+	error = cur->bc_ops->free_block(cur, bp);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+
+	XFS_BTREE_STATS_INC(cur, free);
+
+	cur->bc_bufs[level] = NULL;
+	cur->bc_ra[level] = 0;
+	cur->bc_nlevels--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
+
 STATIC int
 xfs_btree_dec_cursor(
 	struct xfs_btree_cur	*cur,
@@ -3179,7 +3213,7 @@ xfs_btree_delrec(
 			 * Make it the new root of the btree.
 			 */
 			pp = xfs_btree_ptr_addr(cur, 1, block);
-			error = cur->bc_ops->kill_root(cur, bp, level, pp);
+			error = xfs_btree_kill_root(cur, bp, level, pp);
 			if (error)
 				goto error0;
 		} else if (level > 0) {
@@ -3475,7 +3509,7 @@ xfs_btree_delrec(
 	XFS_BTREE_STATS_INC(cur, join);
 
 	/*
-	 * Fix up the the number of records and right block pointer in the
+	 * Fix up the number of records and right block pointer in the
 	 * surviving block, and log it.
 	 */
 	xfs_btree_set_numrecs(left, lrecs + rrecs);
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 40b52a4..3eb34d6 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -24,8 +24,6 @@
  * Routines to implement directories as Btrees of hashed names.
  */
 
-static int xfs_error_level;
-
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -553,16 +551,14 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	xfs_da_intnode_t *node;
 	xfs_da_node_entry_t *btree;
 	int tmp;
-	xfs_mount_t *mp;
 
 	node = oldblk->bp->data;
-	mp = state->mp;
 	ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
 	ASSERT((oldblk->index >= 0) && (oldblk->index <= be16_to_cpu(node->hdr.count)));
 	ASSERT(newblk->blkno != 0);
 	if (state->args->whichfork == XFS_DATA_FORK)
-		ASSERT(newblk->blkno >= mp->m_dirleafblk &&
-		       newblk->blkno < mp->m_dirfreeblk);
+		ASSERT(newblk->blkno >= state->mp->m_dirleafblk &&
+		       newblk->blkno < state->mp->m_dirfreeblk);
 
 	/*
 	 * We may need to make some room before we insert the new node.
@@ -1476,7 +1472,7 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
  * This is implemented with some source-level loop unrolling.
  */
 xfs_dahash_t
-xfs_da_hashname(const uchar_t *name, int namelen)
+xfs_da_hashname(const __uint8_t *name, int namelen)
 {
 	xfs_dahash_t hash;
 
@@ -1506,8 +1502,8 @@ xfs_da_hashname(const uchar_t *name, int namelen)
 enum xfs_dacmp
 xfs_da_compname(
 	struct xfs_da_args *args,
-	const char 	*name,
-	int 		len)
+	const unsigned char *name,
+	int		len)
 {
 	return (args->namelen == len && memcmp(args->name, name, len) == 0) ?
 					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
@@ -1539,11 +1535,14 @@ xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
 	int nmap, error, w, count, c, got, i, mapi;
 	xfs_trans_t *tp;
 	xfs_mount_t *mp;
+	xfs_drfsbno_t	nblks;
 
 	dp = args->dp;
 	mp = dp->i_mount;
 	w = args->whichfork;
 	tp = args->trans;
+	nblks = dp->i_d.di_nblocks;
+
 	/*
 	 * For new directories adjust the file offset and block count.
 	 */
@@ -1567,10 +1566,10 @@ xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
 	nmap = 1;
 	ASSERT(args->firstblock != NULL);
 	if ((error = xfs_bmapi(tp, dp, bno, count,
-			XFS_BMAPI_AFLAG(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
+			xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
 			XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
-			args->flist, NULL))) {
+			args->flist))) {
 		return error;
 	}
 	ASSERT(nmap <= 1);
@@ -1588,11 +1587,10 @@ xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
 			nmap = MIN(XFS_BMAP_MAX_NMAP, count);
 			c = (int)(bno + count - b);
 			if ((error = xfs_bmapi(tp, dp, b, c,
-					XFS_BMAPI_AFLAG(w)|XFS_BMAPI_WRITE|
+					xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|
 					XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
-					&mapp[mapi], &nmap, args->flist,
-					NULL))) {
+					&mapp[mapi], &nmap, args->flist))) {
 				kmem_free(mapp);
 				return error;
 			}
@@ -1620,6 +1618,8 @@ xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
 	}
 	if (mapp != &map)
 		kmem_free(mapp);
+	/* account for newly allocated blocks in reserved blocks total */
+	args->total -= dp->i_d.di_nblocks - nblks;
 	*new_blkno = (xfs_dablk_t)bno;
 	return 0;
 }
@@ -1850,8 +1850,8 @@ xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 		 * the last block to the place we want to kill.
 		 */
 		if ((error = xfs_bunmapi(tp, dp, dead_blkno, count,
-				XFS_BMAPI_AFLAG(w)|XFS_BMAPI_METADATA,
-				0, args->firstblock, args->flist, NULL,
+				xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
+				0, args->firstblock, args->flist,
 				&done)) == ENOSPC) {
 			if (w != XFS_DATA_FORK)
 				break;
@@ -1896,8 +1896,6 @@ xfs_da_map_covers_blocks(
 /*
  * Make a dabuf.
  * Used for get_buf, read_buf, read_bufr, and reada_buf.
- *
- * Note: this requires user-space public scope for libxfs_da_read_bufr
  */
 int
 xfs_da_do_buf(
@@ -1957,8 +1955,8 @@ xfs_da_do_buf(
 			if ((error = xfs_bmapi(trans, dp, (xfs_fileoff_t)bno,
 					nfsb,
 					XFS_BMAPI_METADATA |
-						XFS_BMAPI_AFLAG(whichfork),
-					NULL, 0, mapp, &nmap, NULL, NULL)))
+						xfs_bmapi_aflag(whichfork),
+					NULL, 0, mapp, &nmap, NULL)))
 				goto exit0;
 		}
 	} else {
@@ -2019,7 +2017,7 @@ xfs_da_do_buf(
 				mappedbno, nmapped, 0, &bp);
 			break;
 		case 3:
-			xfs_baread(mp->m_ddev_targp, mappedbno, nmapped);
+			xfs_buf_readahead(mp->m_ddev_targp, mappedbno, nmapped);
 			error = 0;
 			bp = NULL;
 			break;
@@ -2077,7 +2075,7 @@ xfs_da_do_buf(
 				   (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC),
 				mp, XFS_ERRTAG_DA_READ_BUF,
 				XFS_RANDOM_DA_READ_BUF))) {
-			xfs_buftrace("DA READ ERROR", rbp->bps[0]);
+			trace_xfs_da_btree_corrupt(rbp->bps[0], _RET_IP_);
 			XFS_CORRUPTION_ERROR("xfs_da_do_buf(2)",
 					     XFS_ERRLEVEL_LOW, mp, info);
 			error = XFS_ERROR(EFSCORRUPTED);
@@ -2171,7 +2169,7 @@ kmem_zone_t *xfs_dabuf_zone;		/* dabuf zone */
 xfs_da_state_t *
 xfs_da_state_alloc(void)
 {
-	return kmem_zone_zalloc(xfs_da_state_zone, KM_SLEEP);
+	return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
 }
 
 /*
@@ -2231,9 +2229,9 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bps, inst_t *ra)
 	int		off;
 
 	if (nbuf == 1)
-		dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_SLEEP);
+		dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_NOFS);
 	else
-		dabuf = kmem_alloc(XFS_DA_BUF_SIZE(nbuf), KM_SLEEP);
+		dabuf = kmem_alloc(XFS_DA_BUF_SIZE(nbuf), KM_NOFS);
 	dabuf->dirty = 0;
 #ifdef XFS_DABUF_DEBUG
 	dabuf->ra = ra;
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 71134f8..d475118 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -18,9 +18,7 @@
 
 #include <xfs.h>
 
-struct xfs_name xfs_name_dotdot = {"..", 2};
-
-extern const struct xfs_nameops xfs_default_nameops;
+struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2};
 
 /*
  * ASCII case-insensitive (ie. A-Z) support for directories that was
@@ -42,8 +40,8 @@ xfs_ascii_ci_hashname(
 STATIC enum xfs_dacmp
 xfs_ascii_ci_compname(
 	struct xfs_da_args *args,
-	const char	*name,
-	int 		len)
+	const unsigned char *name,
+	int		len)
 {
 	enum xfs_dacmp	result;
 	int		i;
@@ -223,7 +221,7 @@ xfs_dir_createname(
 int
 xfs_dir_cilookup_result(
 	struct xfs_da_args *args,
-	const char	*name,
+	const unsigned char *name,
 	int		len)
 {
 	if (args->cmpresult == XFS_CMP_DIFFERENT)
@@ -232,7 +230,7 @@ xfs_dir_cilookup_result(
 					!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return EEXIST;
 
-	args->value = kmem_alloc(len, KM_MAYFAIL);
+	args->value = kmem_alloc(len, KM_NOFS | KM_MAYFAIL);
 	if (!args->value)
 		return ENOMEM;
 
@@ -420,11 +418,14 @@ xfs_dir2_grow_inode(
 	xfs_mount_t	*mp;
 	int		nmap;		/* number of bmap entries */
 	xfs_trans_t	*tp;
+	xfs_drfsbno_t	nblks;
+
+	trace_xfs_dir2_grow_inode(args, space);
 
-	xfs_dir2_trace_args_s("grow_inode", args, space);
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
+	nblks = dp->i_d.di_nblocks;
 	/*
 	 * Set lowest possible block in the space requested.
 	 */
@@ -443,7 +444,7 @@ xfs_dir2_grow_inode(
 	if ((error = xfs_bmapi(tp, dp, bno, count,
 			XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
-			args->flist, NULL)))
+			args->flist)))
 		return error;
 	ASSERT(nmap <= 1);
 	if (nmap == 1) {
@@ -475,8 +476,7 @@ xfs_dir2_grow_inode(
 			if ((error = xfs_bmapi(tp, dp, b, c,
 					XFS_BMAPI_WRITE|XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
-					&mapp[mapi], &nmap, args->flist,
-					NULL))) {
+					&mapp[mapi], &nmap, args->flist))) {
 				kmem_free(mapp);
 				return error;
 			}
@@ -517,7 +517,11 @@ xfs_dir2_grow_inode(
 	 */
 	if (mapp != &map)
 		kmem_free(mapp);
+
+	/* account for newly allocated blocks in reserved blocks total */
+	args->total -= dp->i_d.di_nblocks - nblks;
 	*dbp = xfs_dir2_da_to_db(mp, (xfs_dablk_t)bno);
+
 	/*
 	 * Update file's size if this is the data space and it grew.
 	 */
@@ -594,7 +598,8 @@ xfs_dir2_shrink_inode(
 	xfs_mount_t	*mp;
 	xfs_trans_t	*tp;
 
-	xfs_dir2_trace_args_db("shrink_inode", args, db, bp);
+	trace_xfs_dir2_shrink_inode(args, db);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -604,7 +609,7 @@ xfs_dir2_shrink_inode(
 	 */
 	if ((error = xfs_bunmapi(tp, dp, da, mp->m_dirblkfsbs,
 			XFS_BMAPI_METADATA, 0, args->firstblock, args->flist,
-			NULL, &done))) {
+			&done))) {
 		/*
 		 * ENOSPC actually can happen if we're in a removename with
 		 * no space reservation, and the resulting block removal
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index d197b0b..b614ea6 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -36,8 +36,8 @@ static xfs_dahash_t xfs_dir_hash_dot, xfs_dir_hash_dotdot;
 void
 xfs_dir_startup(void)
 {
-	xfs_dir_hash_dot = xfs_da_hashname(".", 1);
-	xfs_dir_hash_dotdot = xfs_da_hashname("..", 2);
+	xfs_dir_hash_dot = xfs_da_hashname((unsigned char *)".", 1);
+	xfs_dir_hash_dotdot = xfs_da_hashname((unsigned char *)"..", 2);
 }
 
 /*
@@ -73,7 +73,8 @@ xfs_dir2_block_addname(
 	__be16			*tagp;		/* pointer to tag value */
 	xfs_trans_t		*tp;		/* transaction structure */
 
-	xfs_dir2_trace_args("block_addname", args);
+	trace_xfs_dir2_block_addname(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -467,7 +468,8 @@ xfs_dir2_block_lookup(
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 
-	xfs_dir2_trace_args("block_lookup", args);
+	trace_xfs_dir2_block_lookup(args);
+
 	/*
 	 * Get the buffer, look up the entry.
 	 * If not found (ENOENT) then return, have no buffer.
@@ -624,7 +626,8 @@ xfs_dir2_block_removename(
 	int			size;		/* shortform size */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("block_removename", args);
+	trace_xfs_dir2_block_removename(args);
+
 	/*
 	 * Look up the entry in the block.  Gets the buffer and entry index.
 	 * It will always be there, the vnodeops level does a lookup first.
@@ -700,7 +703,8 @@ xfs_dir2_block_replace(
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 
-	xfs_dir2_trace_args("block_replace", args);
+	trace_xfs_dir2_block_replace(args);
+
 	/*
 	 * Lookup the entry in the directory.  Get buffer and entry index.
 	 * This will always succeed since the caller has already done a lookup.
@@ -774,7 +778,8 @@ xfs_dir2_leaf_to_block(
 	int			to;		/* block/leaf to index */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_bb("leaf_to_block", args, lbp, dbp);
+	trace_xfs_dir2_leaf_to_block(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -921,7 +926,8 @@ xfs_dir2_sf_to_block(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_name		name;
 
-	xfs_dir2_trace_args("sf_to_block", args);
+	trace_xfs_dir2_sf_to_block(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -943,10 +949,10 @@ xfs_dir2_sf_to_block(
 	 */
 
 	buf_len = dp->i_df.if_bytes;
-	buf = kmem_alloc(dp->i_df.if_bytes, KM_SLEEP);
+	buf = kmem_alloc(buf_len, KM_SLEEP);
 
-	memcpy(buf, sfp, dp->i_df.if_bytes);
-	xfs_idata_realloc(dp, -dp->i_df.if_bytes, XFS_DATA_FORK);
+	memcpy(buf, sfp, buf_len);
+	xfs_idata_realloc(dp, -buf_len, XFS_DATA_FORK);
 	dp->i_d.di_size = 0;
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	/*
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 9a1aace..9ce2320 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -57,7 +57,8 @@ xfs_dir2_block_to_leaf(
 	int			needscan;	/* need to rescan bestfree */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_b("block_to_leaf", args, dbp);
+	trace_xfs_dir2_block_to_leaf(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -165,7 +166,8 @@ xfs_dir2_leaf_addname(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	xfs_dir2_db_t		use_block;	/* data block number */
 
-	xfs_dir2_trace_args("leaf_addname", args);
+	trace_xfs_dir2_leaf_addname(args);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -526,7 +528,7 @@ xfs_dir2_leaf_addname(
  * Check the internal consistency of a leaf1 block.
  * Pop an assert if something is wrong.
  */
-void
+STATIC void
 xfs_dir2_leaf_check(
 	xfs_inode_t		*dp,		/* incore directory inode */
 	xfs_dabuf_t		*bp)		/* leaf's buffer */
@@ -881,7 +883,8 @@ xfs_dir2_leaf_lookup(
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_lookup", args);
+	trace_xfs_dir2_leaf_lookup(args);
+
 	/*
 	 * Look up name in the leaf block, returning both buffers and index.
 	 */
@@ -1069,7 +1072,8 @@ xfs_dir2_leaf_removename(
 	xfs_dir2_data_off_t	oldbest;	/* old value of best free */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_removename", args);
+	trace_xfs_dir2_leaf_removename(args);
+
 	/*
 	 * Lookup the leaf entry, get the leaf and data blocks read in.
 	 */
@@ -1201,7 +1205,8 @@ xfs_dir2_leaf_replace(
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args("leaf_replace", args);
+	trace_xfs_dir2_leaf_replace(args);
+
 	/*
 	 * Look up the entry.
 	 */
@@ -1381,7 +1386,9 @@ xfs_dir2_node_to_leaf(
 	if (state->path.active > 1)
 		return 0;
 	args = state->args;
-	xfs_dir2_trace_args("node_to_leaf", args);
+
+	trace_xfs_dir2_node_to_leaf(args);
+
 	mp = state->mp;
 	dp = args->dp;
 	tp = args->trans;
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index db88adc..e4e20d6 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -43,7 +43,7 @@ static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
 /*
  * Log entries from a freespace block.
  */
-void
+STATIC void
 xfs_dir2_free_log_bests(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_dabuf_t		*bp,		/* freespace buffer */
@@ -101,7 +101,8 @@ xfs_dir2_leaf_to_node(
 	__be16			*to;		/* pointer to freespace entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_b("leaf_to_node", args, lbp);
+	trace_xfs_dir2_leaf_to_node(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -174,7 +175,8 @@ xfs_dir2_leafn_add(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_sb("leafn_add", args, index, bp);
+	trace_xfs_dir2_leafn_add(args, index);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
@@ -689,8 +691,8 @@ xfs_dir2_leafn_moveents(
 	int		stale;			/* count stale leaves copied */
 	xfs_trans_t	*tp;			/* transaction pointer */
 
-	xfs_dir2_trace_args_bibii("leafn_moveents", args, bp_s, start_s, bp_d,
-		start_d, count);
+	trace_xfs_dir2_leafn_moveents(args, start_s, start_d, count);
+
 	/*
 	 * Silently return if nothing to do.
 	 */
@@ -911,7 +913,8 @@ xfs_dir2_leafn_remove(
 	int			needscan;	/* need to rescan data frees */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
-	xfs_dir2_trace_args_sb("leafn_remove", args, index, bp);
+	trace_xfs_dir2_leafn_remove(args, index);
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
@@ -1082,7 +1085,7 @@ xfs_dir2_leafn_remove(
 	}
 	xfs_dir2_leafn_check(dp, bp);
 	/*
-	 * Return indication of whether this leaf block is emtpy enough
+	 * Return indication of whether this leaf block is empty enough
 	 * to justify trying to join it with a neighbor.
 	 */
 	*rval =
@@ -1341,7 +1344,8 @@ xfs_dir2_node_addname(
 	int			rval;		/* sub-return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_addname", args);
+	trace_xfs_dir2_node_addname(args);
+
 	/*
 	 * Allocate and initialize the state (btree cursor).
 	 */
@@ -1800,7 +1804,8 @@ xfs_dir2_node_lookup(
 	int		rval;			/* operation return value */
 	xfs_da_state_t	*state;			/* btree cursor */
 
-	xfs_dir2_trace_args("node_lookup", args);
+	trace_xfs_dir2_node_lookup(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
@@ -1853,7 +1858,8 @@ xfs_dir2_node_removename(
 	int			rval;		/* operation return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_removename", args);
+	trace_xfs_dir2_node_removename(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
@@ -1922,7 +1928,8 @@ xfs_dir2_node_replace(
 	int			rval;		/* internal return value */
 	xfs_da_state_t		*state;		/* btree cursor */
 
-	xfs_dir2_trace_args("node_replace", args);
+	trace_xfs_dir2_node_replace(args);
+
 	/*
 	 * Allocate and initialize the btree cursor.
 	 */
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 77f30de..6b5e6d4 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -148,7 +148,8 @@ xfs_dir2_block_to_sf(
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 	xfs_ino_t               temp;
 
-	xfs_dir2_trace_args_sb("block_to_sf", args, size, bp);
+	trace_xfs_dir2_block_to_sf(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 
@@ -260,7 +261,8 @@ xfs_dir2_sf_addname(
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 	xfs_dir2_sf_entry_t	*sfep = NULL;	/* shortform entry */
 
-	xfs_dir2_trace_args("sf_addname", args);
+	trace_xfs_dir2_sf_addname(args);
+
 	ASSERT(xfs_dir2_sf_lookup(args) == ENOENT);
 	dp = args->dp;
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -633,7 +635,8 @@ xfs_dir2_sf_create(
 	xfs_dir2_sf_t	*sfp;		/* shortform structure */
 	int		size;		/* directory size */
 
-	xfs_dir2_trace_args_i("sf_create", args, pino);
+	trace_xfs_dir2_sf_create(args);
+
 	dp = args->dp;
 
 	ASSERT(dp != NULL);
@@ -688,7 +691,8 @@ xfs_dir2_sf_lookup(
 	enum xfs_dacmp		cmp;		/* comparison result */
 	xfs_dir2_sf_entry_t	*ci_sfep;	/* case-insens. entry */
 
-	xfs_dir2_trace_args("sf_lookup", args);
+	trace_xfs_dir2_sf_lookup(args);
+
 	xfs_dir2_sf_check(args);
 	dp = args->dp;
 
@@ -771,7 +775,8 @@ xfs_dir2_sf_removename(
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 
-	xfs_dir2_trace_args("sf_removename", args);
+	trace_xfs_dir2_sf_removename(args);
+
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -862,7 +867,8 @@ xfs_dir2_sf_replace(
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 
-	xfs_dir2_trace_args("sf_replace", args);
+	trace_xfs_dir2_sf_replace(args);
+
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
@@ -1005,7 +1011,8 @@ xfs_dir2_sf_toino4(
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_t		*sfp;		/* new sf directory */
 
-	xfs_dir2_trace_args("sf_toino4", args);
+	trace_xfs_dir2_sf_toino4(args);
+
 	dp = args->dp;
 
 	/*
@@ -1082,7 +1089,8 @@ xfs_dir2_sf_toino8(
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_t		*sfp;		/* new sf directory */
 
-	xfs_dir2_trace_args("sf_toino8", args);
+	trace_xfs_dir2_sf_toino8(args);
+
 	dp = args->dp;
 
 	/*
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 32ae4b0..1fcafb6 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -18,73 +18,6 @@
 
 #include <xfs.h>
 
-/*
- * Internal functions.
- */
-
-/*
- * Log specified fields for the inode given by bp and off.
- */
-STATIC void
-xfs_ialloc_log_di(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*bp,		/* inode buffer */
-	int		off,		/* index of inode in buffer */
-	int		fields)		/* bitmask of fields to log */
-{
-	int			first;		/* first byte number */
-	int			ioffset;	/* off in bytes */
-	int			last;		/* last byte number */
-	xfs_mount_t		*mp;		/* mount point structure */
-	static const short	offsets[] = {	/* field offsets */
-						/* keep in sync with bits */
-		offsetof(xfs_dinode_core_t, di_magic),
-		offsetof(xfs_dinode_core_t, di_mode),
-		offsetof(xfs_dinode_core_t, di_version),
-		offsetof(xfs_dinode_core_t, di_format),
-		offsetof(xfs_dinode_core_t, di_onlink),
-		offsetof(xfs_dinode_core_t, di_uid),
-		offsetof(xfs_dinode_core_t, di_gid),
-		offsetof(xfs_dinode_core_t, di_nlink),
-		offsetof(xfs_dinode_core_t, di_projid_lo),
-		offsetof(xfs_dinode_core_t, di_projid_hi),
-		offsetof(xfs_dinode_core_t, di_pad),
-		offsetof(xfs_dinode_core_t, di_atime),
-		offsetof(xfs_dinode_core_t, di_mtime),
-		offsetof(xfs_dinode_core_t, di_ctime),
-		offsetof(xfs_dinode_core_t, di_size),
-		offsetof(xfs_dinode_core_t, di_nblocks),
-		offsetof(xfs_dinode_core_t, di_extsize),
-		offsetof(xfs_dinode_core_t, di_nextents),
-		offsetof(xfs_dinode_core_t, di_anextents),
-		offsetof(xfs_dinode_core_t, di_forkoff),
-		offsetof(xfs_dinode_core_t, di_aformat),
-		offsetof(xfs_dinode_core_t, di_dmevmask),
-		offsetof(xfs_dinode_core_t, di_dmstate),
-		offsetof(xfs_dinode_core_t, di_flags),
-		offsetof(xfs_dinode_core_t, di_gen),
-		offsetof(xfs_dinode_t, di_next_unlinked),
-		offsetof(xfs_dinode_t, di_u),
-		offsetof(xfs_dinode_t, di_a),
-		sizeof(xfs_dinode_t)
-	};
-
-
-	ASSERT(offsetof(xfs_dinode_t, di_core) == 0);
-	ASSERT((fields & (XFS_DI_U|XFS_DI_A)) == 0);
-	mp = tp->t_mountp;
-	/*
-	 * Get the inode-relative first and last bytes for these fields
-	 */
-	xfs_btree_offsets(fields, offsets, XFS_DI_NUM_BITS, &first, &last);
-	/*
-	 * Convert to buffer offsets and log it.
-	 */
-	ioffset = off << mp->m_sb.sb_inodelog;
-	first += ioffset;
-	last += ioffset;
-	xfs_trans_log_buf(tp, bp, first, last);
-}
 
 /*
  * Allocation group level functions.
@@ -101,75 +34,35 @@ xfs_ialloc_cluster_alignment(
 }
 
 /*
- * Lookup the record equal to ino in the btree given by cur.
- */
-STATIC int				/* error */
-xfs_inobt_lookup_eq(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free,	/* free inode mask */
-	int			*stat)	/* success/failure */
-{
-	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
-}
-
-/*
- * Lookup the first record greater than or equal to ino
- * in the btree given by cur.
+ * Lookup a record by ino in the btree given by cur.
  */
 int					/* error */
-xfs_inobt_lookup_ge(
+xfs_inobt_lookup(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free,	/* free inode mask */
+	xfs_lookup_t		dir,	/* <=, >=, == */
 	int			*stat)	/* success/failure */
 {
 	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+	cur->bc_rec.i.ir_freecount = 0;
+	cur->bc_rec.i.ir_free = 0;
+	return xfs_btree_lookup(cur, dir, stat);
 }
 
 /*
- * Lookup the first record less than or equal to ino
- * in the btree given by cur.
- */
-int					/* error */
-xfs_inobt_lookup_le(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free,	/* free inode mask */
-	int			*stat)	/* success/failure */
-{
-	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
-}
-
-/*
- * Update the record referred to by cur to the value given
- * by [ino, fcnt, free].
+ * Update the record referred to by cur to the value given.
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
 STATIC int				/* error */
 xfs_inobt_update(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free)	/* free inode mask */
+	xfs_inobt_rec_incore_t	*irec)	/* btree record */
 {
 	union xfs_btree_rec	rec;
 
-	rec.inobt.ir_startino = cpu_to_be32(ino);
-	rec.inobt.ir_freecount = cpu_to_be32(fcnt);
-	rec.inobt.ir_free = cpu_to_be64(free);
+	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
+	rec.inobt.ir_freecount = cpu_to_be32(irec->ir_freecount);
+	rec.inobt.ir_free = cpu_to_be64(irec->ir_free);
 	return xfs_btree_update(cur, &rec);
 }
 
@@ -179,9 +72,7 @@ xfs_inobt_update(
 int					/* error */
 xfs_inobt_get_rec(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agino_t		*ino,	/* output: starting inode of chunk */
-	__int32_t		*fcnt,	/* output: number of free inodes */
-	xfs_inofree_t		*free,	/* output: free inode mask */
+	xfs_inobt_rec_incore_t	*irec,	/* btree record */
 	int			*stat)	/* output: success/failure */
 {
 	union xfs_btree_rec	*rec;
@@ -189,14 +80,136 @@ xfs_inobt_get_rec(
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (!error && *stat == 1) {
-		*ino = be32_to_cpu(rec->inobt.ir_startino);
-		*fcnt = be32_to_cpu(rec->inobt.ir_freecount);
-		*free = be64_to_cpu(rec->inobt.ir_free);
+		irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
+		irec->ir_freecount = be32_to_cpu(rec->inobt.ir_freecount);
+		irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
 	}
 	return error;
 }
 
 /*
+ * Verify that the number of free inodes in the AGI is correct.
+ */
+#ifdef DEBUG
+STATIC int
+xfs_check_agi_freecount(
+	struct xfs_btree_cur	*cur,
+	struct xfs_agi		*agi)
+{
+	if (cur->bc_nlevels == 1) {
+		xfs_inobt_rec_incore_t rec;
+		int		freecount = 0;
+		int		error;
+		int		i;
+
+		error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
+		if (error)
+			return error;
+
+		do {
+			error = xfs_inobt_get_rec(cur, &rec, &i);
+			if (error)
+				return error;
+
+			if (i) {
+				freecount += rec.ir_freecount;
+				error = xfs_btree_increment(cur, 0, &i);
+				if (error)
+					return error;
+			}
+		} while (i == 1);
+
+		if (!XFS_FORCED_SHUTDOWN(cur->bc_mp))
+			ASSERT(freecount == be32_to_cpu(agi->agi_freecount));
+	}
+	return 0;
+}
+#else
+#define xfs_check_agi_freecount(cur, agi)	0
+#endif
+
+/*
+ * Initialise a new set of inodes.
+ */
+STATIC void
+xfs_ialloc_inode_init(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		length,
+	unsigned int		gen)
+{
+	struct xfs_buf		*fbuf;
+	struct xfs_dinode	*free;
+	int			blks_per_cluster, nbufs, ninodes;
+	int			version;
+	int			i, j;
+	xfs_daddr_t		d;
+
+	/*
+	 * Loop over the new block(s), filling in the inodes.
+	 * For small block sizes, manipulate the inodes in buffers
+	 * which are multiples of the blocks size.
+	 */
+	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
+		blks_per_cluster = 1;
+		nbufs = length;
+		ninodes = mp->m_sb.sb_inopblock;
+	} else {
+		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
+				   mp->m_sb.sb_blocksize;
+		nbufs = length / blks_per_cluster;
+		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
+	}
+
+	/*
+	 * Figure out what version number to use in the inodes we create.
+	 * If the superblock version has caught up to the one that supports
+	 * the new inode format, then use the new inode version.  Otherwise
+	 * use the old version so that old kernels will continue to be
+	 * able to use the file system.
+	 */
+	if (xfs_sb_version_hasnlink(&mp->m_sb))
+		version = 2;
+	else
+		version = 1;
+
+	for (j = 0; j < nbufs; j++) {
+		/*
+		 * Get the block.
+		 */
+		d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
+		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+					 mp->m_bsize * blks_per_cluster,
+					 XBF_LOCK);
+		ASSERT(fbuf);
+		ASSERT(!XFS_BUF_GETERROR(fbuf));
+
+		/*
+		 * Initialize all inodes in this buffer and then log them.
+		 *
+		 * XXX: It would be much better if we had just one transaction
+		 *	to log a whole cluster of inodes instead of all the
+		 *	individual transactions causing a lot of log traffic.
+		 */
+		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
+		for (i = 0; i < ninodes; i++) {
+			int	ioffset = i << mp->m_sb.sb_inodelog;
+			uint	isize = sizeof(struct xfs_dinode);
+
+			free = xfs_make_iptr(mp, fbuf, i);
+			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+			free->di_version = version;
+			free->di_gen = cpu_to_be32(gen);
+			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
+			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
+		}
+		xfs_trans_inode_alloc_buf(tp, fbuf);
+	}
+}
+
+/*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
@@ -208,24 +221,16 @@ xfs_ialloc_ag_alloc(
 {
 	xfs_agi_t	*agi;		/* allocation group header */
 	xfs_alloc_arg_t	args;		/* allocation argument structure */
-	int		blks_per_cluster;  /* fs blocks per inode cluster */
 	xfs_btree_cur_t	*cur;		/* inode btree cursor */
-	xfs_daddr_t	d;		/* disk addr of buffer */
 	xfs_agnumber_t	agno;
 	int		error;
-	xfs_buf_t	*fbuf;		/* new free inodes' buffer */
-	xfs_dinode_t	*free;		/* new free inode structure */
-	int		i;		/* inode counter */
-	int		j;		/* block counter */
-	int		nbufs;		/* num bufs of new inodes */
+	int		i;
 	xfs_agino_t	newino;		/* new first inode's number */
 	xfs_agino_t	newlen;		/* new number of inodes */
-	int		ninodes;	/* num inodes per buf */
 	xfs_agino_t	thisino;	/* current inode number, for loop */
-	int		version;	/* inode version number to use */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
-	unsigned int	gen;
+	struct xfs_perag *pag;
 
 	args.tp = tp;
 	args.mp = tp->t_mountp;
@@ -246,12 +251,12 @@ xfs_ialloc_ag_alloc(
  	 */
 	agi = XFS_BUF_TO_AGI(agbp);
 	newino = be32_to_cpu(agi->agi_newino);
+	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
 			XFS_IALLOC_BLOCKS(args.mp);
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
 		args.type = XFS_ALLOCTYPE_THIS_BNO;
 		args.mod = args.total = args.wasdel = args.isfl =
 			args.userdata = args.minalignslop = 0;
@@ -274,7 +279,7 @@ xfs_ialloc_ag_alloc(
 		args.minalignslop = xfs_ialloc_cluster_alignment(&args) - 1;
 
 		/* Allow space for the inode btree to split. */
-		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
+		args.minleft = args.mp->m_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	} else
@@ -302,8 +307,7 @@ xfs_ialloc_ag_alloc(
 		 * For now, just allocate blocks up front.
 		 */
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
 		/*
 		 * Allocate a fixed-size extent of inodes.
 		 */
@@ -314,7 +318,7 @@ xfs_ialloc_ag_alloc(
 		/*
 		 * Allow space for the inode btree to split.
 		 */
-		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
+		args.minleft = args.mp->m_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
@@ -326,8 +330,7 @@ xfs_ialloc_ag_alloc(
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
 		args.alignment = xfs_ialloc_cluster_alignment(&args);
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
@@ -338,78 +341,30 @@ xfs_ialloc_ag_alloc(
 		return 0;
 	}
 	ASSERT(args.len == args.minlen);
-	/*
-	 * Convert the results.
-	 */
-	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
-	/*
-	 * Loop over the new block(s), filling in the inodes.
-	 * For small block sizes, manipulate the inodes in buffers
-	 * which are multiples of the blocks size.
-	 */
-	if (args.mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(args.mp)) {
-		blks_per_cluster = 1;
-		nbufs = (int)args.len;
-		ninodes = args.mp->m_sb.sb_inopblock;
-	} else {
-		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(args.mp) /
-				   args.mp->m_sb.sb_blocksize;
-		nbufs = (int)args.len / blks_per_cluster;
-		ninodes = blks_per_cluster * args.mp->m_sb.sb_inopblock;
-	}
-	/*
-	 * Figure out what version number to use in the inodes we create.
-	 * If the superblock version has caught up to the one that supports
-	 * the new inode format, then use the new inode version.  Otherwise
-	 * use the old version so that old kernels will continue to be
-	 * able to use the file system.
-	 */
-	if (xfs_sb_version_hasnlink(&args.mp->m_sb))
-		version = XFS_DINODE_VERSION_2;
-	else
-		version = XFS_DINODE_VERSION_1;
 
 	/*
+	 * Stamp and write the inode buffers.
+	 *
 	 * Seed the new inode cluster with a random generation number. This
 	 * prevents short-term reuse of generation numbers if a chunk is
 	 * freed and then immediately reallocated. We use random numbers
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	gen = random32();
-	for (j = 0; j < nbufs; j++) {
-		/*
-		 * Get the block.
-		 */
-		d = XFS_AGB_TO_DADDR(args.mp, be32_to_cpu(agi->agi_seqno),
-				     args.agbno + (j * blks_per_cluster));
-		fbuf = xfs_trans_get_buf(tp, args.mp->m_ddev_targp, d,
-					 args.mp->m_bsize * blks_per_cluster,
-					 XFS_BUF_LOCK);
-		ASSERT(fbuf);
-		ASSERT(!XFS_BUF_GETERROR(fbuf));
-		/*
-		 * Set initial values for the inodes in this buffer.
-		 */
-		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
-		for (i = 0; i < ninodes; i++) {
-			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
-			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-			free->di_core.di_version = version;
-			free->di_core.di_gen = cpu_to_be32(gen);
-			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			xfs_ialloc_log_di(tp, fbuf, i,
-				XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
-		}
-		xfs_trans_inode_alloc_buf(tp, fbuf);
-	}
+	xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno, args.len,
+			      random32());
+
+	/*
+	 * Convert the results.
+	 */
+	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
-	agno = be32_to_cpu(agi->agi_seqno);
-	down_read(&args.mp->m_peraglock);
-	args.mp->m_perag[agno].pagi_freecount += newlen;
-	up_read(&args.mp->m_peraglock);
+	pag = xfs_perag_get(args.mp, agno);
+	pag->pagi_freecount += newlen;
+	xfs_perag_put(pag);
 	agi->agi_newino = cpu_to_be32(newino);
+
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */
@@ -417,13 +372,17 @@ xfs_ialloc_ag_alloc(
 	for (thisino = newino;
 	     thisino < newino + newlen;
 	     thisino += XFS_INODES_PER_CHUNK) {
-		if ((error = xfs_inobt_lookup_eq(cur, thisino,
-				XFS_INODES_PER_CHUNK, XFS_INOBT_ALL_FREE, &i))) {
+		cur->bc_rec.i.ir_startino = thisino;
+		cur->bc_rec.i.ir_freecount = XFS_INODES_PER_CHUNK;
+		cur->bc_rec.i.ir_free = XFS_INOBT_ALL_FREE;
+		error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, &i);
+		if (error) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
 		ASSERT(i == 0);
-		if ((error = xfs_btree_insert(cur, &i))) {
+		error = xfs_btree_insert(cur, &i);
+		if (error) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
@@ -444,7 +403,7 @@ xfs_ialloc_ag_alloc(
 	return 0;
 }
 
-STATIC_INLINE xfs_agnumber_t
+STATIC xfs_agnumber_t
 xfs_ialloc_next_ag(
 	xfs_mount_t	*mp)
 {
@@ -505,9 +464,8 @@ xfs_ialloc_ag_select(
 	 */
 	agno = pagno;
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
-	down_read(&mp->m_peraglock);
 	for (;;) {
-		pag = &mp->m_perag[agno];
+		pag = xfs_perag_get(mp, agno);
 		if (!pag->pagi_init) {
 			if (xfs_ialloc_read_agi(mp, tp, agno, &agbp)) {
 				agbp = NULL;
@@ -546,7 +504,7 @@ xfs_ialloc_ag_select(
 					agbp = NULL;
 					goto nextag;
 				}
-				up_read(&mp->m_peraglock);
+				xfs_perag_put(pag);
 				return agbp;
 			}
 		}
@@ -554,28 +512,81 @@ unlock_nextag:
 		if (agbp)
 			xfs_trans_brelse(tp, agbp);
 nextag:
+		xfs_perag_put(pag);
 		/*
 		 * No point in iterating over the rest, if we're shutting
 		 * down.
 		 */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			up_read(&mp->m_peraglock);
+		if (XFS_FORCED_SHUTDOWN(mp))
 			return NULL;
-		}
 		agno++;
 		if (agno >= agcount)
 			agno = 0;
 		if (agno == pagno) {
-			if (flags == 0) {
-				up_read(&mp->m_peraglock);
+			if (flags == 0)
 				return NULL;
-			}
 			flags = 0;
 		}
 	}
 }
 
 /*
+ * Try to retrieve the next record to the left/right from the current one.
+ */
+STATIC int
+xfs_ialloc_next_rec(
+	struct xfs_btree_cur	*cur,
+	xfs_inobt_rec_incore_t	*rec,
+	int			*done,
+	int			left)
+{
+	int                     error;
+	int			i;
+
+	if (left)
+		error = xfs_btree_decrement(cur, 0, &i);
+	else
+		error = xfs_btree_increment(cur, 0, &i);
+
+	if (error)
+		return error;
+	*done = !i;
+	if (i) {
+		error = xfs_inobt_get_rec(cur, rec, &i);
+		if (error)
+			return error;
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+	}
+
+	return 0;
+}
+
+STATIC int
+xfs_ialloc_get_rec(
+	struct xfs_btree_cur	*cur,
+	xfs_agino_t		agino,
+	xfs_inobt_rec_incore_t	*rec,
+	int			*done,
+	int			left)
+{
+	int                     error;
+	int			i;
+
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		return error;
+	*done = !i;
+	if (i) {
+		error = xfs_inobt_get_rec(cur, rec, &i);
+		if (error)
+			return error;
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+	}
+
+	return 0;
+}
+
+/*
  * Visible inode allocation functions.
  */
 
@@ -629,12 +640,13 @@ xfs_dialloc(
 	int		j;		/* result code */
 	xfs_mount_t	*mp;		/* file system mount structure */
 	int		offset;		/* index of inode in chunk */
-	xfs_agino_t	pagino;		/* parent's a.g. relative inode # */
-	xfs_agnumber_t	pagno;		/* parent's allocation group number */
+	xfs_agino_t	pagino;		/* parent's AG relative inode # */
+	xfs_agnumber_t	pagno;		/* parent's AG number */
 	xfs_inobt_rec_incore_t rec;	/* inode allocation record */
 	xfs_agnumber_t	tagno;		/* testing allocation group number */
 	xfs_btree_cur_t	*tcur;		/* temp cursor */
 	xfs_inobt_rec_incore_t trec;	/* temp inode allocation record */
+	struct xfs_perag *pag;
 
 
 	if (*IO_agbp == NULL) {
@@ -734,13 +746,13 @@ nextag:
 			*inop = NULLFSINO;
 			return noroom ? ENOSPC : 0;
 		}
-		down_read(&mp->m_peraglock);
-		if (mp->m_perag[tagno].pagi_inodeok == 0) {
-			up_read(&mp->m_peraglock);
+		pag = xfs_perag_get(mp, tagno);
+		if (pag->pagi_inodeok == 0) {
+			xfs_perag_put(pag);
 			goto nextag;
 		}
 		error = xfs_ialloc_read_agi(mp, tp, tagno, &agbp);
-		up_read(&mp->m_peraglock);
+		xfs_perag_put(pag);
 		if (error)
 			goto nextag;
 		agi = XFS_BUF_TO_AGI(agbp);
@@ -753,6 +765,9 @@ nextag:
 	 */
 	agno = tagno;
 	*IO_agbp = NULL;
+	pag = xfs_perag_get(mp, agno);
+
+ restart_pagno:
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno));
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
@@ -760,298 +775,315 @@ nextag:
 	 */
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
-#ifdef DEBUG
-	if (cur->bc_nlevels == 1) {
-		int	freecount = 0;
 
-		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		do {
-			if ((error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-					&rec.ir_freecount, &rec.ir_free, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			freecount += rec.ir_freecount;
-			if ((error = xfs_btree_increment(cur, 0, &i)))
-				goto error0;
-		} while (i == 1);
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error0;
 
-		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
-		       XFS_FORCED_SHUTDOWN(mp));
-	}
-#endif
 	/*
-	 * If in the same a.g. as the parent, try to get near the parent.
+	 * If in the same AG as the parent, try to get near the parent.
 	 */
 	if (pagno == agno) {
-		if ((error = xfs_inobt_lookup_le(cur, pagino, 0, 0, &i)))
+		int		doneleft;	/* done, to the left */
+		int		doneright;	/* done, to the right */
+		int		searchdistance = 10;
+
+		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
+		if (error)
 			goto error0;
-		if (i != 0 &&
-		    (error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-			    &rec.ir_freecount, &rec.ir_free, &j)) == 0 &&
-		    j == 1 &&
-		    rec.ir_freecount > 0) {
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		error = xfs_inobt_get_rec(cur, &rec, &j);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		if (rec.ir_freecount > 0) {
 			/*
 			 * Found a free inode in the same chunk
-			 * as parent, done.
+			 * as the parent, done.
 			 */
+			goto alloc_inode;
 		}
+
+
+		/*
+		 * In the same AG as parent, but parent's chunk is full.
+		 */
+
+		/* duplicate the cursor, search left & right simultaneously */
+		error = xfs_btree_dup_cursor(cur, &tcur);
+		if (error)
+			goto error0;
+
 		/*
-		 * In the same a.g. as parent, but parent's chunk is full.
+		 * Skip to last blocks looked up if same parent inode.
 		 */
-		else {
-			int	doneleft;	/* done, to the left */
-			int	doneright;	/* done, to the right */
+		if (pagino != NULLAGINO &&
+		    pag->pagl_pagino == pagino &&
+		    pag->pagl_leftrec != NULLAGINO &&
+		    pag->pagl_rightrec != NULLAGINO) {
+			error = xfs_ialloc_get_rec(tcur, pag->pagl_leftrec,
+						   &trec, &doneleft, 1);
+			if (error)
+				goto error1;
 
+			error = xfs_ialloc_get_rec(cur, pag->pagl_rightrec,
+						   &rec, &doneright, 0);
 			if (error)
-				goto error0;
-			ASSERT(i == 1);
-			ASSERT(j == 1);
-			/*
-			 * Duplicate the cursor, search left & right
-			 * simultaneously.
-			 */
-			if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-				goto error0;
-			/*
-			 * Search left with tcur, back up 1 record.
-			 */
-			if ((error = xfs_btree_decrement(tcur, 0, &i)))
 				goto error1;
-			doneleft = !i;
-			if (!doneleft) {
-				if ((error = xfs_inobt_get_rec(tcur,
-						&trec.ir_startino,
-						&trec.ir_freecount,
-						&trec.ir_free, &i)))
-					goto error1;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error1);
-			}
-			/*
-			 * Search right with cur, go forward 1 record.
-			 */
-			if ((error = xfs_btree_increment(cur, 0, &i)))
+		} else {
+			/* search left with tcur, back up 1 record */
+			error = xfs_ialloc_next_rec(tcur, &trec, &doneleft, 1);
+			if (error)
 				goto error1;
-			doneright = !i;
-			if (!doneright) {
-				if ((error = xfs_inobt_get_rec(cur,
-						&rec.ir_startino,
-						&rec.ir_freecount,
-						&rec.ir_free, &i)))
-					goto error1;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error1);
-			}
-			/*
-			 * Loop until we find the closest inode chunk
-			 * with a free one.
-			 */
-			while (!doneleft || !doneright) {
-				int	useleft;  /* using left inode
-						     chunk this time */
 
+			/* search right with cur, go forward 1 record. */
+			error = xfs_ialloc_next_rec(cur, &rec, &doneright, 0);
+			if (error)
+				goto error1;
+		}
+
+		/*
+		 * Loop until we find an inode chunk with a free inode.
+		 */
+		while (!doneleft || !doneright) {
+			int	useleft;  /* using left inode chunk this time */
+
+			if (!--searchdistance) {
 				/*
-				 * Figure out which block is closer,
-				 * if both are valid.
-				 */
-				if (!doneleft && !doneright)
-					useleft =
-						pagino -
-						(trec.ir_startino +
-						 XFS_INODES_PER_CHUNK - 1) <
-						 rec.ir_startino - pagino;
-				else
-					useleft = !doneleft;
-				/*
-				 * If checking the left, does it have
-				 * free inodes?
-				 */
-				if (useleft && trec.ir_freecount) {
-					/*
-					 * Yes, set it up as the chunk to use.
-					 */
-					rec = trec;
-					xfs_btree_del_cursor(cur,
-						XFS_BTREE_NOERROR);
-					cur = tcur;
-					break;
-				}
-				/*
-				 * If checking the right, does it have
-				 * free inodes?
-				 */
-				if (!useleft && rec.ir_freecount) {
-					/*
-					 * Yes, it's already set up.
-					 */
-					xfs_btree_del_cursor(tcur,
-						XFS_BTREE_NOERROR);
-					break;
-				}
-				/*
-				 * If used the left, get another one
-				 * further left.
-				 */
-				if (useleft) {
-					if ((error = xfs_btree_decrement(tcur, 0,
-							&i)))
-						goto error1;
-					doneleft = !i;
-					if (!doneleft) {
-						if ((error = xfs_inobt_get_rec(
-							    tcur,
-							    &trec.ir_startino,
-							    &trec.ir_freecount,
-							    &trec.ir_free, &i)))
-							goto error1;
-						XFS_WANT_CORRUPTED_GOTO(i == 1,
-							error1);
-					}
-				}
-				/*
-				 * If used the right, get another one
-				 * further right.
+				 * Not in range - save last search
+				 * location and allocate a new inode
 				 */
-				else {
-					if ((error = xfs_btree_increment(cur, 0,
-							&i)))
-						goto error1;
-					doneright = !i;
-					if (!doneright) {
-						if ((error = xfs_inobt_get_rec(
-							    cur,
-							    &rec.ir_startino,
-							    &rec.ir_freecount,
-							    &rec.ir_free, &i)))
-							goto error1;
-						XFS_WANT_CORRUPTED_GOTO(i == 1,
-							error1);
-					}
-				}
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+				pag->pagl_leftrec = trec.ir_startino;
+				pag->pagl_rightrec = rec.ir_startino;
+				pag->pagl_pagino = pagino;
+				goto newino;
 			}
-			ASSERT(!doneleft || !doneright);
+
+			/* figure out the closer block if both are valid. */
+			if (!doneleft && !doneright) {
+				useleft = pagino -
+				 (trec.ir_startino + XFS_INODES_PER_CHUNK - 1) <
+				  rec.ir_startino - pagino;
+			} else {
+				useleft = !doneleft;
+			}
+
+			/* free inodes to the left? */
+			if (useleft && trec.ir_freecount) {
+				rec = trec;
+				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+				cur = tcur;
+
+				pag->pagl_leftrec = trec.ir_startino;
+				pag->pagl_rightrec = rec.ir_startino;
+				pag->pagl_pagino = pagino;
+				goto alloc_inode;
+			}
+
+			/* free inodes to the right? */
+			if (!useleft && rec.ir_freecount) {
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+
+				pag->pagl_leftrec = trec.ir_startino;
+				pag->pagl_rightrec = rec.ir_startino;
+				pag->pagl_pagino = pagino;
+				goto alloc_inode;
+			}
+
+			/* get next record to check */
+			if (useleft) {
+				error = xfs_ialloc_next_rec(tcur, &trec,
+								 &doneleft, 1);
+			} else {
+				error = xfs_ialloc_next_rec(cur, &rec,
+								 &doneright, 0);
+			}
+			if (error)
+				goto error1;
 		}
+
+		/*
+		 * We've reached the end of the btree. because
+		 * we are only searching a small chunk of the
+		 * btree each search, there is obviously free
+		 * inodes closer to the parent inode than we
+		 * are now. restart the search again.
+		 */
+		pag->pagl_pagino = NULLAGINO;
+		pag->pagl_leftrec = NULLAGINO;
+		pag->pagl_rightrec = NULLAGINO;
+		xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		goto restart_pagno;
 	}
+
 	/*
-	 * In a different a.g. from the parent.
+	 * In a different AG from the parent.
 	 * See if the most recently allocated block has any free.
 	 */
-	else if (be32_to_cpu(agi->agi_newino) != NULLAGINO) {
-		if ((error = xfs_inobt_lookup_eq(cur,
-				be32_to_cpu(agi->agi_newino), 0, 0, &i)))
+newino:
+	if (be32_to_cpu(agi->agi_newino) != NULLAGINO) {
+		error = xfs_inobt_lookup(cur, be32_to_cpu(agi->agi_newino),
+					 XFS_LOOKUP_EQ, &i);
+		if (error)
 			goto error0;
-		if (i == 1 &&
-		    (error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-			    &rec.ir_freecount, &rec.ir_free, &j)) == 0 &&
-		    j == 1 &&
-		    rec.ir_freecount > 0) {
-			/*
-			 * The last chunk allocated in the group still has
-			 * a free inode.
-			 */
-		}
-		/*
-		 * None left in the last group, search the whole a.g.
-		 */
-		else {
+
+		if (i == 1) {
+			error = xfs_inobt_get_rec(cur, &rec, &j);
 			if (error)
 				goto error0;
-			if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
-				goto error0;
-			ASSERT(i == 1);
-			for (;;) {
-				if ((error = xfs_inobt_get_rec(cur,
-						&rec.ir_startino,
-						&rec.ir_freecount, &rec.ir_free,
-						&i)))
-					goto error0;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-				if (rec.ir_freecount > 0)
-					break;
-				if ((error = xfs_btree_increment(cur, 0, &i)))
-					goto error0;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+			if (j == 1 && rec.ir_freecount > 0) {
+				/*
+				 * The last chunk allocated in the group
+				 * still has a free inode.
+				 */
+				goto alloc_inode;
 			}
 		}
 	}
-	offset = XFS_IALLOC_FIND_FREE(&rec.ir_free);
+
+	/*
+	 * None left in the last group, search the whole AG
+	 */
+	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
+	if (error)
+		goto error0;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+	for (;;) {
+		error = xfs_inobt_get_rec(cur, &rec, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		if (rec.ir_freecount > 0)
+			break;
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	}
+
+alloc_inode:
+	offset = xfs_ialloc_find_free(&rec.ir_free);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 	ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino + offset);
-	XFS_INOBT_CLR_FREE(&rec, offset);
+	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
-	if ((error = xfs_inobt_update(cur, rec.ir_startino, rec.ir_freecount,
-			rec.ir_free)))
+	error = xfs_inobt_update(cur, &rec);
+	if (error)
 		goto error0;
 	be32_add_cpu(&agi->agi_freecount, -1);
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-	down_read(&mp->m_peraglock);
-	mp->m_perag[tagno].pagi_freecount--;
-	up_read(&mp->m_peraglock);
-#ifdef DEBUG
-	if (cur->bc_nlevels == 1) {
-		int	freecount = 0;
+	pag->pagi_freecount--;
+
+	error = xfs_check_agi_freecount(cur, agi);
+	if (error)
+		goto error0;
 
-		if ((error = xfs_inobt_lookup_ge(cur, 0, 0, 0, &i)))
-			goto error0;
-		do {
-			if ((error = xfs_inobt_get_rec(cur, &rec.ir_startino,
-					&rec.ir_freecount, &rec.ir_free, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			freecount += rec.ir_freecount;
-			if ((error = xfs_btree_increment(cur, 0, &i)))
-				goto error0;
-		} while (i == 1);
-		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
-		       XFS_FORCED_SHUTDOWN(mp));
-	}
-#endif
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
+	xfs_perag_put(pag);
 	*inop = ino;
 	return 0;
 error1:
 	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
 error0:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_perag_put(pag);
 	return error;
 }
 
+STATIC int
+xfs_imap_lookup(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		*chunk_agbno,
+	xfs_agblock_t		*offset_agbno,
+	int			flags)
+{
+	struct xfs_inobt_rec_incore rec;
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agbp;
+	int			error;
+	int			i;
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	if (error) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+				"xfs_ialloc_read_agi() returned "
+				"error %d, agno %d",
+				error, agno);
+		return error;
+	}
+
+	/*
+	 * Lookup the inode record for the given agino. If the record cannot be
+	 * found, then it's an invalid inode number and we should abort. Once
+	 * we have a record, we need to ensure it contains the inode number
+	 * we are looking up.
+	 */
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
+	if (!error) {
+		if (i)
+			error = xfs_inobt_get_rec(cur, &rec, &i);
+		if (!error && i == 0)
+			error = EINVAL;
+	}
+
+	xfs_trans_brelse(tp, agbp);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	if (error)
+		return error;
+
+	/* check that the returned record contains the required inode */
+	if (rec.ir_startino > agino ||
+	    rec.ir_startino + XFS_IALLOC_INODES(mp) <= agino)
+		return EINVAL;
+
+	/* for untrusted inodes check it is allocated first */
+	if ((flags & XFS_IGET_UNTRUSTED) &&
+	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))
+		return EINVAL;
+
+	*chunk_agbno = XFS_AGINO_TO_AGBNO(mp, rec.ir_startino);
+	*offset_agbno = agbno - *chunk_agbno;
+	return 0;
+}
 
 /*
- * Return the location of the inode in bno/off, for mapping it into a buffer.
+ * Return the location of the inode in imap, for mapping it into a buffer.
  */
-/*ARGSUSED*/
 int
-xfs_dilocate(
-	xfs_mount_t	*mp,	/* file system mount structure */
-	xfs_trans_t	*tp,	/* transaction pointer */
+xfs_imap(
+	xfs_mount_t	 *mp,	/* file system mount structure */
+	xfs_trans_t	 *tp,	/* transaction pointer */
 	xfs_ino_t	ino,	/* inode to locate */
-	xfs_fsblock_t	*bno,	/* output: block containing inode */
-	int		*len,	/* output: num blocks in inode cluster */
-	int		*off,	/* output: index in block of inode */
-	uint		flags)	/* flags concerning inode lookup */
+	struct xfs_imap	*imap,	/* location map structure */
+	uint		flags)	/* flags for inode btree lookup */
 {
 	xfs_agblock_t	agbno;	/* block number of inode in the alloc group */
-	xfs_buf_t	*agbp;	/* agi buffer */
 	xfs_agino_t	agino;	/* inode number within alloc group */
 	xfs_agnumber_t	agno;	/* allocation group number */
 	int		blks_per_cluster; /* num blocks per inode cluster */
 	xfs_agblock_t	chunk_agbno;	/* first block in inode chunk */
-	xfs_agino_t	chunk_agino;	/* first agino in inode chunk */
-	__int32_t	chunk_cnt;	/* count of free inodes in chunk */
-	xfs_inofree_t	chunk_free;	/* mask of free inodes in chunk */
 	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
-	xfs_btree_cur_t	*cur;	/* inode btree cursor */
 	int		error;	/* error code */
-	int		i;	/* temp state */
 	int		offset;	/* index of inode in its buffer */
-	int		offset_agbno;	/* blks from chunk start to inode */
+	xfs_agblock_t	offset_agbno;	/* blks from chunk start to inode */
 
 	ASSERT(ino != NULLFSINO);
+
 	/*
 	 * Split up the inode number into its parts.
 	 */
@@ -1061,25 +1093,28 @@ xfs_dilocate(
 	if (agno >= mp->m_sb.sb_agcount || agbno >= mp->m_sb.sb_agblocks ||
 	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 #ifdef DEBUG
-		/* no diagnostics for bulkstat, ino comes from userspace */
-		if (flags & XFS_IMAP_BULKSTAT)
+		/*
+		 * Don't output diagnostic information for untrusted inodes
+		 * as they can be invalid without implying corruption.
+		 */
+		if (flags & XFS_IGET_UNTRUSTED)
 			return XFS_ERROR(EINVAL);
 		if (agno >= mp->m_sb.sb_agcount) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: agno (%d) >= "
+					"xfs_imap: agno (%d) >= "
 					"mp->m_sb.sb_agcount (%d)",
 					agno,  mp->m_sb.sb_agcount);
 		}
 		if (agbno >= mp->m_sb.sb_agblocks) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: agbno (0x%llx) >= "
+					"xfs_imap: agbno (0x%llx) >= "
 					"mp->m_sb.sb_agblocks (0x%lx)",
 					(unsigned long long) agbno,
 					(unsigned long) mp->m_sb.sb_agblocks);
 		}
 		if (ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: ino (0x%llx) != "
+					"xfs_imap: ino (0x%llx) != "
 					"XFS_AGINO_TO_INO(mp, agno, agino) "
 					"(0x%llx)",
 					ino, XFS_AGINO_TO_INO(mp, agno, agino));
@@ -1088,84 +1123,81 @@ xfs_dilocate(
 #endif /* DEBUG */
 		return XFS_ERROR(EINVAL);
 	}
-	if ((mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) ||
-	    !(flags & XFS_IMAP_LOOKUP)) {
-		offset = XFS_INO_TO_OFFSET(mp, ino);
-		ASSERT(offset < mp->m_sb.sb_inopblock);
-		*bno = XFS_AGB_TO_FSB(mp, agno, agbno);
-		*off = offset;
-		*len = 1;
-		return 0;
-	}
+
 	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
-	if (*bno != NULLFSBLOCK) {
+
+	/*
+	 * For bulkstat and handle lookups, we have an untrusted inode number
+	 * that we have to verify is valid. We cannot do this just by reading
+	 * the inode buffer as it may have been unlinked and removed leaving
+	 * inodes in stale state on disk. Hence we have to do a btree lookup
+	 * in all cases where an untrusted inode number is passed.
+	 */
+	if (flags & XFS_IGET_UNTRUSTED) {
+		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
+					&chunk_agbno, &offset_agbno, flags);
+		if (error)
+			return error;
+		goto out_map;
+	}
+
+	/*
+	 * If the inode cluster size is the same as the blocksize or
+	 * smaller we get to the buffer by simple arithmetics.
+	 */
+	if (XFS_INODE_CLUSTER_SIZE(mp) <= mp->m_sb.sb_blocksize) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
-		cluster_agbno = XFS_FSB_TO_AGBNO(mp, *bno);
-		*off = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
-			offset;
-		*len = blks_per_cluster;
+
+		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		imap->im_len = XFS_FSB_TO_BB(mp, 1);
+		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
 		return 0;
 	}
+
+	/*
+	 * If the inode chunks are aligned then use simple maths to
+	 * find the location. Otherwise we have to do a btree
+	 * lookup to find the location.
+	 */
 	if (mp->m_inoalign_mask) {
 		offset_agbno = agbno & mp->m_inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
 	} else {
-		down_read(&mp->m_peraglock);
-		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
-		up_read(&mp->m_peraglock);
-		if (error) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
-					"xfs_ialloc_read_agi() returned "
-					"error %d, agno %d",
-					error, agno);
-#endif /* DEBUG */
-			return error;
-		}
-		cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
-		if ((error = xfs_inobt_lookup_le(cur, agino, 0, 0, &i))) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
-					"xfs_inobt_lookup_le() failed");
-#endif /* DEBUG */
-			goto error0;
-		}
-		if ((error = xfs_inobt_get_rec(cur, &chunk_agino, &chunk_cnt,
-				&chunk_free, &i))) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
-					"xfs_inobt_get_rec() failed");
-#endif /* DEBUG */
-			goto error0;
-		}
-		if (i == 0) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
-					"xfs_inobt_get_rec() failed");
-#endif /* DEBUG */
-			error = XFS_ERROR(EINVAL);
-		}
-		xfs_trans_brelse(tp, agbp);
-		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
+					&chunk_agbno, &offset_agbno, flags);
 		if (error)
 			return error;
-		chunk_agbno = XFS_AGINO_TO_AGBNO(mp, chunk_agino);
-		offset_agbno = agbno - chunk_agbno;
 	}
+
+out_map:
 	ASSERT(agbno >= chunk_agbno);
 	cluster_agbno = chunk_agbno +
 		((offset_agbno / blks_per_cluster) * blks_per_cluster);
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
-	*bno = XFS_AGB_TO_FSB(mp, agno, cluster_agbno);
-	*off = offset;
-	*len = blks_per_cluster;
+
+	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
+	imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+	imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
+
+	/*
+	 * If the inode number maps to a block outside the bounds
+	 * of the file system then return NULL rather than calling
+	 * read_buf and panicing when we get an error from the
+	 * driver.
+	 */
+	if ((imap->im_blkno + imap->im_len) >
+	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
+			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
+			(unsigned long long) imap->im_blkno,
+			(unsigned long long) imap->im_len,
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
+		return XFS_ERROR(EINVAL);
+	}
 	return 0;
-error0:
-	xfs_trans_brelse(tp, agbp);
-	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	return error;
 }
 
 /*
@@ -1233,70 +1265,95 @@ xfs_ialloc_log_agi(
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
+#ifdef DEBUG
+STATIC void
+xfs_check_agi_unlinked(
+	struct xfs_agi		*agi)
+{
+	int			i;
+
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
+		ASSERT(agi->agi_unlinked[i]);
+}
+#else
+#define xfs_check_agi_unlinked(agi)
+#endif
+
 /*
  * Read in the allocation group header (inode allocation section)
  */
 int
-xfs_ialloc_read_agi(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_buf_t	**bpp)		/* allocation group hdr buf */
+xfs_read_agi(
+	struct xfs_mount	*mp,	/* file system mount structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_buf		**bpp)	/* allocation group hdr buf */
 {
-	xfs_agi_t	*agi;		/* allocation group header */
-	int		agi_ok;		/* agi is consistent */
-	xfs_buf_t	*bp;		/* allocation group hdr buf */
-	xfs_perag_t	*pag;		/* per allocation group data */
-	int		error;
+	struct xfs_agi		*agi;	/* allocation group header */
+	int			agi_ok;	/* agi is consistent */
+	int			error;
 
 	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp);
+			XFS_FSS_TO_BB(mp, 1), 0, bpp);
 	if (error)
 		return error;
-	ASSERT(bp && !XFS_BUF_GETERROR(bp));
+
+	ASSERT(*bpp && !XFS_BUF_GETERROR(*bpp));
+	agi = XFS_BUF_TO_AGI(*bpp);
 
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	agi = XFS_BUF_TO_AGI(bp);
-	agi_ok =
-		be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
+	agi_ok = be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
+		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
+		be32_to_cpu(agi->agi_seqno) == agno;
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
 			XFS_RANDOM_IALLOC_READ_AGI))) {
-		XFS_CORRUPTION_ERROR("xfs_ialloc_read_agi", XFS_ERRLEVEL_LOW,
+		XFS_CORRUPTION_ERROR("xfs_read_agi", XFS_ERRLEVEL_LOW,
 				     mp, agi);
-		xfs_trans_brelse(tp, bp);
+		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
-	pag = &mp->m_perag[agno];
+
+	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGI, XFS_AGI_REF);
+
+	xfs_check_agi_unlinked(agi);
+	return 0;
+}
+
+int
+xfs_ialloc_read_agi(
+	struct xfs_mount	*mp,	/* file system mount structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_buf		**bpp)	/* allocation group hdr buf */
+{
+	struct xfs_agi		*agi;	/* allocation group header */
+	struct xfs_perag	*pag;	/* per allocation group data */
+	int			error;
+
+	error = xfs_read_agi(mp, tp, agno, bpp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(*bpp);
+	pag = xfs_perag_get(mp, agno);
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
 		pag->pagi_init = 1;
-	} else {
-		/*
-		 * It's possible for these to be out of sync if
-		 * we are in the middle of a forced shutdown.
-		 */
-		ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-			XFS_FORCED_SHUTDOWN(mp));
-	}
-
-#ifdef DEBUG
-	{
-		int	i;
-
-		for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
-			ASSERT(agi->agi_unlinked[i]);
 	}
-#endif
 
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGI, XFS_AGI_REF);
-	*bpp = bp;
+	/*
+	 * It's possible for these to be out of sync if
+	 * we are in the middle of a forced shutdown.
+	 */
+	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
+		XFS_FORCED_SHUTDOWN(mp));
+	xfs_perag_put(pag);
 	return 0;
 }
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 17afc23..35dd96f 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -140,7 +140,7 @@ xfs_inobt_init_rec_from_cur(
 }
 
 /*
- * intial value of ptr for lookup
+ * initial value of ptr for lookup
  */
 STATIC void
 xfs_inobt_init_ptr_from_cur(
@@ -163,38 +163,6 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
-STATIC int
-xfs_inobt_kill_root(
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*bp,
-	int			level,
-	union xfs_btree_ptr	*newroot)
-{
-	int			error;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_STATS_INC(cur, killroot);
-
-	/*
-	 * Update the root pointer, decreasing the level by 1 and then
-	 * free the old root.
-	 */
-	xfs_inobt_set_root(cur, newroot, -1);
-	error = xfs_inobt_free_block(cur, bp);
-	if (error) {
-		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
-		return error;
-	}
-
-	XFS_BTREE_STATS_INC(cur, free);
-
-	cur->bc_bufs[level] = NULL;
-	cur->bc_nlevels--;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-	return 0;
-}
-
 #ifdef DEBUG
 STATIC int
 xfs_inobt_keys_inorder(
@@ -289,7 +257,6 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
-	.kill_root		= xfs_inobt_kill_root,
 	.alloc_block		= xfs_inobt_alloc_block,
 	.free_block		= xfs_inobt_free_block,
 	.get_minrecs		= xfs_inobt_get_minrecs,
diff --git a/libxfs/xfs_inode.c b/libxfs/xfs_inode.c
index 1c9ea3b..e4474fd 100644
--- a/libxfs/xfs_inode.c
+++ b/libxfs/xfs_inode.c
@@ -87,14 +87,14 @@ xfs_inobp_check(
  * We do basic validation checks on the buffer once it has been
  * retrieved from disk.
  */
-STATIC int
+int
 xfs_imap_to_bp(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
-	xfs_imap_t	*imap,
+	struct xfs_imap	*imap,
 	xfs_buf_t	**bpp,
 	uint		buf_flags,
-	uint		imap_flags)
+	uint		iget_flags)
 {
 	int		error;
 	int		i;
@@ -110,7 +110,7 @@ xfs_imap_to_bp(
 				"an error %d on %s.  Returning error.",
 				error, mp->m_fsname);
 		} else {
-			ASSERT(buf_flags & XFS_BUF_TRYLOCK);
+			ASSERT(buf_flags & XBF_TRYLOCK);
 		}
 		return error;
 	}
@@ -131,12 +131,12 @@ xfs_imap_to_bp(
 
 		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
 					(i << mp->m_sb.sb_inodelog));
-		di_ok = be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
+		di_ok = be16_to_cpu(dip->di_magic) == XFS_DINODE_MAGIC &&
+			    XFS_DINODE_GOOD_VERSION(dip->di_version);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
-			if (imap_flags & XFS_IMAP_BULKSTAT) {
+			if (iget_flags & XFS_IGET_UNTRUSTED) {
 				xfs_trans_brelse(tp, bp);
 				return XFS_ERROR(EINVAL);
 			}
@@ -148,7 +148,7 @@ xfs_imap_to_bp(
 					"daddr %lld #%d (magic=%x)",
 				XFS_BUFTARG_NAME(mp->m_ddev_targp),
 				(unsigned long long)imap->im_blkno, i,
-				be16_to_cpu(dip->di_core.di_magic));
+				be16_to_cpu(dip->di_magic));
 #endif
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EFSCORRUPTED);
@@ -167,6 +167,49 @@ xfs_imap_to_bp(
 }
 
 /*
+ * This routine is called to map an inode number within a file
+ * system to the buffer containing the on-disk version of the
+ * inode.  It returns a pointer to the buffer containing the
+ * on-disk inode in the bpp parameter, and in the dip parameter
+ * it returns a pointer to the on-disk inode within that buffer.
+ *
+ * If a non-zero error is returned, then the contents of bpp and
+ * dipp are undefined.
+ *
+ * Use xfs_imap() to determine the size and location of the
+ * buffer to read from disk.
+ */
+int
+xfs_inotobp(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_ino_t	ino,
+	xfs_dinode_t	**dipp,
+	xfs_buf_t	**bpp,
+	int		*offset,
+	uint		imap_flags)
+{
+	struct xfs_imap	imap;
+	xfs_buf_t	*bp;
+	int		error;
+
+	imap.im_blkno = 0;
+	error = xfs_imap(mp, tp, ino, &imap, imap_flags);
+	if (error)
+		return error;
+
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XBF_LOCK, imap_flags);
+	if (error)
+		return error;
+
+	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	*bpp = bp;
+	*offset = imap.im_boffset;
+	return 0;
+}
+
+
+/*
  * This routine is called to map an inode to the buffer containing
  * the on-disk version of the inode.  It returns a pointer to the
  * buffer containing the on-disk inode in the bpp parameter, and in
@@ -176,15 +219,11 @@ xfs_imap_to_bp(
  * If a non-zero error is returned, then the contents of bpp and
  * dipp are undefined.
  *
- * If the inode is new and has not yet been initialized, use xfs_imap()
- * to determine the size and location of the buffer to read from disk.
- * If the inode has already been mapped to its buffer and read in once,
- * then use the mapping information stored in the inode rather than
- * calling xfs_imap().  This allows us to avoid the overhead of looking
- * at the inode btree for small block file systems (see xfs_dilocate()).
- * We can tell whether the inode has been mapped in before by comparing
- * its disk block address to 0.  Only uninitialized inodes will have
- * 0 for the disk block address.
+ * The inode is expected to already been mapped to its buffer and read
+ * in once, thus we can use the mapping information stored in the inode
+ * rather than calling xfs_imap().  This allows us to avoid the overhead
+ * of looking at the inode btree for small block file systems
+ * (see xfs_imap()).
  */
 int
 xfs_itobp(
@@ -193,51 +232,25 @@ xfs_itobp(
 	xfs_inode_t	*ip,
 	xfs_dinode_t	**dipp,
 	xfs_buf_t	**bpp,
-	xfs_daddr_t	bno,
-	uint		imap_flags,
 	uint		buf_flags)
 {
-	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
 
-	if (ip->i_blkno == (xfs_daddr_t)0) {
-		imap.im_blkno = bno;
-		error = xfs_imap(mp, tp, ip->i_ino, &imap,
-					XFS_IMAP_LOOKUP | imap_flags);
-		if (error)
-			return error;
+	ASSERT(ip->i_imap.im_blkno != 0);
 
-		/*
-		 * Fill in the fields in the inode that will be used to
-		 * map the inode to its buffer from now on.
-		 */
-		ip->i_blkno = imap.im_blkno;
-		ip->i_len = imap.im_len;
-		ip->i_boffset = imap.im_boffset;
-	} else {
-		/*
-		 * We've already mapped the inode once, so just use the
-		 * mapping that we saved the first time.
-		 */
-		imap.im_blkno = ip->i_blkno;
-		imap.im_len = ip->i_len;
-		imap.im_boffset = ip->i_boffset;
-	}
-	ASSERT(bno == 0 || bno == imap.im_blkno);
-
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, buf_flags, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp, buf_flags, 0);
 	if (error)
 		return error;
 
 	if (!bp) {
-		ASSERT(buf_flags & XFS_BUF_TRYLOCK);
+		ASSERT(buf_flags & XBF_TRYLOCK);
 		ASSERT(tp == NULL);
 		*bpp = NULL;
 		return EAGAIN;
 	}
 
-	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 	*bpp = bp;
 	return 0;
 }
@@ -250,8 +263,6 @@ xfs_itobp(
  * pointers.  For a file in B-tree format, only the root is immediately
  * brought in-core.  The rest will be in-lined in if_extents when it
  * is first referenced (see xfs_iread_extents()).
- *
- * Note: this requires user-space public scope for libxfs_iread
  */
 int
 xfs_iformat(
@@ -266,55 +277,65 @@ xfs_iformat(
 		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	error = 0;
 
-	if (unlikely(be32_to_cpu(dip->di_core.di_nextents) +
-		     be16_to_cpu(dip->di_core.di_anextents) >
-		     be64_to_cpu(dip->di_core.di_nblocks))) {
+	if (unlikely(be32_to_cpu(dip->di_nextents) +
+		     be16_to_cpu(dip->di_anextents) >
+		     be64_to_cpu(dip->di_nblocks))) {
 		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 			"corrupt dinode %Lu, extent total = %d, nblocks = %Lu.",
 			(unsigned long long)ip->i_ino,
-			(int)(be32_to_cpu(dip->di_core.di_nextents) +
-			      be16_to_cpu(dip->di_core.di_anextents)),
+			(int)(be32_to_cpu(dip->di_nextents) +
+			      be16_to_cpu(dip->di_anextents)),
 			(unsigned long long)
-				be64_to_cpu(dip->di_core.di_nblocks));
+				be64_to_cpu(dip->di_nblocks));
 		XFS_CORRUPTION_ERROR("xfs_iformat(1)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
-	if (unlikely(dip->di_core.di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
+	if (unlikely(dip->di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
 		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 			"corrupt dinode %Lu, forkoff = 0x%x.",
 			(unsigned long long)ip->i_ino,
-			dip->di_core.di_forkoff);
+			dip->di_forkoff);
 		XFS_CORRUPTION_ERROR("xfs_iformat(2)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
+	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
+		     !ip->i_mount->m_rtdev)) {
+		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
+			"corrupt dinode %Lu, has realtime flag set.",
+			ip->i_ino);
+		XFS_CORRUPTION_ERROR("xfs_iformat(realtime)",
+				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
 	switch (ip->i_d.di_mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		if (unlikely(dip->di_core.di_format != XFS_DINODE_FMT_DEV)) {
+		if (unlikely(dip->di_format != XFS_DINODE_FMT_DEV)) {
 			XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
 					      ip->i_mount, dip);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 		ip->i_d.di_size = 0;
 		ip->i_size = 0;
-		ip->i_df.if_u2.if_rdev = be32_to_cpu(dip->di_u.di_dev);
+		ip->i_df.if_u2.if_rdev = xfs_dinode_get_rdev(dip);
 		break;
 
 	case S_IFREG:
 	case S_IFLNK:
 	case S_IFDIR:
-		switch (dip->di_core.di_format) {
+		switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			/*
 			 * no local regular files yet
 			 */
-			if (unlikely((be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFREG)) {
+			if (unlikely((be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFREG)) {
 				xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 					"corrupt inode %Lu "
 					"(local format for regular file).",
@@ -325,7 +346,7 @@ xfs_iformat(
 				return XFS_ERROR(EFSCORRUPTED);
 			}
 
-			di_size = be64_to_cpu(dip->di_core.di_size);
+			di_size = be64_to_cpu(dip->di_size);
 			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
 				xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 					"corrupt inode %Lu "
@@ -364,13 +385,26 @@ xfs_iformat(
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 	ASSERT(ip->i_afp == NULL);
-	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
+	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP | KM_NOFS);
 	ip->i_afp->if_ext_max =
 		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
-	switch (dip->di_core.di_aformat) {
+	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		size = be16_to_cpu(atp->hdr.totsize);
+
+		if (unlikely(size < sizeof(struct xfs_attr_sf_hdr))) {
+			xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
+				"corrupt inode %Lu "
+				"(bad attr fork size %Ld).",
+				(unsigned long long) ip->i_ino,
+				(long long) size);
+			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
+					     XFS_ERRLEVEL_LOW,
+					     ip->i_mount, dip);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
@@ -434,7 +468,7 @@ xfs_iformat_local(
 		ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
 	else {
 		real_size = roundup(size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
+		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP | KM_NOFS);
 	}
 	ifp->if_bytes = size;
 	ifp->if_real_bytes = real_size;
@@ -561,7 +595,7 @@ xfs_iformat_btree(
 	}
 
 	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmem_alloc(size, KM_SLEEP);
+	ifp->if_broot = kmem_alloc(size, KM_SLEEP | KM_NOFS);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -579,7 +613,7 @@ xfs_iformat_btree(
 void
 xfs_dinode_from_disk(
 	xfs_icdinode_t		*to,
-	xfs_dinode_core_t	*from)
+	xfs_dinode_t		*from)
 {
 	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
@@ -614,7 +648,7 @@ xfs_dinode_from_disk(
 
 void
 xfs_dinode_to_disk(
-	xfs_dinode_core_t	*to,
+	xfs_dinode_t		*to,
 	xfs_icdinode_t		*from)
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
@@ -661,7 +695,6 @@ xfs_iread_extents(
 	int		error;
 	xfs_ifork_t	*ifp;
 	xfs_extnum_t	nextents;
-	size_t		size;
 
 	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
 		XFS_ERROR_REPORT("xfs_iread_extents", XFS_ERRLEVEL_LOW,
@@ -669,7 +702,6 @@ xfs_iread_extents(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	nextents = XFS_IFORK_NEXTENTS(ip, whichfork);
-	size = nextents * sizeof(xfs_bmbt_rec_t);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
 	/*
@@ -737,7 +769,7 @@ xfs_iroot_realloc(
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP);
+			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
 		}
@@ -753,7 +785,7 @@ xfs_iroot_realloc(
 		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
 		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
 				(size_t)XFS_BMAP_BROOT_SPACE_CALC(cur_max), /* old size */
-				KM_SLEEP);
+				KM_SLEEP | KM_NOFS);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -779,7 +811,7 @@ xfs_iroot_realloc(
 	else
 		new_size = 0;
 	if (new_size > 0) {
-		new_broot = kmem_alloc(new_size, KM_SLEEP);
+		new_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
 		/*
 		 * First copy over the btree block header.
 		 */
@@ -883,7 +915,8 @@ xfs_idata_realloc(
 		real_size = roundup(new_size, 4);
 		if (ifp->if_u1.if_data == NULL) {
 			ASSERT(ifp->if_real_bytes == 0);
-			ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
+			ifp->if_u1.if_data = kmem_alloc(real_size,
+							KM_SLEEP | KM_NOFS);
 		} else if (ifp->if_u1.if_data != ifp->if_u2.if_inline_data) {
 			/*
 			 * Only do the realloc if the underlying size
@@ -894,11 +927,12 @@ xfs_idata_realloc(
 					kmem_realloc(ifp->if_u1.if_data,
 							real_size,
 							ifp->if_real_bytes,
-							KM_SLEEP);
+							KM_SLEEP | KM_NOFS);
 			}
 		} else {
 			ASSERT(ifp->if_real_bytes == 0);
-			ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
+			ifp->if_u1.if_data = kmem_alloc(real_size,
+							KM_SLEEP | KM_NOFS);
 			memcpy(ifp->if_u1.if_data, ifp->if_u2.if_inline_data,
 				ifp->if_bytes);
 		}
@@ -908,64 +942,6 @@ xfs_idata_realloc(
 	ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
 }
 
-
-
-
-/*
- * Map inode to disk block and offset.
- *
- * mp -- the mount point structure for the current file system
- * tp -- the current transaction
- * ino -- the inode number of the inode to be located
- * imap -- this structure is filled in with the information necessary
- *	 to retrieve the given inode from disk
- * flags -- flags to pass to xfs_dilocate indicating whether or not
- *	 lookups in the inode btree were OK or not
- */
-int
-xfs_imap(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	xfs_imap_t	*imap,
-	uint		flags)
-{
-	xfs_fsblock_t	fsbno;
-	int		len;
-	int		off;
-	int		error;
-
-	fsbno = imap->im_blkno ?
-		XFS_DADDR_TO_FSB(mp, imap->im_blkno) : NULLFSBLOCK;
-	error = xfs_dilocate(mp, tp, ino, &fsbno, &len, &off, flags);
-	if (error)
-		return error;
-
-	imap->im_blkno = XFS_FSB_TO_DADDR(mp, fsbno);
-	imap->im_len = XFS_FSB_TO_BB(mp, len);
-	imap->im_agblkno = XFS_FSB_TO_AGBNO(mp, fsbno);
-	imap->im_ioffset = (ushort)off;
-	imap->im_boffset = (ushort)(off << mp->m_sb.sb_inodelog);
-
-	/*
-	 * If the inode number maps to a block outside the bounds
-	 * of the file system then return NULL rather than calling
-	 * read_buf and panicing when we get an error from the
-	 * driver.
-	 */
-	if ((imap->im_blkno + imap->im_len) >
-	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
-			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
-			(unsigned long long) imap->im_blkno,
-			(unsigned long long) imap->im_len,
-			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-		return EINVAL;
-	}
-	return 0;
-}
-
 void
 xfs_idestroy_fork(
 	xfs_inode_t	*ip,
@@ -1050,7 +1026,7 @@ xfs_iextents_copy(
 	for (i = 0; i < nrecs; i++) {
 		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
 		start_block = xfs_bmbt_get_startblock(ep);
-		if (ISNULLSTARTBLOCK(start_block)) {
+		if (isnullstartblock(start_block)) {
 			/*
 			 * It's a delayed allocation extent, so skip it.
 			 */
@@ -1078,8 +1054,6 @@ xfs_iextents_copy(
  * changed formats after being modified but before being flushed.
  * In these cases, the format always takes precedence, because the
  * format indicates the current state of the fork.
- * 
- * Note: this requires user-space public scope for libxfs_iread
  */
 /*ARGSUSED*/
 void
@@ -1157,15 +1131,16 @@ xfs_iflush_fork(
 	case XFS_DINODE_FMT_DEV:
 		if (iip->ili_format.ilf_fields & XFS_ILOG_DEV) {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			dip->di_u.di_dev = cpu_to_be32(ip->i_df.if_u2.if_rdev);
+			xfs_dinode_put_rdev(dip, ip->i_df.if_u2.if_rdev);
 		}
 		break;
 
 	case XFS_DINODE_FMT_UUID:
 		if (iip->ili_format.ilf_fields & XFS_ILOG_UUID) {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			memcpy(&dip->di_u.di_muuid, &ip->i_df.if_u2.if_uuid,
-				sizeof(uuid_t));
+			memcpy(XFS_DFORK_DPTR(dip),
+			       &ip->i_df.if_u2.if_uuid,
+			       sizeof(uuid_t));
 		}
 		break;
 
@@ -1206,13 +1181,17 @@ xfs_iext_get_ext(
  */
 void
 xfs_iext_insert(
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
+	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* starting index of new items */
 	xfs_extnum_t	count,		/* number of inserted items */
-	xfs_bmbt_irec_t	*new)		/* items to insert */
+	xfs_bmbt_irec_t	*new,		/* items to insert */
+	int		state)		/* type of extent conversion */
 {
+	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
 	xfs_extnum_t	i;		/* extent record index */
 
+	trace_xfs_iext_insert(ip, idx, new, state, _RET_IP_);
+
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 	xfs_iext_add(ifp, idx, count);
 	for (i = idx; i < idx + count; i++, new++)
@@ -1455,13 +1434,17 @@ xfs_iext_add_indirect_multi(
  */
 void
 xfs_iext_remove(
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
+	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index to begin removing exts */
-	int		ext_diff)	/* number of extents to remove */
+	int		ext_diff,	/* number of extents to remove */
+	int		state)		/* type of extent conversion */
 {
+	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	int		new_size;	/* size of extents after removal */
 
+	trace_xfs_iext_remove(ip, idx, state, _RET_IP_);
+
 	ASSERT(ext_diff > 0);
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	new_size = (nextents - ext_diff) * sizeof(xfs_bmbt_rec_t);
@@ -1583,13 +1566,11 @@ xfs_iext_remove_indirect(
 	xfs_extnum_t	ext_diff;	/* extents to remove in current list */
 	xfs_extnum_t	nex1;		/* number of extents before idx */
 	xfs_extnum_t	nex2;		/* extents after idx + count */
-	int		nlists;		/* entries in indirection array */
 	int		page_idx = idx;	/* index in target extent list */
 
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
 	erp = xfs_iext_idx_to_irec(ifp,  &page_idx, &erp_idx, 0);
 	ASSERT(erp != NULL);
-	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
 	nex1 = page_idx;
 	ext_cnt = count;
 	while (ext_cnt) {
@@ -1743,7 +1724,7 @@ xfs_iext_inline_to_direct(
 /*
  * Resize an extent indirection array to new_size bytes.
  */
-void
+STATIC void
 xfs_iext_realloc_indirect(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* new indirection array size */
@@ -1768,7 +1749,7 @@ xfs_iext_realloc_indirect(
 /*
  * Switch from indirection array to linear (direct) extent allocations.
  */
-void
+STATIC void
 xfs_iext_indirect_to_direct(
 	 xfs_ifork_t	*ifp)		/* inode fork pointer */
 {
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index 02bff42..32d2255 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -73,70 +73,36 @@ static const struct {
     { sizeof(xfs_sb_t),			 0 }
 };
 
-xfs_agnumber_t
-xfs_initialize_perag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agcount)
+/*
+ * Reference counting access wrappers to the perag structures.
+ * Because we never free per-ag structures, the only thing we
+ * have to protect against changes is the tree structure itself.
+ */
+struct xfs_perag *
+xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 {
-	xfs_agnumber_t	index, max_metadata;
-	xfs_perag_t	*pag;
-	xfs_agino_t	agino;
-	xfs_ino_t	ino;
-	xfs_sb_t	*sbp = &mp->m_sb;
-	xfs_ino_t	max_inum = XFS_MAXINUMBER_32;
-
-	/* Check to see if the filesystem can overflow 32 bit inodes */
-	agino = XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
-	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
-
-	/* Clear the mount flag if no inode can overflow 32 bits
-	 * on this filesystem, or if specifically requested..
-	 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > max_inum) {
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
-	} else {
-		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
+	struct xfs_perag	*pag;
+	int			ref = 0;
+
+	rcu_read_lock();
+	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	if (pag) {
+		ASSERT(atomic_read(&pag->pag_ref) >= 0);
+		ref = atomic_inc_return(&pag->pag_ref);
 	}
+	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
+	rcu_read_unlock();
+	return pag;
+}
 
-	/* If we can overflow then setup the ag headers accordingly */
-	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
-		/* Calculate how much should be reserved for inodes to
-		 * meet the max inode percentage.
-		 */
-		if (mp->m_maxicount) {
-			__uint64_t	icount;
-
-			icount = sbp->sb_dblocks * sbp->sb_imax_pct;
-			do_div(icount, 100);
-			icount += sbp->sb_agblocks - 1;
-			do_div(icount, sbp->sb_agblocks);
-			max_metadata = icount;
-		} else {
-			max_metadata = agcount;
-		}
-		for (index = 0; index < agcount; index++) {
-			ino = XFS_AGINO_TO_INO(mp, index, agino);
-			if (ino > max_inum) {
-				index++;
-				break;
-			}
+void
+xfs_perag_put(struct xfs_perag *pag)
+{
+	int	ref;
 
-			/* This ag is preferred for inodes */
-			pag = &mp->m_perag[index];
-			pag->pagi_inodeok = 1;
-			if (index < max_metadata)
-				pag->pagf_metadata = 1;
-			xfs_initialize_perag_icache(pag);
-		}
-	} else {
-		/* Setup default behavior for smaller filesystems */
-		for (index = 0; index < agcount; index++) {
-			pag = &mp->m_perag[index];
-			pag->pagi_inodeok = 1;
-			xfs_initialize_perag_icache(pag);
-		}
-	}
-	return index;
+	ASSERT(atomic_read(&pag->pag_ref) > 0);
+	ref = atomic_dec_return(&pag->pag_ref);
+	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
 }
 
 void
@@ -265,33 +231,9 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	mp->m_litino = sbp->sb_inodesize -
-		((uint)sizeof(xfs_dinode_core_t) + (uint)sizeof(xfs_agino_t));
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
-	INIT_LIST_HEAD(&mp->m_del_inodes);
-
-	/*
-	 * Setup for attributes, in case they get created.
-	 * This value is for inodes getting attributes for the first time,
-	 * the per-inode value is for old attribute values.
-	 */
-	ASSERT(sbp->sb_inodesize >= 256 && sbp->sb_inodesize <= 2048);
-	switch (sbp->sb_inodesize) {
-	case 256:
-		mp->m_attroffset = XFS_LITINO(mp) -
-				   XFS_BMDR_SPACE_CALC(MINABTPTRS);
-		break;
-	case 512:
-	case 1024:
-	case 2048:
-		mp->m_attroffset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
-		break;
-	default:
-		ASSERT(0);
-	}
-	ASSERT(mp->m_attroffset < XFS_LITINO(mp));
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
@@ -340,7 +282,7 @@ xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
 	for (index = 0; index < agcount; index++) {
 		/*
 		 * read the agf, then the agi. This gets us
-		 * all the inforamtion we need and populates the
+		 * all the information we need and populates the
 		 * per-ag structures for us.
 		 */
 		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
@@ -350,12 +292,13 @@ xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
 		error = xfs_ialloc_pagi_init(mp, NULL, index);
 		if (error)
 			return error;
-		pag = &mp->m_perag[index];
+		pag = xfs_perag_get(mp, index);
 		ifree += pag->pagi_freecount;
 		ialloc += pag->pagi_count;
 		bfree += pag->pagf_freeblks;
 		bfreelst += pag->pagf_flcount;
 		btree += pag->pagf_btreeblks;
+		xfs_perag_put(pag);
 	}
 	/*
 	 * Overwrite incore superblock counters with just-read data
@@ -397,18 +340,16 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 	last = 0;
 
 	/* translate/copy */
-
 	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
 
 	/* find modified range */
+	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
+	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
+	last = xfs_sb_info[f + 1].offset - 1;
 
 	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
 	first = xfs_sb_info[f].offset;
 
-	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
-	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
-	last = xfs_sb_info[f + 1].offset - 1;
-
 	xfs_trans_log_buf(tp, bp, first, last);
 }
diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
index 9036995..635de8f 100644
--- a/libxfs/xfs_trans.c
+++ b/libxfs/xfs_trans.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -18,135 +19,491 @@
 
 #include <xfs.h>
 
+kmem_zone_t	*xfs_trans_zone;
+kmem_zone_t	*xfs_log_item_desc_zone;
+
 /*
- * Reservation functions here avoid a huge stack in xfs_trans_init
- * due to register overflow from temporaries in the calculations.
+ * Various log reservation values.
+ *
+ * These are based on the size of the file system block because that is what
+ * most transactions manipulate.  Each adds in an additional 128 bytes per
+ * item logged to try to account for the overhead of the transaction mechanism.
+ *
+ * Note:  Most of the reservations underestimate the number of allocation
+ * groups into which they could free extents in the xfs_bmap_finish() call.
+ * This is because the number in the worst case is quite high and quite
+ * unusual.  In order to fix this we need to change xfs_bmap_finish() to free
+ * extents in only a single AG at a time.  This will require changes to the
+ * EFI code as well, however, so that the EFI for the extents not freed is
+ * logged again in each transaction.  See SGI PV #261917.
+ *
+ * Reservation functions here avoid a huge stack in xfs_trans_init due to
+ * register overflow from temporaries in the calculations.
  */
 
+
+/*
+ * In a write transaction we can allocate a maximum of 2
+ * extents.  This gives:
+ *    the inode getting the new extents: inode size
+ *    the inode's bmap btree: max depth * block size
+ *    the agfs of the ags from which the extents are allocated: 2 * sector
+ *    the superblock free block counter: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ * And the bmap_finish transaction can free bmap blocks in a join:
+ *    the agfs of the ags containing the blocks: 2 * sector size
+ *    the agfls of the ags containing the blocks: 2 * sector size
+ *    the super block free block counter: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_write_reservation(xfs_mount_t *mp)
+xfs_calc_write_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_WRITE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 2))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * In truncating a file we free up to two extents at once.  We can modify:
+ *    the inode being truncated: inode size
+ *    the inode's bmap btree: (max depth + 1) * block size
+ * And the bmap_finish transaction can free the blocks and bmap blocks:
+ *    the agf for each of the ags: 4 * sector size
+ *    the agfl for each of the ags: 4 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming 4 extents:
+ *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_itruncate_reservation(xfs_mount_t *mp)
+xfs_calc_itruncate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ITRUNCATE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) +
+		     128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
+		    (4 * mp->m_sb.sb_sectsize +
+		     4 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 4) +
+		     128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4)) +
+		     128 * 5 +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * In renaming a files we can modify:
+ *    the four inodes involved: 4 * inode size
+ *    the two directory btrees: 2 * (max depth + v2) * dir block size
+ *    the two directory bmap btrees: 2 * max depth * block size
+ * And the bmap_finish transaction can free dir and bmap blocks (two sets
+ *	of bmap blocks) giving:
+ *    the agf for the ags in which the blocks live: 3 * sector size
+ *    the agfl for the ags in which the blocks live: 3 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_rename_reservation(xfs_mount_t *mp)
+xfs_calc_rename_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_RENAME_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((4 * mp->m_sb.sb_inodesize +
+		     2 * XFS_DIROP_LOG_RES(mp) +
+		     128 * (4 + 2 * XFS_DIROP_LOG_COUNT(mp))),
+		    (3 * mp->m_sb.sb_sectsize +
+		     3 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 3) +
+		     128 * (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))));
 }
 
+/*
+ * For creating a link to an inode:
+ *    the parent directory inode: inode size
+ *    the linked inode: inode size
+ *    the directory btree could split: (max depth + v2) * dir block size
+ *    the directory bmap btree could join or split: (max depth + v2) * blocksize
+ * And the bmap_finish transaction can free some bmap blocks giving:
+ *    the agf for the ag in which the blocks live: sector size
+ *    the agfl for the ag in which the blocks live: sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_link_reservation(xfs_mount_t *mp)
+xfs_calc_link_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_LINK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		    (mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * For removing a directory entry we can modify:
+ *    the parent directory inode: inode size
+ *    the removed inode: inode size
+ *    the directory btree could join: (max depth + v2) * dir block size
+ *    the directory bmap btree could join or split: (max depth + v2) * blocksize
+ * And the bmap_finish transaction can free the dir and bmap blocks giving:
+ *    the agf for the ag in which the blocks live: 2 * sector size
+ *    the agfl for the ag in which the blocks live: 2 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_remove_reservation(xfs_mount_t *mp)
+xfs_calc_remove_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_REMOVE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * For symlink we can modify:
+ *    the parent directory inode: inode size
+ *    the new inode: inode size
+ *    the inode btree entry: 1 block
+ *    the directory btree: (max depth + v2) * dir block size
+ *    the directory inode's bmap btree: (max depth + v2) * block size
+ *    the blocks for the symlink: 1 kB
+ * Or in the first xact we allocate some inodes giving:
+ *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_symlink_reservation(xfs_mount_t *mp)
+xfs_calc_symlink_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_SYMLINK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, 1) +
+		     XFS_DIROP_LOG_RES(mp) +
+		     1024 +
+		     128 * (4 + XFS_DIROP_LOG_COUNT(mp))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
+		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * For create we can modify:
+ *    the parent directory inode: inode size
+ *    the new inode: inode size
+ *    the inode btree entry: block size
+ *    the superblock for the nlink flag: sector size
+ *    the directory btree: (max depth + v2) * dir block size
+ *    the directory inode's bmap btree: (max depth + v2) * block size
+ * Or in the first xact we allocate some inodes giving:
+ *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the superblock for the nlink flag: sector size
+ *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_create_reservation(xfs_mount_t *mp)
+xfs_calc_create_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_CREATE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, 1) +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (3 + XFS_DIROP_LOG_COUNT(mp))),
+		    (3 * mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
+		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * Making a new directory is the same as creating a new file.
+ */
 STATIC uint
-xfs_calc_mkdir_reservation(xfs_mount_t *mp)
+xfs_calc_mkdir_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_MKDIR_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return xfs_calc_create_reservation(mp);
 }
 
+/*
+ * In freeing an inode we can modify:
+ *    the inode being freed: inode size
+ *    the super block free inode counter: sector size
+ *    the agi hash list and counters: sector size
+ *    the inode btree entry: block size
+ *    the on disk inode before ours in the agi hash list: inode cluster size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_ifree_reservation(xfs_mount_t *mp)
+xfs_calc_ifree_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_IFREE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, 1) +
+		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
+		    XFS_INODE_CLUSTER_SIZE(mp)) +
+		128 * 5 +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * When only changing the inode we log the inode and possibly the superblock
+ * We also add a bit of slop for the transaction stuff.
+ */
 STATIC uint
-xfs_calc_ichange_reservation(xfs_mount_t *mp)
+xfs_calc_ichange_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ICHANGE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		512;
+
 }
 
+/*
+ * Growing the data section of the filesystem.
+ *	superblock
+ *	agi and agf
+ *	allocation btrees
+ */
 STATIC uint
-xfs_calc_growdata_reservation(xfs_mount_t *mp)
+xfs_calc_growdata_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWDATA_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize * 3 +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the first set of transactions (ALLOC) we allocate space to the
+ * bitmap or summary files.
+ *	superblock: sector size
+ *	agf of the ag from which the extent is allocated: sector size
+ *	bmap btree for bitmap/summary inode: max depth * blocksize
+ *	bitmap/summary inode: inode size
+ *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
+ */
 STATIC uint
-xfs_calc_growrtalloc_reservation(xfs_mount_t *mp)
+xfs_calc_growrtalloc_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTALLOC_LOG_RES(mp);
+	return 2 * mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
+		mp->m_sb.sb_inodesize +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the second set of transactions (ZERO) we zero the new metadata blocks.
+ *	one bitmap/summary block: blocksize
+ */
 STATIC uint
-xfs_calc_growrtzero_reservation(xfs_mount_t *mp)
+xfs_calc_growrtzero_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTZERO_LOG_RES(mp);
+	return mp->m_sb.sb_blocksize + 128;
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the third set of transactions (FREE) we update metadata without
+ * allocating any new blocks.
+ *	superblock: sector size
+ *	bitmap inode: inode size
+ *	summary inode: inode size
+ *	one bitmap block: blocksize
+ *	summary blocks: new summary size
+ */
 STATIC uint
-xfs_calc_growrtfree_reservation(xfs_mount_t *mp)
+xfs_calc_growrtfree_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTFREE_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize +
+		2 * mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_blocksize +
+		mp->m_rsumsize +
+		128 * 5;
 }
 
+/*
+ * Logging the inode modification timestamp on a synchronous write.
+ *	inode
+ */
 STATIC uint
-xfs_calc_swrite_reservation(xfs_mount_t *mp)
+xfs_calc_swrite_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_SWRITE_LOG_RES(mp);
+	return mp->m_sb.sb_inodesize + 128;
 }
 
+/*
+ * Logging the inode mode bits when writing a setuid/setgid file
+ *	inode
+ */
 STATIC uint
 xfs_calc_writeid_reservation(xfs_mount_t *mp)
 {
-	return XFS_CALC_WRITEID_LOG_RES(mp);
+	return mp->m_sb.sb_inodesize + 128;
 }
 
+/*
+ * Converting the inode from non-attributed to attributed.
+ *	the inode being converted: inode size
+ *	agf block and superblock (for block allocation)
+ *	the new block (directory sized)
+ *	bmap blocks for the new directory block
+ *	allocation btrees
+ */
 STATIC uint
-xfs_calc_addafork_reservation(xfs_mount_t *mp)
+xfs_calc_addafork_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ADDAFORK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize * 2 +
+		mp->m_dirblksize +
+		XFS_FSB_TO_B(mp, XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1) +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (4 + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1 +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Removing the attribute fork of a file
+ *    the inode being truncated: inode size
+ *    the inode's bmap btree: max depth * block size
+ * And the bmap_finish transaction can free the blocks and bmap blocks:
+ *    the agf for each of the ags: 4 * sector size
+ *    the agfl for each of the ags: 4 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming 4 extents:
+ *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_attrinval_reservation(xfs_mount_t *mp)
+xfs_calc_attrinval_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRINVAL_LOG_RES(mp);
+	return MAX((mp->m_sb.sb_inodesize +
+		    XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
+		    128 * (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))),
+		   (4 * mp->m_sb.sb_sectsize +
+		    4 * mp->m_sb.sb_sectsize +
+		    mp->m_sb.sb_sectsize +
+		    XFS_ALLOCFREE_LOG_RES(mp, 4) +
+		    128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))));
 }
 
+/*
+ * Setting an attribute.
+ *	the inode getting the attribute
+ *	the superblock for allocations
+ *	the agfs extents are allocated from
+ *	the attribute btree * max depth
+ *	the inode allocation btree
+ * Since attribute transaction space is dependent on the size of the attribute,
+ * the calculation is done partially at mount time and partially at runtime.
+ */
 STATIC uint
-xfs_calc_attrset_reservation(xfs_mount_t *mp)
+xfs_calc_attrset_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRSET_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
+		128 * (2 + XFS_DA_NODE_MAXDEPTH);
 }
 
+/*
+ * Removing an attribute.
+ *    the inode: inode size
+ *    the attribute btree could join: max depth * block size
+ *    the inode bmap btree could join or split: max depth * block size
+ * And the bmap_finish transaction can free the attr blocks freed giving:
+ *    the agf for the ag in which the blocks live: 2 * sector size
+ *    the agfl for the ag in which the blocks live: 2 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_attrrm_reservation(xfs_mount_t *mp)
+xfs_calc_attrrm_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRRM_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
+		     128 * (1 + XFS_DA_NODE_MAXDEPTH +
+			    XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * Clearing a bad agino number in an agi hash bucket.
+ */
 STATIC uint
-xfs_calc_clear_agi_bucket_reservation(xfs_mount_t *mp)
+xfs_calc_clear_agi_bucket_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_CLEAR_AGI_BUCKET_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize + 128;
 }
 
 /*
@@ -155,11 +512,10 @@ xfs_calc_clear_agi_bucket_reservation(xfs_mount_t *mp)
  */
 void
 xfs_trans_init(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_trans_reservations_t	*resp;
+	struct xfs_trans_reservations *resp = &mp->m_reservations;
 
-	resp = &(mp->m_reservations);
 	resp->tr_write = xfs_calc_write_reservation(mp);
 	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
 	resp->tr_rename = xfs_calc_rename_reservation(mp);
@@ -184,6 +540,50 @@ xfs_trans_init(
 }
 
 /*
+ * Add the given log item to the transaction's list of log items.
+ *
+ * The log item will now point to its new descriptor with its li_desc field.
+ */
+void
+xfs_trans_add_item(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_log_item_desc *lidp;
+
+	ASSERT(lip->li_mountp = tp->t_mountp);
+	ASSERT(lip->li_ailp = tp->t_mountp->m_ail);
+
+	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
+
+	lidp->lid_item = lip;
+	lidp->lid_flags = 0;
+	lidp->lid_size = 0;
+	list_add_tail(&lidp->lid_trans, &tp->t_items);
+
+	lip->li_desc = lidp;
+}
+
+STATIC void
+xfs_trans_free_item_desc(
+	struct xfs_log_item_desc *lidp)
+{
+	list_del_init(&lidp->lid_trans);
+	kmem_zone_free(xfs_log_item_desc_zone, lidp);
+}
+
+/*
+ * Unlink and free the given descriptor.
+ */
+void
+xfs_trans_del_item(
+	struct xfs_log_item	*lip)
+{
+	xfs_trans_free_item_desc(lip->li_desc);
+	lip->li_desc = NULL;
+}
+
+/*
  * Roll from one trans in the sequence of PERMANENT transactions to
  * the next: permanent transactions are only flushed out when
  * committed with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 9e0e567..23fe6fd 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -22,31 +22,60 @@
 #define xlog_clear_stale_blocks(log, tail_lsn)		(0)
 #define xfs_readonly_buftarg(buftarg)			(0)
 
-STATIC void	xlog_recover_insert_item_backq(xlog_recover_item_t **q,
-					       xlog_recover_item_t *item);
 
 /*
- * Sector aligned buffer routines for buffer create/read/write/access
+ * Verify the given count of basic blocks is valid number of blocks
+ * to specify for an operation involving the given XFS log buffer.
+ * Returns nonzero if the count is valid, 0 otherwise.
  */
 
-#define XLOG_SECTOR_ROUNDUP_BBCOUNT(log, bbs)	\
-	( ((log)->l_sectbb_mask && (bbs & (log)->l_sectbb_mask)) ? \
-	((bbs + (log)->l_sectbb_mask + 1) & ~(log)->l_sectbb_mask) : (bbs) )
-#define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno)	((bno) & ~(log)->l_sectbb_mask)
+static inline int
+xlog_buf_bbcount_valid(
+	xlog_t		*log,
+	int		bbcount)
+{
+	return bbcount > 0 && bbcount <= log->l_logBBsize;
+}
 
+/*
+ * Allocate a buffer to hold log data.  The buffer needs to be able
+ * to map to a range of nbblks basic blocks at any valid (basic
+ * block) offset within the log.
+ */
 xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
-	int		num_bblks)
+	int		nbblks)
 {
-	ASSERT(num_bblks > 0);
-
-	if (log->l_sectbb_log) {
-		if (num_bblks > 1)
-			num_bblks += XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
-		num_bblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, num_bblks);
+	if (!xlog_buf_bbcount_valid(log, nbblks)) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+			nbblks);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
+		return NULL;
 	}
-	return libxfs_getbufr(log->l_dev, (xfs_daddr_t)-1, num_bblks);
+
+	/*
+	 * We do log I/O in units of log sectors (a power-of-2
+	 * multiple of the basic block size), so we round up the
+	 * requested size to acommodate the basic blocks required
+	 * for complete log sectors.
+	 *
+	 * In addition, the buffer may be used for a non-sector-
+	 * aligned block offset, in which case an I/O of the
+	 * requested size could extend beyond the end of the
+	 * buffer.  If the requested size is only 1 basic block it
+	 * will never straddle a sector boundary, so this won't be
+	 * an issue.  Nor will this be a problem if the log I/O is
+	 * done in basic blocks (sector size 1).  But otherwise we
+	 * extend the buffer by one extra log sector to ensure
+	 * there's space to accomodate this possiblility.
+	 */
+	if (nbblks > 1 && log->l_sectBBsize > 1)
+		nbblks += log->l_sectBBsize;
+	if (log->l_sectBBsize)
+		nbblks = round_up(nbblks, log->l_sectBBsize);
+
+	return libxfs_getbufr(log->l_dev, (xfs_daddr_t)-1, nbblks);
 }
 
 void
@@ -56,25 +85,50 @@ xlog_put_bp(
 	libxfs_putbufr(bp);
 }
 
+/*
+ * Return the address of the start of the given block number's data
+ * in a log buffer.  The buffer covers a log sector-aligned region.
+ */
+STATIC xfs_caddr_t
+xlog_align(
+	xlog_t		*log,
+	xfs_daddr_t	blk_no,
+	int		nbblks,
+	xfs_buf_t	*bp)
+{
+	xfs_daddr_t	offset = 0;
+
+	if (log->l_sectBBsize)
+		offset = blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1);
+
+	ASSERT(BBTOB(offset + nbblks) <= XFS_BUF_SIZE(bp));
+	return XFS_BUF_PTR(bp) + BBTOB(offset);
+}
 
 /*
  * nbblks should be uint, but oh well.  Just want to catch that 32-bit length.
  */
 int
-xlog_bread(
+xlog_bread_noalign(
 	xlog_t		*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
 	xfs_buf_t	*bp)
 {
-	if (log->l_sectbb_log) {
-		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
-		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
+	if (!xlog_buf_bbcount_valid(log, nbblks)) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+			nbblks);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
+		return EFSCORRUPTED;
+	}
+
+	if (log->l_sectBBsize > 1) {
+		blk_no = round_down(blk_no, log->l_sectBBsize);
+		nbblks = round_up(nbblks, log->l_sectBBsize);
 	}
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
-	ASSERT(bp);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
@@ -82,26 +136,24 @@ xlog_bread(
 	return libxfs_readbufr(log->l_dev, XFS_BUF_ADDR(bp), bp, nbblks, 0);
 }
 
-
-static xfs_caddr_t
-xlog_align(
+int
+xlog_bread(
 	xlog_t		*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
-	xfs_buf_t	*bp)
+	xfs_buf_t	*bp,
+	xfs_caddr_t	*offset)
 {
-	xfs_caddr_t	ptr;
+	int		error;
 
-	if (!log->l_sectbb_log)
-		return XFS_BUF_PTR(bp);
+	error = xlog_bread_noalign(log, blk_no, nbblks, bp);
+	if (error)
+		return error;
 
-	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
-	ASSERT(XFS_BUF_SIZE(bp) >=
-		BBTOB(nbblks + (blk_no & log->l_sectbb_mask)));
-	return ptr;
+	*offset = xlog_align(log, blk_no, nbblks, bp);
+	return 0;
 }
 
-
 /*
  * This routine finds (to an approximation) the first block in the physical
  * log which contains the given cycle.  It uses a binary search algorithm.
@@ -118,39 +170,38 @@ xlog_find_cycle_start(
 {
 	xfs_caddr_t	offset;
 	xfs_daddr_t	mid_blk;
+	xfs_daddr_t	end_blk;
 	uint		mid_cycle;
 	int		error;
 
-	mid_blk = BLK_AVG(first_blk, *last_blk);
-	while (mid_blk != first_blk && mid_blk != *last_blk) {
-		if ((error = xlog_bread(log, mid_blk, 1, bp)))
+	end_blk = *last_blk;
+	mid_blk = BLK_AVG(first_blk, end_blk);
+	while (mid_blk != first_blk && mid_blk != end_blk) {
+		error = xlog_bread(log, mid_blk, 1, bp, &offset);
+		if (error)
 			return error;
-		offset = xlog_align(log, mid_blk, 1, bp);
 		mid_cycle = xlog_get_cycle(offset);
-		if (mid_cycle == cycle) {
-			*last_blk = mid_blk;
-			/* last_half_cycle == mid_cycle */
-		} else {
-			first_blk = mid_blk;
-			/* first_half_cycle == mid_cycle */
-		}
-		mid_blk = BLK_AVG(first_blk, *last_blk);
+		if (mid_cycle == cycle)
+			end_blk = mid_blk;   /* last_half_cycle == mid_cycle */
+		else
+			first_blk = mid_blk; /* first_half_cycle == mid_cycle */
+		mid_blk = BLK_AVG(first_blk, end_blk);
 	}
-	ASSERT((mid_blk == first_blk && mid_blk+1 == *last_blk) ||
-	       (mid_blk == *last_blk && mid_blk-1 == first_blk));
+	ASSERT((mid_blk == first_blk && mid_blk+1 == end_blk) ||
+	       (mid_blk == end_blk && mid_blk-1 == first_blk));
+
+	*last_blk = end_blk;
 
 	return 0;
 }
 
 /*
- * Check that the range of blocks does not contain the cycle number
- * given.  The scan needs to occur from front to back and the ptr into the
- * region must be updated since a later routine will need to perform another
- * test.  If the region is completely good, we end up returning the same
- * last block number.
- *
- * Set blkno to -1 if we encounter no errors.  This is an invalid block number
- * since we don't ever expect logs to get this large.
+ * Check that a range of blocks does not contain stop_on_cycle_no.
+ * Fill in *new_blk with the block offset where such a block is
+ * found, or with -1 (an invalid block number) if there is no such
+ * block in the range.  The scan needs to occur from front to back
+ * and the pointer into the region must be updated since a later
+ * routine will need to perform another test.
  */
 STATIC int
 xlog_find_verify_cycle(
@@ -167,12 +218,16 @@ xlog_find_verify_cycle(
 	xfs_caddr_t	buf = NULL;
 	int		error = 0;
 
+	/*
+	 * Greedily allocate a buffer big enough to handle the full
+	 * range of basic blocks we'll be examining.  If that fails,
+	 * try a smaller size.  We need to be able to read at least
+	 * a log sector, or we're out of luck.
+	 */
 	bufblks = 1 << ffs(nbblks);
-
 	while (!(bp = xlog_get_bp(log, bufblks))) {
-		/* can't get enough memory to do everything in one big buffer */
 		bufblks >>= 1;
-		if (bufblks <= log->l_sectbb_log)
+		if (bufblks < MAX(log->l_sectBBsize, 1))
 			return ENOMEM;
 	}
 
@@ -181,10 +236,10 @@ xlog_find_verify_cycle(
 
 		bcount = min(bufblks, (start_blk + nbblks - i));
 
-		if ((error = xlog_bread(log, i, bcount, bp)))
+		error = xlog_bread(log, i, bcount, bp, &buf);
+		if (error)
 			goto out;
 
-		buf = xlog_align(log, i, bcount, bp);
 		for (j = 0; j < bcount; j++) {
 			cycle = xlog_get_cycle(buf);
 			if (cycle == stop_on_cycle_no) {
@@ -238,9 +293,9 @@ xlog_find_verify_log_record(
 			return ENOMEM;
 		smallmem = 1;
 	} else {
-		if ((error = xlog_bread(log, start_blk, num_blks, bp)))
+		error = xlog_bread(log, start_blk, num_blks, bp, &offset);
+		if (error)
 			goto out;
-		offset = xlog_align(log, start_blk, num_blks, bp);
 		offset += ((num_blks - 1) << BBSHIFT);
 	}
 
@@ -255,9 +310,9 @@ xlog_find_verify_log_record(
 		}
 
 		if (smallmem) {
-			if ((error = xlog_bread(log, i, 1, bp)))
+			error = xlog_bread(log, i, 1, bp, &offset);
+			if (error)
 				goto out;
-			offset = xlog_align(log, i, 1, bp);
 		}
 
 		head = (xlog_rec_header_t *)offset;
@@ -325,7 +380,7 @@ out:
  *
  * Return: zero if normal, non-zero if error.
  */
-int
+STATIC int
 xlog_find_head(
 	xlog_t 		*log,
 	xfs_daddr_t	*return_head_blk)
@@ -337,14 +392,13 @@ xlog_find_head(
 	uint		first_half_cycle, last_half_cycle;
 	uint		stop_on_cycle;
 	int		error, log_bbnum = log->l_logBBsize;
-	extern int	platform_has_uuid;
 
 	/* Is the end of the log device zeroed? */
 	if ((error = xlog_find_zeroed(log, &first_blk)) == -1) {
 		*return_head_blk = first_blk;
 
 		/* Is the whole lot zeroed? */
-		if (!first_blk && platform_has_uuid) {
+		if (!first_blk) {
 			/* Linux XFS shouldn't generate totally zeroed logs -
 			 * mkfs etc write a dummy unmount record to a fresh
 			 * log so we can store the uuid in there
@@ -362,15 +416,18 @@ xlog_find_head(
 	bp = xlog_get_bp(log, 1);
 	if (!bp)
 		return ENOMEM;
-	if ((error = xlog_bread(log, 0, 1, bp)))
+
+	error = xlog_bread(log, 0, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, 0, 1, bp);
+
 	first_half_cycle = xlog_get_cycle(offset);
 
 	last_blk = head_blk = log_bbnum - 1;	/* get cycle # of last block */
-	if ((error = xlog_bread(log, last_blk, 1, bp)))
+	error = xlog_bread(log, last_blk, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, last_blk, 1, bp);
+
 	last_half_cycle = xlog_get_cycle(offset);
 	ASSERT(last_half_cycle != 0);
 
@@ -418,7 +475,7 @@ xlog_find_head(
 		 * In this case we want to find the first block with cycle
 		 * number matching last_half_cycle.  We expect the log to be
 		 * some variation on
-		 *        x + 1 ... | x ...
+		 *        x + 1 ... | x ... | x
 		 * The first block with cycle number x (last_half_cycle) will
 		 * be where the new head belongs.  First we do a binary search
 		 * for the first occurrence of last_half_cycle.  The binary
@@ -428,11 +485,13 @@ xlog_find_head(
 		 * the log, then we look for occurrences of last_half_cycle - 1
 		 * at the end of the log.  The cases we're looking for look
 		 * like
-		 *        x + 1 ... | x | x + 1 | x ...
-		 *                               ^ binary search stopped here
+		 *                               v binary search stopped here
+		 *        x + 1 ... | x | x + 1 | x ... | x
+		 *                   ^ but we want to locate this spot
 		 * or
-		 *        x + 1 ... | x ... | x - 1 | x
 		 *        <---------> less than scan distance
+		 *        x + 1 ... | x ... | x - 1 | x
+		 *                           ^ we want to locate this spot
 		 */
 		stop_on_cycle = last_half_cycle;
 		if ((error = xlog_find_cycle_start(log, bp, first_blk,
@@ -488,16 +547,16 @@ xlog_find_head(
 		 * certainly not the head of the log.  By searching for
 		 * last_half_cycle-1 we accomplish that.
 		 */
-		start_blk = log_bbnum - num_scan_bblks + head_blk;
 		ASSERT(head_blk <= INT_MAX &&
-			(xfs_daddr_t) num_scan_bblks - head_blk >= 0);
+			(xfs_daddr_t) num_scan_bblks >= head_blk);
+		start_blk = log_bbnum - (num_scan_bblks - head_blk);
 		if ((error = xlog_find_verify_cycle(log, start_blk,
 					num_scan_bblks - (int)head_blk,
 					(stop_on_cycle - 1), &new_blk)))
 			goto bp_err;
 		if (new_blk != -1) {
 			head_blk = new_blk;
-			goto bad_blk;
+			goto validate_head;
 		}
 
 		/*
@@ -515,7 +574,7 @@ xlog_find_head(
 			head_blk = new_blk;
 	}
 
- bad_blk:
+validate_head:
 	/*
 	 * Now we need to make sure head_blk is not pointing to a block in
 	 * the middle of a log record.
@@ -537,7 +596,7 @@ xlog_find_head(
 		if ((error = xlog_find_verify_log_record(log, start_blk,
 							&head_blk, 0)) == -1) {
 			/* We hit the beginning of the log during our search */
-			start_blk = log_bbnum - num_scan_bblks + head_blk;
+			start_blk = log_bbnum - (num_scan_bblks - head_blk);
 			new_blk = log_bbnum;
 			ASSERT(start_blk <= INT_MAX &&
 				(xfs_daddr_t) log_bbnum-start_blk >= 0);
@@ -620,13 +679,14 @@ xlog_find_tail(
 	if (!bp)
 		return ENOMEM;
 	if (*head_blk == 0) {				/* special case */
-		if ((error = xlog_bread(log, 0, 1, bp)))
-			goto bread_err;
-		offset = xlog_align(log, 0, 1, bp);
+		error = xlog_bread(log, 0, 1, bp, &offset);
+		if (error)
+			goto done;
+
 		if (xlog_get_cycle(offset) == 0) {
 			*tail_blk = 0;
 			/* leave all other log inited values alone */
-			goto exit;
+			goto done;
 		}
 	}
 
@@ -635,9 +695,10 @@ xlog_find_tail(
 	 */
 	ASSERT(*head_blk < INT_MAX);
 	for (i = (int)(*head_blk) - 1; i >= 0; i--) {
-		if ((error = xlog_bread(log, i, 1, bp)))
-			goto bread_err;
-		offset = xlog_align(log, i, 1, bp);
+		error = xlog_bread(log, i, 1, bp, &offset);
+		if (error)
+			goto done;
+
 		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(*(__be32 *)offset)) {
 			found = 1;
 			break;
@@ -651,9 +712,10 @@ xlog_find_tail(
 	 */
 	if (!found) {
 		for (i = log->l_logBBsize - 1; i >= (int)(*head_blk); i--) {
-			if ((error = xlog_bread(log, i, 1, bp)))
-				goto bread_err;
-			offset = xlog_align(log, i, 1, bp);
+			error = xlog_bread(log, i, 1, bp, &offset);
+			if (error)
+				goto done;
+
 			if (XLOG_HEADER_MAGIC_NUM ==
 			    be32_to_cpu(*(__be32 *)offset)) {
 				found = 2;
@@ -686,12 +748,12 @@ xlog_find_tail(
 	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
 	if (found == 2)
 		log->l_curr_cycle++;
-	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
-	log->l_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
-	log->l_grant_reserve_cycle = log->l_curr_cycle;
-	log->l_grant_reserve_bytes = BBTOB(log->l_curr_block);
-	log->l_grant_write_cycle = log->l_curr_cycle;
-	log->l_grant_write_bytes = BBTOB(log->l_curr_block);
+	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
+	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
+	xlog_assign_grant_head(&log->l_grant_reserve_head, log->l_curr_cycle,
+					BBTOB(log->l_curr_block));
+	xlog_assign_grant_head(&log->l_grant_write_head, log->l_curr_cycle,
+					BBTOB(log->l_curr_block));
 
 	/*
 	 * Look for unmount record.  If we find it, then we know there
@@ -721,14 +783,14 @@ xlog_find_tail(
 	}
 	after_umount_blk = (i + hblks + (int)
 		BTOBB(be32_to_cpu(rhead->h_len))) % log->l_logBBsize;
-	tail_lsn = log->l_tail_lsn;
+	tail_lsn = atomic64_read(&log->l_tail_lsn);
 	if (*head_blk == after_umount_blk &&
 	    be32_to_cpu(rhead->h_num_logops) == 1) {
 		umount_data_blk = (i + hblks) % log->l_logBBsize;
-		if ((error = xlog_bread(log, umount_data_blk, 1, bp))) {
-			goto bread_err;
-		}
-		offset = xlog_align(log, umount_data_blk, 1, bp);
+		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
+		if (error)
+			goto done;
+
 		op_head = (xlog_op_header_t *)offset;
 		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
 			/*
@@ -736,12 +798,10 @@ xlog_find_tail(
 			 * log records will point recovery to after the
 			 * current unmount record.
 			 */
-			log->l_tail_lsn =
-				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
-			log->l_last_sync_lsn =
-				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
+			xlog_assign_atomic_lsn(&log->l_tail_lsn,
+					log->l_curr_cycle, after_umount_blk);
+			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
+					log->l_curr_cycle, after_umount_blk);
 			*tail_blk = after_umount_blk;
 
 			/*
@@ -773,12 +833,10 @@ xlog_find_tail(
 	 * But... if the -device- itself is readonly, just skip this.
 	 * We can't recover this device anyway, so it won't matter.
 	 */
-	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp))
 		error = xlog_clear_stale_blocks(log, tail_lsn);
-	}
 
-bread_err:
-exit:
+done:
 	xlog_put_bp(bp);
 
 	if (error)
@@ -820,9 +878,10 @@ xlog_find_zeroed(
 	bp = xlog_get_bp(log, 1);
 	if (!bp)
 		return ENOMEM;
-	if ((error = xlog_bread(log, 0, 1, bp)))
+	error = xlog_bread(log, 0, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, 0, 1, bp);
+
 	first_cycle = xlog_get_cycle(offset);
 	if (first_cycle == 0) {		/* completely zeroed log */
 		*blk_no = 0;
@@ -831,9 +890,10 @@ xlog_find_zeroed(
 	}
 
 	/* check partially zeroed log */
-	if ((error = xlog_bread(log, log_bbnum-1, 1, bp)))
+	error = xlog_bread(log, log_bbnum-1, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, log_bbnum-1, 1, bp);
+
 	last_cycle = xlog_get_cycle(offset);
 	if (last_cycle != 0) {		/* log completely written to */
 		xlog_put_bp(bp);
@@ -899,40 +959,50 @@ bp_err:
 
 STATIC xlog_recover_t *
 xlog_recover_find_tid(
-	xlog_recover_t		*q,
+	struct hlist_head	*head,
 	xlog_tid_t		tid)
 {
-	xlog_recover_t		*p = q;
+	xlog_recover_t		*trans;
+	struct hlist_node	*n;
 
-	while (p != NULL) {
-		if (p->r_log_tid == tid)
-		    break;
-		p = p->r_next;
+	hlist_for_each_entry(trans, n, head, r_list) {
+		if (trans->r_log_tid == tid)
+			return trans;
 	}
-	return p;
+	return NULL;
 }
 
 STATIC void
-xlog_recover_put_hashq(
-	xlog_recover_t		**q,
-	xlog_recover_t		*trans)
+xlog_recover_new_tid(
+	struct hlist_head	*head,
+	xlog_tid_t		tid,
+	xfs_lsn_t		lsn)
 {
-	trans->r_next = *q;
-	*q = trans;
+	xlog_recover_t		*trans;
+
+	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
+	trans->r_log_tid   = tid;
+	trans->r_lsn	   = lsn;
+	INIT_LIST_HEAD(&trans->r_itemq);
+
+	INIT_HLIST_NODE(&trans->r_list);
+	hlist_add_head(&trans->r_list, head);
 }
 
 STATIC void
 xlog_recover_add_item(
-	xlog_recover_item_t	**itemq)
+	struct list_head	*head)
 {
 	xlog_recover_item_t	*item;
 
 	item = kmem_zalloc(sizeof(xlog_recover_item_t), KM_SLEEP);
-	xlog_recover_insert_item_backq(itemq, item);
+	INIT_LIST_HEAD(&item->ri_list);
+	list_add_tail(&item->ri_list, head);
 }
 
 STATIC int
 xlog_recover_add_to_cont_trans(
+	struct log		*log,
 	xlog_recover_t		*trans,
 	xfs_caddr_t		dp,
 	int			len)
@@ -941,8 +1011,7 @@ xlog_recover_add_to_cont_trans(
 	xfs_caddr_t		ptr, old_ptr;
 	int			old_len;
 
-	item = trans->r_itemq;
-	if (item == NULL) {
+	if (list_empty(&trans->r_itemq)) {
 		/* finish copying rest of trans header */
 		xlog_recover_add_item(&trans->r_itemq);
 		ptr = (xfs_caddr_t) &trans->r_theader +
@@ -950,7 +1019,8 @@ xlog_recover_add_to_cont_trans(
 		memcpy(ptr, dp, len); /* d, s, l */
 		return 0;
 	}
-	item = item->ri_prev;
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
 
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
@@ -959,6 +1029,7 @@ xlog_recover_add_to_cont_trans(
 	memcpy(&ptr[old_len], dp, len); /* d, s, l */
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
+	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
 	return 0;
 }
 
@@ -977,6 +1048,7 @@ xlog_recover_add_to_cont_trans(
  */
 STATIC int
 xlog_recover_add_to_trans(
+	struct log		*log,
 	xlog_recover_t		*trans,
 	xfs_caddr_t		dp,
 	int			len)
@@ -987,9 +1059,14 @@ xlog_recover_add_to_trans(
 
 	if (!len)
 		return 0;
-	item = trans->r_itemq;
-	if (item == NULL) {
-		ASSERT(*(uint *)dp == XFS_TRANS_HEADER_MAGIC);
+	if (list_empty(&trans->r_itemq)) {
+		/* we need to catch log corruptions here */
+		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
+			xlog_warn("XFS: xlog_recover_add_to_trans: "
+				  "bad header magic number");
+			ASSERT(0);
+			return XFS_ERROR(EIO);
+		}
 		if (len == sizeof(xfs_trans_header_t))
 			xlog_recover_add_item(&trans->r_itemq);
 		memcpy(&trans->r_theader, dp, len); /* d, s, l */
@@ -1000,88 +1077,40 @@ xlog_recover_add_to_trans(
 	memcpy(ptr, dp, len);
 	in_f = (xfs_inode_log_format_t *)ptr;
 
-	if (item->ri_prev->ri_total != 0 &&
-	     item->ri_prev->ri_total == item->ri_prev->ri_cnt) {
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
+	if (item->ri_total != 0 &&
+	     item->ri_total == item->ri_cnt) {
+		/* tail item is in use, get a new one */
 		xlog_recover_add_item(&trans->r_itemq);
+		item = list_entry(trans->r_itemq.prev,
+					xlog_recover_item_t, ri_list);
 	}
-	item = trans->r_itemq;
-	item = item->ri_prev;
 
 	if (item->ri_total == 0) {		/* first region to be added */
-		item->ri_total	= in_f->ilf_size;
-		ASSERT(item->ri_total <= XLOG_MAX_REGIONS_IN_ITEM);
-		item->ri_buf = kmem_zalloc((item->ri_total *
-					    sizeof(xfs_log_iovec_t)), KM_SLEEP);
+		if (in_f->ilf_size == 0 ||
+		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
+			xlog_warn(
+	"XFS: bad number of regions (%d) in inode log format",
+				  in_f->ilf_size);
+			ASSERT(0);
+			return XFS_ERROR(EIO);
+		}
+
+		item->ri_total = in_f->ilf_size;
+		item->ri_buf =
+			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
+				    KM_SLEEP);
 	}
 	ASSERT(item->ri_total > item->ri_cnt);
 	/* Description region is ri_buf[0] */
 	item->ri_buf[item->ri_cnt].i_addr = ptr;
 	item->ri_buf[item->ri_cnt].i_len  = len;
 	item->ri_cnt++;
+	trace_xfs_log_recover_item_add(log, trans, item, 0);
 	return 0;
 }
 
-STATIC void
-xlog_recover_new_tid(
-	xlog_recover_t		**q,
-	xlog_tid_t		tid,
-	xfs_lsn_t		lsn)
-{
-	xlog_recover_t		*trans;
-
-	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
-	trans->r_log_tid   = tid;
-	trans->r_lsn	   = lsn;
-	xlog_recover_put_hashq(q, trans);
-}
-
-STATIC int
-xlog_recover_unlink_tid(
-	xlog_recover_t		**q,
-	xlog_recover_t		*trans)
-{
-	xlog_recover_t		*tp;
-	int			found = 0;
-
-	ASSERT(trans != NULL);
-	if (trans == *q) {
-		*q = (*q)->r_next;
-	} else {
-		tp = *q;
-		while (tp) {
-			if (tp->r_next == trans) {
-				found = 1;
-				break;
-			}
-			tp = tp->r_next;
-		}
-		if (!found) {
-			xlog_warn(
-			     "XFS: xlog_recover_unlink_tid: trans not found");
-			ASSERT(0);
-			return XFS_ERROR(EIO);
-		}
-		tp->r_next = tp->r_next->r_next;
-	}
-	return 0;
-}
-
-STATIC void
-xlog_recover_insert_item_backq(
-	xlog_recover_item_t	**q,
-	xlog_recover_item_t	*item)
-{
-	if (*q == NULL) {
-		item->ri_prev = item->ri_next = item;
-		*q = item;
-	} else {
-		item->ri_next		= *q;
-		item->ri_prev		= (*q)->ri_prev;
-		(*q)->ri_prev		= item;
-		item->ri_prev->ri_next	= item;
-	}
-}
-
 /*
  * Free up any resources allocated by the transaction
  *
@@ -1089,41 +1118,43 @@ xlog_recover_insert_item_backq(
  */
 STATIC void
 xlog_recover_free_trans(
-	xlog_recover_t		*trans)
+	struct xlog_recover	*trans)
 {
-	xlog_recover_item_t	*first_item, *item, *free_item;
+	xlog_recover_item_t	*item, *n;
 	int			i;
 
-	item = first_item = trans->r_itemq;
-	do {
-		free_item = item;
-		item = item->ri_next;
-		 /* Free the regions in the item. */
-		for (i = 0; i < free_item->ri_cnt; i++) {
-			kmem_free(free_item->ri_buf[i].i_addr);
-		}
+	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
+		/* Free the regions in the item. */
+		list_del(&item->ri_list);
+		for (i = 0; i < item->ri_cnt; i++)
+			kmem_free(item->ri_buf[i].i_addr);
 		/* Free the item itself */
-		kmem_free(free_item->ri_buf);
-		kmem_free(free_item);
-	} while (first_item != item);
+		kmem_free(item->ri_buf);
+		kmem_free(item);
+	}
 	/* Free the transaction recover structure */
 	kmem_free(trans);
 }
 
+/*
+ * Perform the transaction.
+ *
+ * If the transaction modifies a buffer or inode, do it now.  Otherwise,
+ * EFIs and EFDs get queued up by adding entries into the AIL for them.
+ */
 STATIC int
 xlog_recover_commit_trans(
-	xlog_t			*log,
-	xlog_recover_t		**q,
-	xlog_recover_t		*trans,
+	struct log		*log,
+	struct xlog_recover	*trans,
 	int			pass)
 {
-	int			error;
+	int			error = 0;
 
-	if ((error = xlog_recover_unlink_tid(q, trans)))
-		return error;
+	hlist_del(&trans->r_list);
 	if ((error = xlog_recover_do_trans(log, trans, pass)))
 		return error;
-	xlog_recover_free_trans(trans);			/* no error */
+
+	xlog_recover_free_trans(trans);
 	return 0;
 }
 
@@ -1148,7 +1179,7 @@ xlog_recover_unmount_trans(
 STATIC int
 xlog_recover_process_data(
 	xlog_t			*log,
-	xlog_recover_t		*rhash[],
+	struct hlist_head	rhash[],
 	xlog_rec_header_t	*rhead,
 	xfs_caddr_t		dp,
 	int			pass)
@@ -1182,27 +1213,32 @@ xlog_recover_process_data(
 		}
 		tid = be32_to_cpu(ohead->oh_tid);
 		hash = XLOG_RHASH(tid);
-		trans = xlog_recover_find_tid(rhash[hash], tid);
+		trans = xlog_recover_find_tid(&rhash[hash], tid);
 		if (trans == NULL) {		   /* not found; add new tid */
 			if (ohead->oh_flags & XLOG_START_TRANS)
 				xlog_recover_new_tid(&rhash[hash], tid,
 					be64_to_cpu(rhead->h_lsn));
 		} else {
-			ASSERT(dp + be32_to_cpu(ohead->oh_len) <= lp);
+			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
+				xlog_warn(
+			"XFS: xlog_recover_process_data: bad length");
+				return (XFS_ERROR(EIO));
+			}
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
 			if (flags & XLOG_WAS_CONT_TRANS)
 				flags &= ~XLOG_CONTINUE_TRANS;
 			switch (flags) {
 			case XLOG_COMMIT_TRANS:
 				error = xlog_recover_commit_trans(log,
-						&rhash[hash], trans, pass);
+								trans, pass);
 				break;
 			case XLOG_UNMOUNT_TRANS:
 				error = xlog_recover_unmount_trans(trans);
 				break;
 			case XLOG_WAS_CONT_TRANS:
-				error = xlog_recover_add_to_cont_trans(trans,
-						dp, be32_to_cpu(ohead->oh_len));
+				error = xlog_recover_add_to_cont_trans(log,
+						trans, dp,
+						be32_to_cpu(ohead->oh_len));
 				break;
 			case XLOG_START_TRANS:
 				xlog_warn(
@@ -1212,7 +1248,7 @@ xlog_recover_process_data(
 				break;
 			case 0:
 			case XLOG_CONTINUE_TRANS:
-				error = xlog_recover_add_to_trans(trans,
+				error = xlog_recover_add_to_trans(log, trans,
 						dp, be32_to_cpu(ohead->oh_len));
 				break;
 			default:
@@ -1238,7 +1274,6 @@ xlog_unpack_data(
 	xlog_t			*log)
 {
 	int			i, j, k;
-	xlog_in_core_2_t	*xhdr;
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
@@ -1247,7 +1282,7 @@ xlog_unpack_data(
 	}
 
 	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		xhdr = (xlog_in_core_2_t *)rhead;
+		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -1255,8 +1290,6 @@ xlog_unpack_data(
 			dp += BBSIZE;
 		}
 	}
-
-	xlog_unpack_data_checksum(rhead, dp, log);
 }
 
 STATIC int
@@ -1312,12 +1345,12 @@ xlog_do_recovery_pass(
 {
 	xlog_rec_header_t	*rhead;
 	xfs_daddr_t		blk_no;
-	xfs_caddr_t		bufaddr, offset;
+	xfs_caddr_t		offset;
 	xfs_buf_t		*hbp, *dbp;
 	int			error = 0, h_size;
 	int			bblks, split_bblks;
 	int			hblks, split_hblks, wrapped_hblks;
-	xlog_recover_t		*rhash[XLOG_RHASH_SIZE];
+	struct hlist_head	rhash[XLOG_RHASH_SIZE];
 
 	ASSERT(head_blk != tail_blk);
 
@@ -1334,9 +1367,11 @@ xlog_do_recovery_pass(
 		hbp = xlog_get_bp(log, 1);
 		if (!hbp)
 			return ENOMEM;
-		if ((error = xlog_bread(log, tail_blk, 1, hbp)))
+
+		error = xlog_bread(log, tail_blk, 1, hbp, &offset);
+		if (error)
 			goto bread_err1;
-		offset = xlog_align(log, tail_blk, 1, hbp);
+
 		rhead = (xlog_rec_header_t *)offset;
 		error = xlog_valid_rec_header(log, rhead, tail_blk);
 		if (error)
@@ -1353,7 +1388,7 @@ xlog_do_recovery_pass(
 			hblks = 1;
 		}
 	} else {
-		ASSERT(log->l_sectbb_log == 0);
+		ASSERT(log->l_sectBBsize == 1);
 		hblks = 1;
 		hbp = xlog_get_bp(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
@@ -1370,9 +1405,10 @@ xlog_do_recovery_pass(
 	memset(rhash, 0, sizeof(rhash));
 	if (tail_blk <= head_blk) {
 		for (blk_no = tail_blk; blk_no < head_blk; ) {
-			if ((error = xlog_bread(log, blk_no, hblks, hbp)))
+			error = xlog_bread(log, blk_no, hblks, hbp, &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no, hblks, hbp);
+
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
@@ -1380,10 +1416,11 @@ xlog_do_recovery_pass(
 
 			/* blocks in data section */
 			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
-			error = xlog_bread(log, blk_no + hblks, bblks, dbp);
+			error = xlog_bread(log, blk_no + hblks, bblks, dbp,
+					   &offset);
 			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no + hblks, bblks, dbp);
+
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log,
 						rhash, rhead, offset, pass)))
@@ -1401,15 +1438,15 @@ xlog_do_recovery_pass(
 			/*
 			 * Check for header wrapping around physical end-of-log
 			 */
-			offset = NULL;
+			offset = XFS_BUF_PTR(hbp);
 			split_hblks = 0;
 			wrapped_hblks = 0;
 			if (blk_no + hblks <= log->l_logBBsize) {
 				/* Read header in one read */
-				error = xlog_bread(log, blk_no, hblks, hbp);
+				error = xlog_bread(log, blk_no, hblks, hbp,
+						   &offset);
 				if (error)
 					goto bread_err2;
-				offset = xlog_align(log, blk_no, hblks, hbp);
 			} else {
 				/* This LR is split across physical log end */
 				if (blk_no != log->l_logBBsize) {
@@ -1417,12 +1454,13 @@ xlog_do_recovery_pass(
 					ASSERT(blk_no <= INT_MAX);
 					split_hblks = log->l_logBBsize - (int)blk_no;
 					ASSERT(split_hblks > 0);
-					if ((error = xlog_bread(log, blk_no,
-							split_hblks, hbp)))
+					error = xlog_bread(log, blk_no,
+							   split_hblks, hbp,
+							   &offset);
+					if (error)
 						goto bread_err2;
-					offset = xlog_align(log, blk_no,
-							split_hblks, hbp);
 				}
+
 				/*
 				 * Note: this black magic still works with
 				 * large sector sizes (non-512) only because:
@@ -1436,17 +1474,21 @@ xlog_do_recovery_pass(
 				 *   - order is important.
 				 */
 				wrapped_hblks = hblks - split_hblks;
-				bufaddr = XFS_BUF_PTR(hbp);
-				XFS_BUF_SET_PTR(hbp,
-						bufaddr + BBTOB(split_hblks),
+				error = XFS_BUF_SET_PTR(hbp,
+						offset + BBTOB(split_hblks),
 						BBTOB(hblks - split_hblks));
-				error = xlog_bread(log, 0, wrapped_hblks, hbp);
 				if (error)
 					goto bread_err2;
-				XFS_BUF_SET_PTR(hbp, bufaddr, BBTOB(hblks));
-				if (!offset)
-					offset = xlog_align(log, 0,
-							wrapped_hblks, hbp);
+
+				error = xlog_bread_noalign(log, 0,
+							   wrapped_hblks, hbp);
+				if (error)
+					goto bread_err2;
+
+				error = XFS_BUF_SET_PTR(hbp, offset,
+							BBTOB(hblks));
+				if (error)
+					goto bread_err2;
 			}
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead,
@@ -1459,14 +1501,14 @@ xlog_do_recovery_pass(
 
 			/* Read in data for log record */
 			if (blk_no + bblks <= log->l_logBBsize) {
-				error = xlog_bread(log, blk_no, bblks, dbp);
+				error = xlog_bread(log, blk_no, bblks, dbp,
+						   &offset);
 				if (error)
 					goto bread_err2;
-				offset = xlog_align(log, blk_no, bblks, dbp);
 			} else {
 				/* This log record is split across the
 				 * physical end of log */
-				offset = NULL;
+				offset = XFS_BUF_PTR(dbp);
 				split_bblks = 0;
 				if (blk_no != log->l_logBBsize) {
 					/* some data is before the physical
@@ -1476,12 +1518,13 @@ xlog_do_recovery_pass(
 					split_bblks =
 						log->l_logBBsize - (int)blk_no;
 					ASSERT(split_bblks > 0);
-					if ((error = xlog_bread(log, blk_no,
-							split_bblks, dbp)))
+					error = xlog_bread(log, blk_no,
+							split_bblks, dbp,
+							&offset);
+					if (error)
 						goto bread_err2;
-					offset = xlog_align(log, blk_no,
-							split_bblks, dbp);
 				}
+
 				/*
 				 * Note: this black magic still works with
 				 * large sector sizes (non-512) only because:
@@ -1494,18 +1537,21 @@ xlog_do_recovery_pass(
 				 *   _first_, then the log start (LR header end)
 				 *   - order is important.
 				 */
-				bufaddr = XFS_BUF_PTR(dbp);
-				XFS_BUF_SET_PTR(dbp,
-						bufaddr + BBTOB(split_bblks),
+				error = XFS_BUF_SET_PTR(dbp,
+						offset + BBTOB(split_bblks),
 						BBTOB(bblks - split_bblks));
-				error = xlog_bread(log, wrapped_hblks,
-						bblks - split_bblks, dbp);
 				if (error)
 					goto bread_err2;
-				XFS_BUF_SET_PTR(dbp, bufaddr, h_size);
-				if (!offset)
-					offset = xlog_align(log, wrapped_hblks,
-						bblks - split_bblks, dbp);
+
+				error = xlog_bread_noalign(log, wrapped_hblks,
+						bblks - split_bblks,
+						dbp);
+				if (error)
+					goto bread_err2;
+
+				error = XFS_BUF_SET_PTR(dbp, offset, h_size);
+				if (error)
+					goto bread_err2;
 			}
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log, rhash,
@@ -1519,17 +1565,21 @@ xlog_do_recovery_pass(
 
 		/* read first part of physical log */
 		while (blk_no < head_blk) {
-			if ((error = xlog_bread(log, blk_no, hblks, hbp)))
+			error = xlog_bread(log, blk_no, hblks, hbp, &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no, hblks, hbp);
+
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
 				goto bread_err2;
+
 			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
-			if ((error = xlog_bread(log, blk_no+hblks, bblks, dbp)))
+			error = xlog_bread(log, blk_no+hblks, bblks, dbp,
+					   &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no+hblks, bblks, dbp);
+
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log, rhash,
 							rhead, offset, pass)))
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 253e146..707a93b 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -642,7 +642,7 @@ xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops)
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
     xlog_print_trans_inode_core(&dino);
-    *ptr += sizeof(xfs_dinode_core_t);
+    *ptr += sizeof(xfs_icdinode_t);
 
     if (*i == num_ops-1 && f->ilf_size == 3)  {
 	return 1;
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 7bd4617..62727bf 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -36,10 +36,10 @@ xlog_print_find_oldest(
 
 	first_blk = 0;		/* read first block */
 	bp = xlog_get_bp(log, 1);
-	xlog_bread(log, 0, 1, bp);
+	xlog_bread_noalign(log, 0, 1, bp);
 	first_half_cycle = xlog_get_cycle(XFS_BUF_PTR(bp));
 	*last_blk = log->l_logBBsize-1;	/* read last block */
-	xlog_bread(log, *last_blk, 1, bp);
+	xlog_bread_noalign(log, *last_blk, 1, bp);
 	last_half_cycle = xlog_get_cycle(XFS_BUF_PTR(bp));
 	ASSERT(last_half_cycle != 0);
 
@@ -486,19 +486,16 @@ xlog_recover_print_item(
 void
 xlog_recover_print_trans(
 	xlog_recover_t		*trans,
-	xlog_recover_item_t	*itemq,
+	struct list_head	*itemq,
 	int			print)
 {
-	xlog_recover_item_t	*first_item, *item;
+	xlog_recover_item_t	*item;
 
 	if (print < 3)
 		return;
 
 	print_xlog_record_line();
 	xlog_recover_print_trans_head(trans);
-	item = first_item = itemq;
-	do {
+	list_for_each_entry(item, itemq, ri_list)
 		xlog_recover_print_item(item);
-		item = item->ri_next;
-	} while (first_item != item);
 }
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 8b21257..7405772 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -25,7 +25,7 @@ xlog_recover_print_trans_head(
 	printf(_("TRANS: tid:0x%x  type:%s  #items:%d  trans:0x%x  q:0x%lx\n"),
 	       tr->r_log_tid, trans_type[tr->r_theader.th_type],
 	       tr->r_theader.th_num_items,
-	       tr->r_theader.th_tid, (long)tr->r_itemq);
+	       tr->r_theader.th_tid, (long)&tr->r_itemq);
 }
 
 int
@@ -34,7 +34,7 @@ xlog_recover_do_trans(
 	xlog_recover_t	*trans,
 	int		pass)
 {
-	xlog_recover_print_trans(trans, trans->r_itemq, 3);
+	xlog_recover_print_trans(trans, &trans->r_itemq, 3);
 	return 0;
 }
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 3723685..3021028 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -39,7 +39,7 @@ static long filesize(int fd);
  * (basically no fragmentation).
  */
 #define	MKFS_BLOCKRES_INODE	\
-	((uint)(XFS_IALLOC_BLOCKS(mp) + (XFS_IN_MAXLEVELS(mp) - 1)))
+	((uint)(XFS_IALLOC_BLOCKS(mp) + ((mp)->m_in_maxlevels - 1)))
 #define	MKFS_BLOCKRES(rb)	\
 	((uint)(MKFS_BLOCKRES_INODE + XFS_DA_NODE_MAXDEPTH + \
 	(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1) + (rb)))
@@ -201,7 +201,7 @@ rsvfile(
 	if (ip->i_d.di_mode & S_IXGRP)
 		ip->i_d.di_mode &= ~S_ISGID;
 
-	libxfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	libxfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 	ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
 
@@ -244,7 +244,7 @@ newfile(
 		nb = XFS_B_TO_FSB(mp, len);
 		nmap = 1;
 		error = libxfs_bmapi(tp, ip, 0, nb, XFS_BMAPI_WRITE, first, nb,
-				&map, &nmap, flist, NULL);
+				&map, &nmap, flist);
 		if (error) {
 			fail(_("error allocating space for a file"), error);
 		}
@@ -436,7 +436,7 @@ parseproto(
 	xname.len = name ? strlen(name) : 0;
 	tp = libxfs_trans_alloc(mp, 0);
 	flags = XFS_ILOG_CORE;
-	XFS_BMAP_INIT(&flist, &first);
+	xfs_bmap_init(&flist, &first);
 	switch (fmt) {
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
@@ -664,13 +664,13 @@ rtinit(
 	libxfs_trans_ijoin(tp, rbmip, 0);
 	libxfs_trans_ihold(tp, rbmip);
 	bno = 0;
-	XFS_BMAP_INIT(&flist, &first);
+	xfs_bmap_init(&flist, &first);
 	while (bno < mp->m_sb.sb_rbmblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = libxfs_bmapi(tp, rbmip, bno,
 				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
 				XFS_BMAPI_WRITE, &first, mp->m_sb.sb_rbmblocks,
-				map, &nmap, &flist, NULL);
+				map, &nmap, &flist);
 		if (error) {
 			fail(_("Allocation of the realtime bitmap failed"),
 				error);
@@ -701,13 +701,13 @@ rtinit(
 	libxfs_trans_ijoin(tp, rsumip, 0);
 	libxfs_trans_ihold(tp, rsumip);
 	bno = 0;
-	XFS_BMAP_INIT(&flist, &first);
+	xfs_bmap_init(&flist, &first);
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = libxfs_bmapi(tp, rsumip, bno,
 				(xfs_extlen_t)(nsumblocks - bno),
 				XFS_BMAPI_WRITE, &first, nsumblocks,
-				map, &nmap, &flist, NULL);
+				map, &nmap, &flist);
 		if (error) {
 			fail(_("Allocation of the realtime summary failed"),
 				error);
@@ -733,7 +733,7 @@ rtinit(
 		tp = libxfs_trans_alloc(mp, 0);
 		if ((i = libxfs_trans_reserve(tp, 0, 0, 0, 0, 0)))
 			res_failed(i);
-		XFS_BMAP_INIT(&flist, &first);
+		xfs_bmap_init(&flist, &first);
 		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
 			bno + NBBY * mp->m_sb.sb_blocksize);
 		error = libxfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5b3b9a7..1e4e966 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2611,10 +2611,11 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		args.mp = mp;
 		args.agno = agno;
 		args.alignment = 1;
-		args.pag = &mp->m_perag[agno];
+		args.pag = xfs_perag_get(mp,agno);
 		if ((c = libxfs_trans_reserve(tp, worst_freelist, 0, 0, 0, 0)))
 			res_failed(c);
 		libxfs_alloc_fix_freelist(&args, 0);
+		xfs_perag_put(args.pag);
 		libxfs_trans_commit(tp, 0);
 	}
 
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index fb686fa..7672e13 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -388,7 +388,7 @@ process_leaf_attr_local(
 {
 	xfs_attr_leaf_name_local_t *local;
 
-	local = XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
+	local = xfs_attr_leaf_name_local(leaf, i);
 	if (local->namelen == 0 || namecheck((char *)&local->nameval[0], 
 							local->namelen)) {
 		do_warn(_("attribute entry %d in attr block %u, inode %llu "
@@ -423,7 +423,7 @@ process_leaf_attr_local(
 			return -1;
 		}
 	}
-	return XFS_ATTR_LEAF_ENTSIZE_LOCAL(local->namelen, 
+	return xfs_attr_leaf_entsize_local(local->namelen, 
 						be16_to_cpu(local->valuelen));
 }
 
@@ -441,7 +441,7 @@ process_leaf_attr_remote(
 	xfs_attr_leaf_name_remote_t *remotep;
 	char*			value;
 
-	remotep = XFS_ATTR_LEAF_NAME_REMOTE(leaf, i);
+	remotep = xfs_attr_leaf_name_remote(leaf, i);
 
 	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0], 
 						remotep->namelen) || 
@@ -479,7 +479,7 @@ process_leaf_attr_remote(
 	}
 	free(value);
 out:
-	return XFS_ATTR_LEAF_ENTSIZE_REMOTE(remotep->namelen);
+	return xfs_attr_leaf_entsize_remote(remotep->namelen);
 
 bad_free_out:
 	free(value);
@@ -840,8 +840,8 @@ process_longform_attr(
 	bno = blkmap_get(blkmap, 0);
 
 	if ( bno == NULLDFSBNO ) {
-		if (dip->di_core.di_aformat == XFS_DINODE_FMT_EXTENTS && 
-				be16_to_cpu(dip->di_core.di_anextents) == 0)
+		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS && 
+				be16_to_cpu(dip->di_anextents) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(_("block 0 of inode %llu attribute fork is missing\n"), 
 			ino);
@@ -958,7 +958,7 @@ process_attributes(
 	int		*repair)  /* returned if we did repair */
 {
 	int		err;
-	__u8		aformat = dip->di_core.di_aformat;
+	__u8		aformat = dip->di_aformat;
 	xfs_attr_shortform_t *asf;
 
 	asf = (xfs_attr_shortform_t *) XFS_DFORK_APTR(dip);
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 734e9a8..8735f92 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -62,7 +62,7 @@ check_aginode_block(xfs_mount_t	*mp,
 	}
 
 	for (i = 0; i < mp->m_sb.sb_inopblock; i++)  {
-		dino_p = XFS_MAKE_IPTR(mp, bp, i);
+		dino_p = xfs_make_iptr(mp, bp, i);
 		if (!verify_uncertain_dinode(mp, dino_p, agno,
 				XFS_OFFBNO_TO_AGINO(mp, agbno, i)))
 			cnt++;
@@ -674,7 +674,7 @@ process_inode_chunk(
 			/*
 			 * make inode pointer
 			 */
-			dino = XFS_MAKE_IPTR(mp, bplist[bp_index], cluster_offset);
+			dino = xfs_make_iptr(mp, bplist[bp_index], cluster_offset);
 			agino = irec_offset + ino_rec->ino_startnum;
 
 			/*
@@ -767,7 +767,7 @@ process_inode_chunk(
 		/*
 		 * make inode pointer
 		 */
-		dino = XFS_MAKE_IPTR(mp, bplist[bp_index], cluster_offset);
+		dino = xfs_make_iptr(mp, bplist[bp_index], cluster_offset);
 		agino = irec_offset + ino_rec->ino_startnum;
 
 		is_used = 3;
@@ -809,9 +809,9 @@ process_inode_chunk(
 			 * store on-disk nlink count for comparing in phase 7
 			 */
 			set_inode_disk_nlinks(ino_rec, irec_offset,
-				dino->di_core.di_version > XFS_DINODE_VERSION_1
-					? be32_to_cpu(dino->di_core.di_nlink)
-					: be16_to_cpu(dino->di_core.di_onlink));
+				dino->di_version > 1
+					? be32_to_cpu(dino->di_nlink)
+					: be16_to_cpu(dino->di_onlink));
 
 		} else  {
 			set_inode_free(ino_rec, irec_offset);
diff --git a/repair/dinode.c b/repair/dinode.c
index bf04c6e..2fa850d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -43,27 +43,27 @@
 int
 calc_attr_offset(xfs_mount_t *mp, xfs_dinode_t *dino)
 {
-	xfs_dinode_core_t	*dinoc = &dino->di_core;
-	int			offset = ((__psint_t) &dino->di_u)
-						- (__psint_t)dino;
+	int	offset = (__psint_t)XFS_DFORK_DPTR(dino) - (__psint_t)dino;
+	xfs_bmdr_block_t        *dfp;
 
 	/*
 	 * don't worry about alignment when calculating offset
 	 * because the data fork is already 8-byte aligned
 	 */
-	switch (dinoc->di_format)  {
+	switch (dino->di_format)  {
 	case XFS_DINODE_FMT_DEV:
 		offset += sizeof(xfs_dev_t);
 		break;
 	case XFS_DINODE_FMT_LOCAL:
-		offset += be64_to_cpu(dinoc->di_size);
+		offset += be64_to_cpu(dino->di_size);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		offset += be32_to_cpu(dinoc->di_nextents) * 
+		offset += be32_to_cpu(dino->di_nextents) *
 						sizeof(xfs_bmbt_rec_t);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		offset += be16_to_cpu(dino->di_u.di_bmbt.bb_numrecs) * 
+		dfp = (xfs_bmdr_block_t *)XFS_DFORK_DPTR(dino);
+		offset += be16_to_cpu(dfp->bb_numrecs) *
 						sizeof(xfs_bmbt_rec_t);
 		break;
 	default:
@@ -79,9 +79,7 @@ calc_attr_offset(xfs_mount_t *mp, xfs_dinode_t *dino)
 int
 clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 {
-	xfs_dinode_core_t *dinoc = &dino->di_core;
-
-	ASSERT(dinoc->di_forkoff != 0);
+	ASSERT(dino->di_forkoff != 0);
 
 	if (!no_modify)
 		fprintf(stderr, _("clearing inode %llu attributes\n"),
@@ -90,16 +88,16 @@ clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 		fprintf(stderr, _("would have cleared inode %llu attributes\n"),
 			(unsigned long long)ino_num);
 
-	if (be16_to_cpu(dinoc->di_anextents) != 0)  {
+	if (be16_to_cpu(dino->di_anextents) != 0)  {
 		if (no_modify)
 			return(1);
-		dinoc->di_anextents = cpu_to_be16(0);
+		dino->di_anextents = cpu_to_be16(0);
 	}
 
-	if (dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
+	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
 		if (no_modify)
 			return(1);
-		dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
+		dino->di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 
 	/* get rid of the fork by clearing forkoff */
@@ -118,7 +116,7 @@ clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 				XFS_DFORK_APTR(dino);
 		asf->hdr.totsize = cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
 		asf->hdr.count = 0;
-		dinoc->di_forkoff = 0;  /* got to do this after asf is set */
+		dino->di_forkoff = 0;  /* got to do this after asf is set */
 	}
 
 	/*
@@ -129,7 +127,7 @@ clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 
 /* ARGSUSED */
 int
-clear_dinode_core(xfs_dinode_core_t *dinoc, xfs_ino_t ino_num)
+clear_dinode_core(xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 {
 	int dirty = 0;
 
@@ -143,14 +141,13 @@ clear_dinode_core(xfs_dinode_core_t *dinoc, xfs_ino_t ino_num)
 	}
 
 	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
-	    (!fs_inode_nlink && dinoc->di_version > XFS_DINODE_VERSION_1))  {
+	    (!fs_inode_nlink && dinoc->di_version > 1))  {
 		dirty = 1;
 
 		if (no_modify)
 			return(1);
 
-		dinoc->di_version = (fs_inode_nlink) ? XFS_DINODE_VERSION_2
-						: XFS_DINODE_VERSION_1;
+		dinoc->di_version = (fs_inode_nlink) ? 2 : 1;
 	}
 
 	if (be16_to_cpu(dinoc->di_mode) != 0)  {
@@ -252,7 +249,7 @@ clear_dinode_core(xfs_dinode_core_t *dinoc, xfs_ino_t ino_num)
 		dinoc->di_anextents = 0;
 	}
 
-	if (dinoc->di_version > XFS_DINODE_VERSION_1 &&
+	if (dinoc->di_version > 1 &&
 			be32_to_cpu(dinoc->di_nlink) != 0)  {
 		dirty = 1;
 
@@ -289,13 +286,13 @@ clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 {
 	int dirty;
 
-	dirty = clear_dinode_core(&dino->di_core, ino_num);
+	dirty = clear_dinode_core(dino, ino_num);
 	dirty += clear_dinode_unlinked(mp, dino);
 
 	/* and clear the forks */
 
 	if (dirty && !no_modify)
-		memset(&dino->di_u, 0, XFS_LITINO(mp));
+		memset(XFS_DFORK_DPTR(dino), 0, XFS_LITINO(mp));
 
 	return(dirty);
 }
@@ -868,7 +865,7 @@ get_agino_buf(xfs_mount_t	 *mp,
 		return(NULL);
 	}
 
-	*dipp = XFS_MAKE_IPTR(mp, bp, agino -
+	*dipp = xfs_make_iptr(mp, bp, agino -
 		XFS_OFFBNO_TO_AGINO(mp, XFS_AGINO_TO_AGBNO(mp,
 						irec->ino_startnum),
 		0));
@@ -1347,11 +1344,11 @@ process_lclinode(
 	xfs_ino_t		lino;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_core.di_size) >
+	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_size) >
 						XFS_DFORK_DSIZE(dip, mp)) {
 		do_warn(
 	_("local inode %llu data fork is too large (size = %lld, max = %d)\n"),
-			lino, be64_to_cpu(dip->di_core.di_size),
+			lino, be64_to_cpu(dip->di_size),
 			XFS_DFORK_DSIZE(dip, mp));
 		return(1);
 	} else if (whichfork == XFS_ATTR_FORK) {
@@ -1385,23 +1382,23 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
 	int			i;
 	int			max_blocks;
 
-	if (be64_to_cpu(dino->di_core.di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
-		if (dino->di_core.di_format == XFS_DINODE_FMT_LOCAL)  
+	if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
+		if (dino->di_format == XFS_DINODE_FMT_LOCAL)  
 			return 0;
 		do_warn(_("mismatch between format (%d) and size (%lld) in "
-			"symlink ino %llu\n"), dino->di_core.di_format, 
-			be64_to_cpu(dino->di_core.di_size), lino);
+			"symlink ino %llu\n"), dino->di_format, 
+			be64_to_cpu(dino->di_size), lino);
 		return 1;
 	}
-	if (dino->di_core.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dino->di_format == XFS_DINODE_FMT_LOCAL) {
 		do_warn(_("mismatch between format (%d) and size (%lld) in "
-			"symlink inode %llu\n"), dino->di_core.di_format,
-			be64_to_cpu(dino->di_core.di_size), lino);
+			"symlink inode %llu\n"), dino->di_format,
+			be64_to_cpu(dino->di_size), lino);
 		return 1;
 	}
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = be32_to_cpu(dino->di_core.di_nextents);
+	numrecs = be32_to_cpu(dino->di_nextents);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1471,7 +1468,6 @@ process_symlink(
 	blkmap_t 	*blkmap)
 {
 	xfs_dfsbno_t		fsbno;
-	xfs_dinode_core_t	*dinoc = &dino->di_core;
 	xfs_buf_t		*bp = NULL;
 	char			*symlink, *cptr, *buf_data;
 	int			i, size, amountdone;
@@ -1483,9 +1479,9 @@ process_symlink(
 	 * the inode is structurally ok so we don't have to check
 	 * for that
 	 */
-	if (be64_to_cpu(dinoc->di_size) >= MAXPATHLEN)  {
+	if (be64_to_cpu(dino->di_size) >= MAXPATHLEN)  {
 		do_warn(_("symlink in inode %llu too long (%lld chars)\n"),
-			lino, be64_to_cpu(dinoc->di_size));
+			lino, be64_to_cpu(dino->di_size));
 		return(1);
 	}
 
@@ -1494,13 +1490,13 @@ process_symlink(
 	 * get symlink contents into data area
 	 */
 	symlink = &data[0];
-	if (be64_to_cpu(dinoc->di_size) <= XFS_DFORK_DSIZE(dino, mp))  {
+	if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp))  {
 		/*
 		 * local symlink, just copy the symlink out of the
 		 * inode into the data area
 		 */
 		memmove(symlink, XFS_DFORK_DPTR(dino), 
-						be64_to_cpu(dinoc->di_size));
+						be64_to_cpu(dino->di_size));
 	} else {
 		/*
 		 * stored in a meta-data file, have to bmap one block
@@ -1509,7 +1505,7 @@ process_symlink(
 		i = size = amountdone = 0;
 		cptr = symlink;
 
-		while (amountdone < be64_to_cpu(dinoc->di_size)) {
+		while (amountdone < be64_to_cpu(dino->di_size)) {
 			fsbno = blkmap_get(blkmap, i);
 			if (fsbno != NULLDFSBNO)
 				bp = libxfs_readbuf(mp->m_dev,
@@ -1523,7 +1519,7 @@ process_symlink(
 			}
 
 			buf_data = (char *)XFS_BUF_PTR(bp);
-			size = MIN(be64_to_cpu(dinoc->di_size) - amountdone, 
+			size = MIN(be64_to_cpu(dino->di_size) - amountdone, 
 						XFS_FSB_TO_BB(mp, 1) * BBSIZE);
 			memmove(cptr, buf_data, size);
 			cptr += size;
@@ -1532,12 +1528,12 @@ process_symlink(
 			libxfs_putbuf(bp);
 		}
 	}
-	data[be64_to_cpu(dinoc->di_size)] = '\0';
+	data[be64_to_cpu(dino->di_size)] = '\0';
 
 	/*
 	 * check for nulls
 	 */
-	if (null_check(symlink, be64_to_cpu(dinoc->di_size)))  {
+	if (null_check(symlink, be64_to_cpu(dino->di_size)))  {
 		do_warn(
 		_("found illegal null character in symlink inode %llu\n"),
 			lino);
@@ -1547,7 +1543,7 @@ process_symlink(
 	/*
 	 * check for any component being too long
 	 */
-	if (be64_to_cpu(dinoc->di_size) >= MAXNAMELEN)  {
+	if (be64_to_cpu(dino->di_size) >= MAXNAMELEN)  {
 		cptr = strchr(symlink, '/');
 
 		while (cptr != NULL)  {
@@ -1595,27 +1591,27 @@ process_misc_ino_types(xfs_mount_t	*mp,
 	/*
 	 * must also have a zero size
 	 */
-	if (be64_to_cpu(dino->di_core.di_size) != 0)  {
+	if (be64_to_cpu(dino->di_size) != 0)  {
 		switch (type)  {
 		case XR_INO_CHRDEV:
 			do_warn(_("size of character device inode %llu != 0 "
 				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_BLKDEV:
 			do_warn(_("size of block device inode %llu != 0 "
 				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_SOCK:
 			do_warn(_("size of socket inode %llu != 0 "
 				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_FIFO:
 			do_warn(_("size of fifo inode %llu != 0 "
 				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				be64_to_cpu(dino->di_size));
 			break;
 		default:
 			do_warn(_("Internal error - process_misc_ino_types, "
@@ -1634,7 +1630,7 @@ process_misc_ino_types_blocks(xfs_drfsbno_t totblocks, xfs_ino_t lino, int type)
 {
 	/*
 	 * you can not enforce all misc types have zero data fork blocks
-	 * by checking dino->di_core.di_nblocks because atotblocks (attribute
+	 * by checking dino->di_nblocks because atotblocks (attribute
 	 * blocks) are part of nblocks. We must check this later when atotblocks
 	 * has been calculated or by doing a simple check that anExtents == 0.
 	 * We must also guarantee that totblocks is 0. Thus nblocks checking
@@ -1673,28 +1669,28 @@ process_misc_ino_types_blocks(xfs_drfsbno_t totblocks, xfs_ino_t lino, int type)
 
 static inline int
 dinode_fmt(
-	xfs_dinode_core_t *dinoc)
+	xfs_dinode_t *dino)
 {
-	return be16_to_cpu(dinoc->di_mode) & S_IFMT;
+	return be16_to_cpu(dino->di_mode) & S_IFMT;
 }
 
 static inline void
 change_dinode_fmt(
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dino,
 	int		new_fmt)
 {
-	int		mode = be16_to_cpu(dinoc->di_mode);
+	int		mode = be16_to_cpu(dino->di_mode);
 
 	ASSERT((new_fmt & ~S_IFMT) == 0);
 
 	mode &= ~S_IFMT;
 	mode |= new_fmt;
-	dinoc->di_mode = cpu_to_be16(mode);
+	dino->di_mode = cpu_to_be16(mode);
 }
 
 static int
 check_dinode_mode_format(
-	xfs_dinode_core_t *dinoc)
+	xfs_dinode_t *dinoc)
 {
 	if (dinoc->di_format >= XFS_DINODE_FMT_UUID)
 		return -1;	/* FMT_UUID is not used */
@@ -1731,7 +1727,7 @@ check_dinode_mode_format(
 static int
 process_check_sb_inodes(
 	xfs_mount_t	*mp,
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dinoc,
 	xfs_ino_t	lino,
 	int		*type,
 	int		*dirty)
@@ -1827,17 +1823,16 @@ process_check_inode_sizes(
 	xfs_ino_t	lino,
 	int		type)
 {
-	xfs_dinode_core_t *dinoc = &dino->di_core;
-	xfs_fsize_t	size = be64_to_cpu(dinoc->di_size);
+	xfs_fsize_t	size = be64_to_cpu(dino->di_size);
 
 	switch (type)  {
 
 	case XR_INO_DIR:
 		if (size <= XFS_DFORK_DSIZE(dino, mp) &&
-				dinoc->di_format != XFS_DINODE_FMT_LOCAL) {
+				dino->di_format != XFS_DINODE_FMT_LOCAL) {
 			do_warn(_("mismatch between format (%d) and size "
 				"(%lld) in directory ino %llu\n"),
-				dinoc->di_format, size, lino);
+				dino->di_format, size, lino);
 			return 1;
 		}
 		if (size > XFS_DIR2_LEAF_OFFSET) {
@@ -1907,17 +1902,17 @@ process_check_inode_sizes(
 static int
 process_check_inode_forkoff(
 	xfs_mount_t	*mp,
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dino,
 	xfs_ino_t	lino)
 {
-	if (dinoc->di_forkoff == 0)
+	if (dino->di_forkoff == 0)
 		return 0;
 
-	switch (dinoc->di_format)  {
+	switch (dino->di_format)  {
 	case XFS_DINODE_FMT_DEV:
-		if (dinoc->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3)) {
+		if (dino->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3)) {
 			do_warn(_("bad attr fork offset %d in dev inode %llu, "
-				"should be %d\n"), dinoc->di_forkoff, lino,
+				"should be %d\n"), dino->di_forkoff, lino,
 				(int)(roundup(sizeof(xfs_dev_t), 8) >> 3));
 			return 1;
 		}
@@ -1925,15 +1920,15 @@ process_check_inode_forkoff(
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:	/* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dinoc->di_forkoff >= (XFS_LITINO(mp) >> 3)) {
+		if (dino->di_forkoff >= (XFS_LITINO(mp) >> 3)) {
 			do_warn(_("bad attr fork offset %d in inode %llu, "
-				"max=%d\n"), dinoc->di_forkoff, lino,
+				"max=%d\n"), dino->di_forkoff, lino,
 				XFS_LITINO(mp) >> 3);
 			return 1;
 		}
 		break;
 	default:
-		do_error(_("unexpected inode format %d\n"), dinoc->di_format);
+		do_error(_("unexpected inode format %d\n"), dino->di_format);
 		break;
 	}
 	return 0;
@@ -1944,24 +1939,24 @@ process_check_inode_forkoff(
  */
 static int
 process_inode_blocks_and_extents(
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dino,
 	xfs_drfsbno_t	nblocks,
 	__uint64_t	nextents,
 	__uint64_t	anextents,
 	xfs_ino_t	lino,
 	int		*dirty)
 {
-	if (nblocks != be64_to_cpu(dinoc->di_nblocks))  {
+	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(_("correcting nblocks for inode %llu, "
 				"was %llu - counted %llu\n"), lino,
-				be64_to_cpu(dinoc->di_nblocks), nblocks);
-			dinoc->di_nblocks = cpu_to_be64(nblocks);
+				be64_to_cpu(dino->di_nblocks), nblocks);
+			dino->di_nblocks = cpu_to_be64(nblocks);
 			*dirty = 1;
 		} else  {
 			do_warn(_("bad nblocks %llu for inode %llu, "
 				"would reset to %llu\n"),
-				be64_to_cpu(dinoc->di_nblocks), lino, nblocks);
+				be64_to_cpu(dino->di_nblocks), lino, nblocks);
 		}
 	}
 
@@ -1970,16 +1965,16 @@ process_inode_blocks_and_extents(
 			nextents, lino);
 		return 1;
 	}
-	if (nextents != be32_to_cpu(dinoc->di_nextents))  {
+	if (nextents != be32_to_cpu(dino->di_nextents))  {
 		if (!no_modify)  {
 			do_warn(_("correcting nextents for inode %llu, "
 				"was %d - counted %llu\n"), lino,
-				be32_to_cpu(dinoc->di_nextents), nextents);
-			dinoc->di_nextents = cpu_to_be32(nextents);
+				be32_to_cpu(dino->di_nextents), nextents);
+			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(_("bad nextents %d for inode %llu, would reset "
-				"to %llu\n"), be32_to_cpu(dinoc->di_nextents),
+				"to %llu\n"), be32_to_cpu(dino->di_nextents),
 				lino, nextents);
 		}
 	}
@@ -1989,16 +1984,16 @@ process_inode_blocks_and_extents(
 			anextents, lino);
 		return 1;
 	}
-	if (anextents != be16_to_cpu(dinoc->di_anextents))  {
+	if (anextents != be16_to_cpu(dino->di_anextents))  {
 		if (!no_modify)  {
 			do_warn(_("correcting anextents for inode %llu, "
 				"was %d - counted %llu\n"), lino,
-				be16_to_cpu(dinoc->di_anextents), anextents);
-			dinoc->di_anextents = cpu_to_be16(anextents);
+				be16_to_cpu(dino->di_anextents), anextents);
+			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(_("bad anextents %d for inode %llu, would reset"
-				" to %llu\n"), be16_to_cpu(dinoc->di_anextents),
+				" to %llu\n"), be16_to_cpu(dino->di_anextents),
 				lino, anextents);
 		}
 	}
@@ -2021,19 +2016,18 @@ process_inode_data_fork(
 	blkmap_t	**dblkmap,
 	int		check_dups)
 {
-	xfs_dinode_core_t *dinoc = &dino->di_core;
 	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	int		err = 0;
 
-	*nextents = be32_to_cpu(dinoc->di_nextents);
-	if (*nextents > be64_to_cpu(dinoc->di_nblocks))
+	*nextents = be32_to_cpu(dino->di_nextents);
+	if (*nextents > be64_to_cpu(dino->di_nblocks))
 		*nextents = 1;
 
-	if (dinoc->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
+	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;
 
-	switch (dinoc->di_format) {
+	switch (dino->di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		err = process_lclinode(mp, agno, ino, dino, XFS_DATA_FORK);
 		*totblocks = 0;
@@ -2053,7 +2047,7 @@ process_inode_data_fork(
 		break;
 	default:
 		do_error(_("unknown format %d, ino %llu (mode = %d)\n"),
-			dinoc->di_format, lino, be16_to_cpu(dinoc->di_mode));
+			dino->di_format, lino, be16_to_cpu(dino->di_mode));
 	}
 
 	if (err)  {
@@ -2071,7 +2065,7 @@ process_inode_data_fork(
 		 * re-process data fork to set bitmap since the
 		 * bitmap wasn't set the first time through
 		 */
-		switch (dinoc->di_format) {
+		switch (dino->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			err = process_lclinode(mp, agno, ino, dino, 
 						XFS_DATA_FORK);
@@ -2091,8 +2085,8 @@ process_inode_data_fork(
 			break;
 		default:
 			do_error(_("unknown format %d, ino %llu (mode = %d)\n"),
-				dinoc->di_format, lino,
-				be16_to_cpu(dinoc->di_mode));
+				dino->di_format, lino,
+				be16_to_cpu(dino->di_mode));
 		}
 
 		if (no_modify && err != 0)
@@ -2120,7 +2114,6 @@ process_inode_attr_fork(
 	int		extra_attr_check,
 	int		*retval)
 {
-	xfs_dinode_core_t *dinoc = &dino->di_core;
 	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	blkmap_t	*ablkmap = NULL;
 	int		repair = 0;
@@ -2128,12 +2121,12 @@ process_inode_attr_fork(
 
 	if (!XFS_DFORK_Q(dino)) {
 		*anextents = 0;
-		if (dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS) {
+		if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS) {
 			do_warn(_("bad attribute format %d in inode %llu, "),
-				dinoc->di_aformat, lino);
+				dino->di_aformat, lino);
 			if (!no_modify) {
 				do_warn(_("resetting value\n"));
-				dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
+				dino->di_aformat = XFS_DINODE_FMT_EXTENTS;
 				*dirty = 1;
 			} else
 				do_warn(_("would reset value\n"));
@@ -2141,11 +2134,11 @@ process_inode_attr_fork(
 		return 0;
 	}
 
-	*anextents = be16_to_cpu(dinoc->di_anextents);
-	if (*anextents > be64_to_cpu(dinoc->di_nblocks))
+	*anextents = be16_to_cpu(dino->di_anextents);
+	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 
-	switch (dinoc->di_aformat) {
+	switch (dino->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		*anextents = 0;
 		*atotblocks = 0;
@@ -2167,7 +2160,7 @@ process_inode_attr_fork(
 		break;
 	default:
 		do_warn(_("illegal attribute format %d, ino %llu\n"),
-				dinoc->di_aformat, lino);
+				dino->di_aformat, lino);
 		err = 1;
 		break;
 	}
@@ -2187,7 +2180,7 @@ process_inode_attr_fork(
 			if (delete_attr_ok)  {
 				do_warn(_(", clearing attr fork\n"));
 				*dirty += clear_dinode_attr(mp, dino, lino);
-				dinoc->di_aformat = XFS_DINODE_FMT_LOCAL;
+				dino->di_aformat = XFS_DINODE_FMT_LOCAL;
 			} else  {
 				do_warn("\n");
 				*dirty += clear_dinode(mp, dino, lino);
@@ -2206,7 +2199,7 @@ process_inode_attr_fork(
 	}
 
 	if (check_dups)  {
-		switch (dinoc->di_aformat) {
+		switch (dino->di_aformat) {
 		case XFS_DINODE_FMT_LOCAL:
 			err = process_lclinode(mp, agno, ino, dino, 
 						XFS_ATTR_FORK);
@@ -2223,7 +2216,7 @@ process_inode_attr_fork(
 			break;
 		default:
 			do_error(_("illegal attribute fmt %d, ino %llu\n"),
-				dinoc->di_aformat, lino);
+				dino->di_aformat, lino);
 		}
 
 		if (no_modify && err != 0) {
@@ -2247,7 +2240,7 @@ process_inode_attr_fork(
 			/* clear attributes if not done already */
 			if (!no_modify)  {
 				*dirty += clear_dinode_attr(mp, dino, lino);
-				dinoc->di_aformat = XFS_DINODE_FMT_LOCAL;
+				dino->di_aformat = XFS_DINODE_FMT_LOCAL;
 			} else  {
 				do_warn(_("would clear attr fork\n"));
 			}
@@ -2270,18 +2263,18 @@ process_inode_attr_fork(
 
 static int
 process_check_inode_nlink_version(
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dino,
 	xfs_ino_t	lino)
 {
 	int		dirty = 0;
 
-	if (dinoc->di_version > XFS_DINODE_VERSION_1 && !fs_inode_nlink)  {
+	if (dino->di_version > 1 && !fs_inode_nlink)  {
 		/*
 		 * do we have a fs/inode version mismatch with a valid
 		 * version 2 inode here that has to stay version 2 or
 		 * lose links?
 		 */
-		if (be32_to_cpu(dinoc->di_nlink) > XFS_MAXLINK_1)  {
+		if (be32_to_cpu(dino->di_nlink) > XFS_MAXLINK_1)  {
 			/*
 			 * yes.  are nlink inodes allowed?
 			 */
@@ -2311,17 +2304,17 @@ process_check_inode_nlink_version(
 				if (!no_modify)  {
 					do_warn(_("converting back to version 1,\n"
 						"this may destroy %d links\n"),
-						be32_to_cpu(dinoc->di_nlink) -
+						be32_to_cpu(dino->di_nlink) -
 							XFS_MAXLINK_1);
 
-					dinoc->di_version = XFS_DINODE_VERSION_1;
-					dinoc->di_nlink = cpu_to_be32(XFS_MAXLINK_1);
-					dinoc->di_onlink = cpu_to_be16(XFS_MAXLINK_1);
+					dino->di_version = 1;
+					dino->di_nlink = cpu_to_be32(XFS_MAXLINK_1);
+					dino->di_onlink = cpu_to_be16(XFS_MAXLINK_1);
 					dirty = 1;
 				} else  {
 					do_warn(_("would convert back to version 1,\n"
 						"\tthis might destroy %d links\n"),
-						be32_to_cpu(dinoc->di_nlink) -
+						be32_to_cpu(dino->di_nlink) -
 							XFS_MAXLINK_1);
 				}
 			}
@@ -2337,9 +2330,9 @@ process_check_inode_nlink_version(
 			do_warn(_("found version 2 inode %llu, "), lino);
 			if (!no_modify)  {
 				do_warn(_("converting back to version 1\n"));
-				dinoc->di_version = XFS_DINODE_VERSION_1;
-				dinoc->di_onlink = cpu_to_be16(
-					be32_to_cpu(dinoc->di_nlink));
+				dino->di_version = 1;
+				dino->di_onlink = cpu_to_be16(
+					be32_to_cpu(dino->di_nlink));
 				dirty = 1;
 			} else  {
 				do_warn(_("would convert back to version 1\n"));
@@ -2352,18 +2345,18 @@ process_check_inode_nlink_version(
 	 * to stay a version 2 inode.  it should have a zero
 	 * onlink field, so clear it.
 	 */
-	if (dinoc->di_version > XFS_DINODE_VERSION_1 &&
-			dinoc->di_onlink != 0 && fs_inode_nlink > 0) {
+	if (dino->di_version > 1 &&
+			dino->di_onlink != 0 && fs_inode_nlink > 0) {
 		if (!no_modify) {
 			do_warn(_("clearing obsolete nlink field in "
 				"version 2 inode %llu, was %d, now 0\n"),
-				lino, be16_to_cpu(dinoc->di_onlink));
-			dinoc->di_onlink = 0;
+				lino, be16_to_cpu(dino->di_onlink));
+			dino->di_onlink = 0;
 			dirty = 1;
 		} else  {
 			do_warn(_("would clear obsolete nlink field in "
 				"version 2 inode %llu, currently %d\n"),
-				lino, be16_to_cpu(dinoc->di_onlink));
+				lino, be16_to_cpu(dino->di_onlink));
 		}
 	}
 	return dirty;
@@ -2398,7 +2391,6 @@ process_dinode_int(xfs_mount_t *mp,
 {
 	xfs_drfsbno_t		totblocks = 0;
 	xfs_drfsbno_t		atotblocks = 0;
-	xfs_dinode_core_t	*dinoc;
 	int			di_mode;
 	int			type;
 	int			retval = 0;
@@ -2413,9 +2405,8 @@ process_dinode_int(xfs_mount_t *mp,
 	*used = is_used;
 	type = XR_INO_UNKNOWN;
 
-	dinoc = &dino->di_core;
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-	di_mode = be16_to_cpu(dinoc->di_mode);
+	di_mode = be16_to_cpu(dino->di_mode);
 
 	/*
 	 * if in verify mode, don't modify the inode.
@@ -2431,35 +2422,33 @@ process_dinode_int(xfs_mount_t *mp,
 	 */
 	ASSERT(uncertain == 0 || verify_mode != 0);
 
-	if (be16_to_cpu(dinoc->di_magic) != XFS_DINODE_MAGIC)  {
+	if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)  {
 		retval = 1;
 		if (!uncertain)
 			do_warn(_("bad magic number 0x%x on inode %llu%c"),
-				be16_to_cpu(dinoc->di_magic), lino,
+				be16_to_cpu(dino->di_magic), lino,
 				verify_mode ? '\n' : ',');
 		if (!verify_mode) {
 			if (!no_modify)  {
 				do_warn(_(" resetting magic number\n"));
-				dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+				dino->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 				*dirty = 1;
 			} else
 				do_warn(_(" would reset magic number\n"));
 		}
 	}
 
-	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
-	    (!fs_inode_nlink && dinoc->di_version > XFS_DINODE_VERSION_1))  {
+	if (!XFS_DINODE_GOOD_VERSION(dino->di_version) ||
+	    (!fs_inode_nlink && dino->di_version > 1))  {
 		retval = 1;
 		if (!uncertain)
 			do_warn(_("bad version number 0x%x on inode %llu%c"),
-				(__s8)dinoc->di_version, lino,
+				(__s8)dino->di_version, lino,
 				verify_mode ? '\n' : ',');
 		if (!verify_mode) {
 			if (!no_modify) {
 				do_warn(_(" resetting version number\n"));
-				dinoc->di_version = (fs_inode_nlink) ?
-					XFS_DINODE_VERSION_2 :
-					XFS_DINODE_VERSION_1;
+				dino->di_version = (fs_inode_nlink) ?  2 : 1;
 				*dirty = 1;
 			} else
 				do_warn(_(" would reset version number\n"));
@@ -2469,10 +2458,10 @@ process_dinode_int(xfs_mount_t *mp,
 	/*
 	 * blow out of here if the inode size is < 0
 	 */
-	if ((xfs_fsize_t)be64_to_cpu(dinoc->di_size) < 0)  {
+	if ((xfs_fsize_t)be64_to_cpu(dino->di_size) < 0)  {
 		if (!uncertain)
 			do_warn(_("bad (negative) size %lld on inode %llu\n"),
-				be64_to_cpu(dinoc->di_size), lino);
+				be64_to_cpu(dino->di_size), lino);
 		if (verify_mode)
 			return 1;
 		goto clear_bad_out;
@@ -2522,7 +2511,7 @@ process_dinode_int(xfs_mount_t *mp,
 	 * free inodes since technically any format is legal
 	 * as we reset the inode when we re-use it.
 	 */
-	if (di_mode != 0 && check_dinode_mode_format(dinoc) != 0) {
+	if (di_mode != 0 && check_dinode_mode_format(dino) != 0) {
 		if (!uncertain)
 			do_warn(_("bad inode format in inode %llu\n"), lino);
 		if (verify_mode)
@@ -2552,7 +2541,7 @@ process_dinode_int(xfs_mount_t *mp,
 		*isa_dir = 1;
 		break;
 	case S_IFREG:
-		if (be16_to_cpu(dinoc->di_flags) & XFS_DIFLAG_REALTIME)
+		if (be16_to_cpu(dino->di_flags) & XFS_DIFLAG_REALTIME)
 			type = XR_INO_RTDATA;
 		else if (lino == mp->m_sb.sb_rbmino)
 			type = XR_INO_RTBITMAP;
@@ -2585,27 +2574,27 @@ process_dinode_int(xfs_mount_t *mp,
 	/*
 	 * type checks for superblock inodes
 	 */
-	if (process_check_sb_inodes(mp, dinoc, lino, &type, dirty) != 0)
+	if (process_check_sb_inodes(mp, dino, lino, &type, dirty) != 0)
 		goto clear_bad_out;
 
 	/*
 	 * only regular files with REALTIME or EXTSIZE flags set can have
 	 * extsize set, or directories with EXTSZINHERIT.
 	 */
-	if (be32_to_cpu(dinoc->di_extsize) != 0) {
+	if (be32_to_cpu(dino->di_extsize) != 0) {
 		if ((type == XR_INO_RTDATA) ||
-		    (type == XR_INO_DIR && (be16_to_cpu(dinoc->di_flags) &
+		    (type == XR_INO_DIR && (be16_to_cpu(dino->di_flags) &
 					XFS_DIFLAG_EXTSZINHERIT)) ||
-		    (type == XR_INO_DATA && (be16_to_cpu(dinoc->di_flags) &
+		    (type == XR_INO_DATA && (be16_to_cpu(dino->di_flags) &
 				 XFS_DIFLAG_EXTSIZE)))  {
 			/* s'okay */ ;
 		} else {
 			do_warn(_("bad non-zero extent size %u for "
 					"non-realtime/extsize inode %llu, "),
-					be32_to_cpu(dinoc->di_extsize), lino);
+					be32_to_cpu(dino->di_extsize), lino);
 			if (!no_modify)  {
 				do_warn(_("resetting to zero\n"));
-				dinoc->di_extsize = 0;
+				dino->di_extsize = 0;
 				*dirty = 1;
 			} else
 				do_warn(_("would reset to zero\n"));
@@ -2621,7 +2610,7 @@ process_dinode_int(xfs_mount_t *mp,
 	/*
 	 * check for illegal values of forkoff
 	 */
-	if (process_check_inode_forkoff(mp, dinoc, lino) != 0)
+	if (process_check_inode_forkoff(mp, dino, lino) != 0)
 		goto clear_bad_out;
 
 	/*
@@ -2649,7 +2638,7 @@ process_dinode_int(xfs_mount_t *mp,
 	/*
 	 * correct space counters if required
 	 */
-	if (process_inode_blocks_and_extents(dinoc, totblocks + atotblocks,
+	if (process_inode_blocks_and_extents(dino, totblocks + atotblocks,
 			nextents, anextents, lino, dirty) != 0)
 		goto clear_bad_out;
 
@@ -2687,7 +2676,7 @@ process_dinode_int(xfs_mount_t *mp,
 	 * just leave nlinks alone.  even if it's set wrong,
 	 * it'll be reset when read in.
 	 */
-	*dirty += process_check_inode_nlink_version(dinoc, lino);
+	*dirty += process_check_inode_nlink_version(dino, lino);
 
 	return retval;
 
diff --git a/repair/dir.c b/repair/dir.c
index 6e0d54b..3c44132 100644
--- a/repair/dir.c
+++ b/repair/dir.c
@@ -107,7 +107,7 @@ process_shortform_dir(
 	sf = (xfs_dir_shortform_t *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
 	num_entries = sf->hdr.count;
-	ino_dir_size = be64_to_cpu(dip->di_core.di_size);
+	ino_dir_size = be64_to_cpu(dip->di_size);
 	*repair = 0;
 
 	ASSERT(ino_dir_size <= max_size);
@@ -338,7 +338,7 @@ process_shortform_dir(
 
 			if (!no_modify)  {
 				tmp_elen = xfs_dir_sf_entsize_byentry(sf_entry);
-				be64_add_cpu(&dip->di_core.di_size, -tmp_elen);
+				be64_add_cpu(&dip->di_size, -tmp_elen);
 				ino_dir_size -= tmp_elen;
 
 				tmp_sfe = (xfs_dir_sf_entry_t *)
@@ -425,7 +425,7 @@ process_shortform_dir(
 				ino, (__int64_t) ino_dir_size,
 			(__int64_t)((__psint_t) next_sfe - (__psint_t) sf));
 
-			dip->di_core.di_size = cpu_to_be64((__psint_t)next_sfe 
+			dip->di_size = cpu_to_be64((__psint_t)next_sfe 
 							- (__psint_t)sf);
 			*dino_dirty = 1;
 			*repair = 1;
@@ -954,7 +954,7 @@ get_first_dblock_fsbno(xfs_mount_t	*mp,
 		return(fsbno);
 	}
 
-	if (be64_to_cpu(dino->di_core.di_size) <= XFS_LBSIZE(mp))
+	if (be64_to_cpu(dino->di_size) <= XFS_LBSIZE(mp))
 		return(fsbno);
 
 	do {
@@ -2551,7 +2551,7 @@ process_node_dir(
 	/*
 	 * sanity check inode size
 	 */
-	if (be64_to_cpu(dip->di_core.di_size) <
+	if (be64_to_cpu(dip->di_size) <
 			(da_cursor.greatest_bno + 1) * mp->m_sb.sb_blocksize)  {
 		if ((xfs_fsize_t) da_cursor.greatest_bno
 				* mp->m_sb.sb_blocksize > UINT_MAX)  {
@@ -2565,9 +2565,9 @@ process_node_dir(
 _("setting directory inode (%llu) size to %llu bytes, was %lld bytes\n"),
 			ino, (xfs_dfiloff_t) (da_cursor.greatest_bno + 1)
 				* mp->m_sb.sb_blocksize,
-			be64_to_cpu(dip->di_core.di_size));
+			be64_to_cpu(dip->di_size));
 
-		dip->di_core.di_size = cpu_to_be64((da_cursor.greatest_bno + 1) 
+		dip->di_size = cpu_to_be64((da_cursor.greatest_bno + 1) 
 						* mp->m_sb.sb_blocksize);
 	}
 	return(0);
@@ -2709,13 +2709,13 @@ process_dir(
 	 * is only called ONCE so all the subordinate routines will
 	 * fix '.' and junk '..' if they're bogus.
 	 */
-	if (be64_to_cpu(dip->di_core.di_size) <= XFS_DFORK_DSIZE(dip, mp))  {
+	if (be64_to_cpu(dip->di_size) <= XFS_DFORK_DSIZE(dip, mp))  {
 		dot = 1;
 		dotdot = 1;
 		if (process_shortform_dir(mp, ino, dip, ino_discovery,
 				dino_dirty, parent, dirname, &repair))
 			res = 1;
-	} else if (be64_to_cpu(dip->di_core.di_size) <= XFS_LBSIZE(mp))  {
+	} else if (be64_to_cpu(dip->di_size) <= XFS_LBSIZE(mp))  {
 		if (process_leaf_dir(mp, ino, dip, ino_discovery,
 				dino_dirty, blkmap, &dot, &dotdot,
 				parent, dirname, &repair))
diff --git a/repair/dir2.c b/repair/dir2.c
index d0739fd..780f5cd 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -810,7 +810,7 @@ process_sf_dir2_fixoff(
 	xfs_dir2_sf_entry_t	*sfep;
 	xfs_dir2_sf_t		*sfp;
 
-	sfp = &dip->di_u.di_dir2sf;
+	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 
@@ -862,10 +862,10 @@ process_sf_dir2(
 	xfs_dir2_sf_entry_t	*tmp_sfep;
 	xfs_ino_t		zero = 0;
 
-	sfp = &dip->di_u.di_dir2sf;
+	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
 	num_entries = sfp->hdr.count;
-	ino_dir_size = be64_to_cpu(dip->di_core.di_size);
+	ino_dir_size = be64_to_cpu(dip->di_size);
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	bad_offset = *repair = 0;
 
@@ -1101,7 +1101,7 @@ process_sf_dir2(
 			if (!no_modify)  {
 				tmp_elen =
 					xfs_dir2_sf_entsize_byentry(sfp, sfep);
-				be64_add_cpu(&dip->di_core.di_size, -tmp_elen);
+				be64_add_cpu(&dip->di_size, -tmp_elen);
 				ino_dir_size -= tmp_elen;
 
 				tmp_sfep = (xfs_dir2_sf_entry_t *)
@@ -1209,7 +1209,7 @@ process_sf_dir2(
 				(__int64_t)((__psint_t)next_sfep -
 					    (__psint_t)sfp));
 
-			dip->di_core.di_size = cpu_to_be64(
+			dip->di_size = cpu_to_be64(
 					(__psint_t)next_sfep - (__psint_t)sfp);
 			*dino_dirty = 1;
 			*repair = 1;
@@ -2073,20 +2073,20 @@ process_dir2(
 	 */
 	if (blkmap)
 		last = blkmap_last_off(blkmap);
-	if (be64_to_cpu(dip->di_core.di_size) <= XFS_DFORK_DSIZE(dip, mp) &&
-			dip->di_core.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (be64_to_cpu(dip->di_size) <= XFS_DFORK_DSIZE(dip, mp) &&
+			dip->di_format == XFS_DINODE_FMT_LOCAL) {
 		dot = dotdot = 1;
 		res = process_sf_dir2(mp, ino, dip, ino_discovery, dino_dirty,
 			dirname, parent, &repair);
 	} else if (last == mp->m_dirblkfsbs &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE)) {
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE)) {
 		res = process_block_dir2(mp, ino, dip, ino_discovery,
 			dino_dirty, dirname, parent, blkmap, &dot, &dotdot,
 			&repair);
 	} else if (last >= mp->m_dirleafblk + mp->m_dirblkfsbs &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE)) {
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE)) {
 		res = process_leaf_node_dir2(mp, ino, dip, ino_discovery,
 			dirname, parent, blkmap, &dot, &dotdot, &repair,
 			last > mp->m_dirleafblk + mp->m_dirblkfsbs);
diff --git a/repair/incore.h b/repair/incore.h
index 99853fb..3d7e736 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -441,6 +441,9 @@ void			clear_uncertain_ino_cache(xfs_agnumber_t agno);
 	XFS_INOCF_SET_CF((ino_rec), (ino_offset)), \
 	XFS_INOBT_CLR_FREE((ino_rec), (ino_offset))
 
+#define XFS_INOBT_IS_FREE(ino_rec, ino_offset) \
+	(((ino_rec)->ir_free & XFS_INOBT_MASK(ino_offset)) != 0)
+
 #define is_inode_used(ino_rec, ino_offset)	\
 	!XFS_INOBT_IS_FREE((ino_rec), (ino_offset))
 
diff --git a/repair/phase6.c b/repair/phase6.c
index d056063..f7ae25e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -35,7 +35,7 @@ static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
-static struct xfs_name 		xfs_name_dot = {".", 1};
+static struct xfs_name		xfs_name_dot = {(unsigned char *)".", 1};
 
 /*
  * Data structures used to keep track of directories where the ".."
@@ -133,7 +133,7 @@ dir_hash_add(
 	__uint32_t		addr,
 	xfs_ino_t		inum,
 	int			namelen,
-	char			*name)
+	unsigned char		*name)
 {
 	xfs_dahash_t		hash = 0;
 	int			byaddr;
@@ -346,7 +346,7 @@ dir_hash_see_all(
 static void
 dir_hash_dup_names(dir_hash_tab_t *hashtab)
 {
-	char			*name;
+	unsigned char		*name;
 	dir_hash_ent_t		*p;
 
 	if (hashtab->names_duped)
@@ -444,11 +444,11 @@ mk_rbmino(xfs_mount_t *mp)
 			error);
 	}
 
-	memset(&ip->i_d, 0, sizeof(xfs_dinode_core_t));
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
-	ip->i_d.di_version = XFS_DINODE_VERSION_1;
+	ip->i_d.di_version = 1;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
@@ -481,13 +481,13 @@ mk_rbmino(xfs_mount_t *mp)
 
 	libxfs_trans_ijoin(tp, ip, 0);
 	bno = 0;
-	XFS_BMAP_INIT(&flist, &first);
+	xfs_bmap_init(&flist, &first);
 	while (bno < mp->m_sb.sb_rbmblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = libxfs_bmapi(tp, ip, bno,
 			  (xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
 			  XFS_BMAPI_WRITE, &first, mp->m_sb.sb_rbmblocks,
-			  map, &nmap, &flist, NULL);
+			  map, &nmap, &flist);
 		if (error) {
 			do_error(
 			_("couldn't allocate realtime bitmap, error = %d\n"),
@@ -543,7 +543,7 @@ fill_rbmino(xfs_mount_t *mp)
 		 */
 		nmap = 1;
 		error = libxfs_bmapi(tp, ip, bno, 1, XFS_BMAPI_WRITE,
-					&first, 1, &map, &nmap, NULL, NULL);
+					&first, 1, &map, &nmap, NULL);
 		if (error || nmap != 1) {
 			do_error(
 		_("couldn't map realtime bitmap block %llu, error = %d\n"),
@@ -612,7 +612,7 @@ fill_rsumino(xfs_mount_t *mp)
 		 */
 		nmap = 1;
 		error = libxfs_bmapi(tp, ip, bno, 1, XFS_BMAPI_WRITE,
-					&first, 1, &map, &nmap, NULL, NULL);
+					&first, 1, &map, &nmap, NULL);
 		if (error || nmap != 1) {
 			do_error(
 	_("couldn't map realtime summary inode block %llu, error = %d\n"),
@@ -677,11 +677,11 @@ mk_rsumino(xfs_mount_t *mp)
 			error);
 	}
 
-	memset(&ip->i_d, 0, sizeof(xfs_dinode_core_t));
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
-	ip->i_d.di_version = XFS_DINODE_VERSION_1;
+	ip->i_d.di_version = 1;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
@@ -708,7 +708,7 @@ mk_rsumino(xfs_mount_t *mp)
 	 * from mkfs)
 	 */
 	tp = libxfs_trans_alloc(mp, 0);
-	XFS_BMAP_INIT(&flist, &first);
+	xfs_bmap_init(&flist, &first);
 
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 	if ((error = libxfs_trans_reserve(tp,
@@ -720,13 +720,13 @@ mk_rsumino(xfs_mount_t *mp)
 
 	libxfs_trans_ijoin(tp, ip, 0);
 	bno = 0;
-	XFS_BMAP_INIT(&flist, &first);
+	xfs_bmap_init(&flist, &first);
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = libxfs_bmapi(tp, ip, bno,
 			  (xfs_extlen_t)(nsumblocks - bno),
 			  XFS_BMAPI_WRITE, &first, nsumblocks,
-			  map, &nmap, &flist, NULL);
+			  map, &nmap, &flist);
 		if (error) {
 			do_error(
 		_("couldn't allocate realtime summary inode, error = %d\n"),
@@ -778,11 +778,11 @@ mk_root_dir(xfs_mount_t *mp)
 	/*
 	 * take care of the core -- initialization from xfs_ialloc()
 	 */
-	memset(&ip->i_d, 0, sizeof(xfs_dinode_core_t));
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = (__uint16_t) mode|S_IFDIR;
-	ip->i_d.di_version = XFS_DINODE_VERSION_1;
+	ip->i_d.di_version = 1;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
@@ -843,7 +843,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
 			i, ORPHANAGE);
 
-	xname.name = ORPHANAGE;
+	xname.name = (unsigned char *)ORPHANAGE;
 	xname.len = strlen(ORPHANAGE);
 	if (libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
 		return ino;
@@ -853,7 +853,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 */
 
 	tp = libxfs_trans_alloc(mp, 0);
-	XFS_BMAP_INIT(&flist, &first);
+	xfs_bmap_init(&flist, &first);
 
 	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
 	if ((i = libxfs_trans_reserve(tp, nres, XFS_MKDIR_LOG_RES(mp), 0,
@@ -935,7 +935,7 @@ mv_orphanage(
 	xfs_bmap_free_t		flist;
 	int			err;
 	int			committed;
-	char			fname[MAXPATHLEN + 1];
+	unsigned char		fname[MAXPATHLEN + 1];
 	int			nres;
 	int			incr;
 	ino_tree_node_t		*irec;
@@ -945,7 +945,7 @@ mv_orphanage(
 	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
 
 	xname.name = fname;
-	xname.len = snprintf(fname, sizeof(fname), "%llu",
+	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
 				(unsigned long long)ino);
 
 	err = libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip, 0);
@@ -957,7 +957,7 @@ mv_orphanage(
 	incr = 0;
 	while (libxfs_dir_lookup(NULL, orphanage_ip, &xname, &entry_ino_num,
 								NULL) == 0)
-		xname.len = snprintf(fname, sizeof(fname), "%llu.%d",
+		xname.len = snprintf((char *)fname, sizeof(fname), "%llu.%d",
 					(unsigned long long)ino, ++incr);
 
 	tp = libxfs_trans_alloc(mp, 0);
@@ -989,7 +989,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, orphanage_ip, 0);
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
-			XFS_BMAP_INIT(&flist, &first);
+			xfs_bmap_init(&flist, &first);
 			err = libxfs_dir_createname(tp, orphanage_ip, &xname,
 						ino, &first, &flist, nres);
 			if (err)
@@ -1033,7 +1033,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, orphanage_ip, 0);
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
-			XFS_BMAP_INIT(&flist, &first);
+			xfs_bmap_init(&flist, &first);
 
 			err = libxfs_dir_createname(tp, orphanage_ip, &xname,
 						ino, &first, &flist, nres);
@@ -1090,7 +1090,7 @@ mv_orphanage(
 		libxfs_trans_ijoin(tp, orphanage_ip, 0);
 		libxfs_trans_ijoin(tp, ino_p, 0);
 
-		XFS_BMAP_INIT(&flist, &first);
+		xfs_bmap_init(&flist, &first);
 		err = libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
 						&first, &flist, nres);
 		if (err)
@@ -1151,7 +1151,7 @@ map_first_dblock_fsbno(xfs_mount_t	*mp,
 	nmap = 1;
 	error = libxfs_bmapi(NULL, ip, (xfs_fileoff_t) da_bno, 1,
 				XFS_BMAPI_METADATA, &fblock, 0,
-				&map, &nmap, NULL, NULL);
+				&map, &nmap, NULL);
 	if (error || nmap != 1)  {
 		if (!no_modify)
 			do_error(
@@ -1221,7 +1221,7 @@ _("bad dir/attr magic number in inode %llu, file bno = %u, fsbno = %llu\n"),
 		nmap = 1;
 		error = libxfs_bmapi(NULL, ip, (xfs_fileoff_t) da_bno, 1,
 				XFS_BMAPI_METADATA, &fblock, 0,
-				&map, &nmap, NULL, NULL);
+				&map, &nmap, NULL);
 		if (error || nmap != 1)  {
 			if (!no_modify)
 				do_error(
@@ -1438,7 +1438,7 @@ lf_block_dir_entry_check(xfs_mount_t		*mp,
 		 */
 		if (!dir_hash_add(mp, hashtab, (da_bno << mp->m_sb.sb_blocklog)
 					+ be16_to_cpu(entry->nameidx), lino,
-					entry->namelen, (char *)namest->name)) {
+					entry->namelen, namest->name)) {
 			nbad++;
 			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
 					"%llu is a duplicate name"),
@@ -1606,7 +1606,7 @@ _("bad magic # (0x%x) for dir ino %llu leaf block (bno %u fsbno %llu)\n"),
 			nmap = 1;
 			error = libxfs_bmapi(NULL, ip, (xfs_fileoff_t)da_bno, 1,
 					XFS_BMAPI_METADATA, &fblock, 0,
-					&map, &nmap, NULL, NULL);
+					&map, &nmap, NULL);
 			if (error || nmap != 1)  {
 				if (!no_modify)
 					do_error(
@@ -1678,7 +1678,7 @@ longform_dir2_rebuild(
 	if (pip.i_ino == NULLFSINO)
 		pip.i_ino = mp->m_sb.sb_rootino;
 
-	XFS_BMAP_INIT(&flist, &firstblock);
+	xfs_bmap_init(&flist, &firstblock);
 
 	tp = libxfs_trans_alloc(mp, 0);
 	nres = XFS_REMOVE_SPACE_RES(mp);
@@ -1696,7 +1696,7 @@ longform_dir2_rebuild(
 
 	/* free all data, leaf, node and freespace blocks */
 	error = libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA, 0,
-				&firstblock, &flist, NULL, &done);
+				&firstblock, &flist, &done);
 	if (error) {
 		do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
 		libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
@@ -1735,7 +1735,7 @@ longform_dir2_rebuild(
 		libxfs_trans_ijoin(tp, ip, 0);
 		libxfs_trans_ihold(tp, ip);
 
-		XFS_BMAP_INIT(&flist, &firstblock);
+		xfs_bmap_init(&flist, &firstblock);
 		error = libxfs_dir_createname(tp, ip, &p->name, p->inum,
 						&firstblock, &flist, nres);
 		if (error) {
@@ -1793,7 +1793,7 @@ dir2_kill_block(
 	libxfs_trans_ihold(tp, ip);
 	libxfs_da_bjoin(tp, bp);
 	memset(&args, 0, sizeof(args));
-	XFS_BMAP_INIT(&flist, &firstblock);
+	xfs_bmap_init(&flist, &firstblock);
 	args.dp = ip;
 	args.trans = tp;
 	args.firstblock = &firstblock;
@@ -1974,7 +1974,7 @@ longform_dir2_entry_check_data(
 	libxfs_trans_ihold(tp, ip);
 	libxfs_da_bjoin(tp, bp);
 	libxfs_da_bhold(tp, bp);
-	XFS_BMAP_INIT(&flist, &firstblock);
+	xfs_bmap_init(&flist, &firstblock);
 	if (be32_to_cpu(d->hdr.magic) != wantmagic) {
 		do_warn(_("bad directory block magic # %#x for directory inode "
 			"%llu block %d: "),
@@ -2102,7 +2102,7 @@ longform_dir2_entry_check_data(
 		 * check for duplicate names in directory.
 		 */
 		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
-							(char *)dep->name)) {
+							dep->name)) {
 			nbad++;
 			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
 					"%llu is a duplicate name"),
@@ -2724,7 +2724,7 @@ shortform_dir_entry_check(xfs_mount_t	*mp,
 		 */
 		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
 					(sf_entry - &sf->list[0]), lino,
-				sf_entry->namelen, (char *)sf_entry->name)) {
+					sf_entry->namelen, sf_entry->name)) {
 			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is a "
 				"duplicate name"), fname, lino, ino);
 			goto do_junkit;
@@ -3051,7 +3051,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 		 */
 		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
 					(sfep - xfs_dir2_sf_firstentry(sfp)),
-				lino, sfep->namelen, (char *)sfep->name)) {
+					lino, sfep->namelen, sfep->name)) {
 			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is a "
 				"duplicate name"), fname, lino, ino);
 			goto do_junkit;
@@ -3397,7 +3397,7 @@ process_dir_inode(
 		libxfs_trans_ijoin(tp, ip, 0);
 		libxfs_trans_ihold(tp, ip);
 
-		XFS_BMAP_INIT(&flist, &first);
+		xfs_bmap_init(&flist, &first);
 
 		error = libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
 					ip->i_ino, &first, &flist, nres);
@@ -3462,7 +3462,7 @@ process_dir_inode(
 			libxfs_trans_ijoin(tp, ip, 0);
 			libxfs_trans_ihold(tp, ip);
 
-			XFS_BMAP_INIT(&flist, &first);
+			xfs_bmap_init(&flist, &first);
 
 			error = libxfs_dir_createname(tp, ip, &xfs_name_dot,
 					ip->i_ino, &first, &flist, nres);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index a70082f..d2fdf90 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -316,7 +316,7 @@ pf_read_exinode(
 	xfs_dinode_t		*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			be32_to_cpu(dino->di_core.di_nextents));
+			be32_to_cpu(dino->di_nextents));
 }
 
 static void
@@ -328,23 +328,21 @@ pf_read_inode_dirs(
 	int			icnt = 0;
 	int			hasdir = 0;
 	int			isadir;
-	xfs_dinode_core_t	*dinoc;
 
 	for (icnt = 0; icnt < (XFS_BUF_COUNT(bp) >> mp->m_sb.sb_inodelog); icnt++) {
-		dino = XFS_MAKE_IPTR(mp, bp, icnt);
-		dinoc = &dino->di_core;
+		dino = xfs_make_iptr(mp, bp, icnt);
 
 		/*
 		 * We are only prefetching directory contents in extents
 		 * and btree nodes for other inodes
 		 */
-		isadir = (be16_to_cpu(dinoc->di_mode) & S_IFMT) == S_IFDIR;
+		isadir = (be16_to_cpu(dino->di_mode) & S_IFMT) == S_IFDIR;
 		hasdir |= isadir;
 
-		if (dinoc->di_format <= XFS_DINODE_FMT_LOCAL)
+		if (dino->di_format <= XFS_DINODE_FMT_LOCAL)
 			continue;
 
-		if (!isadir && (dinoc->di_format == XFS_DINODE_FMT_EXTENTS ||
+		if (!isadir && (dino->di_format == XFS_DINODE_FMT_EXTENTS ||
 				args->dirs_only))
 			continue;
 
@@ -353,25 +351,24 @@ pf_read_inode_dirs(
 		 * its directory data. It's a cut down version of
 		 * process_dinode_int() in dinode.c.
 		 */
-		if (dinoc->di_format > XFS_DINODE_FMT_BTREE)
+		if (dino->di_format > XFS_DINODE_FMT_BTREE)
 			continue;
 
-		if (be16_to_cpu(dinoc->di_magic) != XFS_DINODE_MAGIC)
+		if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)
 			continue;
 
-		if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
-				(!fs_inode_nlink && dinoc->di_version >
-					XFS_DINODE_VERSION_1))
+		if (!XFS_DINODE_GOOD_VERSION(dino->di_version) ||
+				(!fs_inode_nlink && dino->di_version > 1))
 			continue;
 
-		if (be64_to_cpu(dinoc->di_size) <= XFS_DFORK_DSIZE(dino, mp))
+		if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp))
 			continue;
 
-		if ((dinoc->di_forkoff != 0) &&
-				(dinoc->di_forkoff >= (XFS_LITINO(mp) >> 3)))
+		if ((dino->di_forkoff != 0) &&
+				(dino->di_forkoff >= (XFS_LITINO(mp) >> 3)))
 			continue;
 
-		switch (dinoc->di_format) {
+		switch (dino->di_format) {
 			case XFS_DINODE_FMT_EXTENTS:
 				pf_read_exinode(args, dino);
 				break;
diff --git a/repair/rt.c b/repair/rt.c
index 7645128..d6ecd56 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -193,7 +193,7 @@ process_rtbitmap(xfs_mount_t	*mp,
 	extno = 0;
 	error = 0;
 
-	end_bmbno = howmany(be64_to_cpu(dino->di_core.di_size),
+	end_bmbno = howmany(be64_to_cpu(dino->di_size),
 						mp->m_sb.sb_blocksize);
 
 	for (bmbno = 0; bmbno < end_bmbno; bmbno++) {
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
