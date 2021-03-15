Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA60C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 18:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287BC64E61
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 18:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCOSsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 14:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhCOSsM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 14:48:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C15BC06174A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 11:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A6j/YfMBkr1SdpnNzZebVGwf183rMgbGSn8rbHXbSfA=; b=eWtpAIUDvTMYUXvIQZaZM7mt47
        dbTvmLCqx1aYPJGiRBaO2bqQDYlr84tMrp+k0HCHVOXtunidHEjLPUuna/v6mGoxkI/aDP1h4UfEt
        VsVL23mElkRhX1h2ZXGCpNzHvcyOh4j4slcUOvvf9+cTNDtP4iF44r7OE1tt9G4Uvc9oPu0v3uVx6
        qNYS/o98TOw764M88++AgPT45CZ1PrbkHt5ExQACyXiyOO0Q8jdAcMTa7ncWAJ6B1zTF8iwFFwHyB
        s4SnbwqxVG6n/XtrY/apjT+Wd+4nAA8xGHlFu7hfwdIapGUdtxtjeaOTmYPwTNvhMG9XuiT8Zf/CG
        8nn7cx8w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLsFh-000cAy-Tk; Mon, 15 Mar 2021 18:47:57 +0000
Date:   Mon, 15 Mar 2021 18:47:41 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: decide if inode needs inactivation
Message-ID: <20210315184741.GC140421@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543196269.1947934.4125444770307830204.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543196269.1947934.4125444770307830204.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:06:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a predicate function to decide if an inode needs (deferred)
> inactivation.  Any file that has been unlinked or has speculative
> preallocations either for post-EOF writes or for CoW qualifies.
> This function will also be used by the upcoming deferred inactivation
> patch.

The helper looks good, but I'd just merge it into patch 6, without
that is isn't very helpful.
