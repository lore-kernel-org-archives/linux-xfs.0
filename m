Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BC83E49C6
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 09:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785404044; cv=none; b=uLuasZIgjRSSSHGebmDc9wiiX1/lgottn0uAEfCeBkGlGhq8cMjSYuK/gqPeOPGkwf/pCsnPZKLSBXqfYEbpHRS8Kmo95+6t2SY1OO6cy+PkO1+86fFhxF1vl+CXFTqMYM8jtP5dHB0ePi0RIDerN5zS2A93Mwi9OJ2hPe3kbDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785404044; c=relaxed/simple;
	bh=r9nrL8UYXfs+QtbUue/YnOSzs8Tk5DP8lBP8JYaAer4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pU15TsnJXW/LxKOZZU6neB0JkOKp54X+ngqpmcQCSB+QrKcLxbmN6oVxK0KggCyi58hixZNEDb1Hr9/enKk2ARs+RSsRltvPkpnxc721/F60EcjuNADgEvzVwA2sW8lgvBud1pm79DjDzU61RnD/0VXsUY9JFlJP8SY/RAo+Wcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qu9IBaes; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OVpjfGtI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Wk8gDWRi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JSK5C5rL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qu9IBaes";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OVpjfGtI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Wk8gDWRi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JSK5C5rL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C1BA3EF6;
	Thu, 30 Jul 2026 09:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785404036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=qu9IBaesPpr06f2cuqhgTKK9UNK91bLXIZjsthmp4zv5oVsq8RNqegWHGKn/emU0t0AfjM
	A2q2dAkWjUpTUd/6FdvD/9i/SnCpyP/z7xqeL5UXqbuRa0j6V94ofWPJu3bc5rmJjlUDD3
	h18OGxJk0MZpaUAkhyy8M0EatIs6t0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785404036;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=OVpjfGtILz3iZaDzGRsvNn41u3xsZALYlDTs+M2nGzQa77zhqDYjEqAWqfxiTQK/RT/L8N
	ccbVysQLd1LTCTAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wk8gDWRi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JSK5C5rL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785404032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=Wk8gDWRiAd83zVAa4qco61zp1av1ez7Tc8QcxmYtaKmmzAW4HdH9OlDBxHp31075uj2xH+
	DQX4dM6eMnXZCJ1C46WEA+neiKROCsg6yjwQvFn7c3F1e3LqdDVVFGxM9Z1jcyzR8uSN0U
	L9HoaioXVPo9UFNMx7pA3aEUiWWhIv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785404032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=JSK5C5rLS50CA5TXAYwb00lHJJaWYj5eQlYuB53VTYmrK/8H2COoLnQcAsTtj2B267b5fj
	KtPHYW6rQlWcRxBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 70E28779CC;
	Thu, 30 Jul 2026 09:33:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EomJG4Aaa2oGegAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Jul 2026 09:33:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 18A07A0AAA; Thu, 30 Jul 2026 11:33:52 +0200 (CEST)
Date: Thu, 30 Jul 2026 11:33:52 +0200
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
	linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 5/5] block: enable RWF_DONTCACHE for block devices
Message-ID: <enjg4xj3q5mpeegvzfemg3irkowvufw66h6yqo2vcpi434q3vk@cqlba4kwki6t>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7C1BA3EF6
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,sina.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[27];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,kernel.org,zeniv.linux.org.uk,suse.cz,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,acm.org,sina.com,linutronix.de,vger.kernel.org,kvack.org,lists.ozlabs.org,lst.de];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	R_RATELIMIT(0.00)[to_ip_from(RLgtcj9mh9ghuanj5qgfrqcyig)];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,columbia.edu:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,lst.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Thu 30-07-26 02:57:55, Tal Zussman wrote:
> Block device buffered reads and writes already pass through
> filemap_read() and iomap_file_buffered_write() respectively, both of
> which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
> by setting FOP_DONTCACHE in def_blk_fops.
> 
> For CONFIG_BUFFER_HEAD=y, writeback goes through buffer_head's
> __bh_submit() which sets BIO_COMPLETE_IN_TASK on dropbehind folios. For
> CONFIG_BUFFER_HEAD=n, writeback goes through iomap which handles it via
> BIO_COMPLETE_IN_TASK on the ioend bio.
> 
> This support is useful for databases that operate on raw block devices,
> among other userspace applications.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/fops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 15783a6180de..8b39c53b6393 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -941,7 +941,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
>  	.uring_cmd	= blkdev_uring_cmd,
> -	.fop_flags	= FOP_BUFFER_RASYNC,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
>  };
>  
>  static __init int blkdev_init(void)
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
