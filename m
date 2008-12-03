Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3Cu8aY018382 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 06:56:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A61F81BEE974
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 04:56:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id V8ZIL38rJKEDm4ol for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 04:56:07 -0800 (PST)
Date: Wed, 3 Dec 2008 07:55:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: next-20081203 build failure, when building xfs_file.o
Message-ID: <20081203125534.GA8007@infradead.org>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<20081203124104.GA5400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203124104.GA5400@linux.vnet.ibm.com>
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
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 06:11:04PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> 	next-20081203 kernel build fails on x86 with build failure
> 
> In file included from fs/xfs/linux-2.6/xfs_file.c:39:

This is the fix I submitted for it yesterday:

-- 

fix compile on 32 bit systems

The recent compat patches make xfs_file.c include xfs_ioctl32.h unconditional,
which breaks the build on 32 bit systems which don't have the various compat
defintions.

Remove the include and move the defintion of xfs_file_compat_ioctl to
xfs_ioctl.h so that we can avoid including all the compat defintions in
xfs_file.c


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_file.c	2008-12-02 11:43:38.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_file.c	2008-12-02 11:44:06.000000000 +0100
@@ -36,9 +36,9 @@
 #include "xfs_inode.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
-#include "xfs_ioctl32.h"
 #include "xfs_vnodeops.h"
 #include "xfs_da_btree.h"
+#include "xfs_ioctl.h"
 
 #include <linux/dcache.h>
 #include <linux/smp_lock.h>
Index: xfs-master/fs/xfs/linux-2.6/xfs_ioctl.h
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-02 11:44:10.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-02 11:44:52.000000000 +0100
@@ -67,4 +67,16 @@ xfs_attrmulti_attr_remove(
 	char			*name,
 	__uint32_t		flags);
 
+extern long
+xfs_file_compat_ioctl(
+	struct file		*file,
+	unsigned int		cmd,
+	unsigned long		arg);
+
+extern long
+xfs_file_compat_ioctl_invis(
+	struct file		*file,
+	unsigned int		cmd,
+	unsigned long		arg);
+
 #endif
Index: xfs-master/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-12-02 11:44:10.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-12-02 11:44:18.000000000 +0100
@@ -20,9 +20,6 @@
 
 #include <linux/compat.h>
 
-extern long xfs_file_compat_ioctl(struct file *, unsigned, unsigned long);
-extern long xfs_file_compat_invis_ioctl(struct file *, unsigned, unsigned long);
-
 /*
  * on 32-bit arches, ioctl argument structures may have different sizes
  * and/or alignment.  We define compat structures which match the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
