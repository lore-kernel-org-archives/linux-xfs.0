Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8187EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 09:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A1DD23975
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 09:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbhAUJ3Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 04:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728077AbhAUJCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 04:02:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889E7C061757;
        Thu, 21 Jan 2021 01:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=t3P41GTC5sgFHY2Hkmcr/32W5vs+9zP8VqnGZlHPGkg=; b=It4aKNtN3agIdmytmBjugTgFXa
        pONcSxMG4EF7bYav7AWYi5n9NyKdA3rF32dc7NsDhFJXeGuVIh656iggo+rWOAjg8+cUonVE66ktS
        GMM5Ylk+UgGCz4VHqcfWnQBD9Of8KXqR/JOQeLIwMqkfIIKTUU6/pznA1V30buT1CYpzAnUw22aBS
        VpIzct/hUzYUH6IWulQhvhVI4tjMs+voA0ZFAEwtMPgwdPF/9bvaUJA2MwrwdpNjC4la5PYW1FwcG
        sjr8s4Iywt+iIixV+sf0bN4szmpnJFd2YReNa9Yn10huHQn8eDT0a13c7QnlIBuq45M4UxXlUOX+/
        yWrSpWDg==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2VqB-00Gpv9-J1; Thu, 21 Jan 2021 09:01:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, avi@scylladb.com
Subject: reduce sub-block DIO serialisation v3
Date:   Thu, 21 Jan 2021 09:58:55 +0100
Message-Id: <20210121085906.322712-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This takes the approach from Dave, but adds a new flag instead of abusing
the nowait one, and keeps a simpler calling convention for iomap_dio_rw.

Changes since v2:
 - add another sanity check in __iomap_dio_rw
 - rename IOMAP_DIO_UNALIGNED to IOMAP_DIO_OVERWRITE_ONLY
 - use more consistent parameter naming
 - improve a few comments
 - cleanup an if statement

Changes since v1:
 - rename the new flags
 - add an EOF check for subblock I/O
 - minor cleanups
