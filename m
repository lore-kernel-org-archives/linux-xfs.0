Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795384759;
	b=vvwS5bYYa/EcAIDOFujFCLO7oE0f9h2kZ9DbHdqR9UkdKGLumoLCIl1yW8k1eQtf9Mbb
	 HoY3VC3gCWlBwjIsZkeBjHz0ZVz7H4sykehih+FCmKxxSc00n6qWb6w6NBhyHeL2rEGd0
	 3sJXZ9r9UtWkGjD1cDnN3KpCeo46tZaCvJ4fOYPbvDOFeISDKbCa+ZNnENrVyM7PNWTgQ
	 yKKGC/Jl/dJ1IHLRv41hUGPVtydmXxH96PqtAhkqO6gesWmKCfa653NlhOpwX/caoMK6+
	 z1psG8+iyfHNZ1p45/A2mIM1kvcysjLO1FKe4dWdpGh8hhhZijiaZ+3TMVf6jPMQsRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795384759;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VKVDcIuQaevgGtraEctBRDBAbnJnWgbfI/Qfisvu0r0=;
	b=ngKWN6Lhosg+aOafGHCx4bUvvP4TlOWREk0JQOaQjvM3BEqqgkC+GpqryLHijJXWeC9w
	 Ct93oPJtWxNrIE4HnyfhoMzUrOtreWBARJ+2VB9i7tU9TR224xoV8Bxvbyw3boF7UkQFr
	 WcQR8Ziypm10tQ39l5yqQDMW8QXiASBAtp8zU4Nkrt+jsHKIvgkkznF8sTNDuvR7yolSd
	 WBx2NmS/nzLh9J3f5rJCBxhgXQNZ9ZxCTzp9H600R2vawn5q68jNJQj+Aubd0W3nYcDc8
	 ofj0n3n7+sEJozXOU2ZzhjJItkIfH7HrTiqL0GO4bCJA+zpL0GxCSQbhLVm/RAhzcjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cygjGK2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264A5606A31A;
	Sun, 22 Nov 2026 21:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cygjGK2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0781F000C6;
	Sun, 22 Nov 2026 21:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795384758;
	bh=VKVDcIuQaevgGtraEctBRDBAbnJnWgbfI/Qfisvu0r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cygjGK2Qwk9AC2AgYeX3wIMuyM2D/W4bApQSl3IG+pJ0cP6HqakHMPQLUNCkoH5NF
	 5lWbm+OaDH/oRuD4/wFvLK+u5lHhxWSYGGOGLKt8I5NQn92eGHCskMtF8M+tNGLmfT
	 YOCauVmKvNOpjEjykvO0t9wXkc3M6aFy6/QuYsDfv219zt5a8OdvSpHtvQlT/z4ruQ
	 WaPRcXTS4t/VjF/QRjqxJS6bbnJyvVyl0cxndf+IZ/R5/f9In22RgJpZJCGM4aO2iV
	 ZeewTk7p1HgGq4TZ7uWMgAzYUKBe6kOHLB6k5nnWQwQuvwf3fC7tmR0BdZyMOOyt47
	 QQnxSbMV562dg==
Date: Mon, 23 Nov 2026 08:59:08 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Qing Zhang <diasyzhangqing@gmail.com>, viro@zeniv.linux.org.uk,
	jack@suse.cz, raven@themaw.net, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] namei: revalidate the symlink dentry before invoking
 get_link in RCU-walk
Message-ID: <awNlrO5A-kdDOYvO@dread>
References: <20261118083945.1449264-1-diasyzhang@tencent.com>
 <20261120-desillusionieren-holzhammer-mieten-8ec8551ef2b0@brauner>
 <awB0RE6WN_v4YBbn@infradead.org>
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
In-Reply-To: <awB0RE6WN_v4YBbn@infradead.org>

On Fri, Nov 20, 2026 at 08:24:36AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 20, 2026 at 02:59:42PM +0100, Christian Brauner wrote:
> > This only makes the window smaller.
> > 
> > XFS can still reinitialize the inode right after this check and while
> > get() is running. Then ->get_link() operates on an inode that is being
> > reset underneath it. And the !get check only catches the case where the
> > that re-init already finished before we loaded ->get_link.
> > 
> > RCU pathwalk relies on inode memory not being reused before a grace
> > period has passed. XFS itself frees inodes via call_rcu() but the
> > recycle path hands the same struct inode out again without waiting for
> > existing RCU walkers.
> > 
> > So that should be fixed in XFS, either by not recycling an inode in
> > place while RCU walkers can still see it or by keeping i_op and the link
> > state valid across a recycle.
> 
> Not recycling the inode really isn't an option, as that means there
> would cause duplicate inodes in the xfs inode cache.  Keeping i_op and
> state in place sounds a bit more feasibly, but could be iffy as well.
> 
> The best thing would be to find a way to keep the inode alive at the VFS
> level when XFS marks it reclaimable.  That would be a huge an invasive
> change, but it would solve this and many other problems as well.

I don't think that's feasible without a massive rework of the VFS
inode life cycle management and/or the way XFS tracks inode metadata
dirtiness for writeback purposes.

Background:

The xfs_iget_recycle() code exists because dirty XFS_IRECLAIMABLE
inodes are tied into the journal machinery and need writeback before
they can be reclaimed. This is all invisible to the VFS, and it is
done via lockless lookups and atomic state checks without the need
for reference counts within XFS itself.

The issue is that reclaiming such an inode generally requires a log
force to stabilise it in the journal before it can be written back,
and the act of writing it back requires access to the inode state.
Hence the journal requires the XFS inode to live in XFS_IRECLAIMABLE
state until metadata writeback is complete, regardless of any other
inode state changes.

xfs_ireclaim() can expedite the writeback portion of reclaim (by
running an inode flush) but it does not expedite the required
journal flush if the inode is still dirty in memory. On lookup
of an XFS_IRECLAIMABLE inode in RCU mode, we cannot directly reclaim
a dirty XFS_IRECLAIMABLE inode because it requires blocking on both
a log force and metadata writeback. That's why the inode is sitting
in the XFS_IRECLAIMABLE limbo in the first place...

That's where the xfs_iget_recycle() code stepped in - it
reinitialises the VFS portion of the inode without affecting the
internal journal state of the inode. This allows new modifications to
be added to the inode and the attached log item without any
discontinuities in journal state.

The reason it does a full initialisation of the VFS inode is that
the inode can change identity whilst in XFS_IRECLAIMABLE. i.e. it
could be unlinked and then reallocated as a different inode (same
number, different generation), and so the type can change (e.g. REG
-> DIR) and hence a full VFS init is required to recycle it.

And the reason that we've always done this recycle is for
performance reasons - the inode allocation algorithms can prefer to
allocate recently freed inodes (for locality reasons), and hence
recently unlinked inodes in the IRECLAIMABLE state can be
reallocated and need recycling because the final unlink state hasn't
reached stable media before they are recycled.

Doing things like forcing logs, instant reclaim, RCU
synchronisation, etc have all had significant performance impacts
due to the additional latency these operations add to common
workload patterns. Hence the rarity of this recycle issue hasn't
outweighed the cost of the "simple" fixes to everyday operation.

---

> A good reproducer for the issue would help either way.

IIRC, we reproduced this previously using unlinked inodes and
exploiting the inode allocation algorithms to immediately reallocate
said freed inodes whilst they were still in the IRECLAIMABLE state.

I suspect that an acceptible fix here is made up of two parts. The
first is for clean inodes in IRECLAIMABLE state - they can be freed
without needing to wait for IO, so if the inode is clean we simply
reclaim it and return a 'miss' from the fast lookup path. Then the
lookup will hit the slow path, allocate a new inode, instantiate it
from the underlying cached inode cluster buffer (i.e. no IO needed)
and return that newly allocated indoe for the next VFS life cycle.

THis only costs a bit of extra CPU for the reclaim/reallocate case
for clean inodes, and should avoid the issue for all clean inodes.

For dirty inodes, it's a bit more complex - we are going to have to
block in the lookup path to resolve it. The fast path is going to
have to tag the inode as IRECLAIM so that all other lookups will
avoid it, then drop out of the lockless lookup mode. If the inode is
pinned, we need to force the log to enable expedited writeback to
succeed.

Then we can treat it like the clean path - calling
xfs_inode_reclaim() will then expedite the writeback flushing,
remove the inode from the cache and schedule it for freeing via
call_rcu(). Now we can run the cache miss path that will instantiate
a new inode from the underlying cluster buffer, and that gets
returned for the new VFS inode life cycle.

These two mods will give correct behaviour in all situations. It
will still have performance imapcts in the unlink/alloc case,
though, because that's the typical latency sensitive workload (think
working with lots of short term temp files) where the current
xfs_iget_recycle() code works well.

Hence there is a 3rd part to fixing this - avoiding reallocation of
free inodes still in XFS_IRECLAIMABLE state. Right now we have a
separation of on-disk indoe allocation (xfs_dialloc()) and in-memory
inode allocation (xfs_icreate()), with both of these functions being
paired everywhere we allocate an on-disk inode identically.
xfs-dialloc() retuns the inode number of the allocated inode, and
xfs_icreate() instantiates the in-memory inode for that inode
number.

Moving the instantiation of the in-memory inode to the same place we
select and allocate the on-disk inode would allow us to avoid
allocating IRECLAIMABLE inodes on-disk. i.e. we select a candidate
inode for on-disk allocation, check if it is in-memory already, and
if so, select a different inode to allocate. Otherwise, allocate the
in-memory inode and insert it into the cache as XFS_INEW without
doing any of the final setup, the allocate the on-disk inode for
that inode number, and then when that succeeds, do the final setup
of the in-memory inode that enables future lookups to find it in
cache...

At this point, we handle lookups of IRECLAIMABLE inodes correctly,
and we avoid the common situation where lookup-based reclaiming of
dirty IRECLAIMABLE inodes has a major impact on performance...

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
