Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753769AbeEWDbb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 23:31:31 -0400
Date: Tue, 22 May 2018 20:31:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 5/9] xfs_spaceman: print a nicer message when the file
 path isn't on an xfs
Message-ID: <20180523033117.GJ14384@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401956294.13048.1815463748899965760.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401956294.13048.1815463748899965760.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the file path passed in is not something on an xfs filesystem, print
a nice message about that instead of yelling about ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/file.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/spaceman/file.c b/spaceman/file.c
index 4c13b4a8..23f8be1c 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -69,7 +69,12 @@ openfile(
 	}
 
 	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
-		perror("XFS_IOC_FSGEOMETRY");
+		if (errno == ENOTTY)
+			fprintf(stderr,
+_("%s: Not on a mounted XFS filesystem.\n"),
+					path);
+		else
+			perror("XFS_IOC_FSGEOMETRY");
 		close(fd);
 		return -1;
 	}
