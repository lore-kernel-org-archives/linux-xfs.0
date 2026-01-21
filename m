Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B9734B408
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 19:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025300; cv=none; b=TUaJEDc9R0mpQN4cGQ9F0k5zZg78Q+GEDnsgq70Q/hESIXIrGLxc1vX/heX8/sMJX7miSvwdiNvJRpKAZwB4jJp0KQ5jcMb1m2QhH6XEEnDuOn9aCapNED48gnuzVR2nFDfmfFvd7FIT7FFYaG2toK3pwAPYO2j2IFJ5kdV8SCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025300; c=relaxed/simple;
	bh=+FHQ1hfSyTT6VI8M149P/ZbCjPfOZTrHJq4X8tNwqmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjSWR1QYpi+42VJDEHOfzqz8wabqM2HpVvcEN9EzEKmvK/L7vwlbhk/kmWv4NLFsH6uo0ekgByCMm8moiWfIFNcQZfjVfIcaN1QHWQZzBdTkTNWYb08BQTRuU8kRwiAv0dxJlNartJ3algNl1FVVYgOdAeZcl7TWcPdGC0JdI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OqD3OO8f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqD3OO8f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769025297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zfynPqgAvAkpjBmuuO2JFrn162BWPXesCBnZDuNhRyE=;
	b=OqD3OO8faMBjasd+3ZLmScee99uc/4dUdc4eBzjLJDLcUImoEt8U0QifmS0x4um5ad7WKb
	pRuCidymMoJDrZQRfiqUXh943GeZQmdNiNIrWGc4qZjTXVoqi3naC59btuSxYCirILmpqV
	Me6Mc2vlwEzmQPl5Um0/bEicfkmVWtE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-lFkgxWuyM0i-XSDNQC4aXQ-1; Wed,
 21 Jan 2026 14:54:51 -0500
X-MC-Unique: lFkgxWuyM0i-XSDNQC4aXQ-1
X-Mimecast-MFC-AGG-ID: lFkgxWuyM0i-XSDNQC4aXQ_1769025289
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4895719560B2;
	Wed, 21 Jan 2026 19:54:47 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.128])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A97018001D5;
	Wed, 21 Jan 2026 19:54:42 +0000 (UTC)
Date: Wed, 21 Jan 2026 14:54:40 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <aXEvAD5Rf5QLp4Ma@bfoster>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
 <20260116100818.7576-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Jan 16, 2026 at 03:38:12PM +0530, Kundan Kumar wrote:
> This series explores AG aware parallel writeback for XFS. The goal is
> to reduce writeback contention and improve scalability by allowing
> writeback to be distributed across allocation groups (AGs).
> 
> Problem statement
> =================
> Today, XFS writeback walks the page cache serially per inode and funnels
> all writeback through a single writeback context. For aging filesystems,
> especially with high parallel buffered IO this leads to limited
> concurrency across independent AGs.
> 
> The filesystem already has strong AG level parallelism for allocation and
> metadata operations, but writeback remains largely AG agnostic.
> 
> High-level approach
> ===================
> This series introduces an AG aware writeback with following model:
> 1) Predict the target AG for buffered writes (mapped or delalloc) at write
>    time.
> 2) Tag AG hints per folio (via lightweight metadata / xarray).
> 3) Track dirty AGs per inode using bitmap.
> 4) Offload writeback to per AG worker threads, each performing a onepass
>    scan.
> 5) Workers filter folios and submit folios which are tagged for its AG.
> 
> Unlike our earlier approach that parallelized writeback by introducing
> multiple writeback contexts per BDI, this series keeps all changes within
> XFS and is orthogonal to that work. The AG aware mechanism uses per folio
> AG hints to route writeback to AG specific workers, and therefore applies
> even when a single inode’s data spans multiple AGs. This avoids the
> earlier limitation of relying on inode-based AG locality, which can break
> down on aged/fragmented filesystems.
> 
> IOPS and throughput
> ===================
> We see significant improvemnt in IOPS if files span across multiple AG
> 
> Workload 12 files each of 500M in 12 directories(AGs) - numjobs = 12
>     - NVMe device Intel Optane
>         Base XFS                : 308 MiB/s
>         Parallel Writeback XFS  : 1534 MiB/s  (+398%)
> 
> Workload 6 files each of 6G in 6 directories(AGs) - numjobs = 12
>     - NVMe device Intel Optane
>         Base XFS                : 409 MiB/s
>         Parallel Writeback XFS  : 1245 MiB/s  (+204%)
> 

Hi Kundan,

Could you provide more detail on how you're testing here? I threw this
at some beefier storage I have around out of curiosity and I'm not
seeing much of a difference. It could be I'm missing some details or
maybe the storage outweighs the processing benefit. But for example, is
this a fio test command being used? Is there preallocation? What type of
storage? Is a particular fs geometry being targeted for this
optimization (i.e. smaller AGs), etc.?

FWIW, I skimmed through the code a bit and the main thing that kind of
stands out to me is the write time per-folio hinting. Writeback handling
for the overwrite (i.e. non-delalloc) case is basically a single lookup
per mapping under shared inode lock. The question that comes to mind
there is what is the value of per-ag batching as opposed to just adding
generic concurrency? It seems unnecessary to me to take care to shuffle
overwrites into per-ag based workers when the underlying locking is
already shared.

WRT delalloc, it looks like we're basically taking the inode AG as the
starting point and guessing based on the on-disk AGF free blocks counter
at the time of the write. The delalloc accounting doesn't count against
the AGF, however, so ISTM that in many cases this would just effectively
land on the inode AG for larger delalloc writes. Is that not the case?

Once we get to delalloc writeback, we're under exclusive inode lock and
fall into the block allocator. The latter trylock iterates the AGs
looking for a good candidate. So what's the advantage of per-ag
splitting delalloc at writeback time if we're sending the same inode to
per-ag workers that all 1. require exclusive inode lock and 2. call into
an allocator that is designed to be scalable (i.e. if one AG is locked
it will just move to the next)?

Yet another consideration is how delalloc conversion works at the
xfs_bmapi_convert_delalloc() -> xfs_bmapi_convert_one_delalloc() level.
If you take a look at the latter, we look up the entire delalloc extent
backing the folio under writeback and attempt to allocate it all at once
(not just the blocks backing the folio). So in theory if we were to end
up tagging a sequence of contiguous delalloc backed folios at buffered
write time with different AGs, we're still going to try to allocate all
of that in one AG at writeback time. So the per-ag hinting also sort of
competes with this by shuffling writeback of the same potential extent
into different workers, making it a little hard to try and reason about.

So stepping back it kind of feels to me like the write time hinting has
so much potential for inaccuracy and unpredictability of writeback time
behavior (for the delalloc case), that it makes me wonder if we're
effectively just enabling arbitrary concurrency at writeback time and
perhaps seeing benefit from that. If so, that makes me wonder if the
associated value can be gained by somehow simplifying this to not
require write time hinting at all.

Have you run any experiments that perhaps rotors inodes to the
individual wb workers based on the inode AG (i.e. basically ignoring all
the write time stuff) by chance? Or anything that otherwise helps
quantify the value of per-ag batching over just basic concurrency? I'd
be interested to see if/how behavior changes with something like that.

Brian

> These changes are on top of the v6.18 kernel release.
> 
> Future work involves tighten writeback control (wbc) handling to integrate
> with global writeback accounting and range semantics, also evaluate
> interaction with higher level writeback parallelism.
> 
> Kundan Kumar (6):
>   iomap: add write ops hook to attach metadata to folios
>   xfs: add helpers to pack AG prediction info for per-folio tracking
>   xfs: add per-inode AG prediction map and dirty-AG bitmap
>   xfs: tag folios with AG number during buffered write via iomap attach
>     hook
>   xfs: add per-AG writeback workqueue infrastructure
>   xfs: offload writeback by AG using per-inode dirty bitmap and per-AG
>     workers
> 
>  fs/iomap/buffered-io.c |   3 +
>  fs/xfs/xfs_aops.c      | 257 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_aops.h      |   3 +
>  fs/xfs/xfs_icache.c    |  27 +++++
>  fs/xfs/xfs_inode.h     |   5 +
>  fs/xfs/xfs_iomap.c     | 114 ++++++++++++++++++
>  fs/xfs/xfs_iomap.h     |  31 +++++
>  fs/xfs/xfs_mount.c     |   2 +
>  fs/xfs/xfs_mount.h     |  10 ++
>  fs/xfs/xfs_super.c     |   2 +
>  include/linux/iomap.h  |   3 +
>  11 files changed, 457 insertions(+)
> 
> -- 
> 2.25.1
> 
> 

