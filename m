Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10207 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730306AbfHAHBs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 03:01:48 -0400
Subject: Re: [PATCH v4 1/3] mm/gup: add make_dirty arg to
 put_user_pages_dirty_lock()
References: <20190730205705.9018-1-jhubbard@nvidia.com>
 <20190730205705.9018-2-jhubbard@nvidia.com> <20190801060755.GA14893@lst.de>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <36713a8a-ac94-8af7-bedf-a3da6c6132a7@nvidia.com>
Date: Thu, 1 Aug 2019 00:01:46 -0700
MIME-Version: 1.0
In-Reply-To: <20190801060755.GA14893@lst.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, john.hubbard@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Christian Benvenuti <benve@cisco.com>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>, Jerome Glisse <jglisse@redhat.com>, "Kirill A . Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On 7/31/19 11:07 PM, Christoph Hellwig wrote:
> On Tue, Jul 30, 2019 at 01:57:03PM -0700, john.hubbard@gmail.com wrote:
>> @@ -40,10 +40,7 @@
>>  static void __qib_release_user_pages(struct page **p, size_t num_pages,
>>  				     int dirty)
>>  {
>> -	if (dirty)
>> -		put_user_pages_dirty_lock(p, num_pages);
>> -	else
>> -		put_user_pages(p, num_pages);
>> +	put_user_pages_dirty_lock(p, num_pages, dirty);
>>  }
> 
> __qib_release_user_pages should be removed now as a direct call to
> put_user_pages_dirty_lock is a lot more clear.

OK.

> 
>> index 0b0237d41613..62e6ffa9ad78 100644
>> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
>> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
>> @@ -75,10 +75,7 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
>>  		for_each_sg(chunk->page_list, sg, chunk->nents, i) {
>>  			page = sg_page(sg);
>>  			pa = sg_phys(sg);
>> -			if (dirty)
>> -				put_user_pages_dirty_lock(&page, 1);
>> -			else
>> -				put_user_page(page);
>> +			put_user_pages_dirty_lock(&page, 1, dirty);
>>  			usnic_dbg("pa: %pa\n", &pa);
> 
> There is a pre-existing bug here, as this needs to use the sg_page
> iterator.  Probably worth throwing in a fix into your series while you
> are at it.

The amount of scatterlist code I've written is approximately zero lines,
+/- a few lines. :)  I thought for_each_sg() *was* the sg_page iterator...

I'll be glad to post a fix, but I'm not yet actually spotting the bug! heh

> 
>> @@ -63,15 +63,7 @@ struct siw_mem *siw_mem_id2obj(struct siw_device *sdev, int stag_index)
>>  static void siw_free_plist(struct siw_page_chunk *chunk, int num_pages,
>>  			   bool dirty)
>>  {
>> -	struct page **p = chunk->plist;
>> -
>> -	while (num_pages--) {
>> -		if (!PageDirty(*p) && dirty)
>> -			put_user_pages_dirty_lock(p, 1);
>> -		else
>> -			put_user_page(*p);
>> -		p++;
>> -	}
>> +	put_user_pages_dirty_lock(chunk->plist, num_pages, dirty);
> 
> siw_free_plist should just go away now.

OK, yes.

> 
> Otherwise this looks good to me.
> 

Great, I'll make the above changes and post an updated series with your
Reviewed-by, and Bjorn's ACK for patch #3.

Next: I've just finished sweeping through a bunch of patches and applying this
where applicable, so now that this API seems acceptable, I'll post another
chunk of put_user_page*() conversions.

thanks,
-- 
John Hubbard
NVIDIA
