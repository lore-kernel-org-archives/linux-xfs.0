Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C36C6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 05:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4E6E61106
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 05:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhGVFE2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 01:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbhGVFE0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 01:04:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EFEC061757;
        Wed, 21 Jul 2021 22:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=cr10h9z9+xvH5DVIGvCd48Eahn8xgaETGvbM+ScXgAI=; b=oI2Q5SQixA52w0MsK82aHetnJq
        58Qfg9+fEW6f5g18PnUc1UM7y0pkDObGSFWOeLwHSicVe1o3u4/4UfPOiUeUKRWxFev9pMEuLDrac
        UvcOh0ZJ29/q+Sv07PDciNcYqZzDtCCD8oGY6/aVYc74sMnT8qZA52MdJFFhV7r41peJ/kEN5GC9s
        0EbY5dxGckIBSMzCSe858qwlGKYYkOYrXDtWfjtuzmdZr13dtVx0U7zOCQLRvl2q29xUHwuDzhCe+
        X8yJSvyb2FVvYfJc2YMnDqjchAzjwsywF7GNjszaJLGnQLn6xzivHnfF8U+2ToF20idhgXY44t2/0
        lwxbXYBg==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6RU2-009vJb-K7; Thu, 22 Jul 2021 05:43:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>
Subject: cleanup the bio handling in iomap v2
Date:   Thu, 22 Jul 2021 07:42:54 +0200
Message-Id: <20210722054256.932965-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up the bio handling in the iomap buffered I/O code
by dropping use of the very lowlevel helpers.  We did only need them
before Matthew converted the inflight counters to be byte based

Changes sine v1:
 - fix readpage to properly handle bios that hit their byte size limit
