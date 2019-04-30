Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26829 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfD3UC5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Apr 2019 16:02:57 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B89C8046D
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2019 20:02:57 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FF6E19497
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2019 20:02:57 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: rework includes for statx structures
Message-ID: <cec15436-c098-c59f-2663-a6a189e46a0c@redhat.com>
Date: Tue, 30 Apr 2019 15:02:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Only include the kernel's linux/stat.h headers if we haven't
already picked up statx bits from glibc, to avoid redefinition.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Tested-by: Bill O'Donnell <billodo@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/stat.c b/io/stat.c
index 517be66..37c0b2e 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -6,9 +6,6 @@
  * Portions of statx support written by David Howells (dhowells@redhat.com)
  */
 
-/* Try to pick up statx definitions from the system headers. */
-#include <linux/stat.h>
-
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/statx.h b/io/statx.h
index 4f40eaa..c6625ac 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -33,7 +33,14 @@
 # endif
 #endif
 
+
+#ifndef STATX_TYPE
+/* Pick up kernel definitions if glibc didn't already provide them */
+#include <linux/stat.h>
+#endif
+
 #ifndef STATX_TYPE
+/* Local definitions if glibc & kernel headers didn't already provide them */
 
 /*
  * Timestamp structure for the timestamps in struct statx.
