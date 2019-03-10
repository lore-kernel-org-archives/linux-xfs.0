Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46371 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfCJFHp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Mar 2019 00:07:45 -0500
From: Sean Fu <fxinrong@gmail.com>
Date: Sun, 10 Mar 2019 13:07:32 +0800
Subject: Re: [PATCH] xfs: Use kmem_zalloc for bp->b_pages.
Message-ID: <20190310050608.dtidrfuqepze6uoh@linux-xjtn>
References: <20190309153636.14154-1-fxinrong@gmail.com>
 <20190309173230.GA4359@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190309173230.GA4359@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Sean Fu <fxinrong@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Mar 09, 2019 at 09:32:30AM -0800, Darrick J. Wong wrote:
> On Sat, Mar 09, 2019 at 11:36:36PM +0800, Sean Fu wrote:
> > Change the allocation of bp->b_pages to use kmem_zalloc instead of
> > kmem_alloc.
> > Remove unnecessary memset for bp->b_pages.
> >
> > This reduces text size by 42 bytes.
> > Before:
> >    text	   data	    bss	    dec	    hex	filename
> >   23335	    588	      8	  23931	   5d7b	./fs/xfs/xfs_buf.o
> > After:
> >    text	   data	    bss	    dec	    hex	filename
> >   23293	    588	      8	  23889	   5d51	./fs/xfs/xfs_buf.o
> >
> > Signed-off-by: Sean Fu <fxinrong@gmail.com>
> > ---
> >  fs/xfs/xfs_buf.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 4f5f2ff3f70f..be4f740b97c1 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -289,12 +289,11 @@ _xfs_buf_get_pages(
> >  		if (page_count <= XB_PAGES) {
> >  			bp->b_pages = bp->b_page_array;
> >  		} else {
> > -			bp->b_pages = kmem_alloc(sizeof(struct page *) *
> > +			bp->b_pages = kmem_zalloc(sizeof(struct page *) *
> >  						 page_count, KM_NOFS);
> >  			if (bp->b_pages == NULL)
> >  				return -ENOMEM;
> >  		}
> > -		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
>
> Does this leave b_pages uninitialized in the page_count <= XB_PAGES
> case?
bp is allocated by kmem_zone_zalloc, But i will take a deep look at xfs_buf_associate_memory.
>
> --D
>
> >  	}
> >  	return 0;
> >  }
> > --
> > 2.16.4
> >
