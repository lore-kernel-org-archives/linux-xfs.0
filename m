Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9285C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 12:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C54F4207DA
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 12:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KC6s2PS1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgHUMob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 08:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHUMoa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 08:44:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DCCC061385;
        Fri, 21 Aug 2020 05:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XCvj4UvtI8iBMYfCEtiYykY+vZaMey49dX7k5fdz2Jg=; b=KC6s2PS1ionfOA78d78PGDMnaB
        FDAIx5puFcJZXfcSERkREBH32q+nIbrgXoHUzQQEgU1mBAbPrkfGAJlvSAlsHMLfsGLxHKbXbFmEP
        gQXHWs+AmSm4PDeKFmIKpshtm6F/h43HCmxteQyPaOBa5/+HCYjwoyOrQM+mIuNN//3M0F/OUqakg
        D5ehuGs8JM6e9288weor4jAwKwv6dpmTsN8ydizOAXMOTD99eJ4lrt8PUN7Nfzhbcx0Nsietjmgrm
        YC8qNAgchLRkivAdnJFy3zUaMJg3/HTdoRrTkJEj6SdTlU0D5n8ZNl9qAW6mEDPoh5077C8BmCfk1
        48nuulxg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k96PA-0002Yc-2R; Fri, 21 Aug 2020 12:44:24 +0000
Date:   Fri, 21 Aug 2020 13:44:24 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     hch@infradead.org, darrick.wong@oracle.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [RFC PATCH V4] iomap: add support to track dirty state of sub
 pages
Message-ID: <20200821124424.GQ17456@casper.infradead.org>
References: <20200821123306.1658495-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821123306.1658495-1-yukuai3@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 21, 2020 at 08:33:06PM +0800, Yu Kuai wrote:
> changes from v3:
>  - add IOMAP_STATE_ARRAY_SIZE
>  - replace set_bit / clear_bit with bitmap_set / bitmap_clear
>  - move iomap_set_page_dirty() out of 'iop->state_lock'
>  - merge iomap_set/clear_range_dirty() and iomap_iop_clear/clear_range_dirty()

I'm still working on the iomap parts of the THP series (fixing up
invalidatepage right now), but here are some of the relevant bits (patch
series to follow)

