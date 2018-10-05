Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 07/15] libxfs: avoid redefinitions of macros in mount.h
Date: Thu,  4 Oct 2018 23:03:08 -0500
Message-Id: <1538712196-13625-8-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

MS_* (MS_NOSUID ... etc) get redefined.  Fix this by
simply removing the inclusion of mount.h, which isn't needed.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 io/label.c      | 1 -
 libfrog/linux.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/io/label.c b/io/label.c
index df6ac36..602ece8 100644
--- a/io/label.c
+++ b/io/label.c
@@ -4,7 +4,6 @@
  */
 
 #include <sys/ioctl.h>
-#include <sys/mount.h>
 #include "platform_defs.h"
 #include "libxfs.h"
 #include "path.h"
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 2af2675..46f15d6 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -6,7 +6,6 @@
 
 #include <mntent.h>
 #include <sys/stat.h>
-#include <sys/mount.h>
 #include <sys/ioctl.h>
 #include <sys/sysinfo.h>
 
-- 
1.8.3.1
