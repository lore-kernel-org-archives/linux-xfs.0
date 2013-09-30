Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 812E47F5E
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 649C78F8035
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	dPSDlV9W7B1KS2D1 for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxZ-0006Oh-RL
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxZ-0002F5-Qu
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/32] xfsprogs: fix automatic dependency generation
Date: Mon, 30 Sep 2013 13:15:13 +1000
Message-Id: <1380510944-8571-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
