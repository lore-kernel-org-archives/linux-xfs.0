Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4D9C38BF9
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF5E520732
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tqmojPNt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgBXWqY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 17:46:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbgBXWqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 17:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=emVsuVrQkFSTVtQ1doa2q5ySiHFAMcMg6ERMbg/GLb4=; b=tqmojPNtfB6XyYZv9lpYHxG4uW
        AWM/7ynZjVHvhWDJ19RB/dKnL1ODzGGyyCPLeoCO2cNaBpTu2zCUhVImjzZoO4OMuUbDwzT3IuqrR
        hQGoaMi4vskJtt4i5apl5R3GePP1GHJhT3FPEfBFwnY1qMUfEx9r2mqXoPeDncvBijAfUCRJuNu7+
        Nmoric0jnnBADYnM6xrb460+BBYivlyufN4V4yLYdANhzQ6moX9SiLjoCd63/m0wnW+bYU1pwd0nJ
        9zETOEntSGLaZRqX6Yp+WWAx/JaP4ZKa1BC1JjUc3uRVQ4nMKMbXbudnhwPdd+1TQ+3CR4Yuc3izN
        lJX269/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6MUY-0002TT-Cu; Mon, 24 Feb 2020 22:46:22 +0000
Date:   Mon, 24 Feb 2020 14:46:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Message-ID: <20200224224622.GA25075@infradead.org>
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-2-hch@lst.de>
 <20200224220256.GA3446@infradead.org>
 <20200224221931.GA6740@magnolia>
 <20200224222118.GA681@infradead.org>
 <20200224222737.GB6740@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224222737.GB6740@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:27:37PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 24, 2020 at 02:21:18PM -0800, Christoph Hellwig wrote:
> > On Mon, Feb 24, 2020 at 02:19:31PM -0800, Darrick J. Wong wrote:
> > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Any chance we can pick this up for 5.6 to unbreak arm OABI?
> > > 
> > > Yeah, I can do that.  Is there a Fixes: tag that goes with this?
> > 
> > I'm not sure what to add.  I think the problem itself has actually
> > always been around since adding v5 fs support.  But the build break
> > was only caused by the addition of the BUILD_BUG_ON.
> 
> Hmm.  That's tricky, since in theory this should go all the way back to
> the introduction of the v5 format in 3.x, but that's going to require
> explicit backporting to get past all the reorganization and other things
> that have happened.  We might just have to hand-backport it to the
> stable kernels seeing how the macro name change will probably cause all
> sorts of problems with AI backports. :/

So which fixes tag do you want?  Or feel free to just add the one you
feel fits best.

> > > Also, will you have a chance to respin the last patch for 5.7?
> > 
> > Last patch in this series?
> 
> Yes.  From the discussion of patch 6/6,
> 
> "+   __xfs_sb_from_disk(&sb, bp->b_addr, false);
> 
> "why not dsb here
> 
> "Yes, this should just pass dsb."

Oh.  I've actually had the respun branch on my box since a day after
that comment.  But I think it doesn't make sense until the fix in
patch one is in the baseline tree, given how many outstanding patch
series we have.
