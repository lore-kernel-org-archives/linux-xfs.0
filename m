Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QF7Upd131542 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 10:07:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 766C51684A96
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 08:07:35 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BEZSbV89g6ng47XI for <xfs@oss.sgi.com>;
	Tue, 26 Jul 2011 08:07:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QljEH-0004ip-Hu
	for xfs@oss.sgi.com; Tue, 26 Jul 2011 15:07:29 +0000
Date: Tue, 26 Jul 2011 11:07:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: optimize the negative xattr caching
Message-ID: <20110726150729.GC18000@infradead.org>
References: <20110726150633.GA17400@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110726150633.GA17400@infradead.org>
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

Since the addition of file capabilities every write needs to read xattrs to
check if we have any capabilities to clear.  In Linux 3.0 Andi Kleen added
a flag to cache the fact that we do not have any attributes on an inode.
Make sure to already mark a file as not having any attributes when reading
it from disk in case it doesn't even have an attribute fork.  Based on an
earlier patch from Andi Kleen.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2011-07-25 23:49:23.011563852 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2011-07-25 23:49:50.281563691 +0200
@@ -1194,9 +1194,14 @@ xfs_setup_inode(
 		break;
 	}
 
-	/* if there is no attribute fork no ACL can exist on this inode */
-	if (!XFS_IFORK_Q(ip))
+	/*
+	 * If there is no attribute fork no ACL can exist on this inode,
+	 * and it can't have any file capabilities attached to it either.
+	 */
+	if (!XFS_IFORK_Q(ip)) {
+		inode_has_no_xattr(inode);
 		cache_no_acl(inode);
+	}
 
 	xfs_iflags_clear(ip, XFS_INEW);
 	barrier();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
