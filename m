Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:52952 "EHLO ares41.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752918AbcKERrP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Nov 2016 13:47:15 -0400
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: add missing AC_PROG_INSTALL
Date: Sat,  5 Nov 2016 18:38:06 +0100
Message-Id: <20161105173806.20052-2-jengelh@inai.de>
In-Reply-To: <20161105173806.20052-1-jengelh@inai.de>
References: <20161105173806.20052-1-jengelh@inai.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

$ autoreconf -fi
$ ./configure
configure: error: cannot find install-sh, install.sh, or shtool in . "."/.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index b88ab7f..27cab65 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,6 +6,7 @@ AC_CONFIG_SRCDIR([include/libxfs.h])
 AC_CONFIG_HEADER(include/platform_defs.h)
 AC_PREFIX_DEFAULT(/usr)
 
+AC_PROG_INSTALL
 AC_PROG_LIBTOOL
 
 AC_PROG_CC
-- 
2.10.2

