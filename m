Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfBYKDl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Feb 2019 05:03:41 -0500
Date: Mon, 25 Feb 2019 18:03:26 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190225100325.GA10093@ming.t460p>
References: <20190225040904.5557-1-ming.lei@redhat.com>
 <20190225043648.GE23020@dastard>
 <20190225084623.GA8397@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225084623.GA8397@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.org

On Mon, Feb 25, 2019 at 04:46:25PM +0800, Ming Lei wrote:
> On Mon, Feb 25, 2019 at 03:36:48PM +1100, Dave Chinner wrote:
> > On Mon, Feb 25, 2019 at 12:09:04PM +0800, Ming Lei wrote:
> > > XFS uses kmalloc() to allocate sector sized IO buffer.
> > ....
> > > Use page_frag_alloc() to allocate the sector sized buffer, then the
> > > above issue can be fixed because offset_in_page of allocated buffer
> > > is always sector aligned.
> > 
> > Didn't we already reject this approach because page frags cannot be
> 
> I remembered there is this kind of issue mentioned, but just not found
> the details, so post out the patch for restarting the discussion.
> 
> > reused and that pages allocated to the frag pool are pinned in
> > memory until all fragments allocated on the page have been freed?
> 
> Yes, that is one problem. But if one page is consumed, sooner or later,
> all fragments will be freed, then the page becomes available again.
> 
> > 
> > i.e. when we consider 64k page machines and 4k block sizes (i.e.
> > default config), every single metadata allocation is a sub-page
> > allocation and so will use this new page frag mechanism. IOWs, it
> > will result in fragmenting memory severely and typical memory
> > reclaim not being able to fix it because the metadata that pins each
> > page is largely unreclaimable...
> 
> It can be an issue in case of IO timeout & retry.

The worst case is still not worse than allocating single page for sub-page
IO, which should be used on other file systems under the same situation,
I guess.

thanks,
Ming
