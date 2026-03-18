Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547D52DF155
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 17:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855294; cv=none; b=jxj7YKbIHXL7GUh4BtKpu+5VUlyvKaHt30sXe3lJl+q5NGxh+KR3grbuW6jwvSzXJr5XLeL7U3Q2MHhb03Jlc35WY84AIKrweLqeWFLDrmr+F4fJBhpd56Z7GxTo/mVkzIIwD990Dyutf18XyoWnZQ/5gw9JYVlgzebHYZXxE2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855294; c=relaxed/simple;
	bh=Q1woKT0TbNUKKrCcewkkizNK4GuccXpVqkhd3fCobcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMUv89lpZ8qgLdUk9Low/Xf29p0iwJPc1HZpc4c5v1Ie2uis3k0GV3/mV5CyY2Q24yx+In5OegzlBhThTs+saOJE7HxkpOfM+Cy+YiwyFqa/szUous9DD6qcq1RzmGOGtNics8qlbyOF1I2J/OK/lakADwpTfivoynOr9UUN+vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OdHUqHeY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hcHEnmfM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OdHUqHeY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hcHEnmfM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OdHUqHeY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hcHEnmfM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OdHUqHeY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hcHEnmfM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7BC2C4D3C1;
	Wed, 18 Mar 2026 17:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773855291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/12NHQ8nrEt/XtZvZ5WsOUauKqjUwGo+xTkJicOm+0=;
	b=OdHUqHeY6sOjzaByWBpY3dMYxQGjrQDaL+uws7Z88HgdeIfWSEifl4Tvh3o4fmBnbLPmrS
	R/A7M3nnncP/23dC0NCXw1VqpeueLLXdEri3iEZKJiMDgPLldkTQ4g+23HgiHnGaVc7csq
	wpZRjUW87QOUkeme3TbNLrWoB8ljKL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773855291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/12NHQ8nrEt/XtZvZ5WsOUauKqjUwGo+xTkJicOm+0=;
	b=hcHEnmfM+PlOQtZiBxozn0j83jqAU2UFBvHlO8GTXJwMsaomTi7GBAg1eTEHKS1itI0pV0
	602T0SeyTsY2FWCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OdHUqHeY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hcHEnmfM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773855291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/12NHQ8nrEt/XtZvZ5WsOUauKqjUwGo+xTkJicOm+0=;
	b=OdHUqHeY6sOjzaByWBpY3dMYxQGjrQDaL+uws7Z88HgdeIfWSEifl4Tvh3o4fmBnbLPmrS
	R/A7M3nnncP/23dC0NCXw1VqpeueLLXdEri3iEZKJiMDgPLldkTQ4g+23HgiHnGaVc7csq
	wpZRjUW87QOUkeme3TbNLrWoB8ljKL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773855291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/12NHQ8nrEt/XtZvZ5WsOUauKqjUwGo+xTkJicOm+0=;
	b=hcHEnmfM+PlOQtZiBxozn0j83jqAU2UFBvHlO8GTXJwMsaomTi7GBAg1eTEHKS1itI0pV0
	602T0SeyTsY2FWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7044C4273B;
	Wed, 18 Mar 2026 17:34:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VdxeGzviummKKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 17:34:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1E6F1A0AFF; Wed, 18 Mar 2026 18:34:51 +0100 (CET)
Date: Wed, 18 Mar 2026 18:34:51 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs: clear I_DIRTY_TIME in sync_lazytime
Message-ID: <my7zbzcijl7w3waamiow6qsfjjoo6gpxx4izvpyhfjxhvp5vnu@ahonzibzgjpa>
References: <20260317134409.1691317-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317134409.1691317-1-hch@lst.de>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7BC2C4D3C1

On Tue 17-03-26 14:44:04, Christoph Hellwig wrote:
> For file systems implementing ->sync_lazytime, I_DIRTY_TIME fails to get
> cleared in sync_lazytime, and might cause additional calls to
> sync_lazytime during inode deactivation.  Use the same pattern as in
> __mark_inode_dirty to clear the flag under the inode lock.
> 
> Fixes: 5cf06ea56ee6 ("fs: add a ->sync_lazytime method")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 7c75ed7e8979..d8dac1931595 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1711,6 +1711,19 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
>  	}
>  }
>  
> +static bool __sync_lazytime(struct inode *inode)
> +{
> +	spin_lock(&inode->i_lock);
> +	if (!(inode_state_read(inode) & I_DIRTY_TIME)) {
> +		spin_unlock(&inode->i_lock);
> +		return false;
> +	}
> +	inode_state_clear(inode, I_DIRTY_TIME);
> +	spin_unlock(&inode->i_lock);
> +	inode->i_op->sync_lazytime(inode);
> +	return true;
> +}
> +
>  bool sync_lazytime(struct inode *inode)
>  {
>  	if (!(inode_state_read_once(inode) & I_DIRTY_TIME))
> @@ -1718,9 +1731,8 @@ bool sync_lazytime(struct inode *inode)
>  
>  	trace_writeback_lazytime(inode);
>  	if (inode->i_op->sync_lazytime)
> -		inode->i_op->sync_lazytime(inode);
> -	else
> -		mark_inode_dirty_sync(inode);
> +		return __sync_lazytime(inode);
> +	mark_inode_dirty_sync(inode);
>  	return true;
>  }
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
