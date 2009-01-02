Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n02A39bi016919 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 04:03:10 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76B9D59390
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 02:03:08 -0800 (PST)
Received: from parsec.stupidest.org (splinter.f00f.org [216.75.21.205]) by
	cuda.sgi.com with ESMTP id Z1OJhZ17qxE6vcz9 for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 02:03:08 -0800 (PST)
Received: from stupidest.org (unknown [10.0.1.1])
	by parsec.stupidest.org (Postfix) with ESMTP id 25B74AEFA4
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 02:03:07 -0800 (PST)
Date: Fri, 2 Jan 2009 02:03:06 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: [PATCH] fix xfs_fsr insufficient space check
Message-ID: <20090102100306.GA36830@puku.stupidest.org>
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

The xfs_fsr insufficient check should consider the blocks used not the
file length.  Without this change it is not possible to reorganize
sparse files when file size exceeds the free space.

Signed-off-by: Chris Wedgwood <cw@f00f.org>


--- fsr/xfs_fsr.c.orig	2009-01-02 01:51:03.049181411 -0800
+++ fsr/xfs_fsr.c	2009-01-02 01:53:56.297180891 -0800
@@ -912,9 +912,9 @@
 	}
 	bsize = vfss.f_frsize ? vfss.f_frsize : vfss.f_bsize;
 
-	if (statp->bs_size > ((vfss.f_bfree * bsize) - minimumfree)) {
+	if ((statp->bs_blksize * statp->bs_blocks) > ((vfss.f_bfree * bsize) - minimumfree)) {
 		fsrprintf(_("insufficient freespace for: %s: "
-			"size=%lld: ignoring\n"), fname, statp->bs_size);
+			"size=%lld: ignoring\n"), fname, statp->bs_blksize * statp->bs_blocks);
 		return 1;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
