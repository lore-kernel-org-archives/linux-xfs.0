Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbdHRKjR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Aug 2017 06:39:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 041C3356EA
        for <linux-xfs@vger.kernel.org>; Fri, 18 Aug 2017 10:39:17 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] mkfs: add missing translation
Date: Fri, 18 Aug 2017 12:39:24 +0200
Message-Id: <20170818103924.24452-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Add a missing underscore where it was omitted probably by a mistake.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 091ca530..ec9ed633 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1281,7 +1281,7 @@ check_opt(
 
 	if (sp->index != index) {
 		fprintf(stderr,
-	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
+	_("Developer screwed up option parsing (%d/%d)! Please report!\n"),
 			sp->index, index);
 		reqval(opts->name, (char **)opts->subopts, index);
 	}
-- 
2.13.3

