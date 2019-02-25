Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:48044 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726511AbfBYEhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Feb 2019 23:37:00 -0500
Date: Mon, 25 Feb 2019 15:36:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190225043648.GE23020@dastard>
References: <20190225040904.5557-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225040904.5557-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.org

On Mon, Feb 25, 2019 at 12:09:04PM +0800, Ming Lei wrote:
> XFS uses kmalloc() to allocate sector sized IO buffer.
....
> Use page_frag_alloc() to allocate the sector sized buffer, then the
> above issue can be fixed because offset_in_page of allocated buffer
> is always sector aligned.

Didn't we already reject this approach because page frags cannot be
reused and that pages allocated to the frag pool are pinned in
memory until all fragments allocated on the page have been freed?

i.e. when we consider 64k page machines and 4k block sizes (i.e.
default config), every single metadata allocation is a sub-page
allocation and so will use this new page frag mechanism. IOWs, it
will result in fragmenting memory severely and typical memory
reclaim not being able to fix it because the metadata that pins each
page is largely unreclaimable...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
