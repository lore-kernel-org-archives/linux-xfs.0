Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5KAmEB7140331 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 05:48:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BA311D30D
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 03:48:11 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Gx6vZI5Eq1BiESef for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 03:48:11 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QYc1b-0000gr-4N
	for xfs@oss.sgi.com; Mon, 20 Jun 2011 10:48:11 +0000
Date: Mon, 20 Jun 2011 06:48:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: update test 042 golden output
Message-ID: <20110620104811.GA1925@infradead.org>
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

Add the golden output for the newly added tests in common.punch.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/242.out
===================================================================
--- xfstests-dev.orig/242.out	2011-06-20 09:05:09.000000000 +0000
+++ xfstests-dev/242.out	2011-06-20 09:05:18.000000000 +0000
@@ -47,3 +47,14 @@ QA output created by 242
 0: [0..7]: data
 1: [8..31]: unwritten
 2: [32..39]: data
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+	17. data -> hole in single block file
+0: [0..7]: unwritten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
