Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41399 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932743AbdIRQjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 12:39:49 -0400
Date: Mon, 18 Sep 2017 09:39:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: handle missing extent states
Message-ID: <20170918163944.GC6540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, amir73il@gmail.com

Missed a couple of the new extent states in the bmbt processing, so add
them to avoid aborting xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/repair/dinode.c b/repair/dinode.c
index f817b5a..b35a523 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -796,6 +796,7 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 			case XR_E_FS_MAP:
 			case XR_E_INO:
 			case XR_E_INUSE_FS:
+			case XR_E_REFC:
 				do_warn(
 _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 					forkname, ino, b);
@@ -812,6 +813,12 @@ _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
 					forkname, ftype, ino, b);
 				goto done;
 
+			case XR_E_COW:
+				do_warn(
+_("%s fork in %s inode %" PRIu64 " claims CoW block %" PRIu64 "\n"),
+					forkname, ftype, ino, b);
+				goto done;
+
 			default:
 				do_error(
 _("illegal state %d in block map %" PRIu64 "\n"),
