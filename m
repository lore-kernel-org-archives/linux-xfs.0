Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15BGYaR131657 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 05:16:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7783F1372204
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 03:17:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	NJBENhS7DuaYY0Ur for <xfs@oss.sgi.com>;
	Fri, 05 Feb 2010 03:17:44 -0800 (PST)
Date: Fri, 5 Feb 2010 22:17:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: make install in the brave new build system world
Message-ID: <20100205111741.GD11483@discord.disaster>
References: <20100205092229.GA32454@infradead.org>
	<20100205104414.GC11483@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100205104414.GC11483@discord.disaster>
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

On Fri, Feb 05, 2010 at 09:44:14PM +1100, Dave Chinner wrote:
> On Fri, Feb 05, 2010 at 04:22:29AM -0500, Christoph Hellwig wrote:
> > When doing make install in xfsprogs I get a lot of spew like this:
....
> >  b) for some reason the new silent make rules don't apply to this.
> 
> That's something I can't answer off the top of my head. I'll have a
> look into it.

Try the patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfsprogs: clean up make install build

The install targets did not get the silent treatment like the
normal build targets. Shut them up.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 Makefile           |    9 ++++++---
 include/buildrules |    4 ----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 62c4258..31be846 100644
--- a/Makefile
+++ b/Makefile
@@ -107,13 +107,16 @@ install-dev: default $(addsuffix -install-dev,$(SUBDIRS))
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
