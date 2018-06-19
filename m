Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38148 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932843AbeFSGus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 02:50:48 -0400
Date: Mon, 18 Jun 2018 23:50:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] iomap: move bdev and dax_dev in a union
Message-ID: <20180619065029.GB21698@magnolia>
References: <20180614120457.28285-1-hch@lst.de>
 <20180614120457.28285-3-hch@lst.de>
 <20180619062557.GA21698@magnolia>
 <20180619064451.GA24824@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619064451.GA24824@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

On Tue, Jun 19, 2018 at 08:44:51AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 18, 2018 at 11:25:57PM -0700, Darrick J. Wong wrote:
> > Is this going to blow up iomap_dax_zero?  It seems to use both bdev and
> > dax_dev on __dax_zero_page_range, which definitely uses both.
> > 
> > (Or did all that get rearranged when I wasn't looking?)
> 
> Ouch, it does.  And that looks pretty broken.

Indeed.

> > Also, I guess this will break iomap swapfiles since it checks
> > iomap->bdev which we stop supplying with this patch...
> > though I have no idea if DAX swapfiles are even supported.
> 
> Not sure if we support it.  We didn't use to support it when
> swap used ->bmap, so until someone volunteers to test it we
> should disable it with the iomap swapfile code as well.  But
> even then doing a detour through the block layer and thus
> the bdev makes very little sense.

For now all we do with it is compare iomap->bdev to the swapfile bdev so
it'll effectively disable DAX swapfiles in a weird and scary way...

...but maybe we should ask around if anyone cares about DAX swapfiles.
Everyone may just run away, but at least we will have tried. :)

> > 
> > What's the harm in supplying both pointers?
> 
> Just blowing up the size of the iomap.  Especially once we add
> the inline data as the third option.

<nod>

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
