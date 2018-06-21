Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932922AbeFUTzj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 15:55:39 -0400
Date: Thu, 21 Jun 2018 12:55:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_bmap: remove -c from manpage
Message-ID: <20180621195524.GH4838@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

There is no -c switch so remove the documentation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_bmap.8 |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
index ae923481..dd925b12 100644
--- a/man/man8/xfs_bmap.8
+++ b/man/man8/xfs_bmap.8
@@ -36,10 +36,6 @@ no matter what the filesystem's block size is.
 If this option is specified, information about the file's
 attribute fork is printed instead of the default data fork.
 .TP
-.B \-c
-If this option is specified, information about the file's
-copy on write fork is printed instead of the default data fork.
-.TP
 .B \-d
 If portions of the file have been migrated offline by
 a DMAPI application, a DMAPI read event will be generated to
