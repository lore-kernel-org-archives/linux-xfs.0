Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1KB3XD4172000 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 05:03:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55AFE138871
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:59:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mv9YFryzpRlMnsgd for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:59:17 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LaT6D-0003AI-93
	for xfs@oss.sgi.com; Fri, 20 Feb 2009 10:59:17 +0000
Date: Fri, 20 Feb 2009 05:59:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: test 134 requires quotas
Message-ID: <20090220105917.GA11888@infradead.org>
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

Add a  _require_quota call to make sure it shows up as not run and not
as failed if the kernel doesn't support quotas.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/134
===================================================================
--- xfstests-dev.orig/134	2009-02-20 10:57:34.000000000 +0000
+++ xfstests-dev/134	2009-02-20 10:57:42.000000000 +0000
@@ -36,6 +36,8 @@
 _supported_fs xfs
 _supported_os Linux IRIX
 
+_require_quota
+
 dir=$SCRATCH_MNT/project
 
 #project quota files

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
