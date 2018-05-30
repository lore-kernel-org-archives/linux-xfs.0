Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50842 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753483AbeE3Pvq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 11:51:46 -0400
Subject: [PATCH 2/2] xfs_repair: notify user if free inodes contain errors
References: <4f70c5e0-8093-38b3-256d-ee16460aa4ad@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8a7acb77-f0ce-0b6d-cb2c-2dabcc2bab63@sandeen.net>
Date: Wed, 30 May 2018 10:51:45 -0500
MIME-Version: 1.0
In-Reply-To: <4f70c5e0-8093-38b3-256d-ee16460aa4ad@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

xfs_repair checks allocated but unused (free) inodes in on-disk clusters,
and up until now silently repairs any errors, and as a result does not
alter exit status if errors are found.

The in-kernel verifiers will be noisy about these errors and instruct
the user to run repair, so it's best if repair is explicit about any
fixes it makes.

This shamelessly re-uses xfs_dinode_verify for this purpose.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 63bf27e..0f68e58 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -134,6 +134,7 @@
  #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
  
  #define xfs_verify_cksum		libxfs_verify_cksum
+#define xfs_dinode_verify		libxfs_dinode_verify
  
  #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
  #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
diff --git a/repair/dinode.c b/repair/dinode.c
index 92130db..a4e3c51 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2448,9 +2448,15 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
  			 * it just in case to ensure that format, etc. are
  			 * set correctly
  			 */
-			if (!no_modify) {
-				clear_dinode(mp, dino, lino);
-				*dirty += 1;
+			if (libxfs_dinode_verify(mp, lino, dino) != NULL) {
+				do_warn(
+	_("free inode %" PRIu64 " contains errors, "), lino);
+				if (!no_modify) {
+					clear_dinode(mp, dino, lino);
+					do_warn(_("corrected\n"));
+					*dirty += 1;
+				} else
+					do_warn(_("would correct\n"));
  			}
  			*used = is_free;
  			return 0;

