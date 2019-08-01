Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42295 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731914AbfHAOTI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 10:19:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id h18so70385729qtm.9
        for <linux-xfs@vger.kernel.org>; Thu, 01 Aug 2019 07:19:08 -0700 (PDT)
Date: Thu, 1 Aug 2019 11:19:06 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 1/3] mm/gup: add make_dirty arg to
 put_user_pages_dirty_lock()
Message-ID: <20190801141906.GC23899@ziepe.ca>
References: <20190730205705.9018-1-jhubbard@nvidia.com>
 <20190730205705.9018-2-jhubbard@nvidia.com>
 <20190801060755.GA14893@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801060755.GA14893@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Christian Benvenuti <benve@cisco.com>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, Jerome Glisse <jglisse@redhat.com>, "Kirill A . Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>

On Thu, Aug 01, 2019 at 08:07:55AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 30, 2019 at 01:57:03PM -0700, john.hubbard@gmail.com wrote:
> > @@ -40,10 +40,7 @@
> >  static void __qib_release_user_pages(struct page **p, size_t num_pages,
> >  				     int dirty)
> >  {
> > -	if (dirty)
> > -		put_user_pages_dirty_lock(p, num_pages);
> > -	else
> > -		put_user_pages(p, num_pages);
> > +	put_user_pages_dirty_lock(p, num_pages, dirty);
> >  }
> 
> __qib_release_user_pages should be removed now as a direct call to
> put_user_pages_dirty_lock is a lot more clear.
> 
> > index 0b0237d41613..62e6ffa9ad78 100644
> > +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> > @@ -75,10 +75,7 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
> >  		for_each_sg(chunk->page_list, sg, chunk->nents, i) {
> >  			page = sg_page(sg);
> >  			pa = sg_phys(sg);
> > -			if (dirty)
> > -				put_user_pages_dirty_lock(&page, 1);
> > -			else
> > -				put_user_page(page);
> > +			put_user_pages_dirty_lock(&page, 1, dirty);
> >  			usnic_dbg("pa: %pa\n", &pa);
> 
> There is a pre-existing bug here, as this needs to use the sg_page
> iterator.  Probably worth throwing in a fix into your series while you
> are at it.

Sadly usnic does not use the core rdma umem abstraction but open codes
an old version of it.

In this version each sge in the sgl is exactly one page. See
usnic_uiom_get_pages - so I think this loop is not a bug?

Jason
