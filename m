Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28475C2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 11:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7B742076B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 11:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fiz9D45S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732957AbgKXLwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 06:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732852AbgKXLww (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 06:52:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5BFC0613D6;
        Tue, 24 Nov 2020 03:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EcWi9+S29vOTFIAAm9bKVVKBIY3LaJMRPri+apbEGP8=; b=Fiz9D45SkyFlVfE2RbxXqJ8oUG
        F45hNDPlYd6z1KtuS6IJXKWqExQGxhxZMW1rEOAT5icqPVG8OmKwHPHm3ZXDqf174Py+EIoHqlHb9
        XgiX8KfMhA1O/aMB6q8p1g9DcrMpDTYRm1wgMNr1kKTatHnEpmkLHOLea1cGfDd/wrtcywozyUt1z
        w2Hk8lrazrHXfvmiXnuHG9UEGsA5yEz/z/JJwqZuaDCHkgA9u4sUZ8UxaFPi5+ToDDyGijKnWRNTk
        ojQahvjpt08p3Y1o2pNEtquOjuIpwW7I1AT3PiVicJBhvJtm4Ew6w4kk/W/OE3X8ooajD5uHaDPKX
        VX5/q5IQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khWs4-0000Tx-5n; Tue, 24 Nov 2020 11:52:32 +0000
Date:   Tue, 24 Nov 2020 11:52:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove the extra processing of zero size in
 xfs_idata_realloc()
Message-ID: <20201124115232.GC32060@infradead.org>
References: <20201124104531.561-1-thunder.leizhen@huawei.com>
 <20201124104531.561-3-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124104531.561-3-thunder.leizhen@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 06:45:31PM +0800, Zhen Lei wrote:
> krealloc() does the free operation when the parameter new_size is 0, with
> ZERO_SIZE_PTR returned. Because all other places use NULL to check whether
> if_data is available or not, so covert it from ZERO_SIZE_PTR to NULL.

This new code looks much harder to read than the version it replaced.
