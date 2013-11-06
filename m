Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64B1029E13
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 579D7304051
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:40 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	haV3I91VBd5MR9vJ for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:39 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdraj-0003Np-V3
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdraj-0008Tz-UZ
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/37] xfsprogs: fix automatic dependency generation
Date: Wed,  6 Nov 2013 12:06:47 +1100
Message-Id: <1383700043-32305-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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
