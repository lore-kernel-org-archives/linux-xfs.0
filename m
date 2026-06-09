Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BAA3DFC8F
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 12:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781009580; cv=none; b=KiOaZGE9+moEdDLRFM6e7oFWEjknBBallFdRMXCN4TjSOe+UxzWOLb5mXKbr5+L0fh1uWfn0RYD9Z4oJ93tyI7xd9Sl85BjCoL8JvUuD/qhVV6mgBDjWnexlf9DjUbQqRNUhtAQB1La6pDiv42qkpcjnTcmBeyyD+kO3qsdW7i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781009580; c=relaxed/simple;
	bh=X3FmxBPotfpP0P/Jqyuj35eEnfREEjf5+UxBE/R32iA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYnd8Lyl5Ad5h30KGgh2I7WGlOw1EoTyggflg+PgRNlkcMl0e3T00+bOHk7ogR/MDt4/Z1jJz4I7TSZy0LzLiot9Tr9ctXi2uoCZvlQpiKLQIu3v22pKkg3i6rryevloqu5yZwwKAOZN+VUJf5iMN5+QLgLHuiQ9tSKWvy5uBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D3sxU875; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Lydqrcde; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=E5p0l2vR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/qcl9yXQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D3sxU875";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Lydqrcde";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="E5p0l2vR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/qcl9yXQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F4387599F;
	Tue,  9 Jun 2026 12:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781009577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=D3sxU875kN70T0k1ZVYP9/E8y2C526A1rckA9z0cLAfzHFl1kIf+w82Oz/0wkqviJaBluv
	1liRSl1kEmUo1AgPYzvfXbNp3pYN6mA2lOG/qugCxyuDgLMKY9odM8ELxvwVSPpsiw7mqh
	nc/D+lzSLjAX/vZpkxoqK7h5fLCRAQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781009577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=LydqrcdeYiAka5kpfgjfXTGMot6slWhu4iN1WL/VymRlCSQNY2PQ7UfTg211b34ndFZL6Q
	zY4Dy4l8Fb4Lx0BQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E5p0l2vR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/qcl9yXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781009573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=E5p0l2vRyc4Aamw3PZVZDZMxitZ+J7/tHa+G1PsNtT4tWBTSHyIZCAYADXfyKQCnMwK03J
	h8XcA7s62eeQCNGURjfIwiravYlhf86bEQXB5WrkyUH4OwlVX4yVrEqx7FsIM4gRbNhcqK
	WnJE/cldEn/uoMKXeqGksCk3xFgWSEQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781009573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjVs4XMojEDCZDsneHUjmf+6PVevcMqyxX1dX7ene70=;
	b=/qcl9yXQ05C4n3FIWYXNaPy9IIWptYcXNBNYxuZveZpo7H0K5Tpb6S0sZjVPVtKsdgnSXH
	iHdeyBLUvHfYc1BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5FF84779A7;
	Tue,  9 Jun 2026 12:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DaBnF6UMKGoQcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 12:52:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 08919A0A90; Tue, 09 Jun 2026 14:52:53 +0200 (CEST)
Date: Tue, 9 Jun 2026 14:52:52 +0200
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in
 memcg slab shrink
Message-ID: <5exadtggg276xp5tayiqbbomnms4hjyaopmgu3chfpl2ug56dq@vyhswy2afzmo>
References: <20260609123047.1948242-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609123047.1948242-1-usama.arif@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6F4387599F
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue 09-06-26 05:30:47, Usama Arif wrote:
> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
> btrfs extent maps and xfs inode reclaim operate on filesystem-global
> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
> None of them filter by sc->memcg.
> 
> The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
> calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
> whose bit is set in the per-superblock shrinker bitmap, which on a busy
> host means hundreds of calls per reclaim pass. Each scan queues the same
> global shrinker work item that's already kicked from the root path.
> 
> Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
> the returned total stays positive even if a memcg's own dentry/inode LRUs
> are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
> in the memcg bitmap, so subsequent reclaim passes from the same memcg
> re-enter super_cache_count() and pay for the global counter walk again.
> 
> Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
> or root). The memcg-aware dentry/inode LRUs keep being counted and
> scanned per memcg as before; only the global fs-specific hooks are skipped.
> The root/global shrink path still drives those hooks; only their
> invocation from non-root memcg slab reclaim is removed.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

To me this makes sense. However I'm bit surprised that XFS inode shrinker
(which is what gets counted in nr_cached_objects for XFS) isn't memcg
aware. I guess since these inodes are on their way to a relatively quick
destruction, nobody really bothered. So I'm fine with the change, just
I'd like to make sure XFS folks are aware and don't plan anything in this
area.

								Honza

> ---
>  fs/super.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 378e81efe643..5216c5dbd4c4 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,6 +24,7 @@
>  #include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> +#include <linux/memcontrol.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
>  #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -169,6 +170,19 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>  	wake_up_var(&sb->s_flags);
>  }
>  
> +/*
> + * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
> + * operate on filesystem-global state and ignore sc->memcg. Driving them
> + * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
> + * per-cpu counters and queueing duplicate work: the actual reclaim happens on
> + * the global path (kswapd or root direct reclaim) regardless. Restrict them
> + * to that path.
> + */
> +static inline bool super_fs_objects_eligible(struct shrink_control *sc)
> +{
> +	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> +}
> +
>  /*
>   * One thing we have to be careful of with a per-sb shrinker is that we don't
>   * drop the last active reference to the superblock from within the shrinker.
> @@ -198,7 +212,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	if (!super_trylock_shared(sb))
>  		return SHRINK_STOP;
>  
> -	if (sb->s_op->nr_cached_objects)
> +	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
>  		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
> @@ -259,7 +273,8 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  		return 0;
>  	smp_rmb();
>  
> -	if (sb->s_op && sb->s_op->nr_cached_objects)
> +	if (sb->s_op && sb->s_op->nr_cached_objects &&
> +	    super_fs_objects_eligible(sc))
>  		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
