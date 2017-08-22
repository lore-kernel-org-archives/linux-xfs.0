Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18262 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdHVQl5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 12:41:57 -0400
Date: Tue, 22 Aug 2017 09:41:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: another possible integer truncation in xfs
Message-ID: <20170822164134.GV4796@magnolia>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173010E035CD2@EXCHANGE.collogia.de>
 <20170821081603.GA6581@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170821081603.GA6581@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Markus Stockhausen <stockhausen@collogia.de>, "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Aug 21, 2017 at 10:16:03AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 21, 2017 at 08:01:03AM +0000, Markus Stockhausen wrote:
> > Hi Christoph,
> > 
> > out of curiosity I looked for other use cases of min_t in xfs. At least 
> > until 4.12 there is a similar constellation in xfs_dir2_leaf_readbuf:
> > 
> >   if (trim_map) {
> >     mip->map_blocks -= geo->fsbcount;
> >     /*
> >      * Loop to get rid of the extents for the
> >      * directory block.
> >      */
> >     for (i = geo->fsbcount; i > 0; ) {
> >       j = min_t(int, map->br_blockcount, i);
> >       map->br_blockcount -= j;
> >       map->br_startblock += j;
> >       map->br_startoff += j;
> > 
> > The loop could go havoc if map->br_blockcount is larger than 
> > 2G. If you think it could classify for stable feel free to add it too.

"2G"... are you concerned about an integer overflow if map->br_blockcount
is a value larger than 2147483647, or if *map itself represents an
extent longer than 2GiB?  (I'm pretty sure you're talking about the
first scenario, but the units here are ambiguous.)

I /think/ the correct answer here is that file extent records can't ever
be longer than 2^20 blocks so this min_t ought to be fine.

--D

> I don't think it has a chance to be larger in practice, but we should
> fix it anyway.  I'll prepare a patch.
> 
> Thanks for spotting this!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
