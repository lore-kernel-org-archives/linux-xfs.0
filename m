Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45142 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:28:57 -0400
Subject: [PATCH 5/6] xfs_io: repair_f should use its own name
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Jun 2019 12:28:51 -0700
Message-ID: <155993573179.2343365.6485890004354925274.stgit@magnolia>
In-Reply-To: <155993569512.2343365.15510991248022865602.stgit@magnolia>
References: <155993569512.2343365.15510991248022865602.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the repair command fails, it should tag the error message with its
own name ("repair").

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/io/scrub.c b/io/scrub.c
index 2ff1a6af..052497be 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -293,7 +293,7 @@ repair_ioctl(
 
 	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
 	if (error)
-		perror("scrub");
+		perror("repair");
 	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		printf(_("Corruption remains.\n"));
 	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)
