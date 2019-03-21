Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfCUCYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 22:24:04 -0400
Date: Wed, 20 Mar 2019 19:23:55 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
Message-ID: <20190321022355.GA19508@bombadil.infradead.org>
References: <20190319211108.15495-1-vbabka@suse.cz>
 <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
 <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz>
 <20190320185347.GZ19508@bombadil.infradead.org>
 <b5290e04-6f29-c237-78a7-511821183efe@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5290e04-6f29-c237-78a7-511821183efe@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christopher Lameter <cl@linux.com>, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Mar 20, 2019 at 10:48:03PM +0100, Vlastimil Babka wrote:
> On 3/20/2019 7:53 PM, Matthew Wilcox wrote:
> > On Wed, Mar 20, 2019 at 09:48:47AM +0100, Vlastimil Babka wrote:
> >> Natural alignment to size is rather well defined, no? Would anyone ever
> >> assume a larger one, for what reason?
> >> It's now where some make assumptions (even unknowingly) for natural
> >> There are two 'odd' sizes 96 and 192, which will keep cacheline size
> >> alignment, would anyone really expect more than 64 bytes?
> > 
> > Presumably 96 will keep being aligned to 32 bytes, as aligning 96 to 64
> > just results in 128-byte allocations.
> 
> Well, looks like that's what happens. This is with SLAB, but the alignment
> calculations should be common: 
> 
> slabinfo - version: 2.1
> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
> kmalloc-96          2611   4896    128   32    1 : tunables  120   60    8 : slabdata    153    153      0
> kmalloc-128         4798   5536    128   32    1 : tunables  120   60    8 : slabdata    173    173      0

Hmm.  On my laptop, I see:

kmalloc-96         28050  35364     96   42    1 : tunables    0    0    0 : slabdata    842    842      0

That'd take me from 842 * 4k pages to 1105 4k pages -- an extra megabyte of
memory.

This is running Debian's 4.19 kernel:

# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SLUB_CPU_PARTIAL=y
