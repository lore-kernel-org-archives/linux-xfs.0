Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAP4N0l8006298 for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 22:23:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2684B15E72B0
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 20:23:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Fhq4WPnB5NGbvx8m for
	<xfs@oss.sgi.com>; Mon, 24 Nov 2008 20:23:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L4pRz-0005kg-S9
	for xfs@oss.sgi.com; Tue, 25 Nov 2008 04:22:59 +0000
Date: Mon, 24 Nov 2008 23:22:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] fix xfsqa on whole disks
Message-ID: <20081125042259.GA22092@infradead.org>
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

mkfe2fs unfortunately hasn't heard about real enterprise setups using
whole disks and needs the -F option to create a filesystem on those
without asking stupid questions that make the testcases block forever.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/032
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/032,v
retrieving revision 1.14
diff -u -p -r1.14 032
--- xfstests/032	29 May 2008 17:01:09 -0000	1.14
+++ xfstests/032	25 Nov 2008 04:18:59 -0000
@@ -46,6 +46,10 @@ do
 	[ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
 	# cramfs mkfs requires a directory argument
 	[ $fs = cramfs ] && preargs=/proc/fs/xfs
+	[ $fs = ext2 ] && preargs="-F"
+	[ $fs = ext3 ] && preargs="-F"
+	[ $fs = ext4 ] && preargs="-F"
+	[ $fs = ext4dev ] && preargs="-F"
 
 	# overwite the first few Kb - should blow away superblocks
 	src/devzero -n 20 $SCRATCH_DEV >/dev/null
Index: xfstests/049
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/049,v
retrieving revision 1.16
diff -u -p -r1.16 049
--- xfstests/049	29 Jun 2007 06:16:22 -0000	1.16
+++ xfstests/049	25 Nov 2008 04:18:59 -0000
@@ -60,7 +60,7 @@ echo "--- mounts" >> $seq.full
 mount >> $seq.full
 
 _log "Create ext2 fs on scratch"
-mkfs -t ext2 $SCRATCH_DEV >> $seq.full 2>&1 \
+mkfs -t ext2 -F $SCRATCH_DEV >> $seq.full 2>&1 \
     || _fail "!!! failed to mkfs ext2"
 
 _log "Mount ext2 fs on scratch"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
