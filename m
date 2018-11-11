Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:41783 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbeKKLCe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Nov 2018 06:02:34 -0500
Date: Sun, 11 Nov 2018 12:15:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/16] iomap: prepare buffered IO paths for block size >
 page size
Message-ID: <20181111011517.GJ19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-8-david@fromorbit.com>
 <20181109151938.GG9153@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109151938.GG9153@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Nov 09, 2018 at 07:19:38AM -0800, Christoph Hellwig wrote:
> > +/*
> > + * Return the block size we should use for page cache based operations.
> > + * This will return the inode block size for block size < PAGE_SIZE,
> > + * otherwise it will return PAGE_SIZE.
> > + */
> > +static inline unsigned
> > +iomap_pageblock_size(struct inode *inode)
> 
> Maybe cal this a chunk size instead?

Sure.

/me has flashbacks to Irix and it's "chunk cache" for efficient
filesystem block size state tracking and caching over the top of the
page cache.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
