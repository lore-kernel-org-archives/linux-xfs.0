Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 895797F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 02:53:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 736318F8049
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 00:53:46 -0700 (PDT)
Date: Thu, 16 May 2013 10:53:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xfs: bug widening binary "not" operation
Message-ID: <20130516075330.GB7494@elgon.mountain>
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
Cc: Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

The problem here is:

	ioffset = offset & ~(rounding - 1);

"offset" and "ioffset" are type xfs_off_t (__s64) and "rounding" is
unsigned int.  The "offset & ~(rounding - 1)" clears the high 32 bits
and which is unintentional.

This is a static checker fix so I'm not sure how much difference this
makes in real life.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 1501f4f..9f557c6 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1453,7 +1453,7 @@ xfs_free_file_space(
 	xfs_mount_t		*mp;
 	int			nimap;
 	uint			resblks;
-	uint			rounding;
+	xfs_off_t		rounding;
 	int			rt;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_trans_t		*tp;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
