Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34306 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCAX1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:27:06 -0500
Subject: [PATCH 02/23] xfs_io: actually check copy file range helper return
 values
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:01 -0800
Message-ID: <155148282102.16677.10679618728085405445.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, schumaker.anna@gmail.com

From: Darrick J. Wong <darrick.wong@oracle.com>

We need to check the return value of copy_src_filesize and
copy_dst_truncate because either could return -1 due to fstat/ftruncate
failure.

Fixes: 628e112afdd98c5 ("xfs_io: implement 'copy_range' command")
Cc: schumaker.anna@gmail.com
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/copy_file_range.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)


diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 4e2969c9..d069e5bb 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -120,11 +120,24 @@ copy_range_f(int argc, char **argv)
 		return 0;
 
 	if (src == 0 && dst == 0 && len == 0) {
-		len = copy_src_filesize(fd);
-		copy_dst_truncate();
+		off64_t	sz;
+
+		sz = copy_src_filesize(fd);
+		if (sz < 0 || (unsigned long long)sz > SIZE_MAX) {
+			ret = 1;
+			goto out;
+		}
+		len = sz;
+
+		ret = copy_dst_truncate();
+		if (ret < 0) {
+			ret = 1;
+			goto out;
+		}
 	}
 
 	ret = copy_file_range_cmd(fd, &src, &dst, len);
+out:
 	close(fd);
 	return ret;
 }
