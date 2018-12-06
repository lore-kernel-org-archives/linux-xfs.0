Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57765 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbeLFPRR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Dec 2018 10:17:17 -0500
Date: Thu, 6 Dec 2018 16:17:15 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: use a dedicated SLAB cache for sector sized
 buffer data
Message-ID: <20181206151715.GA25967@lst.de>
References: <20181205225147.12626-1-hch@lst.de> <20181206125151.GA49273@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206125151.GA49273@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Thu, Dec 06, 2018 at 07:51:52AM -0500, Brian Foster wrote:
> On Wed, Dec 05, 2018 at 02:51:47PM -0800, Christoph Hellwig wrote:
> > XFS currently uses kmalloc for buffers smaller than the page size to
> > avoid wasting too much memory.  But this can cause a problem with slub
> > debugging turned on as the allocations might not be naturally aligned.
> > On block devices that require sector size alignment this can lead to
> > data corruption.
> > 
> > Give that our smaller than page size buffers are always sector sized
> > on a live file system, we can just create a kmem_cache with an
> > explicitly specified alignment requirement for this case to fix this
> > case without much effort.
> > 
> 
> What exactly is the data corruption related problem? Can you
> characterize it in a couple sentences?

Ming reported the actual occurance, so he can explain in detail.  But
the summary is that various devices require a minimum alignment for DMA,
and if we don't follow that bad things will happen.  What "bad things"
are might vary from case to case.
