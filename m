Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35J2dDM012697 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 14:02:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B44601DCC2F0
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 12:04:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9tuCIlRLBR8eV9rG for
	<xfs@oss.sgi.com>; Mon, 05 Apr 2010 12:04:29 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Nyrb3-00010t-1n
	for xfs@oss.sgi.com; Mon, 05 Apr 2010 19:04:29 +0000
Date: Mon, 5 Apr 2010 15:04:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: don't use -s option to repquota
Message-ID: <20100405190428.GA3807@infradead.org>
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

The -s option to repquota used to be a no-op, but actually changes
output to different units in quota tools 4.0.  Remove it from the
repquota invocation in test 219.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/219
===================================================================
--- xfstests-dev.orig/219	2010-04-05 18:55:09.000000000 +0000
+++ xfstests-dev/219	2010-04-05 18:55:16.000000000 +0000
@@ -85,7 +85,7 @@ test_accounting()
 		$here/src/lstat64 $file | head -3 | filter_scratch
 	done
 
-	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+	repquota -$type -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
 	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }'
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
