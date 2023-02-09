Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF768C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 05:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBIFOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 00:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjBIFOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 00:14:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7132DE65;
        Wed,  8 Feb 2023 21:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ieoi4y1hv2WdSgU7SsXMc4tfOss4jdSh/bGneP0pDZw=; b=FDGXdR3aNZF7Aqp4oUS+z5bCxo
        fJmGbYfo/R3NVlg7msJYhq1F73YFNUzK/ch8BEkyS/SDJe1nwzKQm/JFZ2wxjRmrI2wadapQ+TVwA
        YbaXNgMKfMsfwaOW1qPxx3GuskW1cCOlTcqx1V5EOZFLdcVM8NeDZ8o85Tk/5nncuthyngUtlhhIf
        3dU4AySrp8HDGMgivImiA/fl5DriQpiu88OPODoxdELVPAxi3Jyq84VaAlmKps+ixWfGAWrh8LVrX
        wmcZ81nDb/VHR/JJEkEWPOMOlgFzvIiRURBt+ZH7W2JRKX6pDTkUDLc6BJr2ibLUzwqQaAOLFvJbD
        UqvQwCMA==;
Received: from [2001:4bb8:182:9f5b:acdc:d3c1:a8cd:f858] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPzGB-000BxF-Dg; Thu, 09 Feb 2023 05:14:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: add 080 to the auto and quick groups
Date:   Thu,  9 Feb 2023 06:13:55 +0100
Message-Id: <20230209051355.358942-8-hch@lst.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209051355.358942-1-hch@lst.de>
References: <20230209051355.358942-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/080 is not dangerous, isn't a known fail and runs very quickly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/080 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/080 b/tests/xfs/080
index abcfa004..2d90b6c4 100755
--- a/tests/xfs/080
+++ b/tests/xfs/080
@@ -7,7 +7,7 @@
 # rwtest (iogen|doio)
 #
 . ./common/preamble
-_begin_fstest rw ioctl
+_begin_fstest rw ioctl auto quick
 
 # Import common functions.
 . ./common/filter
-- 
2.39.1

