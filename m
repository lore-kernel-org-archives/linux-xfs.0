Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E271A9FBA
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773660214; cv=none; b=YfVPQzEr2LcXYoBv8onhBGDMYODQtROZ5ab5JxSo3vxvF8cxkti1hG9kL1gjTL4p1WByJwJdFFBR+Odw06spAl/hLleHeqN568uC1dMIKjgHbBpzADq3D/IH7GG1dlh4rFXxo693uBs2NvU5dL/VJKJtavsl/uMMXOzkhc44fVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773660214; c=relaxed/simple;
	bh=teee8vzlr5I52VALSpkXiCKR/hFCeiuAThsacU/pkrw=;
	h=Content-Type:To:Cc:References:From:Mime-Version:In-Reply-To:Date:
	 Message-Id:Subject; b=ANJZhd6mo2IsLrdV+/aofD/Wx8MNuheDRz5FZWYz7mYixFXn/0FsGQN+6xujvxhsX5KZSR3Lzh0VJmmjXNV3MRR/A/snWrcQPnkMeq8mMQTU76J1VEcMK/Ha0L8PKuLkl2wZCteekcW7xvE1oGkzP7nJvl6RVwKg+lRK8w9V5wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=n25MEtkI; arc=none smtp.client-ip=118.26.132.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="n25MEtkI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1773660163; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=teee8vzlr5I52VALSpkXiCKR/hFCeiuAThsacU/pkrw=;
 b=n25MEtkIyiUOdLK74INwAJRrVBbC3bLyS/1r1JZUuP7vPrN/6rAvKLLqF/3hwo/Pa3zl7x
 MmW6FoXSEczfphsLKTZwoOtdTAlXxM7DuvpbumGbuJJBVUV/0KROlTzwOsld+af1k+C6o4
 B9ZHoI2eKDsVF2yAmR6u8O41M+xBwSc7owK6PwsagTrp2DBOJZFXBA08gFxYlLUMDNpPfO
 Z7X+WFouELqmvkoCM+bdJapOlsqI2LGHEsx/kg1LE94ykTsTEVotIIm3QjNRFMjs7pUvgT
 x2nxqwn2arRV25UD12To55f0+MJ/nLvrSluS9KeXZPIFvRidV1bgTqDIb6MsEQ==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "Dave Chinner" <david@fromorbit.com>
Cc: "guzebing" <guzebing1612@gmail.com>, <brauner@kernel.org>, 
	<djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<guzebing@bytedance.com>, <syzbot@syzkaller.appspotmail.com>, 
	<linux-mm@kvack.org>, "Vlastimil Babka" <vbabka@suse.cz>
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
	<aWh06YoiJrR3-J-X@dread.disaster.area>
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+169b7e801+97c5bf+vger.kernel.org+changfengnan@bytedance.com>
In-Reply-To: <aWh06YoiJrR3-J-X@dread.disaster.area>
Date: Mon, 16 Mar 2026 19:22:39 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio


> From: "Dave Chinner"<david@fromorbit.com>
> Date:=C2=A0 Thu, Jan 15, 2026, 13:02
> Subject:=C2=A0 Re: [PATCH v3] iomap: add allocation cache for iomap_dio
> To: "guzebing"<guzebing1612@gmail.com>
> Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <linu=
x-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger=
.kernel.org>, <guzebing@bytedance.com>, <syzbot@syzkaller.appspotmail.com>,=
 "Fengnan Chang"<changfengnan@bytedance.com>, <linux-mm@kvack.org>, "Vlasti=
mil Babka"<vbabka@suse.cz>
> [cc linux-mm]
>=C2=A0
> On Thu, Jan 15, 2026 at 10:11:08AM +0800, guzebing wrote:
> > As implemented by the bio structure, we do the same thing on the
> > iomap-dio structure. Add a per-cpu cache for iomap_dio allocations,
> > enabling us to quickly recycle them instead of going through the slab
> > allocator.
> >=C2=A0
> > By making such changes, we can reduce memory allocation on the direct
> > IO path, so that direct IO will not block due to insufficient system
> > memory. In addition, for direct IO, the read performance of io_uring
> > is improved by about 2.6%.
>=C2=A0
> Honestly, this just feels wrong.
>=C2=A0
> If heap memory allocation has performance issues, then the right
> solution is to fix the memory allocator.
>=C2=A0
> Oh, wait, you're copy-pasting the hacky per-cpu bio allocator cache
> lists into the iomap DIO code.
>=C2=A0
> IMO, this really should be part of the generic memory allocation
> APIs, not repeatedly tacked on the outside of specific individual
> object allocations.
>=C2=A0
> <thinks a bit>
>=C2=A0
> Huh. per-cpu free lists is the traditional SLAB allocator
> architecture. That was removed a while back because SLUB performs
> better in most cases....
>=C2=A0
> <thinks a bit more>
>=C2=A0
> ISTR somebody was already working to optimise the SLUB allocator to
> address these corner case shortcomings w.r.t. traditional SLABs.
>=C2=A0
> Yup:
>=C2=A0
>=C2=A0
> commit 2d517aa09bbc4203f10cdee7e1d42f3bbdc1b1cd
> Author: Vlastimil Babka <vbabka@suse.cz>
> Date: =C2=A0 Wed Sep 3 14:59:45 2025 +0200
>=C2=A0
> =C2=A0 =C2=A0 slab: add opt-in caching layer of percpu sheaves
>=C2=A0
> =C2=A0 =C2=A0 Specifying a non-zero value for a new struct kmem_cache_arg=
s field
> =C2=A0 =C2=A0 sheaf_capacity will setup a caching layer of percpu arrays =
called
> =C2=A0 =C2=A0 sheaves of given capacity for the created cache.
>=C2=A0
> =C2=A0 =C2=A0 Allocations from the cache will allocate via the percpu she=
aves (main or
> =C2=A0 =C2=A0 spare) as long as they have no NUMA node preference. Frees =
will also
> =C2=A0 =C2=A0 put the object back into one of the sheaves.
>=C2=A0
> =C2=A0 =C2=A0 When both percpu sheaves are found empty during an allocati=
on, an empty
> =C2=A0 =C2=A0 sheaf may be replaced with a full one from the per-node bar=
n. If none
> =C2=A0 =C2=A0 are available and the allocation is allowed to block, an em=
pty sheaf is
> =C2=A0 =C2=A0 refilled from slab(s) by an internal bulk alloc operation. =
When both
> =C2=A0 =C2=A0 percpu sheaves are full during freeing, the barn can replac=
e a full one
> =C2=A0 =C2=A0 with an empty one, unless over a full sheaves limit. In tha=
t case a
> =C2=A0 =C2=A0 sheaf is flushed to slab(s) by an internal bulk free operat=
ion. Flushing
> =C2=A0 =C2=A0 sheaves and barns is also wired to the existing cpu flushin=
g and cache
> =C2=A0 =C2=A0 shrinking operations.
>=C2=A0
> =C2=A0 =C2=A0 The sheaves do not distinguish NUMA locality of the cached =
objects. If
> =C2=A0 =C2=A0 an allocation is requested with kmem_cache_alloc_node() (or=
 a mempolicy
> =C2=A0 =C2=A0 with strict_numa mode enabled) with a specific node (not NU=
MA_NO_NODE),
> =C2=A0 =C2=A0 the sheaves are bypassed.
>=C2=A0
> =C2=A0 =C2=A0 The bulk operations exposed to slab users also try to utili=
ze the
> =C2=A0 =C2=A0 sheaves as long as the necessary (full or empty) sheaves ar=
e available
> =C2=A0 =C2=A0 on the cpu or in the barn. Once depleted, they will fallbac=
k to bulk
> =C2=A0 =C2=A0 alloc/free to slabs directly to avoid double copying.
>=C2=A0
> =C2=A0 =C2=A0 The sheaf_capacity value is exported in sysfs for observabi=
lity.
>=C2=A0
> =C2=A0 =C2=A0 Sysfs CONFIG_SLUB_STATS counters alloc_cpu_sheaf and free_c=
pu_sheaf
> =C2=A0 =C2=A0 count objects allocated or freed using the sheaves (and thu=
s not
> =C2=A0 =C2=A0 counting towards the other alloc/free path counters). Count=
ers
> =C2=A0 =C2=A0 sheaf_refill and sheaf_flush count objects filled or flushe=
d from or to
> =C2=A0 =C2=A0 slab pages, and can be used to assess how effective the cac=
hing is. The
> =C2=A0 =C2=A0 refill and flush operations will also count towards the usu=
al
> =C2=A0 =C2=A0 alloc_fastpath/slowpath, free_fastpath/slowpath and other c=
ounters for
> =C2=A0 =C2=A0 the backing slabs. =C2=A0For barn operations, barn_get and =
barn_put count how
> =C2=A0 =C2=A0 many full sheaves were get from or put to the barn, the _fa=
il variants
> =C2=A0 =C2=A0 count how many such requests could not be satisfied mainly =
=C2=A0because the
> =C2=A0 =C2=A0 barn was either empty or full. While the barn also holds em=
pty sheaves
> =C2=A0 =C2=A0 to make some operations easier, these are not as critical t=
o mandate own
> =C2=A0 =C2=A0 counters. =C2=A0Finally, there are sheaf_alloc/sheaf_free c=
ounters.
>=C2=A0
> =C2=A0 =C2=A0 Access to the percpu sheaves is protected by local_trylock(=
) when
> =C2=A0 =C2=A0 potential callers include irq context, and local_lock() oth=
erwise (such
> =C2=A0 =C2=A0 as when we already know the gfp flags allow blocking). The =
trylock
> =C2=A0 =C2=A0 failures should be rare and we can easily fallback. Each pe=
r-NUMA-node
> =C2=A0 =C2=A0 barn has a spin_lock.
>=C2=A0
> =C2=A0 =C2=A0 When slub_debug is enabled for a cache with sheaf_capacity =
also
> =C2=A0 =C2=A0 specified, the latter is ignored so that allocations and fr=
ees reach the
> =C2=A0 =C2=A0 slow path where debugging hooks are processed. Similarly, w=
e ignore it
> =C2=A0 =C2=A0 with CONFIG_SLUB_TINY which prefers low memory usage to per=
formance.
>=C2=A0
> =C2=A0 =C2=A0 [boot failure: https://lore.kernel.org/all/583eacf5-c971-45=
1a-9f76-fed0e341b815@linux.ibm.com/ ]
>=C2=A0
> =C2=A0 =C2=A0 Reported-and-tested-by: Venkat Rao Bagalkote <venkat88@linu=
x.ibm.com>
> =C2=A0 =C2=A0 Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> =C2=A0 =C2=A0 Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> =C2=A0 =C2=A0 Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>=C2=A0
> Yeah, recent code, functionality is not enabled by default yet. So,
> kmem_cache_alloc() with:
>=C2=A0
> struct kmem_cache_args {
> .....
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /**
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* @sheaf_capacity: Enable sheaves of gi=
ven capacity for the cache.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* With a non-zero value, allocations fr=
om the cache go through caching
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* arrays called sheaves. Each cpu has a=
 main sheaf that's always
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* present, and a spare sheaf that may b=
e not present. When both become
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* empty, there's an attempt to replace =
an empty sheaf with a full sheaf
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* from the per-node barn.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* When no full sheaf is available, and =
gfp flags allow blocking, a
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* sheaf is allocated and filled from sl=
ab(s) using bulk allocation.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Otherwise the allocation falls back t=
o the normal operation
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* allocating a single object from a sla=
b.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Analogically when freeing and both pe=
rcpu sheaves are full, the barn
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* may replace it with an empty sheaf, u=
nless it's over capacity. In
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* that case a sheaf is bulk freed to sl=
ab pages.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* The sheaves do not enforce NUMA place=
ment of objects, so allocations
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* via kmem_cache_alloc_node() with a no=
de specified other than
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* NUMA_NO_NODE will bypass them.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Bulk allocation and free operations a=
lso try to use the cpu sheaves
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* and barn, but fallback to using slab =
pages directly.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* When slub_debug is enabled for the ca=
che, the sheaf_capacity argument
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* is ignored.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* %0 means no sheaves will be created.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int sheaf_capacity;
> }
>=C2=A0
> set to the value required is all we need. i.e. something like this
> in iomap_dio_init():
>=C2=A0
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kmem_cache_args kmem_args =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .sheaf_capacity =
=3D 256,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 dio_kmem_cache =3D kmem_cache_create("iomap_d=
io", sizeof(struct iomap_dio),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &kmem_args, SLAB_PANIC | SLAB_ACCOUNT
>=C2=A0
> And changing the allocation to kmem_cache_alloc(dio_kmem_cache,
> GFP_KERNEL) should provide the same sort of performance improvement
> as this patch does.
>=C2=A0
> Can you test this, please?

Hi Dave:
Sorry it took so long to respond. Guzebing was busy with something else, I =
did
this test.
I test sheaf_capacity on 7.0-rc3, it doesn't show any performance improvmen=
t.
Besides, I wrote a simple kernel modules to test the performance difference=
 by
creating a normal memcache and one with sheaf_capacity and testing the time
consuming to request 32 objects and then free 32 objects. which resulted in=
 a
roughly 10% improvement in time spent.=C2=A0
I'm thinking that maybe these improvements may not be significant enough to
see the effect in the io flow.
Using a simple list seems to be the most efficient approach.

Thanks.
Fengnan.

>=C2=A0
> If it doesn't provide any performance improvment, then I suspect
> that Vlastimil will be interested to find out why....
>=C2=A0
> Also, if it does work, it is likely the bioset mempools (which are
> slab based) can be initialised similarly, removing the need for
> custom per-cpu free lists in the block layer, too.
>=C2=A0
> -Dave.
>=C2=A0
> >=C2=A0
> > v3:
> > kmalloc now is called outside the get_cpu/put_cpu code section.
> >=C2=A0
> > v2:
> > Factor percpu cache into common code and the iomap module uses it.
> >=C2=A0
> > v1:
> > https://lore.kernel.org/all/20251121090052.384823-1-guzebing1612@gmail.=
com/
> >=C2=A0
> > Tested-by: syzbot@syzkaller.appspotmail.com
> >=C2=A0
> > Suggested-by: Fengnan Chang <changfengnan@bytedance.com>
> > Signed-off-by: guzebing <guzebing1612@gmail.com>
> > ---
> > =C2=A0fs/iomap/direct-io.c | 133 ++++++++++++++++++++++++++++++++++++++=
++++-
> > =C2=A01 file changed, 130 insertions(+), 3 deletions(-)
> >=C2=A0
> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > index 5d5d63efbd57..4421e4ad3a8f 100644
> > --- a/fs/iomap/direct-io.c
> > +++ b/fs/iomap/direct-io.c
> > @@ -56,6 +56,130 @@ struct iomap_dio {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> > =C2=A0};
> > =C2=A0
> > +#define PCPU_CACHE_IRQ_THRESHOLD =C2=A0 =C2=A0 =C2=A0 =C2=A016
> > +#define PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list) \
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0(sizeof(struct pcpu_cache_element) + pcpu_=
cache_list->element_size)
> > +#define PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload) \
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0((struct pcpu_cache_element *)((unsigned l=
ong)(payload) - \
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(stru=
ct pcpu_cache_element)))
> > +#define PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(head) \
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0((void *)((unsigned long)(head) + sizeof(s=
truct pcpu_cache_element)))
> > +
> > +struct pcpu_cache_element {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element =C2=A0 =C2=A0 =
=C2=A0 =C2=A0*next;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0char =C2=A0 =C2=A0 =C2=A0 =C2=A0payload[];
> > +};
> > +struct pcpu_cache {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element =C2=A0 =C2=A0 =
=C2=A0 =C2=A0*free_list;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element =C2=A0 =C2=A0 =
=C2=A0 =C2=A0*free_list_irq;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0nr;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0nr_irq;
> > +};
> > +struct pcpu_cache_list {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache __percpu *cache;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t element_size;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0int max_nr;
> > +};
> > +
> > +static struct pcpu_cache_list *pcpu_cache_list_create(int max_nr, size=
_t size)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_list *pcpu_cache_list;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list =3D kmalloc(sizeof(struct =
pcpu_cache_list), GFP_KERNEL);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pcpu_cache_list)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list->element_size =3D size;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list->max_nr =3D max_nr;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list->cache =3D alloc_percpu(st=
ruct pcpu_cache);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pcpu_cache_list->cache) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(pcpu_cac=
he_list);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0return pcpu_cache_list;
> > +}
> > +
> > +static void pcpu_cache_list_destroy(struct pcpu_cache_list *pcpu_cache=
_list)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0free_percpu(pcpu_cache_list->cache);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(pcpu_cache_list);
> > +}
> > +
> > +static void irq_cache_splice(struct pcpu_cache *cache)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0/* cache->free_list must be empty */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (WARN_ON_ONCE(cache->free_list))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0local_irq_save(flags);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free_list =3D cache->free_list_irq;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free_list_irq =3D NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr +=3D cache->nr_irq;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr_irq =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0local_irq_restore(flags);
> > +}
> > +
> > +static void *pcpu_cache_list_alloc(struct pcpu_cache_list *pcpu_cache_=
list)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache *cache;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element *cache_element;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache =3D per_cpu_ptr(pcpu_cache_list->cac=
he, get_cpu());
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cache->free_list) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (READ_ONCE(=
cache->nr_irq) >=3D PCPU_CACHE_IRQ_THRESHOLD)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0irq_cache_splice(cache);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cache->fr=
ee_list) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0put_cpu();
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cache_element =3D kmalloc(PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_=
list),
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0GFP_KERNEL);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (!cache_element)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element=
);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_element =3D cache->free_list;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free_list =3D cache_element->next;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr--;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0put_cpu();
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM=
_HEAD(cache_element);
> > +}
> > +
> > +static void pcpu_cache_list_free(void *payload, struct pcpu_cache_list=
 *pcpu_cache_list)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache *cache;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element *cache_element;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_element =3D PCPU_CACHE_ELEMENT_GET_H=
EAD_FROM_PAYLOAD(payload);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache =3D per_cpu_ptr(pcpu_cache_list->cac=
he, get_cpu());
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (READ_ONCE(cache->nr_irq) + cache->nr >=
=3D pcpu_cache_list->max_nr)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_free;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (in_task()) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_element-=
>next =3D cache->free_list;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free_li=
st =3D cache_element;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr++;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (in_hardirq()) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lockdep_assert=
_irqs_disabled();
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_element-=
>next =3D cache->free_list_irq;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free_li=
st_irq =3D cache_element;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr_irq+=
+;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_free;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0put_cpu();
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> > +out_free:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0put_cpu();
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(cache_element);
> > +}
> > +
> > +#define DIO_ALLOC_CACHE_MAX =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0256
> > +static struct pcpu_cache_list *dio_pcpu_cache_list;
> > +
> > =C2=A0static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *i=
ter,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct io=
map_dio *dio, unsigned short nr_vecs, blk_opf_t opf)
> > =C2=A0{
> > @@ -135,7 +259,7 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0ret +=3D dio->done_before;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_complete(iocb, dio->e=
rror, ret);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(dio);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list_free(dio, dio_pcpu_cache_l=
ist);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> > =C2=A0}
> > =C2=A0EXPORT_SYMBOL_GPL(iomap_dio_complete);
> > @@ -620,7 +744,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter =
*iter,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!iomi.len)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NU=
LL;
> > =C2=A0
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0dio =3D kmalloc(sizeof(*dio), GFP_KERNEL);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0dio =3D pcpu_cache_list_alloc(dio_pcpu_cac=
he_list);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dio)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ER=
R_PTR(-ENOMEM);
> > =C2=A0
> > @@ -804,7 +928,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter =
*iter,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return dio;
> > =C2=A0
> > =C2=A0out_free_dio:
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(dio);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list_free(dio, dio_pcpu_cache_l=
ist);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ER=
R_PTR(ret);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> > @@ -834,6 +958,9 @@ static int __init iomap_dio_init(void)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!zero_page)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -E=
NOMEM;
> > =C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0dio_pcpu_cache_list =3D pcpu_cache_list_cr=
eate(DIO_ALLOC_CACHE_MAX, sizeof(struct iomap_dio));
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dio_pcpu_cache_list)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> > =C2=A0}
> > =C2=A0fs_initcall(iomap_dio_init);
> > --=C2=A0
> > 2.20.1
> >=C2=A0
> >=C2=A0
> >=C2=A0
>=C2=A0
> --=C2=A0
> Dave Chinner
> david@fromorbit.com
>=C2=A0
