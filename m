Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39EEE7F4E
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9010AC0A3
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:30 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vwx8jAj1AQxQgnbE for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:29 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRF-0002yK-HB
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRF-0007dS-Ga
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/30] xfsprogs: fix automatic dependency generation
Date: Wed, 30 Oct 2013 15:30:52 +1100
Message-Id: <1383107481-28937-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Adding are removing a header file does not result in dependency
regeneration like it should. make clean will rebuild the
dependencies, but a normal make won't. Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/buildrules | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/buildrules b/include/buildrules
index 49cb2a4..edb1beb 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -79,18 +79,30 @@ endif # _BUILDRULES_INCLUDED_
 $(_FORCE):
 
 # dependency build is automatic, relies on gcc -MM to generate.
+#
+# This is a bit messy. It regenerates the depenencies on each build so
+# that we catch files being added and removed. There are other ways of doing
+# this (e.g. per-file dependency files) but that requires more in-depth changes
+# to the build system. Compile time is not an issue for us, so the
+# rebuild on every make invocation isn't a problem we need to care about. Just
+# do it silently so it doesn't make the build unnecessarily noisy.
+
 .PHONY : depend ltdepend install-qa
 
 MAKEDEP := $(MAKEDEPEND) $(CFLAGS)
 
-ltdepend: .ltdep
+ltdepend: rmltdep .ltdep
+
+rmltdep:
+	@rm -f .ltdep
 
 .ltdep: $(CFILES) $(HFILES)
-	@echo "    [LTDEP]"
 	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
 
-depend: .dep
+depend: rmdep .dep
+
+rmdep:
+	@rm -f .dep
 
 .dep: $(CFILES) $(HFILES)
-	@echo "    [DEP]"
 	$(Q)$(MAKEDEP) $(CFILES) > .dep
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
