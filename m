Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N8TFPx164707 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 03:29:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38E051DA1889
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 01:29:14 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UNiNAa8BDluR7jEv for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 01:29:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QvmMD-00064e-MF
	for xfs@oss.sgi.com; Tue, 23 Aug 2011 08:29:13 +0000
Message-Id: <20110823082913.640125155@bombadil.infradead.org>
Date: Tue, 23 Aug 2011 04:28:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/11] xfs: wait for I/O completion when writing out pages in
	xfs_setattr_size
References: <20110823082802.335389799@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-setattr-wait-for-writeback
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The current code relies on the xfs_ioend_wait call later on to make sure
all I/O actually has completed.  The xfs_ioend_wait call will go away soon,
so prepare for that by using the waiting filemap function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2011-08-13 09:18:59.458202448 -0700
+++ xfs/fs/xfs/xfs_iops.c	2011-08-13 09:19:21.664748812 -0700
@@ -825,8 +825,8 @@ xfs_setattr_size(
 	 * care about here.
 	 */
 	if (ip->i_size != ip->i_d.di_size && iattr->ia_size > ip->i_d.di_size) {
-		error = xfs_flush_pages(ip, ip->i_d.di_size, iattr->ia_size,
-					XBF_ASYNC, FI_NONE);
+		error = xfs_flush_pages(ip, ip->i_d.di_size, iattr->ia_size, 0,
+					FI_NONE);
 		if (error)
 			goto out_unlock;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
