Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCD6C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 07:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23DF660560
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 07:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhGZGpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 02:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhGZGpc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 02:45:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38CFC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 00:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uDBg/mK4nynAqVbi5WY4QHQok+XoMCSegnqTIBTVK/8=; b=KtW5CI0Az20AhCRf/I1hOIibnW
        Slr90SUP3Db5z2FSWkyz4pJ3SABeQW/zL16h7fcPvvSpShjamXBlxe87MvVSmZRJJeW12pbJAWj/j
        3GMxfndIzSUaX912BCHZQi4Pm0A/C4o/Z6hQvvu4dDTtA5D2k2M7Q6jB15RAkdyzpjcArN+1REF63
        mI+Kq1c/AzBTHT5hzep2v523+ELdHJlueaiopdY2nZTSvX/HiCOIzFdbZLiUWMp4JtakoqLd9NicY
        Y6MVyIsw5BZsG4lGLx21TRHYwQc1xfSNGkVE17tuavgiP/pMNNqxsLBwobQXbDJH0W7QybaUaBXCH
        Kl5+WDcA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7uzb-00DhJK-2Y; Mon, 26 Jul 2021 07:25:48 +0000
Date:   Mon, 26 Jul 2021 08:25:39 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: factor out forced iclog flushes
Message-ID: <YP5jc6pHazRF1nxD@infradead.org>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 04:07:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We force iclogs in several places - we need them all to have the
> same cache flush semantics, so start by factoring out the iclog
> force into a common helper.

We lose the iclog state assert in xlog_unmount_write, but that looks
fine, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
