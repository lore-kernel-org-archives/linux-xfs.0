Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A46E30D409
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782832319; cv=none; b=WLAce7LKiQcS40x+xdLHavbRTKiqNR4NYuRl12nxOTW+ByzGPKfiyYtYKZQygJUBQD4nGYv4QNAsCJDyIaQp6aE+GFztE+SviFTeFkYC3idi4q5Btt1JIGlkTfbvhekpQc1Ff0xWQ7PnH/B7ieZTld4puBGjvXZqV5HxSxT2Dy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782832319; c=relaxed/simple;
	bh=Xl97sexu2b7afrKiBr4H5EC86HAhV+tqsfxcszsAL4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/KXzdbt7CLFsFM1SvvFbCjhbEcXITYal/bYI57a6AoZzQSX4Z2ThYjQmCPRFkrAEeyrVyS5bUUQdYRudq/Tup9cG9LwODeGlf6vUxkgzVh76RhGMRHe8Obgje6mah/LfWetGDnBe86oaty1YpOiFDiG8Zh4+6anvS149ROaUO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=20oow+QW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cKynzAzr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qZOdn/l0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0thdJM3a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="20oow+QW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cKynzAzr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qZOdn/l0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0thdJM3a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF9DF75F51;
	Tue, 30 Jun 2026 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782832316;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EI/OgqgRY/EKWgoKaSeyLXyRRrr2pSBHkCzWMKZMlWQ=;
	b=20oow+QWdA1/GK5mHHJMnVGKwKmHKxWAJIiuP1EUt4GF92Q4ENflMytNjqetcszR0psnJf
	PswxZw3L2WVs3R/lix1mjPoUaOGOcIolM66dg/okLzImtbC30TyugD4N2piP9sjve34P/t
	vVQN/WQ/U2CAbzbwEcqZAoYs6EA0OQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782832316;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EI/OgqgRY/EKWgoKaSeyLXyRRrr2pSBHkCzWMKZMlWQ=;
	b=cKynzAzrrQlizVCA/c0kXgAooKxYxS7VxXSAhpU/FvhqETR4fi2SfCLGIRrWXvOdTeBb2C
	Jl52W+STX+zSPTDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782832314;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EI/OgqgRY/EKWgoKaSeyLXyRRrr2pSBHkCzWMKZMlWQ=;
	b=qZOdn/l0XraOti9Rej/qYiN/hKelGIZwgu7ZchTge+SQ8TBfjxwbDXMuwvTt3Za8FbECBf
	Tb39ONSWP7ZdjFTqpAd4qaRp0VEmXpJigm/K0e9YYjZd5MYkA1qAtqJRu0hrR7Zz2OKcOD
	OuIrB1mgpJXW71cTT9oyddeYMI66VIc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782832314;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EI/OgqgRY/EKWgoKaSeyLXyRRrr2pSBHkCzWMKZMlWQ=;
	b=0thdJM3at96HD8gKIXDgWvOsR8sxi6Tkhga6F2h0sNuOSfMteeInJHxfQNJagw2rrJUhj0
	9EjZ7nWLpeguSZCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C22DC779A8;
	Tue, 30 Jun 2026 15:11:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gr85L7rcQ2pGKwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 15:11:54 +0000
Date: Tue, 30 Jun 2026 17:11:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 3/3] btrfs: use IOMAP_DIO_BOUNCE flag instead of
 falling back to buffered IO
Message-ID: <20260630151145.GA2907432@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1781597506.git.wqu@suse.com>
 <1a89047dac91b6b12d190c37cd7bb3d8328b2073.1781597506.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a89047dac91b6b12d190c37cd7bb3d8328b2073.1781597506.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,suse.com:email,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Tue, Jun 16, 2026 at 05:42:37PM +0930, Qu Wenruo wrote:
> Previously btrfs forces direct writes to fall back to buffered ones if the
> inode has data checksum or the profile has duplication.
> 
> That fallback is to avoid the content being modified that the final
> content may mismatch with the checksum or the other mirrors.
> 
> That brings a pretty huge performance cost, which already caused some
> concern at that time.
> 
> But later upstream commit c9d114846b38 ("iomap: add a flag to bounce
> buffer direct I/O") introduced a new method by copying the content into
> new pages, and do all the operations based on the newly allocated pages.
> 
> So let btrfs to utilize the new flag for direct writes if we require
> stable folios.
> 
> There is a quick benchmark, using the following fio setup:
> 
>  fio --name=randwrite --filename $mnt/foobar --ioengine=libaio --size=4G \
>      --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
>      --bs=$blocksize
> 
> Unit is MiB/s.
> 
>  Blocksize | Zero-copy (*) | Buffered |   Bounce
> -----------+---------------+----------+-----------
>         4K |          35.1 |     17.1 |      33.8
>        64K |           522 |      251 |       492
> 
> *: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
>    fallback to buffered write if the inode requires checksum")
> 
> Although with page bouncing the performance is only around 95% of
> true-zero copy, it's still almost double the performance of buffered
> fallback.
> 
> There will be a small change in behavior, since we're using
> IOMAP_DIO_BOUNCE flag to allocate new folios, NOWAIT flag will
> immediately fail.
> 
> So for true NOWAIT direct IOs, NODATASUM and RAID0/SINGLE profiles are
> still required.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

The block layer patches have been merged and our for-next is now based
on 7.2-rc1 so pleaase add this one too so we can get back the dio
performance. Thanks.
