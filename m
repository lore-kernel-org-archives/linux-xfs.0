Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51559 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387936AbfEXGPA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 May 2019 02:15:00 -0400
Date: Fri, 24 May 2019 08:14:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/20] xfs: factor out log buffer writing from xlog_sync
Message-ID: <20190524061436.GA2235@lst.de>
References: <20190523173742.15551-1-hch@lst.de> <20190523173742.15551-8-hch@lst.de> <20190523230445.GT29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523230445.GT29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, May 24, 2019 at 09:04:45AM +1000, Dave Chinner wrote:
> > +STATIC void
> > +xlog_write_iclog(
> > +	struct xlog		*log,
> > +	struct xlog_in_core	*iclog,
> > +	struct xfs_buf		*bp,
> > +	uint64_t		bno,
> > +	bool			flush)
> 
> Can you rename this to need_flush here and in xlog_sync()? I kept
> having to check whether it meant "we need a flush" or "we've
> already done a flush" while reading the patch.

Ok.

> But on the extra buffer, we don't set it's I/O length at all....
> 
> Oh, the setting of the IO length is hidden inside
> xfs_buf_associate_memory(). Can you add a comment indicating that
> this is why we omit the setting of the io length for the extra
> buffer?

Well, for one this is how we've always done it, and second we remove
this whole thing and xfs_buf_associate_memory a few patches down the
road.  I'd rather not bother writing a comment here.
