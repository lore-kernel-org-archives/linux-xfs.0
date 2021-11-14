Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23402C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 22:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 057376112E
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 22:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhKNXCH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Nov 2021 18:02:07 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21807 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbhKNXCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Nov 2021 18:02:07 -0500
X-Greylist: delayed 918 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Nov 2021 18:02:06 EST
ARC-Seal: i=1; a=rsa-sha256; t=1636929828; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=TX+bH2/PVjkU3kCb/b18+MypPjF7fU+SHu/m3Vs95XUV41LCJB/UJjoQOPmbAd/prEL+XMfNyLd4JNlD8zLlxW5cXBA5Zf8585Rx7l2iFGZuFUnty6w26QzS6w7Co59hZFrOzUHCKsev344PwiAXq9AKkOBW/9+z4dvHavH/7GQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1636929828; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ANs1/M02ay+sxBi0ledXKHhs/49s7luEop0YTYTKxew=; 
        b=bw5jMpj2RozIiukasMd/auqNUJZLp9ARElydUlQk9q+z9rBeDU1XnXZr8je8l3zi9zTKbUCSJs+3Rytgkq9WAEq7zkTdqrXVHB1YMZKV44JjrYaLNhHHf8o2NNR2mi7U+RTNnHBFiC564CaDpybk+KgLzLnCXkj/eMD5g5NNFR8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from thinkbage.fritz.box (pd9544ed8.dip0.t-ipconnect.de [217.84.78.216]) by mx.zoho.eu
        with SMTPS id 1636929827422597.5303581064687; Sun, 14 Nov 2021 23:43:47 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>
Message-ID: <20211114224339.20246-5-bage@debian.org>
Subject: [PATCH v2 4/4] debian: Add changelog entry for 5.14.0-rc1-1
Date:   Sun, 14 Nov 2021 23:43:39 +0100
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211114224339.20246-1-bage@debian.org>
References: <20211114224339.20246-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This holds all package changes since v5.13.0.
Add Closes tags that will autoclose related bugs.

Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/changelog | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index 4f09e2ca..48a5ffa8 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,18 @@
+xfsprogs (5.14.0-rc1-1) unstable; urgency=medium
+
+  [ Dave Chinner ]
+  * New build dependency: liburcu-dev
+
+  [ Helmut Grohne ]
+  * Fix FTCBFS (Closes: #794158)
+    + Pass --build and --host to configure
+
+  [ Boian Bonev ]
+  * Fix FTBFS (Closes: #997656)
+    + Keep custom install-sh after autogen
+
+ -- Bastian Germann <bage@debian.org>  Sun, 14 Nov 2021 23:18:22 +0100
+
 xfsprogs (5.13.0-1) unstable; urgency=medium
 
   * New upstream release
-- 
2.33.1


