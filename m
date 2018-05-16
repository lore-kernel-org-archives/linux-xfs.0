Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbeEPRRz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 May 2018 13:17:55 -0400
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2] xfs_io: syncfs can fail
Date: Wed, 16 May 2018 13:17:52 -0400
Message-Id: <20180516171752.26583-1-jlayton@kernel.org>
In-Reply-To: <20180516132738.27776-2-jlayton@kernel.org>
References: <20180516132738.27776-2-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

syncfs can return an error. Report one if it does. Also, ensure that
xfs_io will exit with a non-zero status in that case.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 io/sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

v2: also set exitcode when reporting error

diff --git a/io/sync.c b/io/sync.c
index c77263804a35..20ab50a7fcd4 100644
--- a/io/sync.c
+++ b/io/sync.c
@@ -41,8 +41,10 @@ syncfs_f(
 	int			argc,
 	char			**argv)
 {
-	/* syncfs can't fail */
-	syncfs(file->fd);
+	if (syncfs(file->fd) < 0) {
+		perror("syncfs");
+		exitcode = 1;
+	}
 	return 0;
 }
 #endif
-- 
2.17.0

