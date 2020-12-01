Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB15BC64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE9220809
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Eq6QiAZW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgLAKSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgLAKSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:18:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C1C0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Eq6QiAZWE1ToTO9OoKXosvX4e7
        3uUE2lwdDn6EGs5yYaxnYFWHHIuDtCqHRGAes2JB+ChwmxtlvlovhC1ZgYPSMhcUTcjDKLq4esiAa
        9WSPX+FqC8VaAzlr0LXAqG262ZLhdE56/0acWwjG+40793OWqWiaTomi5pN+7XOsvBSjFQUQqq28J
        gx8sPV11fPgyNt8j5mnC6OTJC6i9bFMPI1rVB9kj4DlvEAKpMNMjADz88vTAq5yg1I4o2NxyOsMFp
        Yx2MtT9+Aj0205JZvPQrXiYSPoFZlicJJ9eMHFp7jlcTvhlcwaYBlOexVJWdmd7ZlTUxJo1SAAF4S
        edmsRxNw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2jc-0003yz-Uc; Tue, 01 Dec 2020 10:18:12 +0000
Date:   Tue, 1 Dec 2020 10:18:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] libxfs: add realtime extent reservation and usage
 tracking to transactions
Message-ID: <20201201101812.GD12730@infradead.org>
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
 <160633669427.634603.6917592828334064504.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160633669427.634603.6917592828334064504.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
