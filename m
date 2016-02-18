Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 421D87CA5
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 14:55:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 276F48F8035
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 12:55:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HNZojcjBtOHv8WM4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2016 12:55:31 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id A012EC00FBB0
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 20:55:30 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1IKtT2r004011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 15:55:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libxfs: fix up mismerge in libxfs_iflush_int
Message-ID: <56C62FC1.60205@redhat.com>
Date: Thu, 18 Feb 2016 14:55:29 -0600
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

XFS_ISDIR is a bool, don't compare it to S_IFDIR

e37bf5 xfs: mode di_mode to vfs inode had a small mis-merge
from kernelspace, when moving from

	if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) 
to
	if (XFS_ISDIR(ip) == S_IFDIR

that "==" should have been dropped.

Signed-off-by: ERic Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/util.c b/libxfs/util.c
index 576f954..f3b9895 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -420,7 +420,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	if (XFS_ISREG(ip)) {
 		ASSERT( (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS) ||
 			(ip->i_d.di_format == XFS_DINODE_FMT_BTREE) );
-	} else if (XFS_ISDIR(ip) == S_IFDIR) {
+	} else if (XFS_ISDIR(ip)) {
 		ASSERT( (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS) ||
 			(ip->i_d.di_format == XFS_DINODE_FMT_BTREE)   ||
 			(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) );

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
