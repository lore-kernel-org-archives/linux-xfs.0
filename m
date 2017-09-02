Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51153 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752732AbdIBRJF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 13:09:05 -0400
Date: Sat, 2 Sep 2017 10:08:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs: open code end_buffer_async_write in
 xfs_finish_page_writeback
Message-ID: <20170902170858.GD4073@magnolia>
References: <20170816085157.24074-1-hch@lst.de>
 <20170816154454.GX4796@magnolia>
 <20170902163245.GA6141@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902163245.GA6141@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Sat, Sep 02, 2017 at 06:32:45PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 16, 2017 at 08:44:54AM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 16, 2017 at 10:51:57AM +0200, Christoph Hellwig wrote:
> > > Our loop in xfs_finish_page_writeback, which iterates over all buffer
> > > heads in a page and then calls end_buffer_async_write, which also
> > > iterates over all buffers in the page to check if any I/O is in flight
> > > is not only inefficient, but also potentially dangerous as
> > > end_buffer_async_write can cause the page and all buffers to be freed.
> > > 
> > > Replace it with a single loop that does the work of end_buffer_async_write
> > > on a per-page basis.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks ok,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > I'm assuming 4.14 for this one, unless you know of people banging into
> > use-after-free problems and therefore need it pushed into 4.13?
> 
> Looks like it didn't make it into for-next for 4.14 either.

Fortunately, I received this email just as I was about to kick off the
weekend soak tests, so it'll be the last thing that goes in for 4.14
(assuming QA tests pass and all that stuff).  It's a 3 day weekend which
means it's easier to commandeer everything for a mass test. :)

Anyway, thanks for the reminder(s) everyone.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
