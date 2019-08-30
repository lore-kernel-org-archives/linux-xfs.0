Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B78C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0045123429
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfH3Pc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:32:56 -0400
Received: from verein.lst.de ([213.95.11.211]:56556 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727751AbfH3Pc4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Aug 2019 11:32:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8050168BFE; Fri, 30 Aug 2019 17:32:53 +0200 (CEST)
Date:   Fri, 30 Aug 2019 17:32:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Message-ID: <20190830153253.GA20550@lst.de>
References: <20190830102411.519-1-hch@lst.de> <20190830102411.519-2-hch@lst.de> <20190830150650.GA5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830150650.GA5354@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 08:06:50AM -0700, Darrick J. Wong wrote:
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -171,6 +171,9 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> >  		!isnullstartblock(irec->br_startblock);
> >  }
> >  
> > +#define xfs_valid_startblock(ip, startblock) \
> > +	((startblock) != 0 || XFS_IS_REALTIME_INODE(ip))
> 
> We have more robust validators for data/rtdev fsblock_t, so why not:
> 
> #define xfs_valid_startblock(ip, startblock) \
> 	(XFS_IS_REALTIME_INODE(ip) ? xfs_verify_rtbno(startblock) : \
> 				     xfs_verify_fsbno(startblock))
> 
> and why not make it a static inline function too?

I tried an inline function, but I could not find a header to place
it that would actually easily compile everywhere...  Maybe we should
just make that a xfs_verify_bno(mp, startblock) and move that out of
line such in a way that a smart compiler avoids the function call
overhead for xfs_verify_rtbno / xfs_verify_fsbno.  I'll take another
stab at this.
