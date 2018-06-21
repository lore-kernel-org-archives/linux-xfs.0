Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754284AbeFUCze (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jun 2018 22:55:34 -0400
From: jeffm@suse.com
Subject: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
Date: Wed, 20 Jun 2018 22:55:20 -0400
Message-Id: <20180621025520.9115-1-jeffm@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, Jeff Mahoney <jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
AG alignment code into a separate function.  It got rid of
redundant checks for dswidth != 0 but did too good a job since now
it doesn't check at all.  When we hit the check to see if agsize
is a multiple of stripe width: (cfg->agsize % cfg->dswidth), we crash
on a divide by zero.

This patch re-adds the check to the top of align_ag_geometry.

Fixes: 051b4e37f5e (mkfs: factor AG alignment)
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 78d0ce5d..28a7e70c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2670,7 +2670,7 @@ align_ag_geometry(
 	uint64_t	tmp_agsize;
 	int		dsunit = cfg->dsunit;
 
-	if (!dsunit)
+	if (!dsunit || !cfg->dswidth)
 		goto validate;
 
 	/*
-- 
2.15.1

