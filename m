Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F51C47247
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDC13207DD
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P4De22BI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEHGe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727030AbgEHGe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A5C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=O9+EFsXYDNjs+Ifu4WJ1/SDHYwQxk0V08n8QQymarps=; b=P4De22BINChuyhzmGxtxG5M0r6
        TxhVdxaQLyQlPBZPO5SMbmtsL3guZ+Q9Lh1KLRmukqZ9MC/vA4pQO2y1g9+DboUZxhLvru57p7J4Q
        pe19DHovOeOQ5bMlfuaLAJHMF98ovy2mh8YwcSWCbG+7hekL6Yj82s2AIgyQqShNmvjt5N5Wd5Lyf
        aHuy72YB7xKtk//JHDnQMnVsZE/ftJDb4QQ3RzUwwvFtaw2KtAc0ws+brIAgACW2pAPDr9rEbOazG
        azo4wbeYdOZqDQwoGBGuGm3J02vZ0WcvRbd8f+lL7h+DrkU/BLyYK+Qng6D1Kdzmpy/G9HIaaP1Ad
        ICsJdVmQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwaX-0002tS-9m
        for linux-xfs@vger.kernel.org; Fri, 08 May 2020 06:34:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: dinode reading cleanups v2
Date:   Fri,  8 May 2020 08:34:11 +0200
Message-Id: <20200508063423.482370-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

while dusting off my series to move the per-fork extent count and format
into the xfs_ifork structure I found that we added a few more hacks in
the area it touched.  This series has some of the prep patch combined with
a restructure of the dinode reading path that cleans up handling of early
errors during dinode reading, and allows droppign a workaround in
xfs_bmapi_read.

Another side effect is that we can share more code with xfsprogs.

Changes since v1:
 - remove the repair hack in the dir2 verifier
 - keep a NULL ifork safety check in xfs_bmapi_read
 - handle a NULL attr fork in xfs_ifork_verify_local_attr
 - cleanup various comments

Git tree:

    git://git.infradead.org/users/hch/xfs.git xfs-inode-read-cleanup.2

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-inode-read-cleanup.2
