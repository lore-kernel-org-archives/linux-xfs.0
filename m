Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8BDA729DFE
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 13:57:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E0D0AC002
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 11:57:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KysBIOr4ZYbKsuWJ for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 11:57:52 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append only file
Date: Fri, 11 Apr 2014 20:57:43 +0200
Message-Id: <1397242665-2183-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Currently punch hole and collapse range fallocate operation are not
allowed on append only file. This should be case for zero range as well.
Fix it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/open.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 631aea81..7882ff5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -254,10 +254,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EBADF;
 
 	/*
-	 * It's not possible to punch hole or perform collapse range
-	 * on append only file
+	 * It's not possible to punch hole, perform collapse range
+	 * or zero range on append only file
 	 */
-	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
+		    FALLOC_FL_ZERO_RANGE)
 	    && IS_APPEND(inode))
 		return -EPERM;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
