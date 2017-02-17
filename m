Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58388 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932757AbdBQVM2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Feb 2017 16:12:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfsdump: fix build on 32-bit platforms
Message-ID: <d1f01b20-8272-80d8-df1c-0cb5c8f8aa70@sandeen.net>
Date: Fri, 17 Feb 2017 15:02:09 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, Eric Biggers <ebiggers@google.com>

Now that xfsprogs requires anyone using the headers to
properly define 64-bit file access, xfsdump has stopped
building on 32-bit platforms.

I think this is all it needs; works for me here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

cc: Eric Biggers because he seems to enjoy this stuff :)

diff --git a/configure.ac b/configure.ac
index 7bb6f1d..8d78ed4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,6 +6,8 @@ AC_CONFIG_SRCDIR([common/main.c])
 AC_CONFIG_HEADER(include/config.h)
 AC_PREFIX_DEFAULT(/usr)
 
+AC_SYS_LARGEFILE
+
 AC_PROG_LIBTOOL
 
 AC_ARG_ENABLE(shared,

