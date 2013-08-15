Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C34B7F3F
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 00:53:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 751F4304066
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 22:53:53 -0700 (PDT)
Date: Thu, 15 Aug 2013 08:53:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xfs: check for underflow in xfs_iformat_fork()
Message-ID: <20130815055338.GC23580@elgon.mountain>
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
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

The "di_size" variable comes from the disk and it's a signed 64 bit.
We check the upper limit but we should check for negative numbers as
well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 123971b..849fc70 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -167,7 +167,8 @@ xfs_iformat_fork(
 			}
 
 			di_size = be64_to_cpu(dip->di_size);
-			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
+			if (unlikely(di_size < 0 ||
+				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
 				xfs_warn(ip->i_mount,
 			"corrupt inode %Lu (bad size %Ld for local inode).",
 					(unsigned long long) ip->i_ino,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
