Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B598C7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 11:41:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4979CAC002
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:41:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MXKoqdRhY59Ip5hJ for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:41:23 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3 v2] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append only
	file
Date: Tue, 15 Apr 2014 18:41:15 +0200
Message-Id: <1397580076-19826-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
References: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Currently punch hole and collapse range fallocate operation are not
allowed on append only file. This should be case for zero range as well.
Fix it by allowing only pure fallocate (possibly with keep size set).

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Change the condition to be future proof as suggested by hch

 fs/open.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 631aea81..fe48b2f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -254,11 +254,9 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EBADF;
 
 	/*
-	 * It's not possible to punch hole or perform collapse range
-	 * on append only file
+	 * We can only allow pure fallocate on append only files
 	 */
-	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
-	    && IS_APPEND(inode))
+	if (mode & ~FALLOC_FL_KEEP_SIZE && IS_APPEND(inode))
 		return -EPERM;
 
 	if (IS_IMMUTABLE(inode))
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
