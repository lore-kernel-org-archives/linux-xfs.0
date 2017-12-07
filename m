Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57068 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdLGANa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 19:13:30 -0500
Date: Wed, 6 Dec 2017 16:13:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: make iomap_begin functions trim iomaps consistently
Message-ID: <20171207001300.GP19219@magnolia>
References: <20171206183807.GD6896@magnolia>
 <20171207000234.GA8602@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207000234.GA8602@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 06, 2017 at 04:02:34PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 06, 2017 at 10:38:07AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Historically, the XFS iomap_begin function only returned mappings for
> > exactly the range queried, i.e. it doesn't do XFS_BMAPI_ENTIRE lookups.
> > The current vfs iomap consumers are only set up to deal with trimmed
> > mappings.  xfs_xattr_iomap_begin does BMAPI_ENTIRE lookups, which is
> > inconsistent with the current iomap usage.  Remove the flag so that both
> > iomap_begin functions behave the same way.
> > 
> > FWIW this also fixes a behavioral regression in xattr FIEMAP that was
> > introduced in 4.8 wherein attr fork extents are no longer trimmed like
> > they used to be.
> 
> I would still prefer to trim in the iomap code.  But I'll need to find
> some time to look into that, so until then here is my reluctant ACK:

I started looking into that -- the iomap trimming is easy, but the data
fork iomap_begin (with a BMAPI_ENTIRE lookup) gets tripped up on
trimming the iomap around shared extents, because if we have an extent:
(R = regular, S = shared block)

01234567
RRRSSSSS

and we ask for iomap_begin(off=3, len=5) we return RRR (because we trim
to the first change in sharedness status) and not the SSSSS we expect and
then everything goes nuts.... so in the meantime we'll just restore the
old XFS behavior and bikeshed fiemap^W^Wclean it up later.

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
