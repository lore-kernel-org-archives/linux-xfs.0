Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC274C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC4C2312D
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbhASHDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 02:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730649AbhASHDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:03:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1B2C061575
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=LSOZESCVaWuNCqwS3Ualosswkt
        6eeDX8jXrix848hCMjCRjJhq/pMLOBnkDwm9TsYECX0zO6D4FN/gw9/i8dr8Vhip9YnB3x9TUs9fU
        mTxs5KPTpPtxTaok07kym9XIGtn/8tSEJRfBuVY4WDxT3pFuCmy2t5yo9ojx69pIvuTDTGaRZ9pL7
        4k9Pr8MpzgRyOJN+Jj60WLh0XvewgVUajABKDdThES6HIoW1PaSxpwdlc+oY4Xu8MgDnt4bmhyVW0
        BcKgKre7DNNLDhn10ajIz9FPSwSo+ceC6Lb/LD3euhr6A94GgcXk6wZCKdEyaWXOT0nKGWnqtA1xw
        D12DwaSw==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1l1h-00Dw2k-Kj; Tue, 19 Jan 2021 07:02:11 +0000
Date:   Tue, 19 Jan 2021 07:59:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
Message-ID: <YAaDae62QfvuLGas@infradead.org>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
 <161100794571.88816.8971225498794802527.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100794571.88816.8971225498794802527.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
