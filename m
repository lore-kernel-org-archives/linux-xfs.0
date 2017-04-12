Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59526 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753179AbdDLIBB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 04:01:01 -0400
Date: Wed, 12 Apr 2017 10:00:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] xfs: remove xfs_bmap_remap_alloc
Message-ID: <20170412080059.GA22618@lst.de>
References: <20170411111011.9437-1-hch@lst.de> <20170411111011.9437-6-hch@lst.de> <20170411230246.GG8502@birch.djwong.org> <20170412053839.GA19900@lst.de> <20170412055535.GI8502@birch.djwong.org> <20170412060026.GB20204@lst.de> <20170412064420.GB5109@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412064420.GB5109@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Apr 11, 2017 at 11:44:20PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 12, 2017 at 08:00:26AM +0200, Christoph Hellwig wrote:
> > > Looks like _bmapi_remap needs to be able to _iread_extents() if the
> > > data fork hasn't been loaded during log recovery.
> > 
> > Yeah, probably.  I'll respin once more with that included.
> 
> Unfortunately, even after adding in the necessary loading code I still
> get -ENOSPC back from xfs_bmap_add_extent_hole_real which causes log
> recovery to fail.

The test in your configuration already fails with -ENOSPC for me on
for-next..
