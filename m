Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39712 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTRQ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Feb 2019 12:16:28 -0500
Date: Wed, 20 Feb 2019 09:16:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs_io: actually check copy file range helper return
 values
Message-ID: <20190220171615.GM32253@magnolia>
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
 <b48c8b5d-9ed3-c4b6-c7fc-2c13df211dd3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b48c8b5d-9ed3-c4b6-c7fc-2c13df211dd3@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, schumaker.anna@gmail.com

From: Darrick J. Wong <darrick.wong@oracle.com>

We need to check the return value of copy_src_filesize and
copy_dst_truncate because either could return -1 due to fstat/ftruncate
failure.

Fixes: 628e112afdd98c5 ("xfs_io: implement 'copy_range' command")
Cc: schumaker.anna@gmail.com
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix return values and overflow problems
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
