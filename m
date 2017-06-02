Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39470 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750807AbdFBSUH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jun 2017 14:20:07 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C5AEABF2
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2017 18:20:06 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] fsr: fix uninitialized fs usage after timeout
Message-ID: <b4921f6d-01c7-09eb-641f-47f1be998e61@suse.com>
Date: Fri, 2 Jun 2017 14:20:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

In the main loop of fsrallfs, we exit when we've hit the timeout but
we increment fs before we get there.  If we're operating on the last
file system in the array, we'll hit an uninitialized fsdesc and
crash in fsrall_cleanup.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fsr/xfs_fsr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 517b75f0..e695c243 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -598,7 +598,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 	signal(SIGTERM, aborter);

 	/* reorg for 'howlong' -- checked in 'fsrfs' */
-	while (endtime > time(0)) {
+	for (; endtime > time(0); fs->npass++, fs++) {
 		pid_t pid;
 		if (fs == fsend)
 			fs = fsbase;
@@ -629,8 +629,6 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 			break;
 		}
 		startino = 0;  /* reset after the first time through */
-		fs->npass++;
-		fs++;
 	}
 	fsrall_cleanup(endtime <= time(0));
 }


-- 
Jeff Mahoney
SUSE Labs
