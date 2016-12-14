Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx141.netapp.com ([216.240.21.12]:9155 "EHLO mx141.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753398AbcLNVcP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 16:32:15 -0500
From: Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH v2] xfs_io: Improvements to copy_range return code handling
Date: Wed, 14 Dec 2016 16:28:46 -0500
Message-ID: <20161214212846.22198-1-Anna.Schumaker@Netapp.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com

If copy_file_range() returns 0, then that means no data was copied.  We
should break out of the loop in this case to prevent looping
indefinitely.

Additionally, if an error is returned by copy_file_range() then we need
to print out the string form to be used by error checking tests in
xfstests.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
---
v2:
- Use perror() instead of fprintf()
---
 io/copy_file_range.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 88203e9..249c649 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -49,8 +49,11 @@ copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
 
 	do {
 		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst, len, 0);
-		if (ret == -1)
+		if (ret == -1) {
+			perror("copy_range");
 			return errno;
+		} else if (ret == 0)
+			break;
 		len -= ret;
 	} while (len > 0);
 
-- 
2.10.2

