Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56296 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbeJaE6e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 00:58:34 -0400
Subject: Re: [PATCH 2/7] repair: don't dirty inodes which are not unlinked
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-3-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <539a02d8-f9fd-e9b4-d928-dcdced642376@sandeen.net>
Date: Tue, 30 Oct 2018 15:03:38 -0500
MIME-Version: 1.0
In-Reply-To: <20181030112043.6034-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 10/30/18 6:20 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I noticed phase 4 writing back lots of inode buffers during recent
> testing. The recent rework of clear_inode() in commit 0724d0f4cb53
> ("xfs_repair: clear_dinode should simply clear, not check contents")
> accidentally caught a call to clear_inode_unlinked() as well,
> resulting in all inodes being marked dirty whether then needed
> updating or not.
> 
> Fix it by reverting the erroneous hunk and adding warnings so taht
> this corruption is no longer silently fixed.

I find it confusing that "clear_dinode_unlinked" may or may not clear
unlinked.  Can we change it to actually do as it's named, and move the
test to the (one) caller where it's needed, something like:

===

repair: don't dirty inodes unconditionally when testing unlinked state

Dave noticed phase 4 writing back lots of inode buffers during recent
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
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(I can keep Dave's SOB if preferred with a [sandeen: do it different]
tag if this looks ok and that approach is preferred)

(this also fixes unlinked_next lysdexia in the warnings)

diff --git a/repair/dinode.c b/repair/dinode.c
index 379f85c..c0fa3df 100644
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
