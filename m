Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54D2siZ244899 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 08:02:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E667148E6BD
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 06:09:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LR931um4Tikr7Bbp for
	<xfs@oss.sgi.com>; Thu, 04 Jun 2009 06:09:49 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MCCb8-0006ot-NX
	for xfs@oss.sgi.com; Thu, 04 Jun 2009 13:03:10 +0000
Date: Thu, 4 Jun 2009 09:03:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix for bash 3.2
Message-ID: <20090604130310.GA14560@infradead.org>
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

Bash 3.2 wants a space before the closing "]" in a test:


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/check
===================================================================
--- xfstests-dev.orig/check	2009-06-04 12:36:21.000000000 +0000
+++ xfstests-dev/check	2009-06-04 12:36:26.000000000 +0000
@@ -160,7 +160,7 @@
 
 EOF
 
-if [ ! -z "$SCRATCH_DEV"]; then
+if [ ! -z "$SCRATCH_DEV" ]; then
   umount $SCRATCH_DEV 2>/dev/null
   # call the overridden mkfs - make sure the FS is built
   # the same as we'll create it later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
