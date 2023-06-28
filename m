Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B95EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 09:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjF1J2e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 05:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjF1H5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 03:57:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C0B3593
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 00:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lRfVuThSrSKGntY6Olk5ufxyBD47A+4zw0LGrsKnryA=; b=V55PxDH7cJSlHyZffd7DL6xKkl
        UK6CantxjUeTcktDXrIosdDUZgW8J7n1sIFdNM/hpYybMo8t3NT0irFoE789qwNWZZ8usUKZo1DHk
        sVIgftmopII/IRZNSl9EsWRRH7hn+6SisEhbTJiPDo/ohS+eLob2eXrYyZ5fJ9GHAUJjtlSirlMtD
        ZykO1rmPFM8TdNrGQ+UhPURzJNX3qUwV4XBDo0DUUWLnMLMJd997+U7YpeiALJ46tKF/g25+ZC81H
        I+2HXMwOxQXHtzpQdwrxb3T/LATlxeLvxPx9p7jLAgWiJ5MxDr6RawaZNfiLin1awTc/a1Dr4cUwf
        QYEn+qIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qEOMA-00Ew9q-2a;
        Wed, 28 Jun 2023 06:08:46 +0000
Date:   Tue, 27 Jun 2023 23:08:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: journal geometry is not properly bounds checked
Message-ID: <ZJvObtDmbYVyR+KO@infradead.org>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	if (sbp->sb_logblocks > XFS_MAX_LOG_BLOCKS) {
> +		xfs_notice(mp,
> +		"Log size 0x%x blocks too large, maximum size is 0x%llx blocks",
> +			 sbp->sb_logblocks, XFS_MAX_LOG_BLOCKS);

Just a little nitpick, didn't we traditionally align the overly
long format strings with a single tab and not to the same line as
the xfs_notice/warn/etc?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
