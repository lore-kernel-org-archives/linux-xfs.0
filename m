Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 658A129DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 22:41:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5465F8F8035
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 20:41:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	X2c3TpcTBEFgHLM8 for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 20:41:01 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Uomms-00084U-5E
	for xfs@oss.sgi.com; Tue, 18 Jun 2013 13:40:54 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Uomms-00046l-0y
	for xfs@oss.sgi.com; Tue, 18 Jun 2013 13:40:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsprogs: fix make deb
Date: Tue, 18 Jun 2013 13:40:53 +1000
Message-Id: <1371526854-15761-1-git-send-email-david@fromorbit.com>
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

Commit 48212a30 ("xfsprogs: update 'make deb' to use tarball) fixed
a bunch of problems with making the source tarball for releases.
However, it broke the debian package builds in a way I hadn't
noticed until I rewrote my CI system build script.

I noticed that the CI system wasn't building from a pristine
workarea, and instead was just updating the old workarea and running
'make deb'. I added a 'make realclean' to remove all previous state
from the workarea, and then 'make deb' started failing with errors
building the tarball because po/xfsprogs.pot didn't have a build
rule

The above commit removed the pre-build of the translations target,
and instead made the translation build target a dependency of
building the the tarball. Hence the lack of a build rule of the
translations causes the source tarball build to fail.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index b73bb57..f56aebd 100644
--- a/Makefile
+++ b/Makefile
@@ -135,6 +135,8 @@ deb: include/builddefs include/platform_defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
+	# need to build translations before the source tarball
+	$(Q)$(MAKE) $(MAKEOPTS) -C po
 	$(Q)$(MAKE) $(MAKEOPTS) $(SRCDIR)
 	$(Q)cd $(SRCDIR) && dpkg-buildpackage
 endif
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
