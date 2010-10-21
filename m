Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LK60IR066412 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 15:06:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18F2A118EBD
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 13:07:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YwaG4HFZ6PTE26yz for
	<xfs@oss.sgi.com>; Thu, 21 Oct 2010 13:07:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P91Ps-0007uj-TO
	for xfs@oss.sgi.com; Thu, 21 Oct 2010 20:07:12 +0000
Date: Thu, 21 Oct 2010 16:07:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: remove dead code in test 062
Message-ID: <20101021200712.GA30128@infradead.org>
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

The _linux_attr_calls function is never called, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/062
===================================================================
--- xfstests-dev.orig/062	2010-10-21 19:57:24.000000000 +0000
+++ xfstests-dev/062	2010-10-21 19:58:34.000000000 +0000
@@ -51,47 +51,6 @@ _filter_scratch()
 	    sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
 }
 
-_linux_attr_calls()
-{
-    echo "*** set/get one initially empty attribute"
-    setfattr -h -n $nsp.name $SCRATCH_MNT/$inode
-    getfattr -m $nsp $SCRATCH_MNT/$inode
-
-    echo "*** overwrite empty, set several new attributes"
-    setfattr -h -n $nsp.name -v 0xbabe $SCRATCH_MNT/$inode
-    setfattr -h -n $nsp.name2 -v 0xdeadbeef $SCRATCH_MNT/$inode
-    setfattr -h -n $nsp.name3 -v 0xdeface $SCRATCH_MNT/$inode
-
-    echo "*** fetch several attribute names and values (hex)"
-    getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
-
-    echo "*** fetch several attribute names and values (base64)"
-    getfattr -m $nsp -e base64 $SCRATCH_MNT/$inode
-
-    echo "*** shrink value of an existing attribute"
-    setfattr -h -n $nsp.name2 -v 0xdeaf $SCRATCH_MNT/$inode
-    getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
-
-    echo "*** grow value of existing attribute"
-    setfattr -h -n $nsp.name2 -v 0xdecade $SCRATCH_MNT/$inode
-    getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
-
-    echo "*** set an empty value for second attribute"
-    setfattr -h -n $nsp.name2 $SCRATCH_MNT/$inode
-    getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode
-
-    echo "*** overwrite empty value"
-    setfattr -h -n $nsp.name2 -v 0xcafe $SCRATCH_MNT/$inode
-    getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode
-
-    echo "*** remove attribute"
-    setfattr -h -x $nsp.name2 $SCRATCH_MNT/$inode
-    getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode
-
-    echo "*** final list (strings, type=$inode, nsp=$nsp)"
-    getfattr -m '.' -e hex $SCRATCH_MNT/$inode
-}
-
 getfattr()
 {
     $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
