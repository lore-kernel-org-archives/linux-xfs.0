Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Jul 2006 00:07:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6E77EDW018408
	for <xfs@oss.sgi.com>; Fri, 14 Jul 2006 00:07:25 -0700
Date: Fri, 14 Jul 2006 17:06:29 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH 4/7] xfs: add xfs_btree_check_lptr_disk
Message-ID: <20060714170628.B1797719@wobbly.melbourne.sgi.com>
References: <20060710170420.GD26786@lst.de> <20060712104921.A1732817@wobbly.melbourne.sgi.com> <20060712154317.GA21752@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060712154317.GA21752@lst.de>; from hch@lst.de on Wed, Jul 12, 2006 at 05:43:17PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Hi Christoph,

On Wed, Jul 12, 2006 at 05:43:17PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 12, 2006 at 10:49:21AM +1000, Nathan Scott wrote:
> > 
> > > -			if ((error = xfs_btree_check_lptr(cur, INT_GET(pp[i], ARCH_CONVERT), level))) {
> > > +			if ((error = xfs_btree_check_lptr_disk(cur, pp, level))) {
> > 
> > This incorrectly changes the debug-only btree checking here, no?
> 
> Right, it should be pp[i], I'll resping the patch.  I wonder why I

Don't worry about it - I've got it fixed here.  I'm outta time
for today, will merge it Monday - this and the rest look good.

> > INT_GET?  Maybe static inline here for type checking?  *shrug*.

Send an incremental on the rest of the previous series if you
think this is better, and I'll merge it Monday too.

BTW, the xfs_bulkstat annotations overlapped with a bunch of tuning
work I'd done in there (probably merge that next week too), and I'd
noticed that the endian swizzling in there is all pointless - it's
only an incore buffer of inode clusters... I've got this fixed in a
patch that applies after your series (so I'll apply the sparse work
there, but in the end it'll come back out - no matter).

cheers.

-- 
Nathan
