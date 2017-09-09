Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38285 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753824AbdIIPCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 11:02:40 -0400
Received: by mail-pf0-f194.google.com with SMTP id q76so2860840pfq.5
        for <linux-xfs@vger.kernel.org>; Sat, 09 Sep 2017 08:02:40 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] xfsdump: Use c99 defined int64_t instead of __int64_t
Date: Sat,  9 Sep 2017 08:02:30 -0700
Message-Id: <20170909150230.44139-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 common/hsmapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/hsmapi.c b/common/hsmapi.c
index 6054773..0709dbe 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -585,7 +585,7 @@ HsmModifyExtentMap(
 	struct getbmapx	*bmap)
 {
 	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
-	__int64_t	length;
+	int64_t		length;
 
 	if (bmap[0].bmv_entries <= 0) {
 		return 1;	/* caller must already be at EOF */
-- 
2.14.1

