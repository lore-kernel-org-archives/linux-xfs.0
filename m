Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00251C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 08:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0495233A0
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 08:03:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m993yB1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfHVIDO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 04:03:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58964 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfHVIDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 04:03:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YFX6AZAtHimep7XZOGP+8tuBIbmpv9UGwd4BK1ynYIQ=; b=m993yB1QthmzBaNgru6nS7FSJ
        EvODrSmLH81PhJsEBLFJf9rRvfs7Eo5uDo+9qkOWvBBWbkHjkDXhvDgURg1vktgW9RmVm9tvEu3qn
        nv7y53MRZxtg4phuyIc3YPrDnyGKVq0TttmwDgIA2S1+DbZGBKnfd4xN2uHk9dUQ60yMeQE9K7JcX
        ncRFx+8goNHMGnHKFhZlfDiseS4TD1jd+FOXN8uOUS1gAfpNjkvhNBQ2xp18y5ge0KqHMg1hVtI3f
        OiMNPhWypQeUK9SPkgkgNoG37ZXAmDvZRSIbtCY7dlBawkcZyTMQq9Wa95H4zzApfQ4cmZgRHdz9Q
        dWWoKRGig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0i3s-0002EI-Kr; Thu, 22 Aug 2019 08:03:12 +0000
Date:   Thu, 22 Aug 2019 01:03:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822080312.GB31346@infradead.org>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
 <20190822003745.GS1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822003745.GS1119@dread.disaster.area>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 10:37:45AM +1000, Dave Chinner wrote:
> > I know Jens disagree, but with the amount of bugs we've been hitting
> > thangs to slub (and I'm pretty sure we have a more hiding outside of
> > XFS) I think we need to add the blk_rq_aligned check to bio_add_page.
> 
> ... I'm not prepared to fight this battle to get this initial fix
> into the code. Get the fix merged, then we can 

Well, the initial fix are the first two patches.  This patch really
just adds a safety belt.  I'll happily take over the effort to get
sensible checks in the block code if you give me a couple weeks,
in the meantime I'd prefer if we could skip this third patch for now.

> > Note that all current callers of bio_add_page can only really check
> > for the return value != the added len anyway, so it is not going to
> > make anything worse.
> 
> It does make things worse - it turns multi-bio chaining loops like
> the one xfs_rw_bdev() into an endless loop as they don't make
> progress - they just keep allocating a new bio and retrying the same
> badly aligned buffer and failing. So if we want an alignment failure
> to error out, callers need to handle the failure, not treat it like
> a full bio.

True.  And we need to improve the interface here, which I'm going
to try to fit into my series that lift some common bio filling code
to the core.  I'll add you to the cc list.
