Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3D827F72
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 05:10:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F0C2AC001
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 03:10:38 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id ueDl4TEqdlyIafPw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Aug 2013 03:10:36 -0700 (PDT)
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Wed, 7 Aug 2013 04:10:36 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 6DA7F1FF0043
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 04:05:10 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r77AAY3d372176 for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 04:10:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r77AAXuw029705
	for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 04:10:34 -0600
From: zwu.kernel@gmail.com
Subject: [PATCH 08/12] xfs: fix the comment of xfs_btree_get_iroot()
Date: Wed,  7 Aug 2013 18:11:05 +0800
Message-Id: <1375870269-13157-9-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
References: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
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
 fs/xfs/xfs_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index eccc788..ae106f6 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -510,7 +510,7 @@ xfs_btree_ptr_addr(
 }
 
 /*
- * Get a the root block which is stored in the inode.
+ * Get the root block which is stored in the inode.
  *
  * For now this btree implementation assumes the btree root is always
  * stored in the if_broot field of an inode fork.
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
