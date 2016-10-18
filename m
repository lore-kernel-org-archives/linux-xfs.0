Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51433 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932571AbcJRBye (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 21:54:34 -0400
Subject: [PATCH 1/2] man2/fallocate.2: document behavior with shared blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 17 Oct 2016 18:54:27 -0700
Message-ID: <147675566778.12400.16090171199161180354.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mtk.manpages@gmail.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-man@vger.kernel.org

Add a blurb to the fallocate manpage explaining that the fallocate
command with the UNSHARE mode flag may use CoW to unshare blocks to
guarantee that a disk write won't fail with ENOSPC.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man2/fallocate.2 |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/man2/fallocate.2 b/man2/fallocate.2
index 54d6340..3ed1460 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -79,6 +79,16 @@ but the file size will not be changed even if
 is greater than the file size.
 Preallocating zeroed blocks beyond the end of the file in this manner
 is useful for optimizing append workloads.
+
+If the
+.B FALLOC_FL_UNSHARE
+flag is specified in
+.IR mode ,
+shared file data extents will be made private to the file to guarantee
+that a subsequent write will not fail due to lack of space.
+Typically, this will be done by performing a copy-on-write operation on
+all shared data in the file.
+This flag may not be supported by all filesystems.
 .PP
 Because allocation is done in block size chunks,
 .BR fallocate ()

