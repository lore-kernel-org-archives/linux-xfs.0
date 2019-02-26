Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14379 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbfBZE6a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 23:58:30 -0500
Date: Tue, 26 Feb 2019 15:58:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190226045826.GJ23020@dastard>
References: <20190225040904.5557-1-ming.lei@redhat.com>
 <20190225043648.GE23020@dastard>
 <5ad2ef83-8b3a-0a15-d72e-72652b807aad@suse.cz>
 <20190225202630.GG23020@dastard>
 <20190226022249.GA17747@ming.t460p>
 <20190226030214.GI23020@dastard>
 <20190226032737.GA11592@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226032737.GA11592@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.org

On Mon, Feb 25, 2019 at 07:27:37PM -0800, Matthew Wilcox wrote:
> On Tue, Feb 26, 2019 at 02:02:14PM +1100, Dave Chinner wrote:
> > > Or what is the exact size of sub-page IO in xfs most of time? For
> > 
> > Determined by mkfs parameters. Any power of 2 between 512 bytes and
> > 64kB needs to be supported. e.g:
> > 
> > # mkfs.xfs -s size=512 -b size=1k -i size=2k -n size=8k ....
> > 
> > will have metadata that is sector sized (512 bytes), filesystem
> > block sized (1k), directory block sized (8k) and inode cluster sized
> > (32k), and will use all of them in large quantities.
> 
> If XFS is going to use each of these in large quantities, then it doesn't
> seem unreasonable for XFS to create a slab for each type of metadata?


Well, that is the question, isn't it? How many other filesystems
will want to make similar "don't use entire pages just for 4k of
metadata" optimisations as 64k page size machines become more
common? There are others that have the same "use slab for sector
aligned IO" which will fall foul of the same problem that has been
reported for XFS....

If nobody else cares/wants it, then it can be XFS only. But it's
only fair we address the "will it be useful to others" question
first.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
