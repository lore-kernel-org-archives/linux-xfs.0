Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B1327CBF
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 01:00:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 152328F8071
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 23:00:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NhfsTHxFZRbq8vsy for
	<xfs@oss.sgi.com>; Tue, 06 Aug 2013 23:00:46 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7760jDo014422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 02:00:45 -0400
Message-ID: <5201E28B.1050800@redhat.com>
Date: Wed, 07 Aug 2013 01:00:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] mkfs.xfs: fix protofile name create block reservation
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

A large protofile which creates a large directory and requires
a a dir tree split, can fail:

  mkfs.xfs: directory createname error [28 - No space left on device]

This is because when we've split a block once, we decrement args->total:
(see kernel commit a7444053fb3ebd3d905e3c7a7bd5ea80a54b083a for the
rationale)

       /* account for newly allocated blocks in reserved blocks total */
       args->total -= dp->i_d.di_nblocks - nblks;

but every call into this path from proto file parsing started
reserved / args->total as only "1" as passed tro newdirent() -
so if we allocate a block, args->total hits 0, and then in
xfs_dir2_node_addname():

        /*
         * Add the new leaf entry.
         */
        rval = xfs_dir2_leafn_add(blk->bp, args, blk->index);
        if (rval == 0) {
		...
        } else {
                /*
                 * It didn't work, we need to split the leaf block.
                 */
                if (args->total == 0) {
                        ASSERT(rval == ENOSPC);
                        goto done;
                }
                /*
                 * Split the leaf block and insert the new entry.
                 */

we hit the args->total == 0 special case, and don't do the next
split, and ENOSPC gets returned all the way up, and we fail.

So rather than calling newdirent with a total of "1" in every case,
which doesn't account for possible tree splits, we should call it
with a more appropriate value: XFS_DIRENTER_SPACE_RES(mp, name->len),
which will handle the maximum nr of block allocations that might be
needed during a directory entry insert.

Since the reservation required doesn't depend on entry type,
just push this down a level, into newdirent() itself.

Reported-by: Boris Ranto <branto@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/proto.c b/mkfs/proto.c
index f201096..7d96b46 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -306,12 +306,14 @@ newdirent(
 	struct xfs_name	*name,
 	xfs_ino_t	inum,
 	xfs_fsblock_t	*first,
-	xfs_bmap_free_t	*flist,
-	xfs_extlen_t	total)
+	xfs_bmap_free_t	*flist)
 {
 	int	error;
+	int	rsv;
+
+	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = libxfs_dir_createname(tp, pip, name, inum, first, flist, total);
+	error = libxfs_dir_createname(tp, pip, name, inum, first, flist, rsv);
 	if (error)
 		fail(_("directory createname error"), error);
 }
@@ -449,7 +451,7 @@ parseproto(
 		if (buf)
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist, 1);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		break;
 
@@ -465,7 +467,7 @@ parseproto(
 
 		libxfs_trans_ijoin(tp, pip, 0);
 
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist, 1);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
 
@@ -486,7 +488,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist, 1);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		flags |= XFS_ILOG_DEV;
 		break;
@@ -500,7 +502,7 @@ parseproto(
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist, 1);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		flags |= XFS_ILOG_DEV;
 		break;
@@ -512,7 +514,7 @@ parseproto(
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist, 1);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		break;
 	case IF_SYMLINK:
@@ -525,7 +527,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		flags |= newfile(tp, ip, &flist, &first, 1, 1, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist, 1);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		break;
 	case IF_DIRECTORY:
@@ -544,7 +546,7 @@ parseproto(
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
 			newdirent(mp, tp, pip, &xname, ip->i_ino,
-				  &first, &flist, 1);
+				  &first, &flist);
 			pip->i_d.di_nlink++;
 			libxfs_trans_ihold(tp, pip);
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
