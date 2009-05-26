Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QC2bqX140511 for <xfs@oss.sgi.com>; Tue, 26 May 2009 07:02:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 330141A1C773
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 05:02:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iydPrluDMvJecltN for
	<xfs@oss.sgi.com>; Tue, 26 May 2009 05:02:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1M8vMo-0000MN-MW
	for xfs@oss.sgi.com; Tue, 26 May 2009 12:02:50 +0000
Date: Tue, 26 May 2009 08:02:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: only run 164 for xfs
Message-ID: <20090526120250.GA447@infradead.org>
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

Test 164 uses the xfs_io bmap subcommand which only works for XFS,
so don't offer it for nfs and udf.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/164
===================================================================
--- xfstests-dev.orig/164	2009-05-26 12:00:00.000000000 +0000
+++ xfstests-dev/164	2009-05-26 12:00:54.000000000 +0000
@@ -54,8 +54,7 @@
 
 # real QA test starts here
 
-# Modify as appropriate.
-_supported_fs xfs udf nfs
+_supported_fs xfs
 _supported_os IRIX Linux
 
 testfile=$TEST_DIR/file.$seq

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
