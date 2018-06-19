Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39318 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755513AbeFSGfw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 02:35:52 -0400
Date: Tue, 19 Jun 2018 08:44:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] iomap: move bdev and dax_dev in a union
Message-ID: <20180619064451.GA24824@lst.de>
References: <20180614120457.28285-1-hch@lst.de> <20180614120457.28285-3-hch@lst.de> <20180619062557.GA21698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619062557.GA21698@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

On Mon, Jun 18, 2018 at 11:25:57PM -0700, Darrick J. Wong wrote:
> Is this going to blow up iomap_dax_zero?  It seems to use both bdev and
> dax_dev on __dax_zero_page_range, which definitely uses both.
> 
> (Or did all that get rearranged when I wasn't looking?)

Ouch, it does.  And that looks pretty broken.

> Also, I guess this will break iomap swapfiles since it checks
> iomap->bdev which we stop supplying with this patch...
> though I have no idea if DAX swapfiles are even supported.

Not sure if we support it.  We didn't use to support it when
swap used ->bmap, so until someone volunteers to test it we
should disable it with the iomap swapfile code as well.  But
even then doing a detour through the block layer and thus
the bdev makes very little sense.

> 
> What's the harm in supplying both pointers?

Just blowing up the size of the iomap.  Especially once we add
the inline data as the third option.
