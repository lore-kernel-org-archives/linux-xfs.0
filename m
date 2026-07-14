Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8759D4963A9
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784042461; cv=none; b=rQxhau23216I9BW/kZq5yuuIL+tK96nmFO+htJ8w9POXiA6/0YtBAJQ3JbKjfgT45bcK4K47y7rbyn4L0Mq7bBHeMSm5ejbRyPwbtLiSuv+as/dojUn0pfZ4KeZ4cH0LyQLzknOFCBa/UNY1CfZJEuSpQ+mstLBMGXBRZvj1Yj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784042461; c=relaxed/simple;
	bh=wqFfTlkEbOdYZZvKD6m8yjmVTIDP1K1kzr/Ncxyd3eI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzEOBpthiNbQPet60fCDfl1NQX7zHaMPxbrSmKJvGMT2y1d11zkNRh99MfIKa3lyHjzWyEGcqxvaRZS4Xm7NSoUrQLDd4WWGUjrT0hQodUY6u1SeomlwNZyPpoW0Y6/BbKIsphG32Ca5uFojEcPhA11CV58TDywRrhGXhD8XHko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dASCRtRt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xIE1j4Cr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dASCRtRt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xIE1j4Cr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dASCRtRt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xIE1j4Cr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dASCRtRt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xIE1j4Cr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8AB1C3E09;
	Tue, 14 Jul 2026 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784042457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=dASCRtRtL//gOyKnlywttPlWck8xL5wEGvxxYkQp+GLBVb2rYuh+DGwUc2nRYVlZOUDPmm
	wnFOEOtHrErBl+e8ffFFpOjtMSGZci8GJ4S0j0TKuxldeSqAs5ui1yJbWv5/HCtAhWRDn9
	z6R5ubb0NJj+8sTlcOmyNdlZO9mw54o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784042457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=xIE1j4CrqNVRYt8d6Dk4AJ1wPbp4OzW9GO1U+7vd/ZbLByovfW2xse3D6P3ox9jVuQNqoO
	7bvrJ3ceM2buSsBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784042457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=dASCRtRtL//gOyKnlywttPlWck8xL5wEGvxxYkQp+GLBVb2rYuh+DGwUc2nRYVlZOUDPmm
	wnFOEOtHrErBl+e8ffFFpOjtMSGZci8GJ4S0j0TKuxldeSqAs5ui1yJbWv5/HCtAhWRDn9
	z6R5ubb0NJj+8sTlcOmyNdlZO9mw54o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784042457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=xIE1j4CrqNVRYt8d6Dk4AJ1wPbp4OzW9GO1U+7vd/ZbLByovfW2xse3D6P3ox9jVuQNqoO
	7bvrJ3ceM2buSsBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A0B8779AE;
	Tue, 14 Jul 2026 15:20:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZnPZHNlTVmrnUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Jul 2026 15:20:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 22BE9A1319; Tue, 14 Jul 2026 17:20:57 +0200 (CEST)
Date: Tue, 14 Jul 2026 17:20:57 +0200
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, qi.zheng@linux.dev, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
Message-ID: <7yhd7nfbeukx5ycm4tpk2mc37b6cqpiw4q4gbf3elmtbfaoftb@txp5gavwasxv>
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
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,linux.dev:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -3.80

On Tue 14-07-26 03:14:54, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skips the
> ->nr_cached_objects() hook whenever the shrinker is invoked for a
> non-root memcg, because none of the current implementations (btrfs,
> xfs, shmem huge) honour sc->memcg.
> 
> That policy is really a filesystem-owned property: fs/super.c should
> not encode the assumption that these hooks are never memcg-aware,
> since a future implementation might legitimately filter by sc->memcg.
> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
> and shmem_unused_huge_count() so each filesystem can lift the
> restriction independently once its underlying counters/scans become
> memcg-aware, without needing a coordinated change to fs/super.c.
> 
> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
> still early-return 0 for non-root memcg contexts, keeping the shrinker
> bit clearable in each memcg's bitmap; the global (kswapd or root
> direct reclaim) path still drives them as before.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Makes sense to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/super.c   | 11 +++++++++++
>  fs/super.c         | 19 ++-----------------
>  fs/xfs/xfs_super.c | 12 ++++++++++++
>  mm/shmem.c         | 11 +++++++++++
>  4 files changed, 36 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a7d804219bec..16c24bccc897 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -22,6 +22,7 @@
>  #include <linux/namei.h>
>  #include <linux/miscdevice.h>
>  #include <linux/magic.h>
> +#include <linux/memcontrol.h>
>  #include <linux/slab.h>
>  #include <linux/ratelimit.h>
>  #include <linux/crc32c.h>
> @@ -2434,6 +2435,16 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>  	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
>  
> +	/*
> +	 * The evictable extent map counter is filesystem-global and does not
> +	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> +	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work and
> +	 * pinning the shrinker bit in every memcg's bitmap.
> +	 */
> +	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
> +		return 0;
> +
>  	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
>  
>  	return nr;
> diff --git a/fs/super.c b/fs/super.c
> index d2d04a6f4f84..a8fd61136aaf 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,7 +24,6 @@
>  #include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> -#include <linux/memcontrol.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
>  #include <linux/writeback.h>		/* for the emergency remount stuff */
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
> -
>  /*
>   * One thing we have to be careful of with a per-sb shrinker is that we don't
>   * drop the last active reference to the superblock from within the shrinker.
> @@ -212,7 +198,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	if (!super_trylock_shared(sb))
>  		return SHRINK_STOP;
>  
> -	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
> +	if (sb->s_op->nr_cached_objects)
>  		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
> @@ -273,8 +259,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  		return 0;
>  	smp_rmb();
>  
> -	if (sb->s_op && sb->s_op->nr_cached_objects &&
> -	    super_fs_objects_eligible(sc))
> +	if (sb->s_op && sb->s_op->nr_cached_objects)
>  		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index eac7f9503805..f0d8251fad3b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -54,6 +54,7 @@
>  #include "scrub/rcbag_btree.h"
>  
>  #include <linux/magic.h>
> +#include <linux/memcontrol.h>
>  #include <linux/fs_context.h>
>  #include <linux/fs_parser.h>
>  #include <linux/fserror.h>
> @@ -1242,6 +1243,17 @@ xfs_fs_nr_cached_objects(
>  	/* Paranoia: catch incorrect calls during mount setup or teardown */
>  	if (WARN_ON_ONCE(!sb->s_fs_info))
>  		return 0;
> +
> +	/*
> +	 * The reclaimable inode count is filesystem-global and does not honour
> +	 * sc->memcg, so it is only meaningful on the global (kswapd or root
> +	 * direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work and
> +	 * pinning the shrinker bit in every memcg's bitmap.
> +	 */
> +	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
> +		return 0;
> +
>  	return xfs_reclaim_inodes_count(XFS_M(sb));
>  }
>  
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5789a0f5a346..3ba812e4f5ba 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -846,6 +846,17 @@ static long shmem_unused_huge_count(struct super_block *sb,
>  		struct shrink_control *sc)
>  {
>  	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
> +
> +	/*
> +	 * The per-superblock shrinklist is filesystem-global and does not
> +	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> +	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work and
> +	 * pinning the shrinker bit in every memcg's bitmap.
> +	 */
> +	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
> +		return 0;
> +
>  	return READ_ONCE(sbinfo->shrinklist_len);
>  }
>  #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
