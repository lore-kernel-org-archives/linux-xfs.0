Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3OIxSpM075414 for <xfs@oss.sgi.com>; Sun, 24 Apr 2011 13:59:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4DE81D5F994
	for <xfs@oss.sgi.com>; Sun, 24 Apr 2011 12:02:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2gKQG7eLrbdlcEvu for
	<xfs@oss.sgi.com>; Sun, 24 Apr 2011 12:02:59 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QE4aA-0008N7-UA
	for xfs@oss.sgi.com; Sun, 24 Apr 2011 19:02:58 +0000
Date: Sun, 24 Apr 2011 15:02:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix compiler warning in xfs_trace.h
Message-ID: <20110424190258.GA32137@infradead.org>
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

xfs_fsblock_t may be a 32-bit type on if XFS_BIG_BLKNOS is not set,
make sure to cast a value of this type to an unsigned long long
before using the ll printk qualifier.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-04-22 06:22:11.409709360 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-04-22 06:22:30.756271218 +0200
@@ -1418,7 +1418,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		  __entry->wasfromfl,
 		  __entry->isfl,
 		  __entry->userdata,
-		  __entry->firstblock)
+		  (unsigned long long)__entry->firstblock)
 )
 
 #define DEFINE_ALLOC_EVENT(name) \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
