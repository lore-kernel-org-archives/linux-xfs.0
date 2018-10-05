Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48102 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727578AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 08/15] xfsprogs: avoid redefinition of NBBY
Date: Thu,  4 Oct 2018 23:03:09 -0500
Message-Id: <1538712196-13625-9-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

sys/param.h (re)defines NBBY so just include it first.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 include/platform_defs.h.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index c4f0e8b..411a9bf 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -19,6 +19,7 @@
 #include <pthread.h>
 #include <ctype.h>
 #include <sys/types.h>
+#include <sys/param.h>
 #include <limits.h>
 #include <stdbool.h>
 #include <libgen.h>
-- 
1.8.3.1
