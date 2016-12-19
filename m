Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40887 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755249AbcLSTuY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2016 14:50:24 -0500
Date: Mon, 19 Dec 2016 11:50:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_io: prefix dedupe command error messages consistently
Message-ID: <20161219195020.GA5487@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Prefix the perror output of the dedupe command consistently.  All the
other perror calls reference the ioctl name directly, so we might as
well do that for all the dedupe cases.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/reflink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/reflink.c b/io/reflink.c
index d4c745c..dde26b8 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -79,12 +79,12 @@ dedupe_ioctl(
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
