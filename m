Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031615AbdDZWci (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 18:32:38 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A419D155E4
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 22:32:37 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: fix statx call for changed UAPI
Message-ID: <afe93fb1-ee3b-ce0c-ce32-d6d63acd05a0@redhat.com>
Date: Wed, 26 Apr 2017 17:32:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, David Howells <dhowells@redhat.com>

Due to a late-breaking change in the statx UAPI in kernel commit

1e2f82d1 statx: Kill fd-with-NULL-path support in favour of AT_EMPTY_PATH

we'll need to fix the way we call the syscall in xfs_io.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/stat.c b/io/stat.c
index c5b3075..783eb2e 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -351,7 +351,7 @@ statx_f(
 		return command_usage(&statx_cmd);
 
 	memset(&stx, 0xbf, sizeof(stx));
-	if (_statx(file->fd, NULL, atflag, mask, &stx) < 0) {
+	if (_statx(file->fd, "", atflag | AT_EMPTY_PATH, mask, &stx) < 0) {
 		perror("statx");
 		return 0;
 	}
diff --git a/io/statx.h b/io/statx.h
index ff08e27..3b5978d 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -4,6 +4,10 @@
 #include <unistd.h>
 #include <sys/syscall.h>
 
+#ifndef AT_EMPTY_PATH
+#define AT_EMPTY_PATH	0x1000
+#endif
+
 #ifndef AT_STATX_SYNC_TYPE
 #define AT_STATX_SYNC_TYPE      0x6000  /* Type of synchronisation required from statx() */
 #define AT_STATX_SYNC_AS_STAT   0x0000  /* - Do whatever stat() does */

