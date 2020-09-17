Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9466CC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B7421D90
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XybArEG8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgIQINc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgIQINH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:13:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69446C061797
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5XiQTkA5FTOZ2EPN2InMhC5nRnp0FGqLQcf7MdhIyIo=; b=XybArEG8F2J8e369ryemWnJD37
        cpC1nZnlgh6U3nLWSS4zOTBntgp1y8Tatu9kIVwT9PrHcNF7+y2Wmtvt3vP3YVu+atsBEM+z+5aXo
        hKX/D0HUMEqOw0ldl5I0x3VEFjqbB0AukYcjZWJ7w5EdYC4U1ytVyYMW1fKvyb7lFUu9jWPIKFJpx
        cE+MdHTz28xtOJsFdh2UH4McIg6dJjB3a5wRwzg9Xhe/FasyBIbXeNFJfUw3KAf1pYShNSCc8UElq
        i3JEtqsoPIDGARwilG0Y4k/GXpfg4D58b0BQDDsvTikyALG+RlEM049H0LX0ZrwvVVGK1gk3dnV3A
        amA5dwAA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIosX-0007p9-E2; Thu, 17 Sep 2020 08:02:53 +0000
Date:   Thu, 17 Sep 2020 09:02:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: don't flag RTINHERIT files when no rt
 volume
Message-ID: <20200917080253.GW26262@infradead.org>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
 <160013469008.2932378.8829835167711862408.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013469008.2932378.8829835167711862408.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:51:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't flag directories with the RTINHERIT flag set when the filesystem
> doesn't have a realtime volume configured.  The kernel has let us set
> RTINHERIT without a rt volume for ages, so it's not an invalid state.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
