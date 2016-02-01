Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB6A37CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 09:41:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48ABDAC003
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 07:41:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y7PC2d2yveS04ZbB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Feb 2016 07:41:36 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 74278C0A9CE8
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 15:41:35 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-28.bos.redhat.com [10.18.41.28])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u11FfZdK005634
	for <xfs@oss.sgi.com>; Mon, 1 Feb 2016 10:41:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix xfs_log_ticket leak in xfs_end_io() after fs shutdown
Date: Mon,  1 Feb 2016 10:56:47 -0500
Message-Id: <1454342207-52734-1-git-send-email-bfoster@redhat.com>
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

If the filesystem has shut down, xfs_end_io() currently sets an error on
the ioend and proceeds to ioend destruction. The ioend might contain a
truncate transaction if the I/O extended the size of the file. This
transaction is only cleaned up in xfs_setfilesize_ioend(), however,
which is skipped in this case. This results in an xfs_log_ticket leak
message when the associate cache slab is destroyed (e.g., on rmmod).

This was originally reproduced by xfs/141 on a distro kernel. The
problem is reproducible on an upstream kernel, but not easily detected
in current upstream if the xfs_log_ticket cache happens to be merged
with another cache. This can be reproduced more deterministically with
the 'slab_nomerge' kernel boot option.

Update xfs_end_io() to proceed with normal end I/O processing after an
error is set on an ioend due to fs shutdown. The I/O type-based
processing is already designed to handle an I/O error and ensure that
the ioend is cleaned up correctly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 379c089..7bf8512 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -214,10 +214,12 @@ xfs_end_io(
 	struct xfs_inode *ip = XFS_I(ioend->io_inode);
 	int		error = 0;
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	/*
+	 * Set an error if the mount has shut down and proceed with end I/O
+	 * processing so it can perform whatever cleanups are necessary.
+	 */
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		ioend->io_error = -EIO;
-		goto done;
-	}
 
 	/*
 	 * For unwritten extents we need to issue transactions to convert a
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
