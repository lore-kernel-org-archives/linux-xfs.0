Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B807EB64D7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 09:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjFZJvE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 05:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjFZJvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2023 05:51:04 -0400
Received: from smtp.gentoo.org (smtp.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF1C9D
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 02:51:00 -0700 (PDT)
From:   Sam James <sam@gentoo.org>
To:     linux-xfs@vger.kernel.org
Cc:     David Seifert <soap@gentoo.org>, Sam James <sam@gentoo.org>
Subject: [PATCH] po: Fix invalid .de translation format string
Date:   Mon, 26 Jun 2023 10:50:46 +0100
Message-ID: <20230626095048.1290476-1-sam@gentoo.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: David Seifert <soap@gentoo.org>

* gettext-0.22 validates format strings now
  https://savannah.gnu.org/bugs/index.php?64332#comment1

Bug: https://bugs.gentoo.org/908864
Signed-off-by: David Seifert <soap@gentoo.org>
Signed-off-by: Sam James <sam@gentoo.org>
---
 po/de.po | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/po/de.po b/po/de.po
index 944b0e91..a6f8fde1 100644
--- a/po/de.po
+++ b/po/de.po
@@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
 #: .././estimate/xfs_estimate.c:191
 #, c-format
 msgid "%s will take about %.1f megabytes\n"
-msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
+msgstr "%s wird etwa %.1f Megabytes einnehmen\n"
 
 #: .././estimate/xfs_estimate.c:198
 #, c-format
-- 
2.41.0

