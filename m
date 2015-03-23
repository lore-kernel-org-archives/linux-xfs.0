Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DC127F47
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 00:06:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C477304032
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 22:06:39 -0700 (PDT)
Received: from mail-yh0-f68.google.com (mail-yh0-f68.google.com
	[209.85.213.68]) by cuda.sgi.com with ESMTP id XncIBwDRfRmbf6CP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 22 Mar 2015 22:06:37 -0700 (PDT)
Received: by yhab6 with SMTP id b6so4821557yha.3
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 22:06:37 -0700 (PDT)
From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Subject: [PATCH] xfs: use GFP_NOFS argument in radix_tree_preload
Date: Mon, 23 Mar 2015 01:06:23 -0400
Message-Id: <1427087183-20391-1-git-send-email-sanidhya.gatech@gmail.com>
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
To: david@fromorbit.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, sanidhya@gatech.edu, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, blee@gatech.edu, csong84@gatech.edu, changwoo@gatech.edu

From: Byoungyoung Lee <blee@gatech.edu>

Following the convention of other file systems, GFP_NOFS
should be used as an argument for radix_tree_preload() instead
of GFP_KERNEL.

Signed-off-by: Byoungyoung Lee <blee@gatech.edu>
Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
---
 fs/xfs/xfs_mru_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 30ecca3..f8a674d 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -437,7 +437,7 @@ xfs_mru_cache_insert(
 	if (!mru || !mru->lists)
 		return -EINVAL;
 
-	if (radix_tree_preload(GFP_KERNEL))
+	if (radix_tree_preload(GFP_NOFS))
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&elem->list_node);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
