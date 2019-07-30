Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34186 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfG3Mhu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 08:37:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so65632780wrm.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2019 05:37:49 -0700 (PDT)
Date: Tue, 30 Jul 2019 13:36:48 +0100
From: Sheriff Esseson <sheriffesseson@gmail.com>
Subject: [PATCH] xfs: design: Fix typo
Message-ID: <20190730123648.GA20126@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>

Replace "possible" with "possibly" and improve the flow of the phrase.

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---
 design/XFS_Filesystem_Structure/overview.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 mode change 100644 => 100755 design/XFS_Filesystem_Structure/overview.asciidoc

diff --git a/design/XFS_Filesystem_Structure/overview.asciidoc b/design/XFS_Filesystem_Structure/overview.asciidoc
old mode 100644
new mode 100755
index d15b50a..7628a7d
--- a/design/XFS_Filesystem_Structure/overview.asciidoc
+++ b/design/XFS_Filesystem_Structure/overview.asciidoc
@@ -28,7 +28,7 @@ record.  Both forks associate a logical offset with an extent of physical
 blocks, which makes sparse files and directories possible.  Directory entries
 and extended attributes are contained inside a second-level data structure
 within the blocks that are mapped by the forks.  This structure consists of
-variable-length directory or attribute records and possible a second B+tree to
+variable-length directory or attribute records and, possibly, a second B+tree to
 index these records.
 
 XFS employs a journalling log in which metadata changes are collected so that
-- 
2.22.0
