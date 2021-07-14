Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D44C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 07:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB364613AF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 07:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbhGNHIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbhGNHIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 03:08:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A250FC061574
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 00:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sXK//sJyXvTS/grNeVKYtUnnR4zJDKzxY30nRD6ZH18=; b=LIViMB7gNg0vQbTHsEgYgARzRD
        MVMKLOgSA68zDzYLbPQuUPbrwbAJfaYwJWSU83JdHUheIcJOCltq+c9ks7X9xpL2wjIfNlijd+dhd
        CodaZVyhcegV+nwtehdN8A/y5oArQW3+xy00rNyDwtYocgB9UNfmNJnBtZHEf5n/R2veZWMWnk0Jf
        yvB4IPJLn3Wq3w40BXt8Sj0BK2bfHjv1hvQDjp1fNpo25+F5AcSqbrtmfib2AWlbfJwXY6OpL3ltu
        EaG97316WF/Ix/9Oy8HtzFyjl4fUthwSMa3tCVjpPLuIj43XV1UsrFoKvXTAKwZVuu4LCvBT6ONNn
        8mf9wahg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3Yxg-001wjW-9v; Wed, 14 Jul 2021 07:05:48 +0000
Date:   Wed, 14 Jul 2021 08:05:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs: consolidate mount option features in
 m_features
Message-ID: <YO6MxE1VvDYqCc4s@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This provides separation of mount time feature flags from runtime
> mount flags and mount option state. It also makes the feature
> checks use the same interface as the superblock features. i.e. we
> don't care if the feature is enabled by superblock flags or mount
> options, we just care if it's enabled or not.

What about using a separate field for these?  With this patch we've used
up all 64-bits in the features field, which isn't exactly the definition
of future proof..
