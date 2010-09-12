Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8CHBHjw020009 for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 12:11:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F328DDC1EBC
	for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 10:23:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BVrm9drhlfAIuCDB for
	<xfs@oss.sgi.com>; Sun, 12 Sep 2010 10:23:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Ouq60-0001uD-3c
	for xfs@oss.sgi.com; Sun, 12 Sep 2010 17:12:04 +0000
Date: Sun, 12 Sep 2010 13:12:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix 108 and enable it by default
Message-ID: <20100912171204.GA7225@infradead.org>
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

Apply the prjquota check to the scratch device so that it doesn't fail,
and add the test to the auto and quick groups now that it works.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/108
===================================================================
--- xfstests-dev.orig/108	2010-09-12 17:04:58.000000000 +0000
+++ xfstests-dev/108	2010-09-12 17:05:23.000000000 +0000
@@ -86,8 +86,8 @@ test_accounting()
 }
 
 export MOUNT_OPTIONS="-opquota"
-_require_prjquota
 _qmount
+_require_prjquota $SCRATCH_DEV
 
 # real QA test starts here
 rm -f $tmp.projects $seq.full
Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2010-09-12 17:05:43.000000000 +0000
+++ xfstests-dev/group	2010-09-12 17:06:32.000000000 +0000
@@ -218,7 +218,7 @@ deprecated
 105 acl auto quick
 106 quota
 107 quota
-108 quota
+108 quota auto quick
 109 metadata auto
 110 repair auto
 111 ioctl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
