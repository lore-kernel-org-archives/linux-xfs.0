Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46488 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:46:21 -0400
Subject: [PATCH 5/9] xfs_spaceman: print a nicer message when the file path
 isn't on an xfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:02 -0700
Message-ID: <152401956294.13048.1815463748899965760.stgit@magnolia>
In-Reply-To: <152401952391.13048.15040850425873030425.stgit@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the file path passed in is not something on an xfs filesystem, print
a nice message about that instead of yelling about ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/spaceman/file.c b/spaceman/file.c
index 4c13b4a..4f9f66c 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -69,7 +69,8 @@ openfile(
 	}
 
 	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
-		perror("XFS_IOC_FSGEOMETRY");
+		fprintf(stderr, _("%s: Not on a mounted XFS filesystem.\n"),
+				path);
 		close(fd);
 		return -1;
 	}

