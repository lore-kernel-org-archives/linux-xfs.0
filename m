Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35610 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbfBAQIm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 11:08:42 -0500
Date: Fri, 1 Feb 2019 17:08:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] FOLD: improve xfs_bmapi_delalloc
Message-ID: <20190201160840.GB6532@lst.de>
References: <20190131075524.4769-1-hch@lst.de> <20190131075524.4769-2-hch@lst.de> <20190131180957.GC36239@bfoster> <20190201072322.GA14711@lst.de> <20190201072820.GA14783@lst.de> <20190201124655.GB40798@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201124655.GB40798@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 07:46:56AM -0500, Brian Foster wrote:
> Ok, I see. Hmm.. I'm wondering how accurate the ->total value is in the
> delalloc conversion path. IIUC, the purpose is to try and select an AG
> with enough blocks for the allocation along with the indirect blocks to
> insert into the bmbt. Both of those have been reserved at delalloc res
> time, hence not needed in the tx. The AG selection code uses the max of
> total and the allocation request size, which means that for most
> conversions (> maxlevels) total is a no-op. Shouldn't total reflect the
> full size of the allocation (alloc size + maxlevels) regardless of
> whether the blocks were already "globally reserved?" Note that this is
> existing code and probably not something I would change in this series..

I think the total value in this path is completely bogus.  A while
ago I had a series trying to sort out some of these reservation
issues, but it will take a fair amount of work to get back to that.
