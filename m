Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0RKPXuR212835 for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 14:25:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B516F1480C
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 12:26:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lI28DdGtFFHeenYE for
	<xfs@oss.sgi.com>; Wed, 27 Jan 2010 12:26:38 -0800 (PST)
Date: Wed, 27 Jan 2010 15:26:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix compilation of iopat targets
Message-ID: <20100127202636.GA15643@infradead.org>
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
	<1264053773-6054-3-git-send-email-david@fromorbit.com>
	<4B60932D.7060709@sandeen.net>
	<20100127201733.GA32057@infradead.org> <4B60A026.30905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B60A026.30905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Now that PREALLO_TARGETS is gone these tests must be listed in the main
LINUX_TARGETS list.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/src/Makefile
===================================================================
--- xfstests-dev.orig/src/Makefile	2010-01-27 21:21:18.810261335 +0100
+++ xfstests-dev/src/Makefile	2010-01-27 21:22:08.535005799 +0100
@@ -12,10 +12,10 @@ TARGETS = dirstress fill fill2 getpagesi
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames
 
-LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize \
-	ftrunc trunc fs_perms testx looptest locktest unwritten_mmap \
-	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset \
-	t_futimens
+LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
+	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
+	locktest unwritten_mmap bulkstat_unlink_test \
+	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable
 
 SUBDIRS =
 
@@ -28,9 +28,7 @@ endif
 IRIX_TARGETS = open_unlink
 
 ifeq ($(PKG_PLATFORM),linux)
-PREALLO_TARGETS = preallo_rw_pattern_reader
 TARGETS += $(LINUX_TARGETS)
-TARGETS += t_immutable
 endif
 
 ifeq ($(PKG_PLATFORM),irix)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
