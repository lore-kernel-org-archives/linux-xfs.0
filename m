Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51942 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfCUHCg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Mar 2019 03:02:36 -0400
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
References: <20190319211108.15495-1-vbabka@suse.cz>
 <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
 <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz>
 <20190320185347.GZ19508@bombadil.infradead.org>
 <b5290e04-6f29-c237-78a7-511821183efe@suse.cz>
 <20190321022355.GA19508@bombadil.infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <718a767c-5f0c-7435-3f9b-c63bcd5b488f@suse.cz>
Date: Thu, 21 Mar 2019 08:02:32 +0100
MIME-Version: 1.0
In-Reply-To: <20190321022355.GA19508@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On 3/21/19 3:23 AM, Matthew Wilcox wrote:
> On Wed, Mar 20, 2019 at 10:48:03PM +0100, Vlastimil Babka wrote:
>>
>> Well, looks like that's what happens. This is with SLAB, but the alignment
>> calculations should be common: 
>>
>> slabinfo - version: 2.1
>> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
>> kmalloc-96          2611   4896    128   32    1 : tunables  120   60    8 : slabdata    153    153      0
>> kmalloc-128         4798   5536    128   32    1 : tunables  120   60    8 : slabdata    173    173      0
> 
> Hmm.  On my laptop, I see:
> 
> kmalloc-96         28050  35364     96   42    1 : tunables    0    0    0 : slabdata    842    842      0
> 
> That'd take me from 842 * 4k pages to 1105 4k pages -- an extra megabyte of
> memory.
> 
> This is running Debian's 4.19 kernel:
> 
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y

Ah, you're right. SLAB creates kmalloc caches with:

#ifndef ARCH_KMALLOC_FLAGS
#define ARCH_KMALLOC_FLAGS SLAB_HWCACHE_ALIGN
#endif

create_kmalloc_caches(ARCH_KMALLOC_FLAGS);

While SLUB just:

create_kmalloc_caches(0);

even though it uses SLAB_HWCACHE_ALIGN for kmem_cache_node and
kmem_cache caches.
