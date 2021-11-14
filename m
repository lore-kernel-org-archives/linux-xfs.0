Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF4AC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 21:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A545260FDA
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 21:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhKNV1P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Nov 2021 16:27:15 -0500
Received: from mx1.bul.net ([195.85.215.56]:59702 "EHLO mx1.bul.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236359AbhKNV1H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 14 Nov 2021 16:27:07 -0500
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Nov 2021 16:27:06 EST
Received: by mx1.bul.net (Postfix, from userid 1002)
        id 4DE58609A1; Sun, 14 Nov 2021 23:15:25 +0200 (EET)
Received: from purple.bonev.com (purple.bonev.com [195.85.215.215])
        by mx1.bul.net (Postfix) with ESMTP id 66DB96096E
        for <linux-xfs@vger.kernel.org>; Sun, 14 Nov 2021 23:15:20 +0200 (EET)
Received: (qmail 25989 invoked by uid 64020); 14 Nov 2021 23:15:20 +0200
Received: from unknown (HELO localhost.localdomain) (195.85.215.8)
  by purple.bonev.com with SMTP; 14 Nov 2021 23:15:20 +0200
From:   Boian Bonev <bbonev@ipacct.com>
To:     linux-xfs@vger.kernel.org
Cc:     bage@debian.org, Boian Bonev <bbonev@ipacct.com>
Subject: [PATCH] Avoid format truncation
Date:   Sun, 14 Nov 2021 23:14:58 +0200
Message-Id: <20211114211457.199710-1-bbonev@ipacct.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

io.c:644:17: note: ‘snprintf’ output between 4 and 14 bytes into a destination of size 8

Signed-off-by: Boian Bonev <bbonev@ipacct.com>
---
 db/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/io.c b/db/io.c
index c79cf105..154c3bd9 100644
--- a/db/io.c
+++ b/db/io.c
@@ -638,7 +638,7 @@ stack_f(
 	char	**argv)
 {
 	int	i;
-	char	tagbuf[8];
+	char	tagbuf[14];
 
 	for (i = iocur_sp; i > 0; i--) {
 		snprintf(tagbuf, sizeof(tagbuf), "%d: ", i);
-- 
2.33.1

