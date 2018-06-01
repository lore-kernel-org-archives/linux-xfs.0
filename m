Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52656 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeFAALy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 20:11:54 -0400
Date: Thu, 31 May 2018 17:11:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_io: fix signed comparison problem in copy_file_range
Message-ID: <20180601001139.GG7825@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

cvtnum() returns a signed long long, so the type of 'len' should be a
signed type so that a user entering a negative length doesn't produce
some huge positive integer.  The negative len check demands it anyway.

Coverity-id: 1435895
Fixes: 25b4549c8b54134106cff094aa098eab9e86eee7
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/copy_file_range.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index ebd1ec76..4d0770ef 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -91,7 +91,7 @@ copy_range_f(int argc, char **argv)
 {
 	long long src = 0;
 	long long dst = 0;
-	size_t len = 0;
+	long long len = 0;
 	int opt;
 	int ret;
 	int fd;
