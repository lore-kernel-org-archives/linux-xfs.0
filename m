Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56990 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbeJaFEx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 01:04:53 -0400
Subject: Re: [PATCH 2/7] repair: don't dirty inodes which are not unlinked
From: Eric Sandeen <sandeen@sandeen.net>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-3-david@fromorbit.com>
 <539a02d8-f9fd-e9b4-d928-dcdced642376@sandeen.net>
Message-ID: <a2aa0727-21db-fd2a-6207-0b70d05a7374@sandeen.net>
Date: Tue, 30 Oct 2018 15:09:56 -0500
MIME-Version: 1.0
In-Reply-To: <539a02d8-f9fd-e9b4-d928-dcdced642376@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

So I'm not stealing commits: ;)

===

repair: don't dirty inodes unconditionally when testing unlinked state

From: Dave Chinner <dchinner@redhat.com>

I noticed phase 4 writing back lots of inode buffers during recent
testing. The recent rework of clear_inode() in commit 0724d0f4cb53
("xfs_repair: clear_dinode should simply clear, not check contents")
accidentally caught a call to clear_inode_unlinked() as well,
resulting in all inodes being marked dirty whether then needed
updating or not.

Fix it by making clear_inode_unlinked unconditionally do the clear
(as was done for clear_inode), and move the test to the caller.
Add warnings as well so that this corruption is no longer silently
fixed.

Reported-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
[sandeen: rework so clear_inode_unlinked is unconditional]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
diff --git a/repair/dinode.c b/repair/dinode.c
index 379f85c..f466e77 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -125,23 +125,16 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 	return;
 }
 
-static int
+static void
 clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
 {
 
-	if (be32_to_cpu(dino->di_next_unlinked) != NULLAGINO)  {
-		if (!no_modify)
-			dino->di_next_unlinked = cpu_to_be32(NULLAGINO);
-		return(1);
-	}
-
-	return(0);
+	dino->di_next_unlinked = cpu_to_be32(NULLAGINO);
 }
 
 /*
  * this clears the unlinked list too so it should not be called
  * until after the agi unlinked lists are walked in phase 3.
- * returns > zero if the inode has been altered while being cleared
  */
 static void
 clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
@@ -2675,9 +2668,16 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	 * we're going to find.  check_dups is set to 1 only during
 	 * phase 4.  Ugly.
 	 */
-	if (check_dups && !no_modify) {
-		clear_dinode_unlinked(mp, dino);
-		*dirty += 1;
+	if (check_dups && be32_to_cpu(dino->di_next_unlinked) != NULLAGINO) {
+		if (no_modify) {
+			do_warn(
+	_("Would clear next_unlinked in inode %" PRIu64 "\n"), lino);
+		} else  {
+			clear_dinode_unlinked(mp, dino);
+			do_warn(
+	_("Cleared next_unlinked in inode %" PRIu64 "\n"), lino);
+			*dirty += 1;
+		}
 	}
 
 	/* set type and map type info */
