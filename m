Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48090 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbeJELAM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:12 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 02/15] xfsprogs: use ANSI declarations of void-arg functions
Date: Thu,  4 Oct 2018 23:03:03 -0500
Message-Id: <1538712196-13625-3-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 db/io.h   | 2 +-
 io/init.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/db/io.h b/db/io.h
index a60aaaa..8d5720b 100644
--- a/db/io.h
+++ b/db/io.h
@@ -59,7 +59,7 @@ extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
  * returns -1 for unchecked, 0 for bad and 1 for good
  */
 static inline int
-iocur_crc_valid()
+iocur_crc_valid(void)
 {
 	if (!iocur_top->bp)
 		return -1;
diff --git a/io/init.c b/io/init.c
index e9449a2..29afe09 100644
--- a/io/init.c
+++ b/io/init.c
@@ -244,7 +244,7 @@ idle_loop(void *arg)
 }
 
 void
-start_idle_thread()
+start_idle_thread(void)
 {
 	pthread_t t;
 
-- 
1.8.3.1
