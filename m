Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50348 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfCNVEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:04:44 -0400
Subject: [PATCH 07/36] xfs_io: actually check copy file range helper return
 values
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:04:26 -0700
Message-ID: <155259746648.31886.15984241616376190830.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

We need to check the return value of copy_src_filesize and
copy_dst_truncate because either could return -1 due to fstat/ftruncate
failure.

Fixes: 628e112afdd98c5 ("xfs_io: implement 'copy_range' command")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
