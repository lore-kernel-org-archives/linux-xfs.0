Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbdH1Kvx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Aug 2017 06:51:53 -0400
Date: Mon, 28 Aug 2017 06:51:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/9] xfs: remove unnecessary dirty bli format check for
 ordered bufs
Message-ID: <20170828105151.GC3098@localhost.localdomain>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-3-bfoster@redhat.com>
 <20170828092543.GB28514@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828092543.GB28514@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 02:25:43AM -0700, Christoph Hellwig wrote:
> This looks generally good, but I have a few nitpicks, too :)
> 
> On Fri, Aug 25, 2017 at 11:05:50AM -0400, Brian Foster wrote:
> > -	bool			clean;
> > +	bool			dirty;
> >  	bool			aborted;
> > +	bool			ordered;
> 
> Can we just initialize all these variables here at the declaration
> 

Sure..

> > +	 * The bli dirty state should match whether the blf has logged segments
> > +	 * except for ordered buffers, where only the bli should be dirty.
> >  	 */
> > +	dirty = (flags & XFS_BLI_DIRTY) ? true : false;
> > +	ordered = (flags & XFS_BLI_ORDERED) ? true : false;
> 
> No need for the "? true : false" both for these two and the existing
> aborted case.
> 

Ok, so I assume you mean to change these to something like:

	bool			aborted = !!(bip->bli_flags & XFS_BLI_ABORTED);
	...

> > +/*
> > + * Return true if the buffer has any ranges logged/dirtied by a transaction,
> > + * false otherwise.
> > + */
> > +bool
> > +xfs_buf_item_dirty_format(
> 
> Do you need this outside of xfs_buf_item.c later?
> 

It's used in xfs_trans_buf.c as well.

Brian
