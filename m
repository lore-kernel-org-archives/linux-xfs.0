Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbfHHCKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 22:10:51 -0400
Date: Wed, 7 Aug 2019 19:10:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: fix page locking deadlocks when deduping files
Message-ID: <20190808021046.GD7157@magnolia>
References: <20190807145114.GP7138@magnolia>
 <20190807223850.GQ7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807223850.GQ7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: viro@zeniv.linux.org.uk, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Aug 08, 2019 at 08:38:50AM +1000, Dave Chinner wrote:
> On Wed, Aug 07, 2019 at 07:51:14AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > +/*
> > + * Lock two pages, ensuring that we lock in offset order if the pages are from
> > + * the same file.
> > + */
> > +static void vfs_lock_two_pages(struct page *page1, struct page *page2)
> > +{
> > +	if (page1 == page2) {
> > +		lock_page(page1);
> > +		return;
> > +	}
> > +
> > +	if (page1->mapping == page2->mapping && page1->index > page2->index)
> > +		swap(page1, page2);
> 
> I would do this even if the pages are on different mappings. That
> way we don't expose a landmine if some other code locks two pages
> from the same mappings in a different order...

Sure.

> > +	lock_page(page1);
> > +	lock_page(page2);
> > +}
> > +
> >  /*
> >   * Compare extents of two files to see if they are the same.
> >   * Caller must have locked both inodes to prevent write races.
> > @@ -1867,10 +1881,12 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
> >  		dest_page = vfs_dedupe_get_page(dest, destoff);
> >  		if (IS_ERR(dest_page)) {
> >  			error = PTR_ERR(dest_page);
> > -			unlock_page(src_page);
> >  			put_page(src_page);
> >  			goto out_error;
> >  		}
> > +
> > +		vfs_lock_two_pages(src_page, dest_page);
> > +
> >  		src_addr = kmap_atomic(src_page);
> >  		dest_addr = kmap_atomic(dest_page);
> >  
> > @@ -1882,7 +1898,8 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
> >  
> >  		kunmap_atomic(dest_addr);
> >  		kunmap_atomic(src_addr);
> > -		unlock_page(dest_page);
> > +		if (dest_page != src_page)
> > +			unlock_page(dest_page);
> >  		unlock_page(src_page);
> 
> Would it make sense for symmetry to wrap these in
> vfs_unlock_two_pages()?

Sure.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
