Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1EM69wx000632 for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 16:06:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 192761DB981E
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 14:07:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NuHxS2MyFQcoFyPf for
	<xfs@oss.sgi.com>; Sun, 14 Feb 2010 14:07:25 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ngmcf-0003xF-QI
	for xfs@oss.sgi.com; Sun, 14 Feb 2010 22:07:25 +0000
Date: Sun, 14 Feb 2010 17:07:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix awk syntax error in 219
Message-ID: <20100214220725.GA14927@infradead.org>
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

There's one brace too many here - this was pointed out in the review
but slipped back into the commited patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/219
===================================================================
--- xfstests-dev.orig/219	2010-02-14 22:00:57.000000000 +0000
+++ xfstests-dev/219	2010-02-14 22:01:03.000000000 +0000
@@ -86,7 +86,7 @@ test_accounting()
 	done
 
 	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
-	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } } { print; }'
+	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }'
 }
 
 # real QA test starts here

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
