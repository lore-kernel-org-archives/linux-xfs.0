Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA17C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D2C23132
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbhASHY6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 02:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbhASHY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:24:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6351C061574
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j+H1n6f6zF4ijvmJtjF0zUfwcurU7s6c5CbTGd3At6I=; b=ePoor7kqoEDOc6R/Kt4xr6svdw
        91ajlxZ3wqP7KoTD7pZ9cd3tq1S0IUt0eheKia0cTUNGuV4nXLCzEaU8WJCI1Jxgq4wPP5XLxdGoi
        t316lVvNrTYhDRA3tkvy+hd2ZHw6lDtfPU1F1cnMNeSGMPoBNyKJQ7xXoY1iW3O/5lwy8mhv2bHT2
        aRqSeu3UAUA6rYaf/cqkZKMbgYlAW1RIa1kJU2TKEj8tckiUw1F5yBi8ZpLWQaKxiFbh/kABz5SaI
        bESJKHe4B7ao6X4Le3VqHc755CXQTC0SeG3CnL++62SXrI8i04V4Rpg2K1ZQSVIol4goQOqis4YjZ
        q0+tvRbw==;
Received: from [2001:4bb8:188:1954:b440:557a:2a9e:a981] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1lDn-00Dwoh-LF; Tue, 19 Jan 2021 07:14:38 +0000
Date:   Tue, 19 Jan 2021 08:14:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: hide xfs_icache_free_cowblocks
Message-ID: <YAaG2zSI88OEZfXP@infradead.org>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
 <161100799781.90204.6400744147219775342.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100799781.90204.6400744147219775342.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:13:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Change the one remaining caller of xfs_icache_free_cowblocks to use our
> new combined blockgc scan function instead, since we will soon be
> combining the two scans.  This introduces a slight behavior change,
> since a readonly remount now clears out post-EOF preallocations and not
> just CoW staging extents.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
