Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44712C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E0C65016
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCEI3Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEI2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:28:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599CCC061574
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 00:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ze/HWqMzdcfxc2XK7FiRwFotipZ8OOvn8D0XuUgANY0=; b=Mwb+d2WeRkAKS/bJUo4OWIp+Xq
        TwxWe/tYfACXwO8riMptmLH98FEl11xONNZCsxL/LqTrWKeg2s9BBxlZ2nQ8juYJxccCsKv48A4EK
        h3qQ1TEyaOANFEfa7aji1kZGRzy1Km6YI4W/ahjfzqNGBgKj3qaCIMj+ps3oEgA74J/9OAdA8p+r0
        Fb+PT8WnLgr5rLiVYMH/vu5y4SI7KYViHb8l3XgQt4KpWV6IxBlr1km9Q7RkOJU/WKJTHWqbIQWsi
        ZrsvaL98iHvZmr/Y4hbAgSeHpJmw0U/rJV65po1u1i/rzGgY+F5QdoRdH02U+TWkHTlAejmzYeuM/
        E93li7Lw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5pH-00ApxW-IE; Fri, 05 Mar 2021 08:28:50 +0000
Date:   Fri, 5 Mar 2021 08:28:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: remove return value from xchk_ag_btcur_init
Message-ID: <20210305082847.GF2567783@infradead.org>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472415044.3421582.2179320230294749858.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472415044.3421582.2179320230294749858.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:29:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Functions called by this function cannot fail, so get rid of the return
> and error checking.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
