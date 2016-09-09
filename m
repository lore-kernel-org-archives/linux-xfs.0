Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36358 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbcIINcp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2016 09:32:45 -0400
Received: by mail-wm0-f66.google.com with SMTP id l65so2787699wmf.3
        for <linux-xfs@vger.kernel.org>; Fri, 09 Sep 2016 06:32:45 -0700 (PDT)
From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: [PATCH] xfs_io: fix building with musl
Date: Fri,  9 Sep 2016 15:32:22 +0200
Message-Id: <1473427942-10726-1-git-send-email-ralph.sennhauser@gmail.com>
In-Reply-To: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Ralph Sennhauser <ralph.sennhauser@gmail.com>

The fallback in case the libc doesn't have or doesn't advertise the
existence of d_reclen in struct dirent uses d_namlen. Musl neither
advertises d_reclen nor does it have a d_namlen member.

Calculate the value for d_namlen from d_name in the fallback path.

Signed-off-by: Ralph Sennhauser <ralph.sennhauser@gmail.com>
---

With ustat.h issue resolved in 4.8.0-rc1 this is the only musl related
one left.

An alternative could be some autoconf magic [1] or waiting for a long
time for musl to add _DIRENT_HAVE_D_RECLEN [2] and for it to propagate
to distributions.

[1] http://oss.sgi.com/archives/xfs/2016-01/msg00388.html
[2] http://www.openwall.com/lists/musl/2016/01/15/9

---
 io/readdir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io/readdir.c b/io/readdir.c
index 151b72e..2b56dc8 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -24,6 +24,10 @@
 #include <sys/types.h>
 #include <dirent.h>
 
+#ifndef _DIRENT_HAVE_D_RECLEN
+#include <string.h>
+#endif
+
 static struct cmdinfo readdir_cmd;
 
 const char *d_type_str(unsigned int type)
@@ -106,7 +110,7 @@ read_directory(
 #ifdef _DIRENT_HAVE_D_RECLEN
 		*total += dirent->d_reclen;
 #else
-		*total += dirent->d_namlen + sizeof(*dirent);
+		*total += strlen(dirent->d_name) + sizeof(*dirent);
 #endif
 		count++;
 
-- 
2.7.3

