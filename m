Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751500AbdLFSgl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 13:36:41 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 581AFAE69
        for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2017 18:36:40 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] xfs_io: Add missing perror for write_once (-O)
Date: Wed,  6 Dec 2017 12:36:33 -0600
Message-Id: <20171206183633.2415-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This got missed in the last set of patches.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 io/pwrite.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io/pwrite.c b/io/pwrite.c
index a89edfd0..afbe4284 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -271,8 +271,10 @@ write_once(
 {
 	ssize_t bytes;
 	bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
-	if (bytes < 0)
+	if (bytes < 0) {
+		perror("pwrite");
 		return -1;
+	}
 	*total = bytes;
 	return 1;
 }
-- 
2.14.2

