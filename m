Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S7GY8Z191489 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 02:16:34 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04E09348BC
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:16:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jHLeKiJLLep6ylca for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2011 00:16:31 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QbSWj-0006cf-Aq
	for xfs@oss.sgi.com; Tue, 28 Jun 2011 17:16:05 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QbSWS-0003IO-Hq
	for xfs@oss.sgi.com; Tue, 28 Jun 2011 17:15:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsprogs: don't hard code the shell binary
Date: Tue, 28 Jun 2011 17:15:48 +1000
Message-Id: <1309245348-12638-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Recent changes to debian unstable user space have caused the
xfsprogs build to break as certain shell functionality is being
assumed by libtool and friends.  The configure scripts test and
select the correct shell, but the input files ignore this and hard
code the shell to use and hence now break.

Fix this by using the shell that the configure scripts decide is the
right one to use.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/builddefs.in |    1 +
 include/buildmacros  |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index f895ed9..4c8ec64 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -71,6 +71,7 @@ MAKE		= @make@
 ECHO		= @echo@
 SORT		= @sort@
 LN_S		= @LN_S@
+SHELL		= @SHELL@
 LIBTOOL		= @LIBTOOL@
 MAKEDEPEND	= @makedepend@
 
diff --git a/include/buildmacros b/include/buildmacros
index 62babca..31c7eb0 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -32,7 +32,6 @@ OBJECTS = $(ASFILES:.s=.o) \
 
 INSTALL	= $(TOPDIR)/install-sh -o $(PKG_USER) -g $(PKG_GROUP)
 
-SHELL = /bin/sh
 IMAGES_DIR = $(TOPDIR)/all-images
 DIST_DIR = $(TOPDIR)/dist
 
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
