Return-Path: <SRS0=2Dxs=CH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB95DC433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 06:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9086120838
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 06:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgH2GrP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 02:47:15 -0400
Received: from verein.lst.de ([213.95.11.211]:43883 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgH2GrP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 29 Aug 2020 02:47:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id ED6F368C4E; Sat, 29 Aug 2020 08:47:12 +0200 (CEST)
Date:   Sat, 29 Aug 2020 08:47:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs: reuse _xfs_buf_read for re-reading the
 superblock
Message-ID: <20200829064712.GA6216@lst.de>
References: <20200709150453.109230-1-hch@lst.de> <20200709150453.109230-14-hch@lst.de> <20200818230256.GN6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818230256.GN6096@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 04:02:56PM -0700, Darrick J. Wong wrote:
> > -	xfs_buf_flags_t		flags)
> > +	struct xfs_buf		*bp,
> > +	xfs_buf_flags_t		flags,
> > +	const struct xfs_buf_ops *ops)
> >  {
> > -	ASSERT(!(flags & XBF_WRITE));
> >  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
> > +	ASSERT(!(flags & XBF_WRITE));
> >  
> > -	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
> > -	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
> > +	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
> > +	bp->b_flags |= flags & (XBF_ASYNC | XBF_READ_AHEAD);
> 
> Doesn't this change mean that the caller's XBF_READ never gets set
> in bp->b_flags?  If the buffer is already in memory but doesn't have
> XBF_DONE set, how does XBF_READ get set?  Maybe I'm missing something?

Yes, this is broken for the re-read case.
