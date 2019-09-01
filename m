Return-Path: <SRS0=vvgS=W4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46338C3A5A4
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 07:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BEE22173E
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 07:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfIAHgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 03:36:37 -0400
Received: from verein.lst.de ([213.95.11.211]:40502 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728780AbfIAHgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 1 Sep 2019 03:36:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6A899227A8A; Sun,  1 Sep 2019 09:36:34 +0200 (CEST)
Date:   Sun, 1 Sep 2019 09:36:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Message-ID: <20190901073634.GA11777@lst.de>
References: <20190830102411.519-1-hch@lst.de> <20190830102411.519-2-hch@lst.de> <20190830150650.GA5354@magnolia> <20190830153253.GA20550@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830153253.GA20550@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 05:32:53PM +0200, Christoph Hellwig wrote:
> On Fri, Aug 30, 2019 at 08:06:50AM -0700, Darrick J. Wong wrote:
> > > --- a/fs/xfs/libxfs/xfs_bmap.h
> > > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > > @@ -171,6 +171,9 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> > >  		!isnullstartblock(irec->br_startblock);
> > >  }
> > >  
> > > +#define xfs_valid_startblock(ip, startblock) \
> > > +	((startblock) != 0 || XFS_IS_REALTIME_INODE(ip))
> > 
> > We have more robust validators for data/rtdev fsblock_t, so why not:
> > 
> > #define xfs_valid_startblock(ip, startblock) \
> > 	(XFS_IS_REALTIME_INODE(ip) ? xfs_verify_rtbno(startblock) : \
> > 				     xfs_verify_fsbno(startblock))
> > 
> > and why not make it a static inline function too?
> 
> I tried an inline function, but I could not find a header to place
> it that would actually easily compile everywhere...  Maybe we should
> just make that a xfs_verify_bno(mp, startblock) and move that out of
> line such in a way that a smart compiler avoids the function call
> overhead for xfs_verify_rtbno / xfs_verify_fsbno.  I'll take another
> stab at this.

So I looked into your suggestion, but xfs_verify_rtbno / xfs_verify_fsbno
do a lot of validity checking, but they don't actually contain the
check that was in the existing code.  The bmap code just checks that
there is a startblock of 0 for non-rt devices, probably this was added
to find some old bug where a irec structure that was zeroed was returned.

So replacing it with xfs_verify_rtbno / xfs_verify_fsbno would not help
in any way.  But the big question is if keeping the 0 check is even
worth it.
