Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE3537F66
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 17:45:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77219AC001
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 15:44:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	hYwLxuB0KlRZpxUN for <xfs@oss.sgi.com>;
	Fri, 31 Jul 2015 15:44:52 -0700 (PDT)
Date: Sat, 1 Aug 2015 08:44:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] build: create include/xfs before installing headers (was Re:
	[PATCH 06/10] xfsprogs: use <>-style includes in installed headers)
Message-ID: <20150731224450.GQ16638@dastard>
References: <1437927209-31354-1-git-send-email-hch@lst.de>
	<1437927209-31354-7-git-send-email-hch@lst.de>
	<20150731025506.GP16638@dastard> <20150731080957.GA22546@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150731080957.GA22546@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

On Fri, Jul 31, 2015 at 10:09:57AM +0200, Christoph Hellwig wrote:
> On Fri, Jul 31, 2015 at 12:55:06PM +1000, Dave Chinner wrote:
> > I made a small change to pull the creation of include/xfs out of
> > include/Makefile and up into include/buildrules where it is done
> > before running the install-headers rule on each header subdir,
> > and that fixes it. i.e:
> 
> Thanks, this looks sensible to me.
> 
> > Now I've just got to work out which patch is breaking 'make deb'....
> 
> "packaging: rework dh_autoreconf invocation for deb builds" is the
> culprit..

That goes away on a make distclean. What was wrong is that
debian/buildrules manually builds programs for the installer packge
(the udebs, IIUC) and so it runs the headers-install rules manually
rather than through the top level make file. It needed to have a
mkdir -p install/xfs added to it....

I've isolated all this to a patch that applies in front of you
series, as it appears the problems aren't directly related to any of
the changes you made - they just expose the problem. Patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


build: create include/xfs before installing headers

From: Dave Chinner <dchinner@redhat.com>

Currently the install-headers rule from include/Makefile creates
include/xfs, but there is no guarantee that it will be the first
directory that make executes that rule in. Hence other directories
can race with the creation on include/xfs and fail.

Move the creation of include/xfs to occur before running the
install_headers rules on the subdirectories to avoid any possible
races with creation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 debian/rules       | 1 +
 include/Makefile   | 5 +----
 include/buildrules | 8 +++++++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/debian/rules b/debian/rules
index 27b043f..5526bbf 100755
--- a/debian/rules
+++ b/debian/rules
@@ -44,6 +44,7 @@ dibuild:
 	@echo "== dpkg-buildpackage: installer" 1>&2
 	if [ ! -f mkfs/mkfs.xfs-$(bootpkg) ]; then \
 		$(diopts) $(MAKE) include/platform_defs.h; \
+		mkdir -p include/xfs; \
 		for dir in include libxfs; do \
 			$(MAKE) -C $$dir NODEP=1 install-headers; \
 		done; \
diff --git a/include/Makefile b/include/Makefile
index 91b33b0..01c886d 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -65,12 +65,9 @@ include $(BUILDRULES)
 # set up include/xfs header directory
 install-headers: $(addsuffix -hdrs, $(HFILES) $(QAHFILES) $(PHFILES) $(DKHFILES) $(LIBHFILES))
 
-%-hdrs: xfs
+%-hdrs:
 	$(Q)$(LN_S) -f $(PWD)/include/$* xfs/$*
 
-xfs:
-	@mkdir -p xfs
-
 install: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 
diff --git a/include/buildrules b/include/buildrules
index 0e13f9d..5010895 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -14,10 +14,16 @@ clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* clean
 
 ifdef HDR_SUBDIRS
+.PHONY: .xfs
+
 headers: $(addsuffix -headers, $(HDR_SUBDIRS))
-%-headers:
+
+%-headers: .xfs
 	@echo "   [HEADERS] $*"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* NODEP=1 install-headers
+
+.xfs:
+	@mkdir -p include/xfs
 endif
 
 # Never blow away subdirs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
