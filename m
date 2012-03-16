Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2GIabBr125519 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 13:36:38 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id fF5s67VSNAbSHwiu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Mar 2012 11:36:36 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so7081668yhj.26
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 11:36:35 -0700 (PDT)
From: Gerard Snitselaar <dev@snitselaar.org>
Subject: [PATCH] fs: xfs: fix section mismatch in linux-next
Date: Fri, 16 Mar 2012 11:36:18 -0700
Message-Id: <1331922978-28572-1-git-send-email-dev@snitselaar.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: bpm@sgi.com
Cc: xfs@oss.sgi.com, elder@kernel.org, linux-kernel@vger.kernel.org, xfs-master@oss.sgi.com

xfs_qm_exit() is called in init_xfs_fs().

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 fs/xfs/xfs_dquot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4be16a0..1155208 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1065,7 +1065,7 @@ out:
 	return -ENOMEM;
 }
 
-void __exit
+void
 xfs_qm_exit(void)
 {
 	kmem_zone_destroy(xfs_qm_dqtrxzone);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
