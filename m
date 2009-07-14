Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6E4DOBY086765 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 23:13:24 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A4C1A556CA
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 21:21:29 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id rCE0FqqJ7iyl26EC for
	<xfs@oss.sgi.com>; Mon, 13 Jul 2009 21:21:29 -0700 (PDT)
Message-ID: <4A5C0606.4030102@sandeen.net>
Date: Mon, 13 Jul 2009 23:13:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair - do not attempt to set shortform attr header
	when clearing
References: <200907031320.48358@zmi.at>
In-Reply-To: <200907031320.48358@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs mailing list <xfs@oss.sgi.com>

As reported in "bad fs - xfs_repair 3.01 crashes on it" ...

The filesystem encountered a bad attribute fork which is cleared:

local inode 3857051697 attr too small (size = 3, min size = 4)
bad attribute fork in inode 3857051697, clearing attr fork
clearing inode 3857051697 attributes

and then later this inode failed an assertion:

data fork in regular inode 3857051697 claims used block 537147998
xfs_repair: dinode.c:2108: process_inode_data_fork: Assertion `err == 0' failed.

The ASSERT is there because process_inode_data_fork() calls 
process_exinode() twice; once with check_dups == 1, and again with 
check_dups == 0.  The assertion is that they should both return the
the same answer about whether the inode contained duplicate blocks.

However, they are tested in different ways; with check_dups set,
process_exinode() simply does search_dup_extent() when it gets
to process_bmbt_reclist_int(); without check_dups set, it utilizes
the ba_bmap[][] array of bitmaps, compared against the current
extent record.

Long story short(er), when we cleared the bad attribute in
clear_dinode_attr(), it used XFS_DFORK_APTR() to get to the
shortform attribute header, and set some fields.  However,
di_forkoff must have been corrupt as well, because setting these
fields corrupted the extent list, and the 4th extent on the inode
got its physical block modified from:
431241822 / 0x19B43A5E
to:
537147998 / 0x20043A5E

and this new (corrupt) physical block matched another inode's
block, triggering the dup & return 1, triggering the ASSERT.

Whew.

Anyway, simply setting di_forkoff to 0 should be enough to flag
the inode as having no attr fork, and messing with where we
think the shortform attribute header may be is now shown to be
dangerous.  Simply not mucking w/ the header seems to fix
the problem, based on testing with the metadump image.

Almost.

process_inode_attr_fork() calls clear_dinode_attr() which puts
it into the XFS_DINODE_FMT_EXTENTS state, but upon return resets
that to XFS_DINODE_FMT_LOCAL.  Later, it's checked that if 
!XFS_DFORK_Q(), the format is XFS_DINODE_FMT_EXTENTS (!)
and it gets reset.

So drop the setting to XFS_DINODE_FMT_LOCAL; for whatever reason,
"no attributes" seems to expect _EXTENTS format, see for example
xfs_attr_shortform_remove(), clear_dinode_core(), and 
xfs_attr_fork_reset() in the kernel, which all set it to _EXTENTS
in this circumstance.

Fix this up after both calls to clear_dinode_attr().

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index 84e1d05..23de0a8 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -103,23 +103,8 @@ clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 	}
 
 	/* get rid of the fork by clearing forkoff */
-
-	/* Originally, when the attr repair code was added, the fork was cleared
-	 * by turning it into shortform status.  This meant clearing the
-	 * hdr.totsize/count fields and also changing aformat to LOCAL
-	 * (vs EXTENTS).  Over various fixes, the aformat and forkoff have
-	 * been updated to not show an attribute fork at all, however.
-	 * It could be possible that resetting totsize/count are not needed,
-	 * but just to be safe, leave it in for now.
-	 */
-
-	if (!no_modify) {
-		xfs_attr_shortform_t *asf = (xfs_attr_shortform_t *)
-				XFS_DFORK_APTR(dino);
-		asf->hdr.totsize = cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
-		asf->hdr.count = 0;
-		dinoc->di_forkoff = 0;  /* got to do this after asf is set */
-	}
+	if (!no_modify)
+		dinoc->di_forkoff = 0;
 
 	/*
 	 * always returns 1 since the fork gets zapped
@@ -2195,7 +2180,6 @@ process_inode_attr_fork(
 			if (delete_attr_ok)  {
 				do_warn(_(", clearing attr fork\n"));
 				*dirty += clear_dinode_attr(mp, dino, lino);
-				dinoc->di_aformat = XFS_DINODE_FMT_LOCAL;
 			} else  {
 				do_warn("\n");
 				*dirty += clear_dinode(mp, dino, lino);
@@ -2253,12 +2237,10 @@ process_inode_attr_fork(
 			lino);
 		if (!repair) {
 			/* clear attributes if not done already */
-			if (!no_modify)  {
+			if (!no_modify)
 				*dirty += clear_dinode_attr(mp, dino, lino);
-				dinoc->di_aformat = XFS_DINODE_FMT_LOCAL;
-			} else  {
+			else
 				do_warn(_("would clear attr fork\n"));
-			}
 			*atotblocks = 0;
 			*anextents = 0;
 		}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
