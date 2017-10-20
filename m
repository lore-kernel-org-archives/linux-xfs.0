Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23598 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752977AbdJTQwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 12:52:50 -0400
Date: Fri, 20 Oct 2017 09:52:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/15] xfs: remove the never fully implemented UUID fork
 format
Message-ID: <20171020165245.GX4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-7-hch@lst.de>
 <20171019224813.GP4755@magnolia>
 <20171020070235.GB11101@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171020070235.GB11101@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 20, 2017 at 09:02:35AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 19, 2017 at 03:48:13PM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 19, 2017 at 08:59:33AM +0200, Christoph Hellwig wrote:
> > > Remove the dead code dealing with the UUID fork format that was never
> > > implemented in Linux (and neither in IRIX as far as I know).
> > 
> > I think I need a little more context on this -- for what purpose was the
> > UUID format created, and has it ever been used anywhere?  When I was
> > working on the ifork verifiers/scrub I noticed that we'd never actually
> > accept anything with that format.
> > 
> > (I'm ok with removing it, I just want to know what I'm killing before I
> > commit to it.)
> 
> For that you'd need to find people that were around at SGI in the 90s..
> 
> Note that we already removed it briefly in 2008, but unlike my patch
> that didn't keep the padding so broken log recovery.
> 
> relevant xfs-import commits:
> 
> Commit that adds the di_format values:
> c049a3e8d776a76a1ba3adaf168a406a8ee52172
> 
> then various commits in early development add UUID inode format
> bits, but none seems to actually ever generate it.
> 
> 1st removal with minor comments on the history:
> 415c805b441845dfc2be7d887f995ea8875358e9

Yummmmmmmmmy!

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Revert of the above:
> 4ddd5953fad77a14f665fefa06899ef9f388b134
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
