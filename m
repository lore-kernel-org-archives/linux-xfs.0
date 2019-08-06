Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2263 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfHFUjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 16:39:19 -0400
Subject: Re: [PATCH v2 01/34] mm/gup: add make_dirty arg to
 put_user_pages_dirty_lock()
References: <20190804224915.28669-1-jhubbard@nvidia.com>
 <20190804224915.28669-2-jhubbard@nvidia.com>
 <20190806173945.GA4748@iweiny-DESK2.sc.intel.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <0e232d84-e6ea-159e-91d4-77e938377161@nvidia.com>
Date: Tue, 6 Aug 2019 13:39:16 -0700
MIME-Version: 1.0
In-Reply-To: <20190806173945.GA4748@iweiny-DESK2.sc.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ira Weiny <ira.weiny@intel.com>, john.hubbard@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>

On 8/6/19 10:39 AM, Ira Weiny wrote:
> On Sun, Aug 04, 2019 at 03:48:42PM -0700, john.hubbard@gmail.com wrote:
>> From: John Hubbard <jhubbard@nvidia.com>
...
>> -
>>  /**
>> - * put_user_pages_dirty() - release and dirty an array of gup-pinned pages
>> - * @pages:  array of pages to be marked dirty and released.
>> + * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
>> + * @pages:  array of pages to be maybe marked dirty, and definitely released.
> 
> Better would be.
> 
> @pages:  array of pages to be put

OK, I'll change to that wording.

> 
>>   * @npages: number of pages in the @pages array.
>> + * @make_dirty: whether to mark the pages dirty
>>   *
>>   * "gup-pinned page" refers to a page that has had one of the get_user_pages()
>>   * variants called on that page.
>>   *
>>   * For each page in the @pages array, make that page (or its head page, if a
>> - * compound page) dirty, if it was previously listed as clean. Then, release
>> - * the page using put_user_page().
>> + * compound page) dirty, if @make_dirty is true, and if the page was previously
>> + * listed as clean. In any case, releases all pages using put_user_page(),
>> + * possibly via put_user_pages(), for the non-dirty case.
> 
> I don't think users of this interface need this level of detail.  I think
> something like.
> 
>  * For each page in the @pages array, release the page.  If @make_dirty is
>  * true, mark the page dirty prior to release.

Yes, it is too wordy, I'll change to that.

> 
...
>> -void put_user_pages_dirty_lock(struct page **pages, unsigned long npages)
>> -{
>> -	__put_user_pages_dirty(pages, npages, set_page_dirty_lock);
>> +	/*
>> +	 * TODO: this can be optimized for huge pages: if a series of pages is
>> +	 * physically contiguous and part of the same compound page, then a
>> +	 * single operation to the head page should suffice.
>> +	 */
> 
> I think this comment belongs to the for loop below...  or just something about
> how to make this and put_user_pages() more efficient.  It is odd, that this is
> the same comment as in put_user_pages()...

Actually I think I'll just delete the comment entirely, it's just noise really.

> 
> The code is good.  So... Other than the comments.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>


Thanks for the review!


thanks,
-- 
John Hubbard
NVIDIA
