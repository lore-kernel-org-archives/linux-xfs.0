Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20685 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752393AbdDLT2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 15:28:14 -0400
Date: Wed, 12 Apr 2017 12:28:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: remove xfs_bmap_remap_alloc
Message-ID: <20170412192807.GP8502@birch.djwong.org>
References: <20170411111011.9437-1-hch@lst.de>
 <20170411111011.9437-6-hch@lst.de>
 <20170411230246.GG8502@birch.djwong.org>
 <20170412053839.GA19900@lst.de>
 <20170412055535.GI8502@birch.djwong.org>
 <20170412060026.GB20204@lst.de>
 <20170412064420.GB5109@birch.djwong.org>
 <20170412080059.GA22618@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412080059.GA22618@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 10:00:59AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 11, 2017 at 11:44:20PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 12, 2017 at 08:00:26AM +0200, Christoph Hellwig wrote:
> > > > Looks like _bmapi_remap needs to be able to _iread_extents() if the
> > > > data fork hasn't been loaded during log recovery.
> > > 
> > > Yeah, probably.  I'll respin once more with that included.
> > 
> > Unfortunately, even after adding in the necessary loading code I still
> > get -ENOSPC back from xfs_bmap_add_extent_hole_real which causes log
> > recovery to fail.
> 
> The test in your configuration already fails with -ENOSPC for me on
> for-next..

Crap, there are actually /two/ problems here:

The first problem is that xfs_reflink_end_cow reserves only enough
blocks to handle adding 1 extent.  This is problematic if we fragment
free space, have to do CoW, and then have to perform multiple bmap btree
expansions, which g/187 seems to hit.

The second problem is that the BUI recovery routine doesn't reserve
/any/ blocks to handle btree splits, so when the first problem takes the
fs down, recovery also fails.

Evidently with 1k blocks we can hit this fairly often in g/187 if the
scratch fs is big enough.

Ok, patch soon. <sigh>

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
