Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55E967F5D
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 09:49:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D796AAC014
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 07:49:39 -0700 (PDT)
Received: from mail-bk0-f41.google.com (mail-bk0-f41.google.com
	[209.85.214.41]) by cuda.sgi.com with ESMTP id Swgyt0ElyEON7qvK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Oct 2013 07:49:38 -0700 (PDT)
Received: by mail-bk0-f41.google.com with SMTP id na10so2707397bkb.14
	for <xfs@oss.sgi.com>; Tue, 01 Oct 2013 07:49:37 -0700 (PDT)
From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH] xfs: Use kmem_free() instead of free()
Date: Tue,  1 Oct 2013 16:47:53 +0200
Message-Id: <1380638873-5181-1-git-send-email-treding@nvidia.com>
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
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

This fixes a build failure caused by calling the free() function which
does not exist in the Linux kernel.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4324058..3979749 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1585,7 +1585,7 @@ xlog_recover_add_to_trans(
 		"bad number of regions (%d) in inode log format",
 				  in_f->ilf_size);
 			ASSERT(0);
-			free(ptr);
+			kmem_free(ptr);
 			return XFS_ERROR(EIO);
 		}
 
-- 
1.8.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
