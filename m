Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7D17A7F84
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:51:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FA62304032
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 12:51:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id z6EXoLuCHp77qmqU for <xfs@oss.sgi.com>;
	Fri, 09 Oct 2015 12:51:10 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5655863C77A5
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:51:10 -0500 (CDT)
Subject: [PATCH 2/5] xfs_repair: fix unaligned accesses
References: <56181A17.9080503@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56181AAD.9080505@sandeen.net>
Date: Fri, 9 Oct 2015 14:51:09 -0500
MIME-Version: 1.0
In-Reply-To: <56181A17.9080503@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This fixes some unaligned accesses spotted by libubsan in repair.

See Documentation/unaligned-memory-access.txt in the kernel
tree for why these can be a problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: 
Add note about why ...
Add another in libxfs_bmbt_disk_get_all
Fix mistaken double-swap in dinode.c in original patch

 include/libxfs.h  |  4 ++--
 repair/dinode.c   | 47 ++++++++++++++++++++++++-----------------------
 repair/prefetch.c |  4 ++--
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index b1604e2..52fb483 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -206,8 +206,8 @@ libxfs_bmbt_disk_get_all(
 {
 	struct xfs_bmbt_rec_host hrec;
 
-	hrec.l0 = be64_to_cpu(rp->l0);
-	hrec.l1 = be64_to_cpu(rp->l1);
+	hrec.l0 = get_unaligned_be64(&rp->l0);
+	hrec.l1 = get_unaligned_be64(&rp->l1);
 	libxfs_bmbt_get_all(&hrec, irec);
 }
 
diff --git a/repair/dinode.c b/repair/dinode.c
index f78f907..f99cba3 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -960,15 +960,17 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 		 * btree, we'd do it right here.  For now, if there's a
 		 * problem, we'll bail out and presumably clear the inode.
 		 */
-		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
-			do_warn(_("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
-			       (unsigned long long) be64_to_cpu(pp[i]), lino);
+		if (!verify_dfsbno(mp, get_unaligned_be64(&pp[i])))  {
+			do_warn(
+("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
+				get_unaligned_be64(&pp[i]), lino);
 			return(1);
 		}
 
-		if (scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt, type,
-				whichfork, lino, tot, nex, blkmapp, &cursor,
-				1, check_dups, magic, &xfs_bmbt_buf_ops))
+		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
+				type, whichfork, lino, tot, nex, blkmapp,
+				&cursor, 1, check_dups, magic,
+				&xfs_bmbt_buf_ops))
 			return(1);
 		/*
 		 * fix key (offset) mismatches between the keys in root
@@ -977,28 +979,27 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 		 * blocks but the parent hasn't been updated
 		 */
 		if (!check_dups && cursor.level[level-1].first_key !=
-					be64_to_cpu(pkey[i].br_startoff))  {
+				   get_unaligned_be64(&pkey[i].br_startoff)) {
 			if (!no_modify)  {
 				do_warn(
-	_("correcting key in bmbt root (was %llu, now %" PRIu64") in inode "
-	  "%" PRIu64" %s fork\n"),
-				       (unsigned long long)
-					       be64_to_cpu(pkey[i].br_startoff),
-					cursor.level[level-1].first_key,
-					XFS_AGINO_TO_INO(mp, agno, ino),
-					forkname);
+_("correcting key in bmbt root (was %" PRIu64 ", now %" PRIu64") in inode "
+  "%" PRIu64" %s fork\n"),
+				       get_unaligned_be64(&pkey[i].br_startoff),
+				       cursor.level[level-1].first_key,
+				       XFS_AGINO_TO_INO(mp, agno, ino),
+				       forkname);
 				*dirty = 1;
-				pkey[i].br_startoff = cpu_to_be64(
-					cursor.level[level-1].first_key);
+				put_unaligned_be64(
+					cursor.level[level-1].first_key,
+					&pkey[i].br_startoff);
 			} else  {
 				do_warn(
-	_("bad key in bmbt root (is %llu, would reset to %" PRIu64 ") in inode "
-	  "%" PRIu64 " %s fork\n"),
-				       (unsigned long long)
-					       be64_to_cpu(pkey[i].br_startoff),
-					cursor.level[level-1].first_key,
-					XFS_AGINO_TO_INO(mp, agno, ino),
-					forkname);
+_("bad key in bmbt root (is %" PRIu64 ", would reset to %" PRIu64 ") in inode "
+  "%" PRIu64 " %s fork\n"),
+				       get_unaligned_be64(&pkey[i].br_startoff),
+				       cursor.level[level-1].first_key,
+				       XFS_AGINO_TO_INO(mp, agno, ino),
+				       forkname);
 			}
 		}
 		/*
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 32ec55e..52238ca 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -330,7 +330,7 @@ pf_scanfunc_bmap(
 	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 
 	for (i = 0; i < numrecs; i++) {
-		dbno = be64_to_cpu(pp[i]);
+		dbno = get_unaligned_be64(&pp[i]);
 		if (!verify_dfsbno(mp, dbno))
 			return 0;
 		if (!pf_scan_lbtree(dbno, level, isadir, args, pf_scanfunc_bmap))
@@ -372,7 +372,7 @@ pf_read_btinode(
 	pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(dsize, 0));
 
 	for (i = 0; i < numrecs; i++) {
-		dbno = be64_to_cpu(pp[i]);
+		dbno = get_unaligned_be64(&pp[i]);
 		if (!verify_dfsbno(mp, dbno))
 			break;
 		if (!pf_scan_lbtree(dbno, level, isadir, args, pf_scanfunc_bmap))
-- 
2.6.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
