Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEFLEdv215802 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 09:21:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 539511E9BBDD
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 07:21:13 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QnD4QZsI5h838Zf9 for <xfs@oss.sgi.com>;
	Mon, 14 Nov 2011 07:21:13 -0800 (PST)
Date: Mon, 14 Nov 2011 10:21:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] repair: update extent count after zapping duplicate blocks
Message-ID: <20111114152112.GA26535@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

When we find a duplicate extent in an extern format inode we do not zap
the whole inode, but just truncate it to the point where the duplicate
extent was found.  But the current code only updates di_nblocks for the
new size, but no di_nextents/di_anextents.  In most cases this isn't noticed,
but when moving such an inode to the lost+found directoy the consistency
check in xfs_iformat trips over it.  Fix this by updating the on-disk
extent count as part of the inode repair.

Note that we zap btree format inodes with duplicate block completely
at this point, so this fix doesn't apply to them.

Reported-by: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/dinode.c
===================================================================
--- xfsprogs-dev.orig/repair/dinode.c	2011-11-08 12:15:40.000000000 +0000
+++ xfsprogs-dev/repair/dinode.c	2011-11-14 12:09:54.000000000 +0000
@@ -606,7 +606,7 @@ int
 process_bmbt_reclist_int(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			numrecs,
+	int			*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_drfsbno_t		*tot,
@@ -642,7 +642,7 @@ process_bmbt_reclist_int(
 	else
 		ftype = _("regular");
 
-	for (i = 0; i < numrecs; i++) {
+	for (i = 0; i < *numrecs; i++) {
 		libxfs_bmbt_disk_get_all(rp + i, &irec);
 		if (i == 0)
 			*last_key = *first_key = irec.br_startoff;
@@ -831,6 +831,13 @@ _("illegal state %d in block map %" PRIu
 done:
 	if (locked_agno != -1)
 		pthread_mutex_unlock(&ag_locks[locked_agno]);
+
+	if (i != *numrecs) {
+		ASSERT(i < *numrecs);
+		do_warn(_("correcting nextents for inode %" PRIu64 "\n"), ino);
+		*numrecs = i;
+	}
+
 	return error;
 }
 
@@ -842,7 +849,7 @@ int
 process_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			numrecs,
+	int			*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_drfsbno_t		*tot,
@@ -863,7 +870,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			numrecs,
+	int			*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_drfsbno_t		*tot,
@@ -1356,23 +1363,29 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_dfiloff_t		first_key;
 	xfs_dfiloff_t		last_key;
+	int			numrecs;
+	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*tot = 0;
-	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
+
 	/*
 	 * XXX - if we were going to fix up the btree record,
 	 * we'd do it right here.  For now, if there's a problem,
 	 * we'll bail out and presumably clear the inode.
 	 */
 	if (check_dups == 0)
-		return(process_bmbt_reclist(mp, rp, *nex, type, lino,
+		ret = process_bmbt_reclist(mp, rp, &numrecs, type, lino,
 					tot, blkmapp, &first_key, &last_key,
-					whichfork));
+					whichfork);
 	else
-		return(scan_bmbt_reclist(mp, rp, *nex, type, lino, tot,
-					whichfork));
+		ret = scan_bmbt_reclist(mp, rp, &numrecs, type, lino, tot,
+					whichfork);
+
+	*nex = numrecs;
+	return ret;
 }
 
 /*
@@ -2003,6 +2016,12 @@ process_inode_blocks_and_extents(
 	xfs_ino_t	lino,
 	int		*dirty)
 {
+	if (nblocks < nextents + anextents) {
+		do_warn(
+_("nblocks (%" PRIu64 ") smaller than nextents for inode %" PRIu64 "\n"), nblocks, lino);
+		return 1;
+	}
+
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(
@@ -2063,6 +2082,7 @@ _("bad anextents %d for inode %" PRIu64
 				lino, anextents);
 		}
 	}
+
 	return 0;
 }
 
Index: xfsprogs-dev/repair/dinode.h
===================================================================
--- xfsprogs-dev.orig/repair/dinode.h	2010-05-10 18:16:35.000000000 +0000
+++ xfsprogs-dev/repair/dinode.h	2011-11-14 12:09:54.000000000 +0000
@@ -42,7 +42,7 @@ convert_extent(
 int
 process_bmbt_reclist(xfs_mount_t	*mp,
 		xfs_bmbt_rec_t		*rp,
-		int			numrecs,
+		int			*numrecs,
 		int			type,
 		xfs_ino_t		ino,
 		xfs_drfsbno_t		*tot,
@@ -55,7 +55,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			numrecs,
+	int			*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_drfsbno_t		*tot,
Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2011-11-10 11:23:47.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2011-11-14 12:09:54.000000000 +0000
@@ -351,12 +351,12 @@ _("inode %" PRIu64 " bad # of bmap recor
 		 * we'll bail out and presumably clear the inode.
 		 */
 		if (check_dups == 0)  {
-			err = process_bmbt_reclist(mp, rp, numrecs,
-					type, ino, tot, blkmapp,
-					&first_key, &last_key,
-					whichfork);
+			err = process_bmbt_reclist(mp, rp, &numrecs, type, ino,
+						   tot, blkmapp, &first_key,
+						   &last_key, whichfork);
 			if (err)
-				return(1);
+				return 1;
+
 			/*
 			 * check that key ordering is monotonically increasing.
 			 * if the last_key value in the cursor is set to
@@ -380,10 +380,11 @@ _("out-of-order bmap key (file offset) i
 			bm_cursor->level[level].first_key = first_key;
 			bm_cursor->level[level].last_key = last_key;
 
-			return(0);
-		} else
-			return(scan_bmbt_reclist(mp, rp, numrecs,
-						type, ino, tot, whichfork));
+			return 0;
+		} else {
+			return scan_bmbt_reclist(mp, rp, &numrecs, type, ino,
+						 tot, whichfork);
+		}
 	}
 	if (numrecs > mp->m_bmap_dmxr[1] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[1])) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
