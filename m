Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417A13CB2D4
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 09:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403917; cv=none; b=a/vCqg2kpTFm42lmQe8n4ZBrcUnesmppKq5H+Ky/xx7DCtfeU+yKXjKilidNsXNmGdMzUVPzd94bBAxnBse0fowzhu4ZvztyOE/AnRYpNaZt/421atmDh3I7KTsezsYPRIYmM551mPrNXrzjiDzrrI7+oWnUrg5Hyt/fvtDe2N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403917; c=relaxed/simple;
	bh=BEbiGQ+Nh99ZFSOia4MAKon5/RgrKrsnVrr/HCzjb9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cx1AXOTLfbYPgMRphaCEjZL16wirPdoryds7fxnV7xUuwuANOIDMk9Yc52quRJi9vaaIh72rlMXtz1B0TQJdZHggJHRrrVjjIelAst2FWFr2fZ6e0HSECCmWcxSticf2912fipya5ffo6KNcPEy7hobcDjxWOy0SGf/fcsVBWRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Tqarncfb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9kUfo/2L; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X5/Su/p2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rU9fRx/k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Tqarncfb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9kUfo/2L";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X5/Su/p2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rU9fRx/k"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 061617D4D4;
	Thu, 30 Jul 2026 09:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785403909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=TqarncfbgPxXXWBlixuAFNLDHy/2Tq9XaSSU74CxQPidY9A1MMnADQBQFYtDqlBqpiQV3w
	/7yc5/wh+3hu/qhjEqTyN539W3um1k1rzBEac6qfG5nkFO/r6+BrHdRZ4ibevWNhJHuIEz
	lDImgUWm7SZdXyj+cH08TGK5wsZ56kw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785403909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=9kUfo/2LzDHmEMVFfuthPN7OaCbT4qxiNH6ZAheRXnT7Zyjqk4vIXLFNZRWIIg9VghpNgt
	/jiWQLSq9nmcIvAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785403905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=X5/Su/p2jFL+Luy94478xOaWkPh2/4b3Y2ht638r051OM3+wojyx1YWlELDFHSuT1Gp/2y
	dywTkzFi9npuXU9JRleSE/DoUwztm4MtnYGjaOPna9yUlAHnF08B7iWbpFlci1rmNYg6Fm
	JQGyGsmIZok3Xjra7WXFbLNauNGPOzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785403905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OtkjGI26kFz4A5WqZfCAE61davztwoMy3wTqCe/jrpc=;
	b=rU9fRx/ka+uy5uYh7zAjOzmzMobNvPEEw5TC9LzEtV3DKibEiiu3myFi65E4YFq4bozBs3
	jgftj8ZqjUfHcVAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF3AA779CC;
	Thu, 30 Jul 2026 09:31:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2mhiOgAaa2rndwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Jul 2026 09:31:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9C819A0AAA; Thu, 30 Jul 2026 11:31:44 +0200 (CEST)
Date: Thu, 30 Jul 2026 11:31:44 +0200
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
Subject: Re: [PATCH v7 4/5] buffer: set BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <p2a3kz5oyjzsrbjivphnxv3dcf3gkjgtibd36fgfajajrfn4jr@m43y3mfpv4kb>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-4-3e8e6850068d@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-4-3e8e6850068d@columbia.edu>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,sina.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,kernel.org,zeniv.linux.org.uk,suse.cz,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,acm.org,sina.com,linutronix.de,vger.kernel.org,kvack.org,lists.ozlabs.org,lst.de];
	R_RATELIMIT(0.00)[to_ip_from(RL3fjri4hbejo913g8y39c7scs)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,columbia.edu:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Thu 30-07-26 02:57:54, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK in __bh_submit() for write bios when the folio
> has dropbehind set, so that buffer_head writeback completions get
> deferred to task context where folio_end_dropbehind() can safely
> invalidate folios.
> 
> Read completions are not deferred since dropbehind invalidation for
> reads is handled synchronously by the reader.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 9af5f061a1f8..6f099847240e 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1203,6 +1203,9 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> +	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> +
>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
>  		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
>  
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
