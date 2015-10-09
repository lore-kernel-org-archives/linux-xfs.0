Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 35C277F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 19:25:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE633304032
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 17:25:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fxiF8pyIApJQ6TPt for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2015 17:25:26 -0700 (PDT)
Received: from Liberator.local (unknown [205.215.222.148])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7FE0561F8992
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 19:25:26 -0500 (CDT)
Subject: [PATCH 2/4] xfs_repair: fix unaligned accesses
References: <56170906.5090301@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56170974.5020604@sandeen.net>
Date: Thu, 8 Oct 2015 19:25:24 -0500
MIME-Version: 1.0
In-Reply-To: <56170906.5090301@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/dinode.c   |   19 +++++++++----------
 repair/prefetch.c |    4 ++--
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index f78f907..44bbb8f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -960,13 +960,13 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 		 * btree, we'd do it right here.  For now, if there's a
 		 * problem, we'll bail out and presumably clear the inode.
 		 */
-		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
+		if (!verify_dfsbno(mp, get_unaligned_be64(&pp[i])))  {
 			do_warn(_("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
-			       (unsigned long long) be64_to_cpu(pp[i]), lino);
+			       get_unaligned_be64(&pp[i]), lino);
 			return(1);
 		}
 
-		if (scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt, type,
+		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt, type,
 				whichfork, lino, tot, nex, blkmapp, &cursor,
 				1, check_dups, magic, &xfs_bmbt_buf_ops))
 			return(1);
@@ -977,25 +977,24 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 		 * blocks but the parent hasn't been updated
 		 */
 		if (!check_dups && cursor.level[level-1].first_key !=
-					be64_to_cpu(pkey[i].br_startoff))  {
+				   get_unaligned_be64(&pkey[i].br_startoff)) {
 			if (!no_modify)  {
 				do_warn(
 	_("correcting key in bmbt root (was %llu, now %" PRIu64") in inode "
 	  "%" PRIu64" %s fork\n"),
-				       (unsigned long long)
-					       be64_to_cpu(pkey[i].br_startoff),
+					get_unaligned_be64(&pkey[i].br_startoff),
 					cursor.level[level-1].first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
 					forkname);
 				*dirty = 1;
-				pkey[i].br_startoff = cpu_to_be64(
-					cursor.level[level-1].first_key);
+				put_unaligned_be64(
+					cpu_to_be64(cursor.level[level-1].first_key),
+					&pkey[i].br_startoff);
 			} else  {
 				do_warn(
 	_("bad key in bmbt root (is %llu, would reset to %" PRIu64 ") in inode "
 	  "%" PRIu64 " %s fork\n"),
-				       (unsigned long long)
-					       be64_to_cpu(pkey[i].br_startoff),
+					get_unaligned_be64(&pkey[i].br_startoff),
 					cursor.level[level-1].first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
 					forkname);
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
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
