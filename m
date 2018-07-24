Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51750 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388201AbeGXDiY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 23:38:24 -0400
Subject: [PATCH 1/2 V3] xfs_repair: notify user if free inodes contain errors
References: <b6f745ab-3016-9a95-3085-8584f7200b64@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <75f628bc-e8e7-b4fd-0bbb-fb3ca0fabac8@sandeen.net>
Date: Mon, 23 Jul 2018 19:34:13 -0700
MIME-Version: 1.0
In-Reply-To: <b6f745ab-3016-9a95-3085-8584f7200b64@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

xfs_repair checks allocated but unused (free) inodes in on-disk clusters,
and up until now silently repairs any errors, and as a result does not
alter exit status if errors are found.
    
The in-kernel verifiers will be noisy about these errors and instruct
the user to run repair, so it's best if repair is explicit about any
fixes it makes as a result.

To ensure we catch anything the kernel would complain about, re-use
xfs_dinode_verify to determine whether we must clear a free inode.

Note, however, that the verifier contains only a subset of the checks
currently in clear_dinode.  This should be ok; if it's not, the checks
should be added to the verifier in any case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a98483b..05c06a7 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -134,6 +134,7 @@
 #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
 
 #define xfs_verify_cksum		libxfs_verify_cksum
+#define xfs_dinode_verify		libxfs_dinode_verify
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
diff --git a/repair/dinode.c b/repair/dinode.c
index d36338f..c0db15a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2560,12 +2560,20 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		 */
 		if (was_free) {
 			/*
-			 * easy case, inode free -- inode and map agree, clear
+			 * easy case, inode free -- inode and map agree, check
 			 * it just in case to ensure that format, etc. are
 			 * set correctly
 			 */
-			if (!no_modify)
-				*dirty += clear_dinode(mp, dino, lino);
+			if (libxfs_dinode_verify(mp, lino, dino) != NULL) {
+				do_warn(
+ _("free inode %" PRIu64 " contains errors, "), lino);
+				if (!no_modify) {
+					*dirty += clear_dinode(mp, dino, lino);
+					do_warn(_("corrected\n"));
+				} else {
+					do_warn(_("would correct\n"));
+				}
+			}
 			*used = is_free;
 			return 0;
 		}

