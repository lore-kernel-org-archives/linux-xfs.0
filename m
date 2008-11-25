Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPAtoRU000684 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 04:55:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EF8815ECCB1
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 02:55:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iFQmU9ZvGLzGuILG for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 02:55:50 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L4vZf-0005wV-Ob
	for xfs@oss.sgi.com; Tue, 25 Nov 2008 10:55:19 +0000
Date: Tue, 25 Nov 2008 05:55:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsdump: don't redeclare offsetoff
Message-ID: <20081125105519.GA21288@infradead.org>
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

Don't redeclare offsetof, we already include <stddef.h> to get it and
modern gcc will complain about the redeclaration.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsdump/common/getdents.c
===================================================================
--- xfs-cmds.orig/xfsdump/common/getdents.c	2008-11-13 18:45:11.000000000 +0100
+++ xfs-cmds/xfsdump/common/getdents.c	2008-11-13 18:45:18.000000000 +0100
@@ -72,8 +72,6 @@ extern int __have_no_getdents64;
 # endif
 #endif
 
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-
 
 /* For Linux we need a special version of this file since the
    definition of `struct dirent' is not the same for the kernel and

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
