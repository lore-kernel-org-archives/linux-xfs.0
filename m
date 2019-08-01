Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44885 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfHAQfA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Aug 2019 12:35:00 -0400
Date: Thu, 1 Aug 2019 18:34:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 1/3] mm/gup: add make_dirty arg to
 put_user_pages_dirty_lock()
Message-ID: <20190801163453.GA26588@lst.de>
References: <20190730205705.9018-1-jhubbard@nvidia.com> <20190730205705.9018-2-jhubbard@nvidia.com> <20190801060755.GA14893@lst.de> <20190801141906.GC23899@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801141906.GC23899@ziepe.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Christian Benvenuti <benve@cisco.com>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, Jerome Glisse <jglisse@redhat.com>, "Kirill A . Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>

On Thu, Aug 01, 2019 at 11:19:06AM -0300, Jason Gunthorpe wrote:
> Sadly usnic does not use the core rdma umem abstraction but open codes
> an old version of it.
> 
> In this version each sge in the sgl is exactly one page. See
> usnic_uiom_get_pages - so I think this loop is not a bug?

Actually, yes - I think we are fine given that we pass in the number
of elements.  Thus merging by iommus won't affect the list.
