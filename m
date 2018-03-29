Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43398 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752004AbeC2Pew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:52 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 10/10] libxfs: warn about deprecation of irix, freebsd, darwin
Date: Thu, 29 Mar 2018 10:34:22 -0500
Message-Id: <1522337662-26260-11-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

It's not clear that anyone is using these platforms or if
they even build at this point.  Get someone's attention if
they are trying to use it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libxfs/darwin.c  | 4 ++++
 libxfs/freebsd.c | 4 ++++
 libxfs/irix.c    | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/libxfs/darwin.c b/libxfs/darwin.c
index 16d2c35..396477e 100644
--- a/libxfs/darwin.c
+++ b/libxfs/darwin.c
@@ -26,6 +26,10 @@
 int platform_has_uuid = 1;
 extern char *progname;
 
+#warning "Darwin support is deprecated and planned for removal in July 2018"
+#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
+#error   "Remove this line if you'd like to continue the build"
+
 int
 platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
diff --git a/libxfs/freebsd.c b/libxfs/freebsd.c
index 5b9ef29..d9fc837 100644
--- a/libxfs/freebsd.c
+++ b/libxfs/freebsd.c
@@ -26,6 +26,10 @@
 int platform_has_uuid = 1;
 extern char *progname;
 
+#warning "FreeBSD support is deprecated and planned for removal in July 2018"
+#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
+#error   "Remove this line if you'd like to continue the build"
+
 int
 platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
diff --git a/libxfs/irix.c b/libxfs/irix.c
index 0f14aec..4ad68d5 100644
--- a/libxfs/irix.c
+++ b/libxfs/irix.c
@@ -24,6 +24,10 @@ int platform_has_uuid = 0;
 extern char *progname;
 extern int64_t findsize(char *);
 
+#warning "IRIX support is deprecated and planned for removal in July 2018"
+#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
+#error   "Remove this line if you'd like to continue the build"
+
 int
 platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
-- 
1.8.3.1

