Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 400ED7F67
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:15:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C763BAC001
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:15:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4r65W1CJlrBXKzAy for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:15:06 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 6/6 v2] xfs: Add support for FALLOC_FL_ZERO_RANGE
Date: Tue, 25 Feb 2014 20:14:39 +0100
Message-Id: <1393355679-11160-7-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu, xfs@oss.sgi.com

Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
functionality as xfs ioctl XFS_IOC_ZERO_RANGE.

We can also preallocate blocks past EOF in the same was as with
fallocate. Flag FALLOC_FL_KEEP_SIZE will cause the inode size to remain
the same even if we preallocate blocks past EOF.

It uses the same code to zero range as it is used by the
XFS_IOC_ZERO_RANGE ioctl.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 52f96e1..8fb97a6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -824,7 +824,7 @@ xfs_file_fallocate(
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
@@ -855,8 +855,11 @@ xfs_file_fallocate(
 				goto out_unlock;
 		}
 
-		error = xfs_alloc_file_space(ip, offset, len,
-					     XFS_BMAPI_PREALLOC);
+		if (mode & FALLOC_FL_ZERO_RANGE)
+			error = xfs_zero_file_space(ip, offset, len);
+		else
+			error = xfs_alloc_file_space(ip, offset, len,
+						     XFS_BMAPI_PREALLOC);
 		if (error)
 			goto out_unlock;
 	}
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
