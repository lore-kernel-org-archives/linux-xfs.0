Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52172 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfBULW0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Feb 2019 06:22:26 -0500
From: Colin King <colin.king@canonical.com>
Subject: [PATCH][xfs-next] xfs: fix uninitialized error variable
Date: Thu, 21 Feb 2019 11:22:24 +0000
Message-Id: <20190221112224.3748-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A previous commit removed the initialization of variable 'error' to zero,
and can cause a bogus error return.  This occurs when error contains a
non-zero garbage value and the call to xchk_should_terminate detects a
pending fatal signal and checks for a zero error before setting it
to -EAGAIN. Fix the issue by initializing error to zero.

Fixes: b9454fe056bd ("xfs: clean up the inode cluster checking in the inobt scrub")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/scrub/ialloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 2c9dad2b61b1..700114f79a7d 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -161,7 +161,7 @@ xchk_iallocbt_check_cluster_ifree(
 	bool				irec_free;
 	bool				ino_inuse;
 	bool				freemask_ok;
-	int				error;
+	int				error = 0;
 
 	if (xchk_should_terminate(bs->sc, &error))
 		return error;
-- 
2.20.1
