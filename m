Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18192882B6
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 07:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773732510; cv=none; b=ucOBYnTFe0JKec9JUDt9aaJ8u7l/VRPsbIP7yVjWSBi4kpXphWCywN2aGIx1EWQy8VQXPKq0NII+izqMrLU72r7NmhM1pgUO0gOeNRYSbR0qJrYNlRUdemurXVd+UQiMmtp3Yh5Mk2diXSFyq3G2vAns3YbvK7VXdf+EIZccW00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773732510; c=relaxed/simple;
	bh=+Q4LysUL3NurD9VcHhsQ4YMozhn4ULK+UPe3Ho5CCXA=;
	h=References:Content-Type:Date:To:Subject:Mime-Version:In-Reply-To:
	 Message-Id:Cc:From; b=Hbo1xB0TMkXxvUpoB9ojZLSlPp54Yro1cWY2+jIXO2wXr3nKEAHDt6Vg4fhziNjub4SEmAXkB09ew6CjSCkBIqtGf4Ya0AG/sTRRZZZcIdjWcAqQkJiiD3Y2V2ql9Rt1gudZahCTQV6JIxvabvBopmtIwwVoVUrTv31q2O5Ru8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=l/NxLqsz; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="l/NxLqsz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1773732501; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+Q4LysUL3NurD9VcHhsQ4YMozhn4ULK+UPe3Ho5CCXA=;
 b=l/NxLqszGr6VzBH+yfI2F0vEq3NFNJ4xApTEX7KvXJc/UtUQnvDJxtNz0M/SXrce6gSVjR
 QLBLGH0bck8GSHCE2JFges3yGnNBTUY6c1qeRNvQcZ6AfdzIAY6yIj5E0kC4rh+Hsz6YNO
 DdYVM11yaqb2eJ5L3QsRidHjIEcccN/fEnIab7EhzvfFSvjoDlnY1QoxSSUV8y7uB155Aw
 qCmcUg+SXeKyxEmO9TglFy5PWqYMENqUTrfXSXARuEBAH799Q0QFybv8Wgh9VGXHMs56EL
 FxAovJ62esGx0f2IZW30xTRCwOZYur2csUS4DAuPcouG2s4x6WL2GqkNPSUH3g==
References: <20260115021108.1913695-1-guzebing1612@gmail.com> <aWh06YoiJrR3-J-X@dread.disaster.area> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
	<d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
X-Lms-Return-Path: <lba+169b90293+c7f1b9+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Mar 2026 15:28:16 +0800
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
Cc: "Dave Chinner" <david@fromorbit.com>, "Harry Yoo" <harry.yoo@oracle.com>, 
	"Hao Li" <hao.li@linux.dev>, "guzebing" <guzebing1612@gmail.com>, 
	<brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, 
	<syzbot@syzkaller.appspotmail.com>, <linux-mm@kvack.org>
From: "changfengnan" <changfengnan@bytedance.com>


> From: "Vlastimil Babka (SUSE)"<vbabka@kernel.org>
> Date:=C2=A0 Tue, Mar 17, 2026, 00:54
> Subject:=C2=A0 Re: [PATCH v3] iomap: add allocation cache for iomap_dio
> To: "changfengnan"<changfengnan@bytedance.com>, "Dave Chinner"<david@from=
orbit.com>, "Harry Yoo"<harry.yoo@oracle.com>, "Hao Li"<hao.li@linux.dev>
> Cc: "guzebing"<guzebing1612@gmail.com>, <brauner@kernel.org>, <djwong@ker=
nel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>, <linux-fsdevel@=
vger.kernel.org>, <linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>,=
 <syzbot@syzkaller.appspotmail.com>, <linux-mm@kvack.org>
> +CC Harry and Hao
>=C2=A0
> On 3/16/26 12:22, changfengnan wrote:
> >=C2=A0
> >> From: "Dave Chinner"<david@fromorbit.com>
> >> Date:=C2=A0 Thu, Jan 15, 2026, 13:02
> >> Subject:=C2=A0 Re: [PATCH v3] iomap: add allocation cache for iomap_di=
o
> >> To: "guzebing"<guzebing1612@gmail.com>
> >> Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <l=
inux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-kernel@v=
ger.kernel.org>, <guzebing@bytedance.com>, <syzbot@syzkaller.appspotmail.co=
m>, "Fengnan Chang"<changfengnan@bytedance.com>, <linux-mm@kvack.org>, "Vla=
stimil Babka"<vbabka@suse.cz>
> >> [cc linux-mm]
> >>=C2=A0
> >> On Thu, Jan 15, 2026 at 10:11:08AM +0800, guzebing wrote:
> >> > As implemented by the bio structure, we do the same thing on the
> >> > iomap-dio structure. Add a per-cpu cache for iomap_dio allocations,
> >> > enabling us to quickly recycle them instead of going through the sla=
b
> >> > allocator.
> >> >=C2=A0
> >> > By making such changes, we can reduce memory allocation on the direc=
t
> >> > IO path, so that direct IO will not block due to insufficient system
> >> > memory. In addition, for direct IO, the read performance of io_uring
> >> > is improved by about 2.6%.
> >>=C2=A0
> >> Honestly, this just feels wrong.
> >>=C2=A0
> >> If heap memory allocation has performance issues, then the right
> >> solution is to fix the memory allocator.
> >>=C2=A0
> >> Oh, wait, you're copy-pasting the hacky per-cpu bio allocator cache
> >> lists into the iomap DIO code.
> >>=C2=A0
> >> IMO, this really should be part of the generic memory allocation
> >> APIs, not repeatedly tacked on the outside of specific individual
> >> object allocations.
> >>=C2=A0
> >> <thinks a bit>
> >>=C2=A0
> >> Huh. per-cpu free lists is the traditional SLAB allocator
> >> architecture. That was removed a while back because SLUB performs
> >> better in most cases....
> >>=C2=A0
> >> <thinks a bit more>
> >>=C2=A0
> >> ISTR somebody was already working to optimise the SLUB allocator to
> >> address these corner case shortcomings w.r.t. traditional SLABs.
> >>=C2=A0
> >> Yup:
> >>=C2=A0
> >>=C2=A0
> >> commit 2d517aa09bbc4203f10cdee7e1d42f3bbdc1b1cd
> >> Author: Vlastimil Babka <vbabka@suse.cz>
> >> Date: =C2=A0 Wed Sep 3 14:59:45 2025 +0200
> >>=C2=A0
> >> =C2=A0 =C2=A0 slab: add opt-in caching layer of percpu sheaves
> >>=C2=A0
> >> =C2=A0 =C2=A0 Specifying a non-zero value for a new struct kmem_cache_=
args field
> >> =C2=A0 =C2=A0 sheaf_capacity will setup a caching layer of percpu arra=
ys called
> >> =C2=A0 =C2=A0 sheaves of given capacity for the created cache.
> >>=C2=A0
> >> =C2=A0 =C2=A0 Allocations from the cache will allocate via the percpu =
sheaves (main or
> >> =C2=A0 =C2=A0 spare) as long as they have no NUMA node preference. Fre=
es will also
> >> =C2=A0 =C2=A0 put the object back into one of the sheaves.
> >>=C2=A0
> >> =C2=A0 =C2=A0 When both percpu sheaves are found empty during an alloc=
ation, an empty
> >> =C2=A0 =C2=A0 sheaf may be replaced with a full one from the per-node =
barn. If none
> >> =C2=A0 =C2=A0 are available and the allocation is allowed to block, an=
 empty sheaf is
> >> =C2=A0 =C2=A0 refilled from slab(s) by an internal bulk alloc operatio=
n. When both
> >> =C2=A0 =C2=A0 percpu sheaves are full during freeing, the barn can rep=
lace a full one
> >> =C2=A0 =C2=A0 with an empty one, unless over a full sheaves limit. In =
that case a
> >> =C2=A0 =C2=A0 sheaf is flushed to slab(s) by an internal bulk free ope=
ration. Flushing
> >> =C2=A0 =C2=A0 sheaves and barns is also wired to the existing cpu flus=
hing and cache
> >> =C2=A0 =C2=A0 shrinking operations.
> >>=C2=A0
> >> =C2=A0 =C2=A0 The sheaves do not distinguish NUMA locality of the cach=
ed objects. If
> >> =C2=A0 =C2=A0 an allocation is requested with kmem_cache_alloc_node() =
(or a mempolicy
> >> =C2=A0 =C2=A0 with strict_numa mode enabled) with a specific node (not=
 NUMA_NO_NODE),
> >> =C2=A0 =C2=A0 the sheaves are bypassed.
> >>=C2=A0
> >> =C2=A0 =C2=A0 The bulk operations exposed to slab users also try to ut=
ilize the
> >> =C2=A0 =C2=A0 sheaves as long as the necessary (full or empty) sheaves=
 are available
> >> =C2=A0 =C2=A0 on the cpu or in the barn. Once depleted, they will fall=
back to bulk
> >> =C2=A0 =C2=A0 alloc/free to slabs directly to avoid double copying.
> >>=C2=A0
> >> =C2=A0 =C2=A0 The sheaf_capacity value is exported in sysfs for observ=
ability.
> >>=C2=A0
> >> =C2=A0 =C2=A0 Sysfs CONFIG_SLUB_STATS counters alloc_cpu_sheaf and fre=
e_cpu_sheaf
> >> =C2=A0 =C2=A0 count objects allocated or freed using the sheaves (and =
thus not
> >> =C2=A0 =C2=A0 counting towards the other alloc/free path counters). Co=
unters
> >> =C2=A0 =C2=A0 sheaf_refill and sheaf_flush count objects filled or flu=
shed from or to
> >> =C2=A0 =C2=A0 slab pages, and can be used to assess how effective the =
caching is. The
> >> =C2=A0 =C2=A0 refill and flush operations will also count towards the =
usual
> >> =C2=A0 =C2=A0 alloc_fastpath/slowpath, free_fastpath/slowpath and othe=
r counters for
> >> =C2=A0 =C2=A0 the backing slabs. =C2=A0For barn operations, barn_get a=
nd barn_put count how
> >> =C2=A0 =C2=A0 many full sheaves were get from or put to the barn, the =
_fail variants
> >> =C2=A0 =C2=A0 count how many such requests could not be satisfied main=
ly =C2=A0because the
> >> =C2=A0 =C2=A0 barn was either empty or full. While the barn also holds=
 empty sheaves
> >> =C2=A0 =C2=A0 to make some operations easier, these are not as critica=
l to mandate own
> >> =C2=A0 =C2=A0 counters. =C2=A0Finally, there are sheaf_alloc/sheaf_fre=
e counters.
> >>=C2=A0
> >> =C2=A0 =C2=A0 Access to the percpu sheaves is protected by local_trylo=
ck() when
> >> =C2=A0 =C2=A0 potential callers include irq context, and local_lock() =
otherwise (such
> >> =C2=A0 =C2=A0 as when we already know the gfp flags allow blocking). T=
he trylock
> >> =C2=A0 =C2=A0 failures should be rare and we can easily fallback. Each=
 per-NUMA-node
> >> =C2=A0 =C2=A0 barn has a spin_lock.
> >>=C2=A0
> >> =C2=A0 =C2=A0 When slub_debug is enabled for a cache with sheaf_capaci=
ty also
> >> =C2=A0 =C2=A0 specified, the latter is ignored so that allocations and=
 frees reach the
> >> =C2=A0 =C2=A0 slow path where debugging hooks are processed. Similarly=
, we ignore it
> >> =C2=A0 =C2=A0 with CONFIG_SLUB_TINY which prefers low memory usage to =
performance.
> >>=C2=A0
> >> =C2=A0 =C2=A0 [boot failure: https://lore.kernel.org/all/583eacf5-c971=
-451a-9f76-fed0e341b815@linux.ibm.com/ ]
> >>=C2=A0
> >> =C2=A0 =C2=A0 Reported-and-tested-by: Venkat Rao Bagalkote <venkat88@l=
inux.ibm.com>
> >> =C2=A0 =C2=A0 Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> >> =C2=A0 =C2=A0 Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >> =C2=A0 =C2=A0 Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >>=C2=A0
> >> Yeah, recent code, functionality is not enabled by default yet. So,
> >> kmem_cache_alloc() with:
> >>=C2=A0
> >> struct kmem_cache_args {
> >> .....
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /**
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* @sheaf_capacity: Enable sheaves of=
 given capacity for the cache.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* With a non-zero value, allocations=
 from the cache go through caching
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* arrays called sheaves. Each cpu ha=
s a main sheaf that's always
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* present, and a spare sheaf that ma=
y be not present. When both become
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* empty, there's an attempt to repla=
ce an empty sheaf with a full sheaf
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* from the per-node barn.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* When no full sheaf is available, a=
nd gfp flags allow blocking, a
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* sheaf is allocated and filled from=
 slab(s) using bulk allocation.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Otherwise the allocation falls bac=
k to the normal operation
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* allocating a single object from a =
slab.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Analogically when freeing and both=
 percpu sheaves are full, the barn
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* may replace it with an empty sheaf=
, unless it's over capacity. In
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* that case a sheaf is bulk freed to=
 slab pages.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* The sheaves do not enforce NUMA pl=
acement of objects, so allocations
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* via kmem_cache_alloc_node() with a=
 node specified other than
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* NUMA_NO_NODE will bypass them.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Bulk allocation and free operation=
s also try to use the cpu sheaves
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* and barn, but fallback to using sl=
ab pages directly.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* When slub_debug is enabled for the=
 cache, the sheaf_capacity argument
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* is ignored.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* %0 means no sheaves will be create=
d.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int sheaf_capacity;
> >> }
> >>=C2=A0
> >> set to the value required is all we need. i.e. something like this
> >> in iomap_dio_init():
> >>=C2=A0
> >>=C2=A0
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kmem_cache_args kmem_args =3D {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .sheaf_capacit=
y =3D 256,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> >>=C2=A0
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 dio_kmem_cache =3D kmem_cache_create("ioma=
p_dio", sizeof(struct iomap_dio),
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &kmem_args, SLAB_PANIC | SLAB_ACCOUNT
> >>=C2=A0
> >> And changing the allocation to kmem_cache_alloc(dio_kmem_cache,
> >> GFP_KERNEL) should provide the same sort of performance improvement
> >> as this patch does.
> >>=C2=A0
> >> Can you test this, please?
> >=C2=A0
> > Hi Dave:
> > Sorry it took so long to respond. Guzebing was busy with something else=
, I did
> > this test.
> > I test sheaf_capacity on 7.0-rc3, it doesn't show any performance impro=
vment.
>=C2=A0
> 7.0-rc3 already has sheaves in every cache and the old caching scheme
> removed. An explicit sheaf_capacity can now be used to increase the
> automatically calculated one, where the value you can observe in
> /sys/kernel/slab/$cache/sheaf_capacity
>=C2=A0
> > Besides, I wrote a simple kernel modules to test the performance differ=
ence by
> > creating a normal memcache and one with sheaf_capacity and testing the =
time
> > consuming to request 32 objects and then free 32 objects. which resulte=
d in a
> > roughly 10% improvement in time spent.
>=C2=A0
> That suggests in that test you used larger capacity than the automaticall=
y
> calculated.
The 10% improvement is due to the every cache has sheaves.
When I tested 256-byte objects, default sheaf_capacity is 26, allocating an=
d
freeing 32 objects did not show a noticeable difference, but allocating and
freeing 128 objects resulted in a significant improvement, about 3-4x in a=
=C2=A0
multithreaded environment.=C2=A0 about 12% improvement in single thread.

> =C2=A0
> > I'm thinking that maybe these improvements may not be significant enoug=
h to
> > see the effect in the io flow.
> > Using a simple list seems to be the most efficient approach.
>=C2=A0
> I think the question is, what improvement do you now see with your added
> pcpu cache vs kmalloc() when 7.0-rc4 is used as the baseline?

On 7.0-rc4, pcpu get 1.20M IOPS , kmalloc get 1.19M IOPS, new cache with se=
t sheaf_capacity 256, 1.19M IOPS
On 6.19, pcpu get 1.20M IOPS,=C2=A0 kmalloc get 1.17M IOPS, new cache with =
set sheaf_capacity 256, 1.19M IOPS.

>=C2=A0
> Thanks,
> Vlastimil
>=C2=A0
> > Thanks.
> > Fengnan.
> >=C2=A0
> >>=C2=A0
> >> If it doesn't provide any performance improvment, then I suspect
> >> that Vlastimil will be interested to find out why....
> >>=C2=A0
> >> Also, if it does work, it is likely the bioset mempools (which are
> >> slab based) can be initialised similarly, removing the need for
> >> custom per-cpu free lists in the block layer, too.
> >>=C2=A0
> >> -Dave.
> >>=C2=A0
> >> >=C2=A0
> >> > v3:
> >> > kmalloc now is called outside the get_cpu/put_cpu code section.
> >> >=C2=A0
> >> > v2:
> >> > Factor percpu cache into common code and the iomap module uses it.
> >> >=C2=A0
> >> > v1:
> >> > https://lore.kernel.org/all/20251121090052.384823-1-guzebing1612@gma=
il.com/
> >> >=C2=A0
> >> > Tested-by: syzbot@syzkaller.appspotmail.com
> >> >=C2=A0
> >> > Suggested-by: Fengnan Chang <changfengnan@bytedance.com>
> >> > Signed-off-by: guzebing <guzebing1612@gmail.com>
> >> > ---
> >> > =C2=A0fs/iomap/direct-io.c | 133 +++++++++++++++++++++++++++++++++++=
+++++++-
> >> > =C2=A01 file changed, 130 insertions(+), 3 deletions(-)
> >> >=C2=A0
> >> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> >> > index 5d5d63efbd57..4421e4ad3a8f 100644
> >> > --- a/fs/iomap/direct-io.c
> >> > +++ b/fs/iomap/direct-io.c
> >> > @@ -56,6 +56,130 @@ struct iomap_dio {
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> >> > =C2=A0};
> >> > =C2=A0
> >> > +#define PCPU_CACHE_IRQ_THRESHOLD =C2=A0 =C2=A0 =C2=A0 =C2=A016
> >> > +#define PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list) \
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0(sizeof(struct pcpu_cache_element) + pc=
pu_cache_list->element_size)
> >> > +#define PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload) \
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0((struct pcpu_cache_element *)((unsigne=
d long)(payload) - \
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(s=
truct pcpu_cache_element)))
> >> > +#define PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(head) \
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0((void *)((unsigned long)(head) + sizeo=
f(struct pcpu_cache_element)))
> >> > +
> >> > +struct pcpu_cache_element {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element =C2=A0 =C2=A0=
 =C2=A0 =C2=A0*next;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0char =C2=A0 =C2=A0 =C2=A0 =C2=A0payload=
[];
> >> > +};
> >> > +struct pcpu_cache {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element =C2=A0 =C2=A0=
 =C2=A0 =C2=A0*free_list;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element =C2=A0 =C2=A0=
 =C2=A0 =C2=A0*free_list_irq;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0nr;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0nr_irq;
> >> > +};
> >> > +struct pcpu_cache_list {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache __percpu *cache;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t element_size;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0int max_nr;
> >> > +};
> >> > +
> >> > +static struct pcpu_cache_list *pcpu_cache_list_create(int max_nr, s=
ize_t size)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_list *pcpu_cache_list=
;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list =3D kmalloc(sizeof(stru=
ct pcpu_cache_list), GFP_KERNEL);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pcpu_cache_list)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL=
;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list->element_size =3D size;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list->max_nr =3D max_nr;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list->cache =3D alloc_percpu=
(struct pcpu_cache);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pcpu_cache_list->cache) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(pcpu_=
cache_list);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL=
;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0return pcpu_cache_list;
> >> > +}
> >> > +
> >> > +static void pcpu_cache_list_destroy(struct pcpu_cache_list *pcpu_ca=
che_list)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0free_percpu(pcpu_cache_list->cache);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(pcpu_cache_list);
> >> > +}
> >> > +
> >> > +static void irq_cache_splice(struct pcpu_cache *cache)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0/* cache->free_list must be empty */
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (WARN_ON_ONCE(cache->free_list))
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0local_irq_save(flags);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free_list =3D cache->free_list_i=
rq;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free_list_irq =3D NULL;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr +=3D cache->nr_irq;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr_irq =3D 0;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0local_irq_restore(flags);
> >> > +}
> >> > +
> >> > +static void *pcpu_cache_list_alloc(struct pcpu_cache_list *pcpu_cac=
he_list)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache *cache;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element *cache_elemen=
t;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache =3D per_cpu_ptr(pcpu_cache_list->=
cache, get_cpu());
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cache->free_list) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (READ_ON=
CE(cache->nr_irq) >=3D PCPU_CACHE_IRQ_THRESHOLD)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0irq_cache_splice(cache);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cache-=
>free_list) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0put_cpu();
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0cache_element =3D kmalloc(PCPU_CACHE_ELEMENT_SIZE(pcpu_cac=
he_list),
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0GFP_KERNEL);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0if (!cache_element)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_elem=
ent);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_element =3D cache->free_list;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free_list =3D cache_element->nex=
t;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr--;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0put_cpu();
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0return PCPU_CACHE_ELEMENT_GET_PAYLOAD_F=
ROM_HEAD(cache_element);
> >> > +}
> >> > +
> >> > +static void pcpu_cache_list_free(void *payload, struct pcpu_cache_l=
ist *pcpu_cache_list)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache *cache;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pcpu_cache_element *cache_elemen=
t;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_element =3D PCPU_CACHE_ELEMENT_GE=
T_HEAD_FROM_PAYLOAD(payload);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0cache =3D per_cpu_ptr(pcpu_cache_list->=
cache, get_cpu());
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (READ_ONCE(cache->nr_irq) + cache->n=
r >=3D pcpu_cache_list->max_nr)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_fr=
ee;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (in_task()) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_eleme=
nt->next =3D cache->free_list;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free=
_list =3D cache_element;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr++=
;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (in_hardirq()) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lockdep_ass=
ert_irqs_disabled();
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_eleme=
nt->next =3D cache->free_list_irq;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->free=
_list_irq =3D cache_element;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache->nr_i=
rq++;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_fr=
ee;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0put_cpu();
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> >> > +out_free:
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0put_cpu();
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(cache_element);
> >> > +}
> >> > +
> >> > +#define DIO_ALLOC_CACHE_MAX =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0256
> >> > +static struct pcpu_cache_list *dio_pcpu_cache_list;
> >> > +
> >> > =C2=A0static struct bio *iomap_dio_alloc_bio(const struct iomap_iter=
 *iter,
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct=
 iomap_dio *dio, unsigned short nr_vecs, blk_opf_t opf)
> >> > =C2=A0{
> >> > @@ -135,7 +259,7 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio=
)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0ret +=3D dio->done_before;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_complete(iocb, dio=
->error, ret);
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(dio);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list_free(dio, dio_pcpu_cach=
e_list);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> >> > =C2=A0}
> >> > =C2=A0EXPORT_SYMBOL_GPL(iomap_dio_complete);
> >> > @@ -620,7 +744,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_it=
er *iter,
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!iomi.len)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return=
 NULL;
> >> > =C2=A0
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0dio =3D kmalloc(sizeof(*dio), GFP_KERNE=
L);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0dio =3D pcpu_cache_list_alloc(dio_pcpu_=
cache_list);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dio)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return=
 ERR_PTR(-ENOMEM);
> >> > =C2=A0
> >> > @@ -804,7 +928,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_it=
er *iter,
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return dio;
> >> > =C2=A0
> >> > =C2=A0out_free_dio:
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(dio);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0pcpu_cache_list_free(dio, dio_pcpu_cach=
e_list);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return=
 ERR_PTR(ret);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> >> > @@ -834,6 +958,9 @@ static int __init iomap_dio_init(void)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!zero_page)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return=
 -ENOMEM;
> >> > =C2=A0
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0dio_pcpu_cache_list =3D pcpu_cache_list=
_create(DIO_ALLOC_CACHE_MAX, sizeof(struct iomap_dio));
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dio_pcpu_cache_list)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENO=
MEM;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> >> > =C2=A0}
> >> > =C2=A0fs_initcall(iomap_dio_init);
> >> > --=C2=A0
> >> > 2.20.1
> >> >=C2=A0
> >> >=C2=A0
> >> >=C2=A0
> >>=C2=A0
> >> --=C2=A0
> >> Dave Chinner
> >> david@fromorbit.com
> >>
>=C2=A0
