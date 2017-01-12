Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45406 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdALDGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 22:06:52 -0500
Subject: [PATCH 3/5] xfs_io: prefix dedupe command error messages
 consistently
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Jan 2017 19:06:47 -0800
Message-ID: <148419040712.32674.16288936788225568096.stgit@birch.djwong.org>
In-Reply-To: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Prefix the perror output of the dedupe command consistently.  All the
other perror calls reference the ioctl name directly, so we might as
well do that for all the dedupe cases.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/reflink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/io/reflink.c b/io/reflink.c
index 41cb884..4c822b3 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -78,12 +78,12 @@ dedupe_ioctl(
 			goto done;
 		}
 		if (info->status < 0) {
-			fprintf(stderr, "dedupe: %s\n",
+			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
 					_(strerror(-info->status)));
 			goto done;
 		}
 		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
-			fprintf(stderr, "dedupe: %s\n",
+			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
 					_("Extents did not match."));
 			goto done;
 		}

