Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:52954 "EHLO ares41.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755966AbcKERrP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Nov 2016 13:47:15 -0400
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: resolve autoheader warning
Date: Sat,  5 Nov 2016 18:38:05 +0100
Message-Id: <20161105173806.20052-1-jengelh@inai.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

$ autoreconf -fi
[...]
autoheader: warning: missing template: HAVE_UMODE_T
autoheader: Use AC_DEFINE([HAVE_UMODE_T], [], [Description])
autoreconf: /usr/bin/autoheader failed with exit status: 1

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 m4/package_types.m4 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/m4/package_types.m4 b/m4/package_types.m4
index 4aa09a5..1c35839 100644
--- a/m4/package_types.m4
+++ b/m4/package_types.m4
@@ -1,6 +1,7 @@
 #
 # Check if we have umode_t
 #
+AH_TEMPLATE([HAVE_UMODE_T], [Whether you have umode_t])
 AC_DEFUN([AC_TYPE_UMODE_T],
   [ AC_MSG_CHECKING([for umode_t])
     AC_TRY_COMPILE([
-- 
2.10.2

