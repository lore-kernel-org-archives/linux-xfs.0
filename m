Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751690AbdF2RKH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 13:10:07 -0400
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH] xfs_spaceman: fix potential overflowing expression in trim_f()
Date: Thu, 29 Jun 2017 12:10:05 -0500
Message-Id: <20170629171005.9886-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net

Prevent the potential overflow in expression calculating offset
in trim_f(() by casting the first variable to off64_t (64bit signed).

Detected by CoverityScan, CID#1413771 Integer handling issues (OVERFLOW_BEFORE_WIDEN)

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 spaceman/trim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/spaceman/trim.c b/spaceman/trim.c
index 872f68d3..6df9e6a9 100644
--- a/spaceman/trim.c
+++ b/spaceman/trim.c
@@ -77,7 +77,7 @@ trim_f(
 		length = cvtnum(file->geom.blocksize, file->geom.sectsize,
 				argv[optind + 1]);
 	} else if (agno) {
-		offset = agno * file->geom.agblocks * file->geom.blocksize;
+		offset = (off64_t)agno * file->geom.agblocks * file->geom.blocksize;
 		length = file->geom.agblocks * file->geom.blocksize;
 	} else {
 		offset = 0;
-- 
2.13.0

