Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57436 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfBZD1p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 22:27:45 -0500
Date: Mon, 25 Feb 2019 19:27:37 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190226032737.GA11592@bombadil.infradead.org>
References: <20190225040904.5557-1-ming.lei@redhat.com>
 <20190225043648.GE23020@dastard>
 <5ad2ef83-8b3a-0a15-d72e-72652b807aad@suse.cz>
 <20190225202630.GG23020@dastard>
 <20190226022249.GA17747@ming.t460p>
 <20190226030214.GI23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226030214.GI23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ming Lei <ming.lei@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.org

On Tue, Feb 26, 2019 at 02:02:14PM +1100, Dave Chinner wrote:
> > Or what is the exact size of sub-page IO in xfs most of time? For
> 
> Determined by mkfs parameters. Any power of 2 between 512 bytes and
> 64kB needs to be supported. e.g:
> 
> # mkfs.xfs -s size=512 -b size=1k -i size=2k -n size=8k ....
> 
> will have metadata that is sector sized (512 bytes), filesystem
> block sized (1k), directory block sized (8k) and inode cluster sized
> (32k), and will use all of them in large quantities.

If XFS is going to use each of these in large quantities, then it doesn't
seem unreasonable for XFS to create a slab for each type of metadata?
