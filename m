Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C32D67F61
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 04:20:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B46A68F8064
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 02:20:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HK1O4OIeJAxbbgkN for <xfs@oss.sgi.com>;
	Wed, 10 Jun 2015 02:20:23 -0700 (PDT)
Date: Wed, 10 Jun 2015 19:19:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150610091952.GE24666@dastard>
References: <20150610070604.GA9855@infradead.org>
	<20150610081914.GV9143@dastard>
	<20150610082415.GA23860@infradead.org>
	<20150610083441.GW9143@dastard>
	<20150610084043.GA31392@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150610084043.GA31392@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jun 10, 2015 at 01:40:43AM -0700, Christoph Hellwig wrote:
> Here is the fix.  Since that commit the build accidentally relied on the
> installed platform_defs.h:
> 
> ---
> From e406bcdcdad80ca491d5b854cde5ad893bef6f8c Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 10 Jun 2015 10:34:45 +0200
> Subject: xfsprogs: fix platform_defs.h include path
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Since 2fe8a2 ("libxfs: restructure to match kernel layout") platform_defs.h
> the xfs subdirectory under include/ only contains selected headers instead
> of being a directory symlink.
> 
> Because of this the build does not properly pick up platform_defs.h, which
> isn't symlinked into include/xfs.  Builds only work if a recent enough
> platform_defs.h is available under /usr/include/xfs.
> 
> Fix this by including platform_defs.h without the xfs/ prefix.

Actually, I think that platform_defs.h needs to be symlinked into
include/xfs. that was the intent, but I bet I missed it because
the build wasn't failing and so I didn't notice that I'd failed to
put it into the the include/Makefile rule for installed headers.

Yeah, there we are - the install-dev rule has a specific install
rule for platform_defs.h as well, so it was being included in the
package builds correctly (i.e. installed in /usr/include/xfs)
without being mentioned in the HFILES definition that defines header
files to be packaged for /usr/include/xfs....

Patch below (which uncovers another issue to do with include files
on the distclean side, but is not fatal and I'll fix tomorrow).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfsprogs: build fails to find platform_defs.h

From: Dave Chinner <dchinner@redhat.com>

Commit 2fe8a2 ("libxfs: restructure to match kernel layout") failed
to link plaftorm_defs.h into include/xfs, and so the system header
file is used instead if it exists. If it doesn't exist, the n the
build fails.

Classify platform_defs.h as a header file that is installed in the
xfsprogs package into /usr/include/xfs, and remove the special
one-off install rule that puts it into that directory. This also
ensures that a build will always find platform_defs.h in
./include/xfs rather than relying on the system includes to provide
it, hence also solving the build issue.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile | 22 +++++++++++++++++-----
 libxfs/crc32.c   |  7 +++----
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/Makefile b/include/Makefile
index 70e43a0..6b9c7f0 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -18,8 +18,16 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-QAHFILES = libxfs.h libxlog.h \
-	atomic.h bitops.h cache.h kmem.h list.h hlist.h parent.h radix-tree.h \
+QAHFILES = libxfs.h \
+	libxlog.h \
+	atomic.h \
+	bitops.h \
+	cache.h \
+	hlist.h \
+	kmem.h \
+	list.h \
+	parent.h \
+	radix-tree.h \
 	swab.h \
 	xfs_arch.h \
 	xfs_btree_trace.h \
@@ -30,8 +38,13 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_trace.h \
 	xfs_trans.h
 
-HFILES = handle.h jdm.h xqm.h xfs.h
-HFILES += $(PKG_PLATFORM).h
+HFILES = handle.h \
+	jdm.h \
+	$(PKG_PLATFORM).h \
+	platform_defs.h \
+	xfs.h \
+	xqm.h
+
 PHFILES = darwin.h freebsd.h irix.h linux.h gnukfreebsd.h
 DKHFILES = volume.h fstyp.h dvh.h
 LIBHFILES = command.h input.h path.h project.h
@@ -62,7 +75,6 @@ include $(BUILDRULES)
 install-dev: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 	$(INSTALL) -m 644 $(HFILES) $(PKG_INC_DIR)
-	$(INSTALL) -m 644 platform_defs.h $(PKG_INC_DIR)
 
 install-qa: install-dev
 	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)
diff --git a/libxfs/crc32.c b/libxfs/crc32.c
index 0a8d309..bc1fc98 100644
--- a/libxfs/crc32.c
+++ b/libxfs/crc32.c
@@ -33,10 +33,9 @@
  * match the hardware acceleration available on Intel CPUs.
  */
 
-//#include <libxfs.h>
-#include <xfs/platform_defs.h>
-#include <xfs/swab.h>
-#include <xfs/xfs_arch.h>
+#include "xfs/platform_defs.h"
+#include "xfs/swab.h"
+#include "xfs/xfs_arch.h"
 #include "crc32defs.h"
 
 /* types specifc to this file */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
