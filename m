Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9CNefOB061887 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 18:40:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22B841D7C608
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 16:42:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yPgODylpya4GXo5C for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 16:42:10 -0700 (PDT)
Date: Mon, 12 Oct 2009 19:42:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix double IRELE in xfs_dqrele_inode
Message-ID: <20091012234210.GA31892@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_dqrele_inode calls xfs_iput to release the ilock and a reference
and then also calls IRELE which does a second decrement of the reference
count.  This leads to a premature freeing of inodes when quotas were turned
off while the filesystem was mounted.

Thanks to Utako Kusaka for reporting the bug and provinding a good testcase.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>

Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-10-11 13:41:52.932012023 -0300
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2009-10-11 13:42:04.060016467 -0300
@@ -876,7 +876,6 @@ xfs_dqrele_inode(
 		ip->i_gdquot = NULL;
 	}
 	xfs_iput(ip, XFS_ILOCK_EXCL);
-	IRELE(ip);
 
 	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
