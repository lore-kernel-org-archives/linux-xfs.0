Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1GATKdd137523 for <xfs@oss.sgi.com>; Mon, 16 Feb 2009 04:29:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FB721247D4
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2009 02:28:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vjxBEBUB2gIOOVL8 for
	<xfs@oss.sgi.com>; Mon, 16 Feb 2009 02:28:47 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LZ0iT-0002H4-Qp
	for xfs@oss.sgi.com; Mon, 16 Feb 2009 10:28:46 +0000
Date: Mon, 16 Feb 2009 05:28:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsdump: fix system() error reporting
Message-ID: <20090216102845.GA6835@infradead.org>
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

Positive returns from system need the WEXITSTATUS macro applies to get
the real exit code of the executed command.

Based on analysis in oss BZ #804.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsdump-dev/dump/content.c
===================================================================
--- xfsdump-dev.orig/dump/content.c	2009-02-16 11:23:10.361944048 +0100
+++ xfsdump-dev/dump/content.c	2009-02-16 11:23:47.629070808 +0100
@@ -6735,7 +6735,8 @@ save_quotas( char *mntpnt, quota_info_t 
         sts = system( buf );
         if( sts != 0 ) {
             mlog( MLOG_ERROR, _(
-                  "%s failed with exit status: %d\n"), REPQUOTA, sts);
+                  "%s failed with exit status: %d\n"), REPQUOTA,
+		  sts == -1 ? -1 : WEXITSTATUS(sts));
             return BOOL_FALSE;
         }
         if((fd = open( quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
