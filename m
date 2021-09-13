Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF00FC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 05:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 948CF60E8B
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 05:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhIMFpT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 01:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhIMFpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Sep 2021 01:45:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E438C061574;
        Sun, 12 Sep 2021 22:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Bc/r1/v5qYGuobd8WzRjQTK4GgUmwdQvoNbSmc4SwNk=; b=lHbzAsnoK940Q3XtXo1skkoEHr
        T8exy5EAQs0EYBlIha6ZaDyeZQDp0AbiGpn4evFhvKHeUY8ZE7AKqC5AJQCwnAaUBoUpnS0pAXOc7
        6SZPw/5JGCYZemZ3mp55Pw81Oi0io5gL/SnEonIuJY2XqX/tl691/L3ezQsZgzENyVYpsYnJuHLN4
        5SgqxI5jVIsoWpF8jVvJLE2rD47CZ5WMuertKZql5mZ4Qa4dXTAUPpmN4drCKaAuyswG3pj18lvax
        vjGrPKZYdV6C9omsVladCrBKdyK0iGuXCOatU0bq8SbhgsObjlvzUE9RRrNIgG1GqbteyR++wZRjZ
        MlLPR37w==;
Received: from 089144214237.atnat0023.highway.a1.net ([89.144.214.237] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPejL-00DCVR-Pf; Mon, 13 Sep 2021 05:42:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] seq_file: mark seq_get_buf as deprecated
Date:   Mon, 13 Sep 2021 07:41:09 +0200
Message-Id: <20210913054121.616001-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913054121.616001-1-hch@lst.de>
References: <20210913054121.616001-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function pokes a big hole into the seq_file abstraction.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/seq_file.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index dd99569595fd3..db16b11477875 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -59,6 +59,10 @@ static inline bool seq_has_overflowed(struct seq_file *m)
  *
  * Return the number of bytes available in the buffer, or zero if
  * there's no space.
+ *
+ * DOT NOT USE IN NEW CODE! This function pokes a hole into the whole seq_file
+ * abstraction.  The only remaining user outside of seq_file.c is sysfs, which
+ * is gradually moving away from using seq_get_buf directly.
  */
 static inline size_t seq_get_buf(struct seq_file *m, char **bufp)
 {
-- 
2.30.2

