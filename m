Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34368 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932531AbdHWTw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 15:52:29 -0400
Date: Wed, 23 Aug 2017 12:52:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ioctl_getfsmap.2: correct semantics of FMR_OF_LAST flag
Message-ID: <20170823195225.GF4794@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: linux-api@vger.kernel.org, linux-man@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

The FMR_OF_LAST flag is applied to the last record in the returned
dataset, which is not necessarily the last record in the filesystem.
Correct the documentation to reflect the actual behavior of both
getfsmap implementations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man2/ioctl_getfsmap.2 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man2/ioctl_getfsmap.2 b/man2/ioctl_getfsmap.2
index 2a3cf06..047a624 100644
--- a/man2/ioctl_getfsmap.2
+++ b/man2/ioctl_getfsmap.2
@@ -225,7 +225,7 @@ The
 field contains a special value instead of an inode number.
 .TP
 .B FMR_OF_LAST
-This is the last record in the filesystem.
+This is the last record in the data set.
 .RE
 .PP
 The
