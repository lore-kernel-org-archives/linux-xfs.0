Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6C1C4332D
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BA723B04
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbhAVQut (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 11:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729650AbhAVQXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jan 2021 11:23:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B535C0613D6;
        Fri, 22 Jan 2021 08:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=nmbJnm50gZMOc+7PIT6wU2c1XXrqeE+TUm7Cw7Zy394=; b=h6Z17Sj4n8EOAU0uLOogjb9AS1
        chcTwmbMzQVmY2eh03mUZDYIrwnhhk9Uq2Zzms6rtzlAmj7l/8UKzfqyUeY3w5wvNCy4m8+1dFkmD
        o7kKc10SFC/fMbxsIrX7FDfPgTgfwQTh5Y/moY7xzgeAsRJf1XRCl0oUq5jw9ZpNfk6LWrjpY73ji
        e6A7LyeXzE1bCeu2Et0CvE+GVnC7kfdisXM3/+VLIKXnkv/PC/BhndeO8C7EfpbYV84ESUJru9O6K
        /pcBZjwfGKAtxwfeB3c/hIBSZLVEICTYkwEKo11gW1G48HI8/VSg07TbQcyDgrLCvaVPWA0zRaikm
        XnaLnYrQ==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2zD5-000xDY-2H; Fri, 22 Jan 2021 16:23:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, avi@scylladb.com
Subject: reduce sub-block DIO serialisation v4
Date:   Fri, 22 Jan 2021 17:20:32 +0100
Message-Id: <20210122162043.616755-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This takes the approach from Dave, but adds a new flag instead of abusing
the nowait one, and keeps a simpler calling convention for iomap_dio_rw.

Changes since v3:
 - further comment improvements
 - micro-optimize an alignment check

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
