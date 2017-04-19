Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44111 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030745AbdDSScy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 14:32:54 -0400
Date: Wed, 19 Apr 2017 11:32:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] xfs: introduce xfs_bmapi_remap
Message-ID: <20170419183250.GI5193@birch.djwong.org>
References: <20170412103013.9355-1-hch@lst.de>
 <20170412103013.9355-5-hch@lst.de>
 <20170412192827.GQ8502@birch.djwong.org>
 <20170419180757.GA26319@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419180757.GA26319@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 08:07:57PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 12, 2017 at 12:28:27PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 12, 2017 at 12:30:11PM +0200, Christoph Hellwig wrote:
> > > Add a new helper to be used for reflink extent list additions instead of
> > > funneling them through xfs_bmapi_write and overloading the firstblock
> > > member in struct xfs_bmalloca and struct xfs_alloc_args.
> > > 
> > > With some small changes to xfs_bmap_remap_alloc this also means we do
> > > not need a xfs_bmalloca structure for this case at all.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks ok, will test...
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> What's the status of this series?

Seems fine in testing here.  I was planning to push it for 4.12.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
