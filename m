Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB8742BC54;
	Tue, 14 Jul 2026 22:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784067779; cv=none; b=JH/6S0ex+JJKjW2unrRDIe00SSt6jG4JESalUjFrlI0DxpzJt13bB8YOLfSRZQc9z2xCa5P9xxnEoG1egVQCAt/+3+5rqhDh5YgP1QG020BlmwMJUsPzJQBPoA6Y33CM0Nau+JwK4tIpYd4cUO5UWyEGxGyMfcSXcwvbHeywpgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784067779; c=relaxed/simple;
	bh=g66vkgwzdcMtt9TCTAfNwUGZomVfV4ZitLzYFBcrSkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7a/rI8ZOM1icYjG8kCNYWRcU/ssB3ioa1a+geU0EQyGUzRyFtrwhMGiEN/s9X+NN5hEtVIiydem06Y9i7oI91H3x8P2H9XKPgVK/MUPvHcbCPkVTFhdNrldXflAEFXanWhVv+auaj9dqXVZhOh+08TwZB208ErNnh2mEoJtUT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kC//weSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kC//weSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D208D1F000E9;
	Tue, 14 Jul 2026 22:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784067777;
	bh=aW/VhQGKLT7lo4RL60Q9vlfIJhM19IRBW2Xc6k3j5aA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kC//weStXk5f3N6WZzLP0YLgvU9fktRcRiiMLCE5kGshiYa1KIxXg/9Bw7q5Ofqva
	 3TVgHfl3KPemY8C7xjEeCt8ud9H4K/0IlxLbd3S2qNvBAO//ad8IF/JNSzvvoAmW0p
	 NBA7wBiag/P4uG8walzTY/9BXlP5CF75pMQ5hA/WLJ8XHETIEjg2nhoAl3ht9BJuDM
	 eH7f4ZWBfbpn3FC867t2mcdvwML0HaUuyVqAwKnorYZ9K9zrzNvr3U3c+VBB9jqSOz
	 rdDF1enltkZ2LSSqc+GLIGA71bOdngTjtLiSSapXQ2gJjKNoo5NliTTlPAwt9wy/Ct
	 ce62BOPi0BRYg==
Date: Wed, 15 Jul 2026 08:22:36 +1000
From: Dave Chinner <dgc@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, qi.zheng@linux.dev, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
	linux-btrfs@vger.kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, shakeel.butt@linux.dev,
	hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
Message-ID: <ala2rDHrFDjql3Qg@dread>
References: <20260714101454.1202449-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714101454.1202449-1-usama.arif@linux.dev>

On Tue, Jul 14, 2026 at 03:14:54AM -0700, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skips the
> ->nr_cached_objects() hook whenever the shrinker is invoked for a
> non-root memcg, because none of the current implementations (btrfs,
> xfs, shmem huge) honour sc->memcg.

I don't see that commit in an upstream tree. I'm guessing I wasn't
cc'd on it, either, because I don't recall seeing that as a patch,
either.

However, if anything is gating the fs_objects callouts to the fs
when memcg is being srhunk, then it is fundamentally broken and you
are correct to fix it.

> 
> That policy is really a filesystem-owned property: fs/super.c should
> not encode the assumption that these hooks are never memcg-aware,
> since a future implementation might legitimately filter by sc->memcg.
> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
> and shmem_unused_huge_count() so each filesystem can lift the
> restriction independently once its underlying counters/scans become
> memcg-aware, without needing a coordinated change to fs/super.c.

However, your assumptions here are incorrect.

That is, the XFS fs_objects implementation is intended to be called
even when memcg shrinking is occurring. I architected it that way
all those years ago when I introduced the fs_objects shrinker
callout. i.e. XFS is not aging reclaimable inodes via this call - it
is purely an expedite freeing of recently reclaimed VFS inodes when
there is memory pressure of any kind.

Reclaimable XFS inodes are still charged to memcgs, but we don't
track them per-memcg because it is extremely inefficient when their
lifetime after being released by the VFS is usually less than 5
seconds. Indeed, this low level cache is not for working set
retention; the VFS inode cache does that. The XFS inodes need to
through a GC state before they can be freed, this takes a little bit
of time, so we don't hold up the VFS inode cache shrinker for that.

The VFS inode cache shrinker is memcg aware, so it only pushes
inodes that are being reclaimed by memcg reclaim into the the
reclaimable state at the XFS level. Hence we don't need to track
reclaimable inodes by memcg - we know that memcg owned inodes that
are to be freed have already been pushed into reclaim by the VFS
shrinker doing memcg reclaim. Hence all we need to do is sweep them
and free them.

This is what the XFS fs objects shrinker does.  It needs to run in
conjunction with -any- shrinker context to immediately free the
clean inodes that the VFS shrinker released that pass, and to
release any of the recently released VFS inodes that needed GC and
are now clean and can be freed.

IOWs, the XFS fs_objects callout is not "memcg-aware" in the classic
sense of "it tracks objects by their owner memcg". However, the
-combined superblock shrinker algorithm- is memcg aware and that
results in XFS only seeing objects from the memcg being reclaimed
transitioning to RECLAIMABLE state which it then immediately sweeps
away.

i.e. the architecture of the VFS and XFS inode cache reclaim is
entirely memcg aware, and that is why I implemented the fs_objects
callout for XFS all those years ago. It works efficiently, it works
correctly with memcg based reclaim, and XFS doesn't need to care
about memcgs in it's low level reclaim code. Win, win, win.

> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()

Behaviour was broken by the above commit, it needs to change.

> still early-return 0 for non-root memcg contexts, keeping the shrinker
> bit clearable in each memcg's bitmap; the global (kswapd or root
> direct reclaim) path still drives them as before.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>
> @@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>  	wake_up_var(&sb->s_flags);
>  }
>  
> -/*
> - * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
> - * operate on filesystem-global state and ignore sc->memcg. Driving them
> - * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
> - * per-cpu counters and queueing duplicate work: the actual reclaim happens on
> - * the global path (kswapd or root direct reclaim) regardless. Restrict them
> - * to that path.
> - */
> -static inline bool super_fs_objects_eligible(struct shrink_control *sc)
> -{
> -	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> -}

This wrapper should still exist (with a better name) so filesystems
don't need to open code memcg cruft.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
