Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfBAMq7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 07:46:59 -0500
Date: Fri, 1 Feb 2019 07:46:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/11] FOLD: improve xfs_bmapi_delalloc
Message-ID: <20190201124655.GB40798@bfoster>
References: <20190131075524.4769-1-hch@lst.de>
 <20190131075524.4769-2-hch@lst.de>
 <20190131180957.GC36239@bfoster>
 <20190201072322.GA14711@lst.de>
 <20190201072820.GA14783@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201072820.GA14783@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 08:28:20AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 01, 2019 at 08:23:22AM +0100, Christoph Hellwig wrote:
> > > >  	flags |= XFS_BMAPI_DELALLOC;
> > > > -	return xfs_bmapi_write(tp, ip, bno, 1, flags, total, imap, nimaps);
> > > > +	error = xfs_bmapi_write(tp, ip, offset_fsb, 1, flags,
> > > > +			XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK),
> > > 
> > > Shouldn't this be whichfork?
> > 
> > Yeah.
> 
> Actually - XFS_EXTENTADD_SPACE_RES expands to XFS_BM_MAXLEVELS, which
> indexes into m_bm_maxlevels, which only contains two members, one for
> the data and one for the attr fork.  So this should stay a hardcoded
> XFS_DATA_FORK.

Ok, I see. Hmm.. I'm wondering how accurate the ->total value is in the
delalloc conversion path. IIUC, the purpose is to try and select an AG
with enough blocks for the allocation along with the indirect blocks to
insert into the bmbt. Both of those have been reserved at delalloc res
time, hence not needed in the tx. The AG selection code uses the max of
total and the allocation request size, which means that for most
conversions (> maxlevels) total is a no-op. Shouldn't total reflect the
full size of the allocation (alloc size + maxlevels) regardless of
whether the blocks were already "globally reserved?" Note that this is
existing code and probably not something I would change in this series..

That aside, I'll repost my series with this folded in and the other bits
dropped..

Brian
