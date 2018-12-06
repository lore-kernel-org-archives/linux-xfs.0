Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:55747 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725928AbeLFVil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Dec 2018 16:38:41 -0500
Date: Fri, 7 Dec 2018 08:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: use a dedicated SLAB cache for sector sized
 buffer data
Message-ID: <20181206213836.GA6311@dastard>
References: <20181205225147.12626-1-hch@lst.de>
 <20181206125151.GA49273@bfoster>
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

RH BZ 1583556.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
