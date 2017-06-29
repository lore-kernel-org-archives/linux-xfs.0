Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751669AbdF2Pw7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 11:52:59 -0400
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH] xfs_spaceman: fix potential memory leak by malloc in scan_ag
Date: Thu, 29 Jun 2017 10:52:56 -0500
Message-Id: <20170629155256.3607-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net

scan_ag mallocs memory that is potentially leaked. Add a free
to alleviate the potential leak.

Fixes CoverityScan CID#1413772 (RESOURCE_LEAK)

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 spaceman/freesp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 22aec821..367c95d1 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -239,7 +239,9 @@ scan_ag(
 			printf(_("%10u %10llu %10llu\n"), agno, freeexts,
 					freeblks);
 	}
+	free(fsmap);
 }
+
 static void
 aglistadd(
 	char		*a)
-- 
2.13.0

