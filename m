Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43570 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbeBBTL0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 14:11:26 -0500
Received: by mail-qt0-f194.google.com with SMTP id m11so4703272qtn.10
        for <linux-xfs@vger.kernel.org>; Fri, 02 Feb 2018 11:11:26 -0800 (PST)
From: Marco A Benatto <marco.antonio.780@gmail.com>
Subject: [PATCH 1/2] xfs_mdrestore: Add -i option to built-in help
Date: Fri,  2 Feb 2018 17:11:13 -0200
Message-Id: <1517598674-52297-1-git-send-email-marco.antonio.780@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: mbenatto@redhat.com

Currently we are missing -i option from usage().
This patch adds it to this biult-in help.

Signed-off-by: Marco A Benatto <marco.antonio.780@gmail.com>
---
 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index c49c13a..0bb4ac8 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -194,7 +194,7 @@ perform_restore(
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
 	exit(1);
 }
 
-- 
1.8.3.1

