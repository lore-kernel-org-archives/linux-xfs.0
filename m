Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43536 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbfFEPKT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jun 2019 11:10:19 -0400
Date: Wed, 5 Jun 2019 17:09:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/20] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190605150953.GA14846@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603172945.13819-17-hch@lst.de> <20190604061322.GQ29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604061322.GQ29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

> > +
> > +	if (is_vmalloc && op == REQ_OP_READ)
> > +		flush_kernel_vmap_range(data, count);
> 
> That should be REQ_OP_WRITE. i.e. the data the CPU has written to
> the aliased vmap address has to be flushed back to the physical page
> before the DMA from the physical page to the storage device occurs.

Actually it probably should be unconditional, so that we have a
clean cache to start with.  That also matches what xfs_buf.c does.

> > +	if (is_vmalloc && op == REQ_OP_WRITE)
> > +		invalidate_kernel_vmap_range(data, count);
> 
> And this should be REQ_OP_READ - to invalidate anything aliased in
> the CPU cache before the higher layers try to read the new data in
> the physical page...

Fixed.
