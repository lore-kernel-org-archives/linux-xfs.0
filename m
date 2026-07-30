Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149C63ED13F
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 09:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785402189; cv=none; b=uKykGsJx6Qq5VmnfzUZjvlm56zhmWe7zUztsaiyFJL3nnUnVzJtr7Qf6dylZKKhawZ2YvPdMi29t0cMmEDV+YnnyQhmq9rdT5EyEBoaC8vLLsdx1mqiO2oQTt4G5gYuU+CBeEfuSRl+uR94MRGhHoynKNSKAmKbND9mwjsc+/+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785402189; c=relaxed/simple;
	bh=mhlJVzmtd9DjQwfuD/65q7Hpdk/4Pf+0XyhCE1RUCb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pq6Ltl4TiCSWZzJ/4YJN6LcCimtDcpBQFCa1mU8eK3lR4BNqzJyhWhk/KWIUQv+m5KmcUs62s2TMoY262IX9G6V7djODjAUY7szfThhgEZRhZWS+nTnYEP2TTMHRN7ub1wesjleNPcZDA+TbecM+4r7d+x4m9AW7z7BAcpMqU7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0cUIwe9Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mWva2A6K; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=maifyACd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gDc1BEZz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0cUIwe9Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mWva2A6K";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="maifyACd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gDc1BEZz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AF3897D4B7;
	Thu, 30 Jul 2026 09:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785402181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=0cUIwe9Ywz6ANAz5DcQmwuwm3N/lnDg11kIQFZTq9WiaBTTkmIGW7MIv9ohor8Jw3CXiDj
	chQOCdHSNUaNW8YdZSIWGUrdxsZWocDtRQA1UQ9/vfd4uFMRdtiGqpKMHYSFUcWWYQxBnE
	zgg0tbWDfuD6T5NsrNo2ZfUqR7idszY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785402181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=mWva2A6K46mRjcGrjCcIU6z6ngn0i47JX2KuHiRKNdPYG1qdewJRuOHNuTUILQPDUZhHiN
	CXtzCanVf+tlmaBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785402177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=maifyACdq8mMa8+y4Wq5AXK7l4BKn2Sg1/SGME6NZ+ohi26yk6cGO58fiDoFPsu6OYlg12
	btSuM7+HRyYchkuY85FJ4KQw2s/tO+5Lf6RX7n1/qDF7lp5zctTlsb+y2IRokjiRuEXGL/
	t0h7rCE3VJeRmr2F20ECKslkkBcOr+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785402177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=gDc1BEZzFv6Juckc+df3mLmF5Bi0EdNnCFS10baD/7YUIXPo3aeDT1oqiebPSv1TZQDEnH
	v3kAHSzxRmA8xIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3B18779CC;
	Thu, 30 Jul 2026 09:02:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CDyJ0ETa2obWwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Jul 2026 09:02:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 42EE7A0AAA; Thu, 30 Jul 2026 11:02:57 +0200 (CEST)
Date: Thu, 30 Jul 2026 11:02:57 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v7 1/5] block: introduce bio_in_atomic()
Message-ID: <memvwweih7kaket63x6tee7a4z6nefgkelv4xznpxrqysjob2c@t5rfbf53s2og>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,sina.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,kernel.org,zeniv.linux.org.uk,suse.cz,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,acm.org,sina.com,linutronix.de,vger.kernel.org,kvack.org,lists.ozlabs.org];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,infradead.org:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Thu 30-07-26 02:57:51, Tal Zussman wrote:
> Move the atomic context detection logic from erofs's z_erofs_in_atomic()
> into the block layer as bio_in_atomic(). This helper returns true when
> the current context is unsafe for sleeping bio completion handlers (e.g.,
> hard/soft IRQ, preempt-disabled).
> 
> The logic was originally added to erofs in commit c99fab6e80b7 ("erofs:
> fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC"). A
> subsequent patch will use it in the block layer's bio completion
> infrastructure, so move it to include/linux/bio.h where both subsystems
> can share it.
> 
> Convert erofs to call the new bio_in_atomic() directly.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/erofs/zdata.c    | 11 +----------
>  include/linux/bio.h | 15 +++++++++++++++
>  2 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 74520e910259..f796bb3ef53b 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -1427,15 +1427,6 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
>  }
>  #endif
>  
> -/* Use (kthread_)work in atomic contexts to minimize scheduling overhead */
> -static inline bool z_erofs_in_atomic(void)
> -{
> -	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> -		return true;
> -	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> -		return true;
> -	return !preemptible();
> -}
>  
>  static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
>  				       int bios)
> @@ -1452,7 +1443,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
>  
>  	if (atomic_add_return(bios, &io->pending_bios))
>  		return;
> -	if (z_erofs_in_atomic()) {
> +	if (bio_in_atomic()) {
>  		/* See `sync_decompress` in sysfs-fs-erofs for more details */
>  		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
>  			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 8f33f717b14f..62a983758e09 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -368,6 +368,21 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
>  
>  void submit_bio(struct bio *bio);
>  
> +/**
> + * bio_in_atomic - check if the current context is unsafe for bio completion
> + *
> + * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
> + * %false when a bio can be safely completed in the current context.
> + */
> +static inline bool bio_in_atomic(void)
> +{
> +	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +		return true;
> +	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +		return true;
> +	return !preemptible();
> +}
> +
>  extern void bio_endio(struct bio *);
>  
>  /**
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
