Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F6BE7CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 06:11:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3380B304032
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 04:11:45 -0700 (PDT)
Received: from mail-pa0-f66.google.com (mail-pa0-f66.google.com
	[209.85.220.66]) by cuda.sgi.com with ESMTP id OGsEbKNy42GiQyRL
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2016 04:11:43 -0700 (PDT)
Received: by mail-pa0-f66.google.com with SMTP id us13so3756996pab.1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 04:11:43 -0700 (PDT)
Date: Wed, 22 Jun 2016 19:11:37 +0800
From: Kaho Ng <ngkaho1234@gmail.com>
Subject: [PATCH v3] xfs: indentation fix in xfs_btree_get_iroot()
Message-ID: <20160622191137.26d0725d@zenbook.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The indentation in this function is different from the other functions.
Those spacebars are converted to tabs to improve readability.

Signed-off-by: Kaho Ng <ngkaho1234@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 1f88e1c..4f84dde 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -543,12 +543,12 @@ xfs_btree_ptr_addr(
  */
 STATIC struct xfs_btree_block *
 xfs_btree_get_iroot(
-       struct xfs_btree_cur    *cur)
+	struct xfs_btree_cur	*cur)
 {
-       struct xfs_ifork        *ifp;
+	struct xfs_ifork	*ifp;
 
-       ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
-       return (struct xfs_btree_block *)ifp->if_broot;
+	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
 /*
-- 
2.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
