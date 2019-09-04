Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BCDC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBDE723401
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZnsUO8to"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfIDF4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 01:56:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49300 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfIDF4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 01:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IExjpeV2be9LVhwLQV/a5zdhD+pgEIxgoyQWRGPAoY0=; b=ZnsUO8toCXrJpAy58McnJybjR
        x7Eg2DVImQZZrWd0wKyGGhj6JW2rZf963AGw5fqk/wxKwrRxXpjBMiqFwYDqPZ0+WQqkJYhCMF/R2
        SZ882M9O8SGVM0gsjKiuNcruUpgqnGwIXbh7PsgBxpVfujth8s3ISNwMfScAElDwogYpmlb9LwUY3
        P9OaAcYbgyA/ScgReTZ8za8tWnH37wooaa6EAX1p9pk1MkokS8g7jsEoi6OrLDzcBys4j6roSyKtB
        uEXFbfgd0b/bLoBHn87ca698XKpsVsiRVXHizmk2I9sCwBtneKy64aC1c9v/tqpeROCCkQbhcEIwg
        cA6nVO/CQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5OHD-0001r9-2t; Wed, 04 Sep 2019 05:56:19 +0000
Date:   Tue, 3 Sep 2019 22:56:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] xfs: log race fixes and cleanups
Message-ID: <20190904055619.GA2279@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904052600.GA27276@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904052600.GA27276@infradead.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 10:26:00PM -0700, Christoph Hellwig wrote:
> On Wed, Sep 04, 2019 at 02:24:44PM +1000, Dave Chinner wrote:
> > HI folks,
> > 
> > This series of patches contain fixes for the generic/530 hangs that
> > Chandan and Jan reported recently. The first patch in the series is
> > the main fix for this, though in theory the last patch in the series
> > is necessary to totally close the problem off.
> 
> While I haven't been active in the thread I already reported this weeks
> ago as well..

And unfortunately generic/530 still hangs for me with this series.
This is an x86-64 VM with 4G of RAM and virtio-blk, default mkfs.xfs
options from current xfsprogs, 20G test and scratch fs.
