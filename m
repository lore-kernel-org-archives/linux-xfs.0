Return-Path: <SRS0=YpFG=EF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD44C55178
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 08:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A64622228
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 08:20:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RLaU6roD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgJ3IUs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgJ3IUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 04:20:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE33FC0613D2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 01:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3w+SSwrDG/8FVgShwu+FC7sN0htD8+1O9iVzgzvCuAY=; b=RLaU6roDfgHaThoQGo4IgYXcok
        EUMRLRXEHzZFjSWd3N4JhA1t3no4YU8w/fjpUJOvpr97PecCA4yydgNAF1Gbb9NchnmSeLggf2dyK
        RguC1YFZG7GGP3lTaRzButFP7S7mdyKUSL8hkAFDD488mHWvyIsUfOokanCMA5vx878Yy6wGnILEj
        s8Ru5NcgIvYmFklivm6ddJ30sg+c4KTMFX7cmJtFwMHrpg3ppdfRXP7RybxFH5eBK3SLZlovi7QQB
        T4N6rZobeUgtQlCsH1pluI8RWdsCBUwduFcQhOnmmTERLuGyVLS+Y/PBC1OxTCVuV3+A+oWjVLqM4
        OFoJ9Lvg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYPeN-0000Cg-4k; Fri, 30 Oct 2020 08:20:43 +0000
Date:   Fri, 30 Oct 2020 08:20:43 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] libfrog: define LIBFROG_BULKSTAT_CHUNKSIZE to
 remove dependence on XFS_INODES_PER_CHUNK
Message-ID: <20201030082043.GA303@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375526530.881414.1004347326416234607.stgit@magnolia>
 <20201029094504.GF2091@infradead.org>
 <20201029094549.GH2091@infradead.org>
 <20201029172557.GQ1061252@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029172557.GQ1061252@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 10:25:57AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 29, 2020 at 09:45:49AM +0000, Christoph Hellwig wrote:
> > On Thu, Oct 29, 2020 at 09:45:04AM +0000, Christoph Hellwig wrote:
> > > Looks good,
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > And no good reason to use struct timespec64 here, right?
> 
> Huh?  There's no mention of a timespec in this patch at all...?

No, but a few patches earlier timespec64 is added with the rationale
that we can't rely on a 64-bit time type otherwise, while we use time64_t
here.
