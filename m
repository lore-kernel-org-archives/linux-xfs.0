Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U8J1lv011437 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 02:19:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E27C2CE2DB
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 00:18:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7DjrxL9SbrV9ltzH for
	<xfs@oss.sgi.com>; Fri, 30 Jan 2009 00:18:20 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LSoZw-0008V7-Jg
	for xfs@oss.sgi.com; Fri, 30 Jan 2009 08:18:20 +0000
Date: Fri, 30 Jan 2009 03:18:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsdump: small update for CHANGES
Message-ID: <20090130081820.GA29564@infradead.org>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsdump-dev/doc/CHANGES
===================================================================
--- xfsdump-dev.orig/doc/CHANGES	2009-01-30 09:15:46.769299222 +0100
+++ xfsdump-dev/doc/CHANGES	2009-01-30 09:17:21.546298900 +0100
@@ -6,6 +6,8 @@ xfsdump-3.0.0
 	  headers and libraries, in particular no use of libxfs
 	  is permitted in this package anymore (such detailed
 	  on-disk format knowledge is the realm of xfsprogs).
+	- Fix xfsdump/xfsrestore to work on systems with 64k
+	  page size.
 
 xfsdump-2.2.49 (17 Feb 2008)
 	- Fix up error handling in _rmt_open in librmt.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
