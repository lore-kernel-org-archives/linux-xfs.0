Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793736467;
	b=OBsl2ZflvZ7R9MOaOaHcazvBoJXFfXwXjMBA0BWhdzimOHg6jqkis/NbyNaHDH/Bwfm9
	 2WGe52F9+D63bLi2j7oPtwXNHTYaGMpNrTLgHwPAx77Mp/gWYA7aEyrEjRJCglN1cnzEL
	 5dmK1dyMgrSC4F+1xL5skrhnqorjdFmFtl/od4PQXGsqnKsTTwH8nvgiQZw0C0JmiYCGX
	 bboKcqBS1Llu7F3Ph36s+2D6yesf/TX4MQRPeeze25X+eI0ie6dDKcvzsyXfuIA3HDJrS
	 aIYGVwS6GQAuPk175odFsakR6Q7jHNdsfvAFpwtKp77KMC3NVlhfsmzQJES5cxh3R7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793736467;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5rZwAD3Ycaihst6dgcoNSxFsehJMseduQ8wGz5Hbzvw=;
	b=U6Y0F1dvEDqd4ByqQJ5Kp3kCsERAXVyll9ZWQpdJlvw1SO54JP9E4AfLBVDP5jLJ8ElR
	 u0Kqe5emrWDaulbU1BoPfV88rnQj7ahJhGLZXln/dkrZsFK2VOMht1M020zgAWRmGmu2V
	 HyEDYwuOfDKcAyYA5M8P04SZanuSLJNWrPQUgyEd4GMouq6sYMHrMFKidI1C2nt/NZ1DV
	 hYtVPG54WV0CAXn28p+POGM8lpmZT+fR9LXROuQyHtaXBltJITeminhl4qvs+BwDDu0rt
	 I7GbzfFiGgcqPXMWcM969M93ATgNWTkiYFyB/JzglRJD90WaUR1zVheZoCmElK6/J/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCC3nV3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DCE606A31B;
	Tue,  3 Nov 2026 20:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCC3nV3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777DE1F000C1;
	Tue,  3 Nov 2026 20:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793736466;
	bh=5rZwAD3Ycaihst6dgcoNSxFsehJMseduQ8wGz5Hbzvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jCC3nV3gatYb+Op+60ZOPxNoM07PP2vmltvuWnmxmXsapTEmJjATJ7Nr6ROlU3ZeY
	 kHis+d1l0GqsnjSrVf6k4t2mhB323KrYjYFec9GQ+u+xjyH5DmTGnk2pJguctxEjLW
	 MAK0ac+wmy5baBVsuFkGb1c6bkO1yq/Q+OHz65KtZROwEVXqhT0y+5ZET3JAfq/QU+
	 ycQ5Cg3scRwTpTYrY429Bk5l72MDqb8Q7x3SoGpjbcO3ZZJjlI2yDFF2s09na/pOey
	 5aWbIQ9VtwzJ496kH61763zne4hBv9T2tfF9dK8GsjlDTbvuUfQRTmZwvWY3oUIOXr
	 XTQF91uXjCFJw==
Date: Wed, 4 Nov 2026 07:07:37 +1100
From: Dave Chinner <dgc@kernel.org>
To: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Cc: Christian Brauner <brauner@kernel.org>, gfs2@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+5e659793378ad9e06387@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: allow writeback from kswapd again
Message-ID: <auo_CehOVzTMq6kc@dread>
References: <20261103023804.8074-1-wuyiqing@cmss.chinamobile.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103023804.8074-1-wuyiqing@cmss.chinamobile.com>

On Tue, Nov 03, 2026 at 10:38:04AM +0800, Yiqing Wu wrote:
> Commit ff59f71f1c95 ("iomap: simplify writepages reclaim guard") removed
> the PF_KSWAPD exemption from the iomap_writepages() guard on the
> assumption that kswapd can no longer reach filesystem writeback now
> that pageout() returns PAGE_ACTIVATE for non-shmem, non-anon folios.
> That assumption only covers the folio reclaim path.  kswapd can still
> reach filesystem writeback through the inode shrinkers, and syzbot
> reports exactly that on GFS2:
> 
>   WARNING: (current->flags & PF_MEMALLOC) in iomap_writepages
>   kswapd -> balance_pgdat -> shrink_node -> shrink_slab
>   -> super_cache_scan -> prune_icache_sb -> evict
>   -> gfs2_evict_inode -> evict_linked_inode -> gfs2_log_flush
>   -> gfs2_ordered_write -> filemap_fdatawrite -> do_writepages
>   -> gfs2_writepages -> iomap_writepages

Oh, that's awful. Nothing should be calling into iomap_writepages
from reclaim context.

i.e. Doing data writeback from the inode cache shrinker is extremely
suboptimal for many reasons, so I'd consider this a gfs2 bug, not an
iomap issue. It's even worse when data writeback is being driven by
an inode cache shrinker. I'm surprised that lockdep hasn't thrown a
hissy-fit over this (i.e. inode locks taken in writeback appearing
both above and below reclaim.

This is the patch series that Jan Kara came up with to deal with
these issues in inode eviction:

https://lore.kernel.org/linux-fsdevel/20261009133253.20102-1-jack@suse.cz/

This allows filesystems to defer inode eviction that might block
(e.g. due to transaction reservations, journal commits, metadata
read requirements, data writeback requirements, etc) to a context
where the work is allowed to block and isn't running under memory
reclaim context or restrictions.

That patchset is needed for ext4, XFS alreayd does this, and it
would seem that gfs2 needs it for glock reclaim....

> Under memory pressure kswapd evicts GFS2 inodes whose glock is still
> dirty, and gfs2_evict_inode() -> gfs2_log_flush() ->
> gfs2_ordered_write() then writes back the ordered data of every inode
> on sd_log_ordered.  This is long-standing, intentional behaviour: in
> the default data=ordered mode GFS2 must flush dirty data before the
> log commit that writes the metadata.

It's also long standing, known broken behaviour w.r.t. shrinkers
running in memory reclaim contexts.

So, why doesn't this warning happen through the direct reclaim path?
i.e.  what makes only kswapd trigger this?

I see nothing that prevents direct reclaim doing inode eviction
from triggering this same path through gfs2_evict_inode(). IOWs,
direct reclaim should also be triggering the warning in
iomap_writepages(), hence it is not clear to me why re-adding the
kswapd guard is anything other than a band-aid over the broken code
in gfs2....

> Writeback from kswapd has been
> explicitly allowed since 2010, when the guard was still in XFS:
> commit d4f7a5cbd544 ("xfs: allow writeback from kswapd"), because
> the kswapd stack usage is low and it cannot deadlock on the
> filesystem.

No, that was a regression fix for turning off all writeback from
reclaim in XFS as a 'what problems does stopping mm reclaim
writeback actually cause' experiment. That was the first steps we
took down the path to get rid of the problematic random dirty page
writeback issues that memory reclaim had.

IOWs, we didn't want to allow it, but we had to tolerate it because
the MM behaviour was unfixable at the time. Now that the
pageout()->.writepage() path for dirty filebacked page writeback is
gone from the mm, we no longer have to tolerate this behaviour 
and so the guard got removed. It only took 15 years to get to this
point....

tl;dr: Writeback through iomap in memory reclaim context is -a bug-.

> Beyond the noisy warning the new guard is actively harmful: it returns
> -EIO on every hit (WARN_ON_ONCE only limits the report), while
> gfs2_ordered_write() ignores the filemap_fdatawrite() return value, so
> the log commit proceeds with metadata even though the ordered data was
> never written, breaking the data-before-metadata ordering guarantee of
> data=ordered mode.

This is definitely a gfs2 bug - writeback can fail for -many-
reasons, so ignoring IO submission failures when data integrity is
required is a definitely filesystem bug.

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d6e2f1ded5ca..324da0f5cb29 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -2082,7 +2082,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
>  	 * Writeback from reclaim context should never happen except in the case
>  	 * of a VM regression so warn about it and refuse to write the data.
>  	 */
> -	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
> +	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC) && !current_is_kswapd()))
>  		return -EIO;

AFAICT, direct reclaim will still trigger this warning and the bad
gfs2 behaviour, so I'm struggling to see this as anything other than
shooting the messenger...

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
