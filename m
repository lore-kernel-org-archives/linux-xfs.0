Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6TFofo5052842 for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 10:50:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 976C09E2B0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2011 08:50:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Etd928WZxnezh22r for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2011 08:50:40 -0700 (PDT)
Date: Fri, 29 Jul 2011 11:50:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] jfs support for xfstests
Message-ID: <20110729155039.GA28306@infradead.org>
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
To: jfs-discussion@lists.sourceforge.net, xfs@oss.sgi.com

The patch below adds basic jfs support to xfstests.  Unfortunately it
doesn't get very far, as test 001 already blows up with a kernel crash,
as do 011 and 013 as other random picks. 


Index: xfstests-dev/common.rc
===================================================================
--- xfstests-dev.orig/common.rc	2011-07-29 15:36:52.000000000 +0000
+++ xfstests-dev/common.rc	2011-07-29 15:39:41.000000000 +0000
@@ -102,6 +102,9 @@ _mkfs_opts()
     gfs2)
 	export MKFS_OPTIONS="$GFS2_MKFS_OPTIONS -O -p lock_nolock"
 	;;
+    jfs)
+	export MKFS_OPTIONS="$JFS_MKFS_OPTIONS -q"
+	;;
     *)
 	;;
     esac

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
