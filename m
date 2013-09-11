Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D30667F37
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 16:17:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C28A88F8040
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 14:17:44 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id TZZHpo0M3UmsgqbK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Sep 2013 14:17:43 -0700 (PDT)
Date: Thu, 12 Sep 2013 00:17:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xfs: = vs == typo in ASSERT()
Message-ID: <20130911211731.GA10527@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>
Cc: Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

There is a '=' vs '==' typo so the ASSERT()s are always true.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Introduced in 21b5c9784b ('xfs: swap extents operations for CRC
filesystems')

diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 531b020..bb8de8e 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -957,9 +957,9 @@ xfs_bmbt_change_owner(
 	ASSERT(tp || buffer_list);
 	ASSERT(!(tp && buffer_list));
 	if (whichfork == XFS_DATA_FORK)
-		ASSERT(ip->i_d.di_format = XFS_DINODE_FMT_BTREE);
+		ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_BTREE);
 	else
-		ASSERT(ip->i_d.di_aformat = XFS_DINODE_FMT_BTREE);
+		ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE);
 
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
