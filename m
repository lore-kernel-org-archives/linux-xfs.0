Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD6FC7F90
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 07:55:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87E13304067
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 05:55:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	U7GCoXT625VLCx7l for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 05:55:05 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] repair: get rid of BADFSINO
Date: Tue,  1 Jul 2014 22:54:56 +1000
Message-Id: <1404219296-29302-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1404219296-29302-1-git-send-email-david@fromorbit.com>
References: <1404219296-29302-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When we find a bad dirent, we "clear" the inode the inode number by
writing BADFSINO to the inode number in the entry:

#define BADFSINO        ((xfs_ino_t)0xfeffffffffffffffULL)

We then capture this bad inode number later in the same function
either in the same pass or in a later phase and junk the entry.
When we junk the entry, we write a "/" over the first character of
the dirent name, which is then detected up later by the directory
rebuild and ignored.

The issue with this is that the directory buffer can be written to
disk between the dirent being marked with BADFSINO and the directory
rebuild processing in phase 6, resulting in the directory block
verifier firing this error:

Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
Metadata corruption detected at block 0x11fbb698/0x1000
libxfs_writebufr: write verifer failed on bno 0x11fbb698/0x1000

And so will not write the *corrupt block* to disk. The result is
that we don't repair a corruption in the directory block correctly
and subsequent repair runs continue to find problems with the
directory.

We really don't need both BADFSINO *and* overwriting the dirent name
with "/" to mark an entry as junked. They both mean exactly the same
thing, so get rid of BADFSINO and only use the name junking to mark
dirents as bad. This prevents the directory data block verifier from
triggering on bad inode numbers, and so the later reread of the
block will find the junked entries correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dir2.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 14c1435..ef0d377 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -28,13 +28,6 @@
 #include "progress.h"
 
 /*
- * Tag bad directory entries with this.
- * We can't tag them with -1 since that will look like a
- * data_unused_t instead of a data_entry_t.
- */
-#define	BADFSINO	((xfs_ino_t)0xfeffffffffffffffULL)
-
-/*
  * Known bad inode list.  These are seen when the leaf and node
  * block linkages are incorrect.
  */
@@ -1314,7 +1307,7 @@ process_dir2_data(
 		 * Conditions must either set clearino to zero or set
 		 * clearreason why it's being cleared.
 		 */
-		if (!ino_discovery && ent_ino == BADFSINO) {
+		if (!ino_discovery && dep->name[0] == '/') {
 			/*
 			 * Don't do a damned thing.  We already found this
 			 * (or did it ourselves) during phase 3.
@@ -1401,8 +1394,7 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64
 				do_warn(
 _("\tclearing inode number in entry at offset %" PRIdPTR "...\n"),
 					(intptr_t)ptr - (intptr_t)d);
-				dep->inumber = cpu_to_be64(BADFSINO);
-				ent_ino = BADFSINO;
+				dep->name[0] = '/';
 				*dirty = 1;
 			} else {
 				do_warn(
@@ -1415,7 +1407,7 @@ _("\twould clear inode number in entry at offset %" PRIdPTR "...\n"),
 		 * discovery is turned on).  Otherwise, we'd complain a lot
 		 * during phase 4.
 		 */
-		junkit = ent_ino == BADFSINO;
+		junkit = dep->name[0] == '/';
 		nm_illegal = namecheck((char *)dep->name, dep->namelen);
 		if (ino_discovery && nm_illegal) {
 			do_warn(
@@ -1427,11 +1419,11 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has ille
 		/*
 		 * Now we can mark entries with BADFSINO's bad.
 		 */
-		if (!no_modify && ent_ino == BADFSINO) {
-			dep->name[0] = '/';
+		if (!no_modify && dep->name[0] == '/') {
 			*dirty = 1;
 			junkit = 0;
 		}
+
 		/*
 		 * Special .. entry processing.
 		 */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
