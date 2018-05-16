Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751395AbeEPN1l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 May 2018 09:27:41 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575982083A
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 13:27:40 +0000 (UTC)
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 2/2] xfs_io: syncfs can fail
Date: Wed, 16 May 2018 09:27:38 -0400
Message-Id: <20180516132738.27776-2-jlayton@kernel.org>
In-Reply-To: <20180516132738.27776-1-jlayton@kernel.org>
References: <20180516132738.27776-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

syncfs can return an error. Report one if it does.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 io/sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/sync.c b/io/sync.c
index c77263804a35..868cea7c051e 100644
--- a/io/sync.c
+++ b/io/sync.c
@@ -41,8 +41,8 @@ syncfs_f(
 	int			argc,
 	char			**argv)
 {
-	/* syncfs can't fail */
-	syncfs(file->fd);
+	if (syncfs(file->fd) < 0)
+		perror("syncfs");
 	return 0;
 }
 #endif
-- 
2.17.0

