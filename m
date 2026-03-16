Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E261E7660;
	Mon, 16 Mar 2026 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773680058; cv=none; b=XFZDX20unUeKwNLEgfr3tezQw22jWWR2CUJZbmAyLqlKlOuubuqwMxymiugC2e3aWAIHe8KaftAvvThz2XWMSAY8J+eQjpZhRJy1vMAnu9E4StL2Bd29onbCUP58PdHXR4funcS0coOAXhwKRdmrLz/PiqPgCIXjGQlmd3ahoZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773680058; c=relaxed/simple;
	bh=zIZU4rznj3GxPgHukE1YbuSrTakM9B750YZ4WSHMPTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NyibKjzTccm4RA4KZWg+2ypx/HQ0cTLk5x2dkSn/PZ8whF/PXjPt8mom6tBC5d9NJetYUBAUzKPLDXxTrvKF5mERVGHXu2nBQNPchNj1fORBJRTwW3XXmJSSTEX8XBGgY8T6e0Db5mKLcvD7YhlxJxV+GrakhVTjKohbZHhecA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMrD8o9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMrD8o9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1608C19421;
	Mon, 16 Mar 2026 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773680057;
	bh=zIZU4rznj3GxPgHukE1YbuSrTakM9B750YZ4WSHMPTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EMrD8o9P0Bmg6vDwJp7H/T1I/y8HG18Ox5umJp1FoDPm1GS+E+QP3tnBxO+mNVDxk
	 cE+hZ5RqNR/WRshaSrfcAvSG2IpX+oOqZwKECBNImpivH/SsgWqNT8wpHsO5cKXXy4
	 I0x+ylBGJ4rhlc6aw3LhzM80DLzrJLWIwIf4jpbBBnNZXJ8bbms2PG2/e4Dm245e3u
	 uGZYo5SQI/xUg5U3BJg3IjaZtP4wqH6KuiHlw8lDyD3ujgkX0zbtpqngtdOOL9Qgs7
	 kFHAqshKQa9wITxLPliuuPuvZfY9D4rERz9PNlNDh4YKF7EBGh+TMPyjk3kdOhgRqA
	 4TkJtGdRgdzNg==
Message-ID: <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
Date: Mon, 16 Mar 2026 17:54:13 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Content-Language: en-US
To: changfengnan <changfengnan@bytedance.com>,
 Dave Chinner <david@fromorbit.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>
Cc: guzebing <guzebing1612@gmail.com>, brauner@kernel.org, djwong@kernel.org,
 hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, guzebing@bytedance.com,
 syzbot@syzkaller.appspotmail.com, linux-mm@kvack.org
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
 <aWh06YoiJrR3-J-X@dread.disaster.area>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

+CC Harry and Hao

On 3/16/26 12:22, changfengnan wrote:
> 
>> From: "Dave Chinner"<david@fromorbit.com>
>> Date:  Thu, Jan 15, 2026, 13:02
>> Subject:  Re: [PATCH v3] iomap: add allocation cache for iomap_dio
>> To: "guzebing"<guzebing1612@gmail.com>
>> Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, <syzbot@syzkaller.appspotmail.com>, "Fengnan Chang"<changfengnan@bytedance.com>, <linux-mm@kvack.org>, "Vlastimil Babka"<vbabka@suse.cz>
>> [cc linux-mm]
>> 
>> On Thu, Jan 15, 2026 at 10:11:08AM +0800, guzebing wrote:
>> > As implemented by the bio structure, we do the same thing on the
>> > iomap-dio structure. Add a per-cpu cache for iomap_dio allocations,
>> > enabling us to quickly recycle them instead of going through the slab
>> > allocator.
>> > 
>> > By making such changes, we can reduce memory allocation on the direct
>> > IO path, so that direct IO will not block due to insufficient system
>> > memory. In addition, for direct IO, the read performance of io_uring
>> > is improved by about 2.6%.
>> 
>> Honestly, this just feels wrong.
>> 
>> If heap memory allocation has performance issues, then the right
>> solution is to fix the memory allocator.
>> 
>> Oh, wait, you're copy-pasting the hacky per-cpu bio allocator cache
>> lists into the iomap DIO code.
>> 
>> IMO, this really should be part of the generic memory allocation
>> APIs, not repeatedly tacked on the outside of specific individual
>> object allocations.
>> 
>> <thinks a bit>
>> 
>> Huh. per-cpu free lists is the traditional SLAB allocator
>> architecture. That was removed a while back because SLUB performs
>> better in most cases....
>> 
>> <thinks a bit more>
>> 
>> ISTR somebody was already working to optimise the SLUB allocator to
>> address these corner case shortcomings w.r.t. traditional SLABs.
>> 
>> Yup:
>> 
>> 
>> commit 2d517aa09bbc4203f10cdee7e1d42f3bbdc1b1cd
>> Author: Vlastimil Babka <vbabka@suse.cz>
>> Date:   Wed Sep 3 14:59:45 2025 +0200
>> 
>>     slab: add opt-in caching layer of percpu sheaves
>> 
>>     Specifying a non-zero value for a new struct kmem_cache_args field
>>     sheaf_capacity will setup a caching layer of percpu arrays called
>>     sheaves of given capacity for the created cache.
>> 
>>     Allocations from the cache will allocate via the percpu sheaves (main or
>>     spare) as long as they have no NUMA node preference. Frees will also
>>     put the object back into one of the sheaves.
>> 
>>     When both percpu sheaves are found empty during an allocation, an empty
>>     sheaf may be replaced with a full one from the per-node barn. If none
>>     are available and the allocation is allowed to block, an empty sheaf is
>>     refilled from slab(s) by an internal bulk alloc operation. When both
>>     percpu sheaves are full during freeing, the barn can replace a full one
>>     with an empty one, unless over a full sheaves limit. In that case a
>>     sheaf is flushed to slab(s) by an internal bulk free operation. Flushing
>>     sheaves and barns is also wired to the existing cpu flushing and cache
>>     shrinking operations.
>> 
>>     The sheaves do not distinguish NUMA locality of the cached objects. If
>>     an allocation is requested with kmem_cache_alloc_node() (or a mempolicy
>>     with strict_numa mode enabled) with a specific node (not NUMA_NO_NODE),
>>     the sheaves are bypassed.
>> 
>>     The bulk operations exposed to slab users also try to utilize the
>>     sheaves as long as the necessary (full or empty) sheaves are available
>>     on the cpu or in the barn. Once depleted, they will fallback to bulk
>>     alloc/free to slabs directly to avoid double copying.
>> 
>>     The sheaf_capacity value is exported in sysfs for observability.
>> 
>>     Sysfs CONFIG_SLUB_STATS counters alloc_cpu_sheaf and free_cpu_sheaf
>>     count objects allocated or freed using the sheaves (and thus not
>>     counting towards the other alloc/free path counters). Counters
>>     sheaf_refill and sheaf_flush count objects filled or flushed from or to
>>     slab pages, and can be used to assess how effective the caching is. The
>>     refill and flush operations will also count towards the usual
>>     alloc_fastpath/slowpath, free_fastpath/slowpath and other counters for
>>     the backing slabs.  For barn operations, barn_get and barn_put count how
>>     many full sheaves were get from or put to the barn, the _fail variants
>>     count how many such requests could not be satisfied mainly  because the
>>     barn was either empty or full. While the barn also holds empty sheaves
>>     to make some operations easier, these are not as critical to mandate own
>>     counters.  Finally, there are sheaf_alloc/sheaf_free counters.
>> 
>>     Access to the percpu sheaves is protected by local_trylock() when
>>     potential callers include irq context, and local_lock() otherwise (such
>>     as when we already know the gfp flags allow blocking). The trylock
>>     failures should be rare and we can easily fallback. Each per-NUMA-node
>>     barn has a spin_lock.
>> 
>>     When slub_debug is enabled for a cache with sheaf_capacity also
>>     specified, the latter is ignored so that allocations and frees reach the
>>     slow path where debugging hooks are processed. Similarly, we ignore it
>>     with CONFIG_SLUB_TINY which prefers low memory usage to performance.
>> 
>>     [boot failure: https://lore.kernel.org/all/583eacf5-c971-451a-9f76-fed0e341b815@linux.ibm.com/ ]
>> 
>>     Reported-and-tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>>     Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>     Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>     Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> 
>> Yeah, recent code, functionality is not enabled by default yet. So,
>> kmem_cache_alloc() with:
>> 
>> struct kmem_cache_args {
>> .....
>>         /**
>>          * @sheaf_capacity: Enable sheaves of given capacity for the cache.
>>          *
>>          * With a non-zero value, allocations from the cache go through caching
>>          * arrays called sheaves. Each cpu has a main sheaf that's always
>>          * present, and a spare sheaf that may be not present. When both become
>>          * empty, there's an attempt to replace an empty sheaf with a full sheaf
>>          * from the per-node barn.
>>          *
>>          * When no full sheaf is available, and gfp flags allow blocking, a
>>          * sheaf is allocated and filled from slab(s) using bulk allocation.
>>          * Otherwise the allocation falls back to the normal operation
>>          * allocating a single object from a slab.
>>          *
>>          * Analogically when freeing and both percpu sheaves are full, the barn
>>          * may replace it with an empty sheaf, unless it's over capacity. In
>>          * that case a sheaf is bulk freed to slab pages.
>>          *
>>          * The sheaves do not enforce NUMA placement of objects, so allocations
>>          * via kmem_cache_alloc_node() with a node specified other than
>>          * NUMA_NO_NODE will bypass them.
>>          *
>>          * Bulk allocation and free operations also try to use the cpu sheaves
>>          * and barn, but fallback to using slab pages directly.
>>          *
>>          * When slub_debug is enabled for the cache, the sheaf_capacity argument
>>          * is ignored.
>>          *
>>          * %0 means no sheaves will be created.
>>          */
>>         unsigned int sheaf_capacity;
>> }
>> 
>> set to the value required is all we need. i.e. something like this
>> in iomap_dio_init():
>> 
>> 
>>         struct kmem_cache_args kmem_args = {
>>                 .sheaf_capacity = 256,
>>         };
>> 
>>         dio_kmem_cache = kmem_cache_create("iomap_dio", sizeof(struct iomap_dio),
>>                         &kmem_args, SLAB_PANIC | SLAB_ACCOUNT
>> 
>> And changing the allocation to kmem_cache_alloc(dio_kmem_cache,
>> GFP_KERNEL) should provide the same sort of performance improvement
>> as this patch does.
>> 
>> Can you test this, please?
> 
> Hi Dave:
> Sorry it took so long to respond. Guzebing was busy with something else, I did
> this test.
> I test sheaf_capacity on 7.0-rc3, it doesn't show any performance improvment.

7.0-rc3 already has sheaves in every cache and the old caching scheme
removed. An explicit sheaf_capacity can now be used to increase the
automatically calculated one, where the value you can observe in
/sys/kernel/slab/$cache/sheaf_capacity

> Besides, I wrote a simple kernel modules to test the performance difference by
> creating a normal memcache and one with sheaf_capacity and testing the time
> consuming to request 32 objects and then free 32 objects. which resulted in a
> roughly 10% improvement in time spent.

That suggests in that test you used larger capacity than the automatically
calculated.
 
> I'm thinking that maybe these improvements may not be significant enough to
> see the effect in the io flow.
> Using a simple list seems to be the most efficient approach.

I think the question is, what improvement do you now see with your added
pcpu cache vs kmalloc() when 7.0-rc4 is used as the baseline?

Thanks,
Vlastimil

> Thanks.
> Fengnan.
> 
>> 
>> If it doesn't provide any performance improvment, then I suspect
>> that Vlastimil will be interested to find out why....
>> 
>> Also, if it does work, it is likely the bioset mempools (which are
>> slab based) can be initialised similarly, removing the need for
>> custom per-cpu free lists in the block layer, too.
>> 
>> -Dave.
>> 
>> > 
>> > v3:
>> > kmalloc now is called outside the get_cpu/put_cpu code section.
>> > 
>> > v2:
>> > Factor percpu cache into common code and the iomap module uses it.
>> > 
>> > v1:
>> > https://lore.kernel.org/all/20251121090052.384823-1-guzebing1612@gmail.com/
>> > 
>> > Tested-by: syzbot@syzkaller.appspotmail.com
>> > 
>> > Suggested-by: Fengnan Chang <changfengnan@bytedance.com>
>> > Signed-off-by: guzebing <guzebing1612@gmail.com>
>> > ---
>> >  fs/iomap/direct-io.c | 133 ++++++++++++++++++++++++++++++++++++++++++-
>> >  1 file changed, 130 insertions(+), 3 deletions(-)
>> > 
>> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> > index 5d5d63efbd57..4421e4ad3a8f 100644
>> > --- a/fs/iomap/direct-io.c
>> > +++ b/fs/iomap/direct-io.c
>> > @@ -56,6 +56,130 @@ struct iomap_dio {
>> >          };
>> >  };
>> >  
>> > +#define PCPU_CACHE_IRQ_THRESHOLD        16
>> > +#define PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list) \
>> > +        (sizeof(struct pcpu_cache_element) + pcpu_cache_list->element_size)
>> > +#define PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload) \
>> > +        ((struct pcpu_cache_element *)((unsigned long)(payload) - \
>> > +                                       sizeof(struct pcpu_cache_element)))
>> > +#define PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(head) \
>> > +        ((void *)((unsigned long)(head) + sizeof(struct pcpu_cache_element)))
>> > +
>> > +struct pcpu_cache_element {
>> > +        struct pcpu_cache_element        *next;
>> > +        char        payload[];
>> > +};
>> > +struct pcpu_cache {
>> > +        struct pcpu_cache_element        *free_list;
>> > +        struct pcpu_cache_element        *free_list_irq;
>> > +        int                nr;
>> > +        int                nr_irq;
>> > +};
>> > +struct pcpu_cache_list {
>> > +        struct pcpu_cache __percpu *cache;
>> > +        size_t element_size;
>> > +        int max_nr;
>> > +};
>> > +
>> > +static struct pcpu_cache_list *pcpu_cache_list_create(int max_nr, size_t size)
>> > +{
>> > +        struct pcpu_cache_list *pcpu_cache_list;
>> > +
>> > +        pcpu_cache_list = kmalloc(sizeof(struct pcpu_cache_list), GFP_KERNEL);
>> > +        if (!pcpu_cache_list)
>> > +                return NULL;
>> > +
>> > +        pcpu_cache_list->element_size = size;
>> > +        pcpu_cache_list->max_nr = max_nr;
>> > +        pcpu_cache_list->cache = alloc_percpu(struct pcpu_cache);
>> > +        if (!pcpu_cache_list->cache) {
>> > +                kfree(pcpu_cache_list);
>> > +                return NULL;
>> > +        }
>> > +        return pcpu_cache_list;
>> > +}
>> > +
>> > +static void pcpu_cache_list_destroy(struct pcpu_cache_list *pcpu_cache_list)
>> > +{
>> > +        free_percpu(pcpu_cache_list->cache);
>> > +        kfree(pcpu_cache_list);
>> > +}
>> > +
>> > +static void irq_cache_splice(struct pcpu_cache *cache)
>> > +{
>> > +        unsigned long flags;
>> > +
>> > +        /* cache->free_list must be empty */
>> > +        if (WARN_ON_ONCE(cache->free_list))
>> > +                return;
>> > +
>> > +        local_irq_save(flags);
>> > +        cache->free_list = cache->free_list_irq;
>> > +        cache->free_list_irq = NULL;
>> > +        cache->nr += cache->nr_irq;
>> > +        cache->nr_irq = 0;
>> > +        local_irq_restore(flags);
>> > +}
>> > +
>> > +static void *pcpu_cache_list_alloc(struct pcpu_cache_list *pcpu_cache_list)
>> > +{
>> > +        struct pcpu_cache *cache;
>> > +        struct pcpu_cache_element *cache_element;
>> > +
>> > +        cache = per_cpu_ptr(pcpu_cache_list->cache, get_cpu());
>> > +        if (!cache->free_list) {
>> > +                if (READ_ONCE(cache->nr_irq) >= PCPU_CACHE_IRQ_THRESHOLD)
>> > +                        irq_cache_splice(cache);
>> > +                if (!cache->free_list) {
>> > +                        put_cpu();
>> > +                        cache_element = kmalloc(PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list),
>> > +                                                                        GFP_KERNEL);
>> > +                        if (!cache_element)
>> > +                                return NULL;
>> > +                        return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element);
>> > +                }
>> > +        }
>> > +
>> > +        cache_element = cache->free_list;
>> > +        cache->free_list = cache_element->next;
>> > +        cache->nr--;
>> > +        put_cpu();
>> > +        return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element);
>> > +}
>> > +
>> > +static void pcpu_cache_list_free(void *payload, struct pcpu_cache_list *pcpu_cache_list)
>> > +{
>> > +        struct pcpu_cache *cache;
>> > +        struct pcpu_cache_element *cache_element;
>> > +
>> > +        cache_element = PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload);
>> > +
>> > +        cache = per_cpu_ptr(pcpu_cache_list->cache, get_cpu());
>> > +        if (READ_ONCE(cache->nr_irq) + cache->nr >= pcpu_cache_list->max_nr)
>> > +                goto out_free;
>> > +
>> > +        if (in_task()) {
>> > +                cache_element->next = cache->free_list;
>> > +                cache->free_list = cache_element;
>> > +                cache->nr++;
>> > +        } else if (in_hardirq()) {
>> > +                lockdep_assert_irqs_disabled();
>> > +                cache_element->next = cache->free_list_irq;
>> > +                cache->free_list_irq = cache_element;
>> > +                cache->nr_irq++;
>> > +        } else {
>> > +                goto out_free;
>> > +        }
>> > +        put_cpu();
>> > +        return;
>> > +out_free:
>> > +        put_cpu();
>> > +        kfree(cache_element);
>> > +}
>> > +
>> > +#define DIO_ALLOC_CACHE_MAX                256
>> > +static struct pcpu_cache_list *dio_pcpu_cache_list;
>> > +
>> >  static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *iter,
>> >                  struct iomap_dio *dio, unsigned short nr_vecs, blk_opf_t opf)
>> >  {
>> > @@ -135,7 +259,7 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
>> >                          ret += dio->done_before;
>> >          }
>> >          trace_iomap_dio_complete(iocb, dio->error, ret);
>> > -        kfree(dio);
>> > +        pcpu_cache_list_free(dio, dio_pcpu_cache_list);
>> >          return ret;
>> >  }
>> >  EXPORT_SYMBOL_GPL(iomap_dio_complete);
>> > @@ -620,7 +744,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>> >          if (!iomi.len)
>> >                  return NULL;
>> >  
>> > -        dio = kmalloc(sizeof(*dio), GFP_KERNEL);
>> > +        dio = pcpu_cache_list_alloc(dio_pcpu_cache_list);
>> >          if (!dio)
>> >                  return ERR_PTR(-ENOMEM);
>> >  
>> > @@ -804,7 +928,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>> >          return dio;
>> >  
>> >  out_free_dio:
>> > -        kfree(dio);
>> > +        pcpu_cache_list_free(dio, dio_pcpu_cache_list);
>> >          if (ret)
>> >                  return ERR_PTR(ret);
>> >          return NULL;
>> > @@ -834,6 +958,9 @@ static int __init iomap_dio_init(void)
>> >          if (!zero_page)
>> >                  return -ENOMEM;
>> >  
>> > +        dio_pcpu_cache_list = pcpu_cache_list_create(DIO_ALLOC_CACHE_MAX, sizeof(struct iomap_dio));
>> > +        if (!dio_pcpu_cache_list)
>> > +                return -ENOMEM;
>> >          return 0;
>> >  }
>> >  fs_initcall(iomap_dio_init);
>> > -- 
>> > 2.20.1
>> > 
>> > 
>> > 
>> 
>> -- 
>> Dave Chinner
>> david@fromorbit.com
>> 

