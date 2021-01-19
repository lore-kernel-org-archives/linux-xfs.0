Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CA1C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 06:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C62EE2311F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 06:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbhASGl4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 01:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729314AbhASGlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 01:41:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783F0C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 22:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ye6UiiHQpZQPSnah7v03pk3zYLz+t33FxqMVH2IHlyk=; b=bNzIy5E3eRF/KzBL5YY2BXqBjH
        H5+O3/GlkGs7hQ2rZ42z8YyNXVfvlv8Mqjcufayr9YWwwzwRJf2l/8TAJFwa1rwBCYkDgTvwaaAjW
        hER+J57/MZ58iNMjnU6MAUYa/1qgUXsPR1C+GdnOlXFFM7i2mFXectofttY9yxBVTFWD13d0gn3vT
        VJqvzNFbtMIIiIIyLWM/clrOtEozl3ldnQPkTCBd6FVb52GuzHknDhWpmGSYgzCCU+ivorIZUj5Hi
        kRJJXg2XFQ2ikyVjV+fXdM5WtgH3whyluaogdCaowxDq0FynOZtcCYxeIHiK1hu7um7pog4Xnvc5I
        C/Cdwu/g==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1kgz-00DugF-Ho; Tue, 19 Jan 2021 06:40:46 +0000
Date:   Tue, 19 Jan 2021 07:38:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: clean up quota reservation wrappers
Message-ID: <YAZ+Z4DxkbPUnTFk@infradead.org>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
 <161100790484.88678.13971476776021338640.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100790484.88678.13971476776021338640.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:11:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace a couple of quota reservation macros with properly typechecked
> static inline functions ahead of more restructuring in the next patches.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
