Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4973FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 17:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0BFB64F69
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 17:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237835AbhBBR73 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbhBBR5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 12:57:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE768C0613D6
        for <linux-xfs@vger.kernel.org>; Tue,  2 Feb 2021 09:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EpC9uoBUMAhqJYCYBkLeRRlKHA7HNC+bdO6tsKhpiq0=; b=bXb5Pc32wpZxm+kUjzbzqnv1rB
        nnFR9qy8qUSqZFQaOShc0Lb68a5susZODK9RQ3c3Uicz3tycD+ICF0nR4B0VY7NNMFvCjj07KInZC
        p6XajZzvYGgeMoMH4Xg7PsLDj5kx3WeRorSuhKkELleuiHZig3OTpyEtgMGq7kw7Ygy9CyLaaGtIp
        NoXtzYqwASzvVAw7MczN+Uih7QlLikJwAr+aaXCTpL20yjTFWOklng+zAewEIWaKiP/SvDCPaypWg
        eudLOHSs5BhPSYspIE2qDau3QbLILRjlFF1mkRWeH5c6Ge3oWPnzUZlTlujHxDnVXDA0td9U/g9of
        1Vrq81lQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zuO-00FYcV-PY; Tue, 02 Feb 2021 17:56:13 +0000
Date:   Tue, 2 Feb 2021 17:56:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 01/16] xfs: fix chown leaking delalloc quota blocks when
 fssetxattr fails
Message-ID: <20210202175612.GA3707285@infradead.org>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223140369.491593.14536007914189520446.stgit@magnolia>
 <20210202131315.GB3336100@bfoster>
 <20210202174726.GM7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202174726.GM7193@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 09:47:26AM -0800, Darrick J. Wong wrote:
> > > +	prevdq->q_blk.reserved -= ip->i_delayed_blks;
> > > +	xfs_dqunlock(prevdq);
> > > +
> > 
> > What's the reason for not using xfs_trans_reserve_quota_bydquots(NULL,
> > ...) here like the original code?
> 
> xfs_trans_reserve_quota_bydquots() makes the caller pass in user, group,
> and project dquots.  It's not difficult to add more code to declare and
> route parameters, but that just felt overdone.
> 
> Given that this is the only place in the codebase where we want to
> change the incore quota reservation on a single dquot, I also didn't
> think it was worth making a whole new function.
> 
> FWIW I don't really mind doing it, it just seemed like more work.
> Alternately I suppose I could expose xfs_trans_dqresv.

xfs_trans_dqresv sounds way better than
xfs_trans_reserve_quota_bydquots. But I'm also perfectly fine with
the current open coded version.  If we insist on layering my preference
would be a new custom helper just for this case instead of going through
much more heavyweight functions.
