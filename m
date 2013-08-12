Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B73E07F61
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 22:17:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96321304032
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 20:17:43 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id PwTXCMZ6ZNDgFSpR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 20:17:42 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Sun, 11 Aug 2013 23:17:41 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 709CFC90026
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:37 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7C3HdJZ110186 for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:39 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r7C3HcAC026149 for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 00:17:38 -0300
From: zwu.kernel@gmail.com
Subject: [PATCH 08/12] xfs: fix the comment of xfs_ifree_cluster()
Date: Mon, 12 Aug 2013 11:14:59 +0800
Message-Id: <1376277303-29455-9-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
References: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
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
To: xfs@oss.sgi.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ccca9cd..520e200 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1861,7 +1861,7 @@ xfs_iunlink_remove(
 }
 
 /*
- * A big issue when freeing the inode cluster is is that we _cannot_ skip any
+ * A big issue when freeing the inode cluster is that we _cannot_ skip any
  * inodes that are in memory - they all must be marked stale and attached to
  * the cluster buffer.
  */
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
