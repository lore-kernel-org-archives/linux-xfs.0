Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0L4MM1J014121 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 22:22:26 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86F83182D79A
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 20:22:20 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	2SgWZ58FWadeXFrA for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2009 20:22:20 -0800 (PST)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>) id 1LPUbZ-0005pV-9X
	for xfs@oss.sgi.com; Wed, 21 Jan 2009 15:22:17 +1100
Date: Wed, 21 Jan 2009 15:22:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Long btree pointers are still 64 bit on disk
Message-ID: <20090121042217.GL10158@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

[XFS] Long btree pointers are still 64 bit on disk

On 32 bit machines with CONFIG_LBD=n, XFS reduces the
in memory size of xfs_fsblock_t to 32 bits so that it
will fit within 32 bit addressing. However, the disk format
for long btree pointers are still 64 bits in size.

The recent btree rewrite failed to take this into account
when initialising new btree blocks, setting sibling pointers
to NULL and checking if they are NULL. Hence checking whether
a 64 bit NULL was the same as a 32 bit NULL was failingi
resulting in NULL sibling pointers failing to be detected
correctly. This showed up as WANT_CORRUPTED_GOTO shutdowns
in xfs_btree_delrec.

Fix this by making all the comparisons and setting of long
pointer btree NULL blocks to the disk format, not the
in memory format. i.e. use NULLDFSBNO.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Reported-by: Jacek Luczak <difrost.kernel@gmail.com>
Reported-by: Danny ter Haar <dth@dth.net>
Signed-off-by: Dave Chinner <david@fromorbit.com>

---
 fs/xfs/xfs_btree.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 2c3ef20..6bc2136 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -843,7 +843,7 @@ xfs_btree_ptr_is_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
+		return be64_to_cpu(ptr->l) == NULLDFSBNO;
 	else
 		return be32_to_cpu(ptr->s) == NULLAGBLOCK;
 }
@@ -854,7 +854,7 @@ xfs_btree_set_ptr_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		ptr->l = cpu_to_be64(NULLFSBLOCK);
+		ptr->l = cpu_to_be64(NULLDFSBNO);
 	else
 		ptr->s = cpu_to_be32(NULLAGBLOCK);
 }
@@ -918,8 +918,8 @@ xfs_btree_init_block(
 	new->bb_numrecs = cpu_to_be16(numrecs);
 
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
-		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
+		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
+		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
 	} else {
 		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
@@ -971,7 +971,7 @@ xfs_btree_ptr_to_daddr(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ASSERT(be64_to_cpu(ptr->l) != NULLFSBLOCK);
+		ASSERT(be64_to_cpu(ptr->l) != NULLDFSBNO);
 
 		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
 	} else {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
