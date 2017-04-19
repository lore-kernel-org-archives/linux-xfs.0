Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36766 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030594AbdDSSH7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 14:07:59 -0400
Date: Wed, 19 Apr 2017 20:07:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] xfs: introduce xfs_bmapi_remap
Message-ID: <20170419180757.GA26319@lst.de>
References: <20170412103013.9355-1-hch@lst.de> <20170412103013.9355-5-hch@lst.de> <20170412192827.GQ8502@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412192827.GQ8502@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 12:28:27PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 12, 2017 at 12:30:11PM +0200, Christoph Hellwig wrote:
> > Add a new helper to be used for reflink extent list additions instead of
> > funneling them through xfs_bmapi_write and overloading the firstblock
> > member in struct xfs_bmalloca and struct xfs_alloc_args.
> > 
> > With some small changes to xfs_bmap_remap_alloc this also means we do
> > not need a xfs_bmalloca structure for this case at all.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok, will test...
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

What's the status of this series?
