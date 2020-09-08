Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80522C2D0A7
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F83021D40
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:16:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kmWkgFuv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgIHUQf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbgIHPKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:10:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6271C0A5533
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nnxlTweDKsjmEER/IBtEWhhmYpgtrlDppZ+nsrR0iYE=; b=kmWkgFuvP1nxw/+jcItWoGkWtz
        1FVmevnI82JMxsqp6/5nhi0DbP1cNV9ZOrk46YhCFqALua1/3wqNwjmKcr7M87V2UKYvA7W0uL5dX
        IW+plL1iV2+PamB/bjtKNH2uMbVdL+vQCH8k3mPEQu5rQ3aJw8LVPxHXkpG4lzpRBkfFocS84HxXq
        OTSFQLYjh1GfyQl4pjP+xit5gGAKH8mFYXSaixQe/U1y34C5S2k+1XfDry0fHGGib/yde0Ioa/H67
        maL4Js0kooFZ0Rgar4MEBewaTxQ0HXk1rMVQjp6p6EQgYDfxkhb5ewFvhbLJdmQp6VpygRjeiBOVR
        z5MHjojA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFf4f-0003EV-0W; Tue, 08 Sep 2020 14:58:21 +0000
Date:   Tue, 8 Sep 2020 15:58:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: make sure the rt allocator doesn't run off the
 end
Message-ID: <20200908145820.GM6039@infradead.org>
References: <159950166214.582172.6124562615225976168.stgit@magnolia>
 <159950167474.582172.16930353017934744381.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950167474.582172.16930353017934744381.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 11:01:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's an overflow bug in the realtime allocator.  If the rt volume is
> large enough to handle a single allocation request that is larger than
> the maximum bmap extent length and the rt bitmap ends exactly on a
> bitmap block boundary, it's possible that the near allocator will try to
> check the freeness of a range that extends past the end of the bitmap.
> This fails with a corruption error and shuts down the fs.
> 
> Therefore, constrain maxlen so that the range scan cannot run off the
> end of the rt bitmap.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
