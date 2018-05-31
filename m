Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36442 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753772AbeEaGBG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 02:01:06 -0400
Date: Thu, 31 May 2018 08:07:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/13] iomap: add an iomap-based bmap implementation
Message-ID: <20180531060731.GA31350@lst.de>
References: <20180530095813.31245-1-hch@lst.de> <20180530095813.31245-11-hch@lst.de> <20180530231156.GH10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530231156.GH10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Thu, May 31, 2018 at 09:11:56AM +1000, Dave Chinner wrote:
> On Wed, May 30, 2018 at 11:58:10AM +0200, Christoph Hellwig wrote:
> > This adds a simple iomap-based implementation of the legacy ->bmap
> > interface.  Note that we can't easily add checks for rt or reflink
> > files, so these will have to remain in the callers.  This interface
> > just needs to die..
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/iomap.c            | 34 ++++++++++++++++++++++++++++++++++
> >  include/linux/iomap.h |  3 +++
> >  2 files changed, 37 insertions(+)
> > 
> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index 74cdf8b5bbb0..b0bc928672af 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -1307,3 +1307,37 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
> >  }
> >  EXPORT_SYMBOL_GPL(iomap_swapfile_activate);
> >  #endif /* CONFIG_SWAP */
> > +
> > +static loff_t
> > +iomap_bmap_actor(struct inode *inode, loff_t pos, loff_t length,
> > +		void *data, struct iomap *iomap)
> > +{
> > +	sector_t *bno = data, addr;
> 
> Can you split these? maybe scope addr insie the if() branch it is
> used in?

This was intentional to avoid wasting another two lines on this
trivial, deprecated functionality..
