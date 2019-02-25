Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727011AbfBYNQF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Feb 2019 08:16:05 -0500
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
References: <20190225040904.5557-1-ming.lei@redhat.com>
 <20190225043648.GE23020@dastard>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <5ad2ef83-8b3a-0a15-d72e-72652b807aad@suse.cz>
Date: Mon, 25 Feb 2019 14:15:59 +0100
MIME-Version: 1.0
In-Reply-To: <20190225043648.GE23020@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Ming Lei <ming.lei@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.org

On 2/25/19 5:36 AM, Dave Chinner wrote:
> On Mon, Feb 25, 2019 at 12:09:04PM +0800, Ming Lei wrote:
>> XFS uses kmalloc() to allocate sector sized IO buffer.
> ....
>> Use page_frag_alloc() to allocate the sector sized buffer, then the
>> above issue can be fixed because offset_in_page of allocated buffer
>> is always sector aligned.
> 
> Didn't we already reject this approach because page frags cannot be
> reused and that pages allocated to the frag pool are pinned in
> memory until all fragments allocated on the page have been freed?

I don't know if you did, but it's certainly true., Also I don't think
there's any specified alignment guarantee for page_frag_alloc().

What about kmem_cache_create() with align parameter? That *should* be
guaranteed regardless of whatever debugging is enabled - if not, I would
consider it a bug.

> i.e. when we consider 64k page machines and 4k block sizes (i.e.
> default config), every single metadata allocation is a sub-page
> allocation and so will use this new page frag mechanism. IOWs, it
> will result in fragmenting memory severely and typical memory
> reclaim not being able to fix it because the metadata that pins each
> page is largely unreclaimable...
> 
> Cheers,
> 
> Dave.
> 
