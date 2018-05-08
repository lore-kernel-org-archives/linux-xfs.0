Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754736AbeEHQbo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:31:44 -0400
Date: Tue, 8 May 2018 09:31:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 09/11] xfs_repair: actually fix .. entries that point to
 inode zero
Message-ID: <20180508163124.GM11261@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401964787.13319.7143262291746238151.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401964787.13319.7143262291746238151.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we encounter a directory with an entry that points to inode zero,
we'll crash due to an ASSERT during process_inode_chunk.  This is due to
process_dir2_data not arranging for phase 6 to fix the parent pointer
when '..' -> 0, so do that.  Found via xfs/386 fuzzing bu[1].inumber to
zero.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dir2.c            |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d588f342..56f9f8ca 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -78,6 +78,7 @@
 #define xfs_bmbt_get_all		libxfs_bmbt_get_all
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_verify_rtbno		libxfs_verify_rtbno
+#define xfs_verify_ino			libxfs_verify_ino
 #define xfs_zero_extent			libxfs_zero_extent
 
 #define xfs_defer_init			libxfs_defer_init
diff --git a/repair/dir2.c b/repair/dir2.c
index fbe88b50..f0371371 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -847,6 +847,23 @@ _("bad .. entry in root directory inode %" PRIu64 ", was %" PRIu64 ": "),
 					}
 					*parent = ino;
 				}
+				/*
+				 * Make sure our parent pointer doesn't point
+				 * off into space.
+				 */
+				if (!junkit &&
+				    *parent != NULLFSINO &&
+				    !libxfs_verify_ino(mp, *parent)) {
+					do_warn(
+_("bad .. entry in directory inode %" PRIu64 ", was %" PRIu64 ": "),
+						ino, *parent);
+					if (!no_modify) {
+						do_warn(_("correcting\n"));
+					} else {
+						do_warn(_("would correct\n"));
+					}
+					*parent = NULLFSINO;
+				}
 			}
 			/*
 			 * Can't fix the directory unless we know which ..
