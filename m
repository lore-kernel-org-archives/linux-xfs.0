Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965082AbcIPUsR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Sep 2016 16:48:17 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs.xfs: clarify ftype defaults in manpage
Message-ID: <1f98ea1d-893c-d1c0-2307-3f5a9b478238@redhat.com>
Date: Fri, 16 Sep 2016 15:48:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org
Cc: Chris Murphy <chris@cmurf.com>

When CRCs were made default, a few leftovers related to its
prior non-default status remained in the manpage, in the ftype
section.  Clean those up.

Reported-by: Chris Murphy <chris@cmurf.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 9578c4d..033bc36 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -636,13 +636,13 @@ do not need to look up the inode to determine the inode type.
 
 The
 .I value
-is either 0 or 1, with 1 signifiying that filetype information
-will be stored in the directory structure. The default value is 0.
+is either 0 or 1, with 1 signifying that filetype information
+will be stored in the directory structure.
 
-When CRCs are enabled via
-.B \-m crc=1,
-the ftype functionality is always enabled. This feature can not be turned
-off for such filesystem configurations.
+When CRCs are enabled (the default), the ftype functionality is always
+enabled, and cannot be turned off. If CRCs are disabled with
+.B \-m crc=0,
+the ftype functionality is disabled by default.
 .IP
 .RE
 .TP


