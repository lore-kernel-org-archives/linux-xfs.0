Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15Bloiu133447 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 05:47:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C41871B2222
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 03:48:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	hR8SjiKUiSfj7eSX for <xfs@oss.sgi.com>;
	Fri, 05 Feb 2010 03:48:59 -0800 (PST)
Date: Fri, 5 Feb 2010 22:48:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: make install in the brave new build system world
Message-ID: <20100205114856.GE11483@discord.disaster>
References: <20100205092229.GA32454@infradead.org>
	<20100205104414.GC11483@discord.disaster>
	<20100205112850.GB28701@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100205112850.GB28701@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Feb 05, 2010 at 06:28:50AM -0500, Christoph Hellwig wrote:
> On Fri, Feb 05, 2010 at 09:44:14PM +1100, Dave Chinner wrote:
> > The dependencies are always regenerated due to the default target
> > requiring the depend target. Rebuilding the dependencies is the only
> > way to catch changes between builds and so ensure the correct files
> > are rebuilt.
> > 
> > The install target is building the dependencies because it has a
> > dependency on the default target.
> 
> Well, it's building the dependecies twice - once by invoking the
> default target, but they are also rebuilt again when the actuall
> install rules are called.   The latter is pretty clearly superflous.

Ah, there's a double depenency chain.

The top level make file has:

install: default

Which causes "make install" to run the top level default target,
which runs the default target in all the target subdirs.

Then, in each subdir, the makefile has:

install: default

Which when then install target is actually run, does another
dependency check because it's got a local dependency on the depend
target via the default target.

Replace the previous patch with the one below and try again.
Now the "make install" will rebuild targets out of the local
dependencies rather than a separate run of the top level default
target (i.e. only traverse directories once).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfsprogs: clean up make install build V2

The install targets did not get the silent treatment like the
normal build targets. Shut them up.

Also, remove the top level install target dependency on the default
target. Each sub-directory already defines the correct dependencies
for the install targets and so all the rebuilds can be done in one
traversal of the subdirectories via the install rules.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 Makefile           |   13 ++++++++-----
 include/buildrules |    4 ----
 man/Makefile       |    4 ++--
 mdrestore/Makefile |    2 +-
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 62c4258..1905261 100644
--- a/Makefile
+++ b/Makefile
@@ -98,22 +98,25 @@ include/platform_defs.h: include/builddefs
 		$(MAKE) $(MAKEOPTS) $(AM_MAKEFLAGS) include/builddefs; \
 	fi
 
-install: default $(addsuffix -install,$(SUBDIRS))
+install: $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 README $(PKG_DOC_DIR)
 
-install-dev: default $(addsuffix -install-dev,$(SUBDIRS))
+install-dev: $(addsuffix -install-dev,$(SUBDIRS))
 
 install-qa: install $(addsuffix -install-qa,$(SUBDIRS))
 
 %-install:
-	$(MAKE) -C $* install
+	@echo "Installing $@"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* install
 
 %-install-dev:
-	$(MAKE) -C $* install-dev
+	@echo "Installing $@"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-dev
 
 %-install-qa:
-	$(MAKE) -C $* install-qa
+	@echo "Installing $@"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-qa
 
 distclean: clean
 	$(Q)rm -f $(DISTDIRT)
diff --git a/include/buildrules b/include/buildrules
index 1695e23..beb469b 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -101,7 +101,3 @@ ltdepend: $(CFILES) $(HFILES)
 depend: $(CFILES) $(HFILES)
 	@echo "    [DEP]"
 	$(Q)$(MAKEDEP) $(CFILES) > .dep
-
-
-#	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1,' > .dep
-
diff --git a/man/Makefile b/man/Makefile
index 2b5e89c..863284c 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -14,9 +14,9 @@ install : $(addsuffix -install,$(SUBDIRS))
 install-dev : $(addsuffix -install-dev,$(SUBDIRS))
 
 %-install:
-	$(MAKE) -C $* install
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* install
 
 %-install-dev:
-	$(MAKE) -C $* install-dev
+	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-dev
 
 include $(BUILDRULES)
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index fd35d80..ca2d1a0 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -16,7 +16,7 @@ default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
 
-install:
+install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 install-dev:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
