Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n04GgCVZ016981 for <xfs@oss.sgi.com>; Sun, 4 Jan 2009 10:42:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D21B5E0D1
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2009 08:42:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lr8DYrjNUivsTDAB for
	<xfs@oss.sgi.com>; Sun, 04 Jan 2009 08:42:12 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LJW3H-00046U-J9
	for xfs@oss.sgi.com; Sun, 04 Jan 2009 16:42:11 +0000
Date: Sun, 4 Jan 2009 11:42:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] sanity check attr fork size
Message-ID: <20090104164211.GA15734@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Recently we have quite a few kerneloops reports about dereferencing a NULL
if_data in the attribute fork.  From looking over the code this can only
happen if we pass a 0 size argument to xfs_iformat_local.  This implies some
sort of corruption and in fact the only mailinglist report about this from
earlier this year was after a powerfail presumably on a system with write
cache and without barriers.

Add a quick sanity check for the attr fork size in xfs_iformat to catch
these early and without an oops.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2009-01-04 17:35:11.955671640 +0100
+++ linux-2.6/fs/xfs/xfs_inode.c	2009-01-04 17:38:04.643673527 +0100
@@ -424,6 +424,19 @@ xfs_iformat(
 	case XFS_DINODE_FMT_LOCAL:
 		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		size = be16_to_cpu(atp->hdr.totsize);
+
+		if (unlikely(size < sizeof(struct xfs_attr_sf_hdr))) {
+			xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
+				"corrupt inode %Lu "
+				"(bad attr fork size %Ld).",
+				(unsigned long long) ip->i_ino,
+				(long long) size);
+			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
+					     XFS_ERRLEVEL_LOW,
+					     ip->i_mount, dip);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
