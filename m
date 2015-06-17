Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FC477F95
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 14:24:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0044A30405F
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 12:24:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fbYFBWjdJ4Y5mOzP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 12:24:21 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 09DB2BC922
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 19:24:20 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5HJOImH022320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 15:24:19 -0400
Message-ID: <5581C962.7020200@redhat.com>
Date: Wed, 17 Jun 2015 14:24:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_copy: fix copy of hard 4k devices
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
To: xfs-oss <xfs@oss.sgi.com>

If we have a pure 4k device with no 512 emulation, xfs_copy
fails straightaway because it tries to do a 512-byte direct
IO read of the superblock.

Do like we do in xfs_db, and read in the max possible sector size,
because we don't yet know what the filesystem's sector size is.

This fixes a failure in xfs/032 on a hard 4k device.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 279527c..b39c84d 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -654,8 +654,9 @@ main(int argc, char **argv)
 
 	memset(&mbuf, 0, sizeof(xfs_mount_t));
 	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
-	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR, 1, 0,
-							&xfs_sb_buf_ops);
+	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
+			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT),
+			     0, &xfs_sb_buf_ops);
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
