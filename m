Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:50:38 -0400
Subject: [PATCH 10/12] xfs_io: repair_f should use its own name
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jun 2019 09:50:33 -0700
Message-ID: <156104943322.1172531.14877921651268434165.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
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
