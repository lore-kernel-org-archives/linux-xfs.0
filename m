Return-Path: <SRS0=wIC6=IE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4BFC433DB
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Mar 2021 07:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3C965011
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Mar 2021 07:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhCFHP2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Mar 2021 02:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhCFHPV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Mar 2021 02:15:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5909C06175F
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 23:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8ZL1+3h1KJ16WyQcK2BNvBwSGxlASFQwSApPLzU8EPg=; b=gdq8Q4PTGD5EBScct8C9lsP6iH
        r4dFXrQdTv0G1t+M6ukbd/jiem94v1phQNKNtNC0HGt8rVN0u664skj5YFLo6bqjw2IuYQrmN1iBH
        aBcXWeJyM88sXuW1x02fhF+eQ487TEecsjUEjRwyS0Vuysc/G09HLTnKmznY+RfX8VKYqoARBGuiF
        b+BnwYV9owLfpsFixPXMV8M0yGH1VmfcoBgq1MucWc/2fDzjCVM9JM+VG0iDhl/j9MChiXp2h0NPq
        zkr8Td0YQz/T+lUCJ6UqGnzMjOW8EHpzqPKiVTtLHgBjP4jQJAer4MbTcsGJny5th3ShzWjeB5xwU
        fQm5gpjw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lIR9f-00Clm2-Tg; Sat, 06 Mar 2021 07:15:17 +0000
Date:   Sat, 6 Mar 2021 07:15:15 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix uninitialized variables in
 xrep_calc_ag_resblks
Message-ID: <20210306071515.GA3042800@infradead.org>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472412192.3421582.514508996639938538.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472412192.3421582.514508996639938538.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we can't read the AGF header, we never actually set a value for
> freelen and usedlen.  These two variables are used to make the worst
> case estimate of btree size, so it's safe to set them to the AG size as
> a fallback.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
