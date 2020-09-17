Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C179C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 09:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0447D2083B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 09:04:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qHKL3Ce+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgIQJEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIQJEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 05:04:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E57CC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 02:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6X+z9JJ43GY3oQG3sIqWeHB7nqqICyT/nyUjxl2vDwA=; b=qHKL3Ce+jQdQ5pOOKHgQlaFKWF
        z19+xbfYu8v4SxJrhnpbA8ouTWc/YBuQKgmxg04qOU5RkoedG1aSBTYOS3hFLD1pm6eUUE0GopqzC
        TQVq7OzpPyApxKMfN1XlPz3YMsTef+nrNVYS2Ml3VBlT3FuCj0f4S35lWhnGevrhIwuF6e2/nb2FL
        4yQG/96Qi1hyZIDXVYH7VM8Ku6x/SrYJddnoLDvXezlT0oHZosTWyXJM7WfHBoH6Hn69Sgza8YPFJ
        Bxu549BstThNrAkLX1djPPry5dYm4KS68YCUXI/THY4R8ibw5Lta7LIqlIwqtBh5X3IvUZZCUaGQU
        SZHy24Gw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIppl-0003gP-4A; Thu, 17 Sep 2020 09:04:05 +0000
Date:   Thu, 17 Sep 2020 10:04:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v2 2/2] xfs: attach inode to dquot in xfs_bui_item_recover
Message-ID: <20200917090405.GA13366@infradead.org>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <160031333615.3624373.7775190767495604737.stgit@magnolia>
 <20200917070103.GU7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917070103.GU7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 12:01:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the bmap intent item recovery code, we must be careful to attach the
> inode to its dquots (if quotas are enabled) so that a change in the
> shape of the bmap btree doesn't cause the quota counters to be
> incorrect.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
