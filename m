Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E129DC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8110121D90
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P0xPV/va"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgIQHxf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgIQHx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:53:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF50C06174A;
        Thu, 17 Sep 2020 00:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V69XvPu9r31dnEA5wNj0k0Ruuc3Ag9qXqd0p5tKDViU=; b=P0xPV/vaibUr5yfdJOAi4AEX/f
        mm9TRRSm5CL0F6SMjJQQEFJC5DZiaBjvLOWwxv5Ok4vnjTvEhc56N5dTkMmz+l7cvmXVlX6QFd+In
        L3IG4oP15XiCkCDF0JKH8Usjb9drBkBwjBigu1LjgwzSuXOUqjgm2QvHF8x1BLz6Febi7iVkeMOW4
        nz12kBDwReZbnBHXuGyAfNJP5pICqUtfjMDyesrLml5puUbLw8ejsmWZORnRTbcO7VCfNzPGzQay2
        rGKkRVixM/owC4KMH8aow/swqfugKtcTt0IAKRm4L0ivDI4I6Jr69fLEJxjJztBkWrZ2RMLUGp8fe
        eZgcMSqA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIojB-00077J-F5; Thu, 17 Sep 2020 07:53:13 +0000
Date:   Thu, 17 Sep 2020 08:53:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 04/24] xfs: skip tests that rely on allocation behaviors
 of the data device
Message-ID: <20200917075313.GD26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013420138.2923511.15786976146213933728.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013420138.2923511.15786976146213933728.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A large number of xfs-specific tests rely on specific behaviors of the
> data device allocator, such as fragmenting free space, carefully curated
> inode and free space counts, or features like filestreams that only
> exist on the data device.
> 
> These tests fail horribly if the test runner specified rtinherit=1 on
> the mkfs command line, so skip them all.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
