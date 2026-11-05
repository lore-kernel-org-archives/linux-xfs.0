Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793891805;
	b=35WRmV5Tz4mgZaDfk812FpQzB3MEs4vTFTqeAjQb5kdWBfuil+uRgNChUSt38HqK3JWv
	 2EbUOpJeSto+AbAJpZPl2R5Zur7hYEsSrn4DH4NqOgaDsSo4uhGcHgrvfq4fhQMvRsdGA
	 6ateExNnyml+B0OhC4ke7i6dK7PiLjcmqhowac5XYVNML1vtD9e3FW5dM9QzJ8wxb5ZP3
	 G6nul5ZLB9M34slOEoSydcj5uz6aHLlPFqDrDAiYoHs9x6Ol2z8tgV3V3hQs6MER568ri
	 EOwxGuMg9k5dU1SrQgw31giESCnyxXRj+/bwCcaZKqLdH7C7xKIUgOkpko31CGLbFqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793891805;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Jc7jNYHyA9VYliDUcflNu154bjixGFT7JuiOxBXnkUM=;
	b=nLCykP6XFL/vDmEqG7HaQmAslj0UVe1lnBeP1y1jEKTmZ9VR3JIOpjzomjDDb92ZkHTr
	 FT8mdCl7mbp5x13xm2X3cmpHgTknI0f3MTbicXPDHyEFFH9wMBdd858TAR8udPnZjiLrk
	 yJzsPbpwgBUrZ+kkwR6NOHP5JqqrVRodaP5I2aWC4Ucj9NVA60NvegwMaWJ2mWhRe3bAf
	 z9hV68yi5vGktp66IKpEwXwfoSWvfZngZsjL+8xOr1G2ydkBAQn5pkPbZ03nGLZUTo/zD
	 rR2wU4uGC/B5PdHmo+VzbqaiXslT/rSEVoJ39soWmNuc+XQU0siCVsGBdD80XAz9/SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=agE0uUkp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85C5606A33B;
	Thu,  5 Nov 2026 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=agE0uUkp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BBF1F0093A;
	Thu,  5 Nov 2026 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793891805;
	bh=Jc7jNYHyA9VYliDUcflNu154bjixGFT7JuiOxBXnkUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=agE0uUkpU9W2FWjuo4xC/f1uPn9e9784VKwsmGr/AclKR98YkM+YGOoxriRqRJuOM
	 9mqCAZRRQKCKocJ0oNeWgtD5AMQkF6laNXOcArnlIJtHfzCFRAlXR5MGVTcYCL7BWH
	 Gc+HAZKwPomFpb8cKOmblu5SG83e74r/AUaw0VB66237rfWm9I/bqXmH61W+RCmW+V
	 7y42WCdgPHtxS4R3KYgs8dU/2j/15IP8/5z234NKGDX5TX8660Ehw7/yTvx2MDK4l/
	 8+58zefpePAhFTbw3ItbgPqiFfYa3UktwOO1J25yv9wB3iTQSn2OUW+G/48ZZvDfBR
	 KxDqKnGVYOtQA==
Date: Thu, 5 Nov 2026 16:16:40 +0100
From: Christian Brauner <brauner@kernel.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Yiqing Wu <wuyiqing@cmss.chinamobile.com>, gfs2@lists.linux.dev, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+5e659793378ad9e06387@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: allow writeback from kswapd again
Message-ID: <20261105-postkarten-akzentfrei-aufsicht-0ef16b0df401@brauner>
References: <20261103023804.8074-1-wuyiqing@cmss.chinamobile.com>
 <auo_CehOVzTMq6kc@dread>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <auo_CehOVzTMq6kc@dread>

On Wed, Nov 04, 2026 at 07:07:37AM +1100, Dave Chinner wrote:
> On Tue, Nov 03, 2026 at 10:38:04AM +0800, Yiqing Wu wrote:
> > Commit ff59f71f1c95 ("iomap: simplify writepages reclaim guard") removed
> > the PF_KSWAPD exemption from the iomap_writepages() guard on the
> > assumption that kswapd can no longer reach filesystem writeback now
> > that pageout() returns PAGE_ACTIVATE for non-shmem, non-anon folios.
> > That assumption only covers the folio reclaim path.  kswapd can still
> > reach filesystem writeback through the inode shrinkers, and syzbot
> > reports exactly that on GFS2:
> > 
> >   WARNING: (current->flags & PF_MEMALLOC) in iomap_writepages
> >   kswapd -> balance_pgdat -> shrink_node -> shrink_slab
> >   -> super_cache_scan -> prune_icache_sb -> evict
> >   -> gfs2_evict_inode -> evict_linked_inode -> gfs2_log_flush
> >   -> gfs2_ordered_write -> filemap_fdatawrite -> do_writepages
> >   -> gfs2_writepages -> iomap_writepages
> 
> Oh, that's awful. Nothing should be calling into iomap_writepages
> from reclaim context.
> 
> i.e. Doing data writeback from the inode cache shrinker is extremely
> suboptimal for many reasons, so I'd consider this a gfs2 bug, not an
> iomap issue. It's even worse when data writeback is being driven by
> an inode cache shrinker. I'm surprised that lockdep hasn't thrown a
> hissy-fit over this (i.e. inode locks taken in writeback appearing
> both above and below reclaim.
> 
> This is the patch series that Jan Kara came up with to deal with
> these issues in inode eviction:
> 
> https://lore.kernel.org/linux-fsdevel/20261009133253.20102-1-jack@suse.cz/
> 
> This allows filesystems to defer inode eviction that might block
> (e.g. due to transaction reservations, journal commits, metadata
> read requirements, data writeback requirements, etc) to a context
> where the work is allowed to block and isn't running under memory
> reclaim context or restrictions.
> 
> That patchset is needed for ext4, XFS alreayd does this, and it
> would seem that gfs2 needs it for glock reclaim....

I agree.
