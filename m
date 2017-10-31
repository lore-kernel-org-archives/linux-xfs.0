Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41717 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdJaLNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 07:13:52 -0400
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] xfs: remove redundant assignment to variable bit
Date: Tue, 31 Oct 2017 11:13:50 +0000
Message-Id: <20171031111350.21208-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable bit is being assigned a value that is never read, hence
the assignment is redundant and can be removed. Cleans up clang
warning:

fs/xfs/libxfs/xfs_rtbitmap.c:675:3: warning: Value stored to
'bit' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 5d4e43ef4eea..ac09c4333485 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -672,7 +672,6 @@ xfs_rtmodify_range(
 		/*
 		 * Compute a mask of relevant bits.
 		 */
-		bit = 0;
 		mask = ((xfs_rtword_t)1 << lastbit) - 1;
 		/*
 		 * Set/clear the active bits.
-- 
2.14.1

