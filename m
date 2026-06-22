Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1D03B52E1
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 13:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782136222; cv=none; b=OjzxF8xYiEXGbVJL3LFNVwqmv01fsTtX9dhp0BDZ5SMznSWuC8hkOzMduYbIP3ai9oaPnnJfNlzSD6kM+aS+WwNpGTF5aj1GwaxxIUT/h1xO+r+hpg9pauqQevqIwtlLton6e3LC+4iB/rK+p/zjTMoMr56Qcczb0qbDFAoZ3TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782136222; c=relaxed/simple;
	bh=VHT+KBluJOqcRwZEsm+PBsoDoLyAdXax3lQE4PhsvfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIx2bYh9WvgL8yPqUQuL/jtzH8aAqEfWxZeIs4E3KLj7Fll/QO9vFpMOTfYimKZFvFDkpW9BTBH0RLYuN3/pjLETg7idD+qTMCz9WI6Rx1v4dIZurTz+sZEZ2oXnfWZc5Do3NgTj/kMmLmLn0t1p4utU0AlDwbhhbP5/9gvzYac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sCPFn2d7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6sw3sDYH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sCPFn2d7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6sw3sDYH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sCPFn2d7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6sw3sDYH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sCPFn2d7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6sw3sDYH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 96F58704BB;
	Mon, 22 Jun 2026 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782136218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pwdldaccHLqFQeaduzHyGoRmVSJHAn2p6cOpABQhxBg=;
	b=sCPFn2d70ytK8uM+7am/4lVCEEva5/832BbzPLucrCQbcZbl9sCqMV5LCloY/u+fwJUWdP
	LAca2z1K/BesNFEHPBLcxVk1BWThf0t9EVogsScb4UGmjjsBPT1H4l6dI5j/Khk2v9XFSv
	yz/liunQfedntcKIGiSIR7RX5WsIiTo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782136218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pwdldaccHLqFQeaduzHyGoRmVSJHAn2p6cOpABQhxBg=;
	b=6sw3sDYHD0rKJ4cuy1fcFkpAZVhKTEnqqZgTXwYApQ5e9qJFAvoXjArJ3IjEF51c053v4h
	Tm81i5hE95XEHDCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sCPFn2d7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6sw3sDYH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782136218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pwdldaccHLqFQeaduzHyGoRmVSJHAn2p6cOpABQhxBg=;
	b=sCPFn2d70ytK8uM+7am/4lVCEEva5/832BbzPLucrCQbcZbl9sCqMV5LCloY/u+fwJUWdP
	LAca2z1K/BesNFEHPBLcxVk1BWThf0t9EVogsScb4UGmjjsBPT1H4l6dI5j/Khk2v9XFSv
	yz/liunQfedntcKIGiSIR7RX5WsIiTo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782136218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pwdldaccHLqFQeaduzHyGoRmVSJHAn2p6cOpABQhxBg=;
	b=6sw3sDYHD0rKJ4cuy1fcFkpAZVhKTEnqqZgTXwYApQ5e9qJFAvoXjArJ3IjEF51c053v4h
	Tm81i5hE95XEHDCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D44F779A8;
	Mon, 22 Jun 2026 13:50:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zTB6Ipo9OWpjOgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 13:50:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 48C4CA093E; Mon, 22 Jun 2026 15:50:10 +0200 (CEST)
Date: Mon, 22 Jun 2026 15:50:10 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 03/18] super: take lock after last reference count
Message-ID: <p22dytpj26jz72sqohiqrhkacrc4r5wt7soanows744el5jzqb@3236bcjzmilk>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-3-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-3-7df6b864028e@kernel.org>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 96F58704BB
X-Spam-Score: -4.01

On Tue 16-06-26 16:08:19, Christian Brauner wrote:
> __put_super() required the caller to hold sb_lock, so put_super()
> wrapped it. The per-device superblock table introduced later drops its
> passive references from contexts that do not hold sb_lock, so make
> put_super() self-locking: drop the count first and take sb_lock only for
> the final list_del.
> 
> With the count now dropped outside sb_lock a superblock can briefly sit
> on @super_blocks with s_passive == 0 before it is unlinked, so the list
> walkers (__iterate_supers(), iterate_supers_type(), user_get_super())
> switch to refcount_inc_not_zero() and skip it.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good, just one style nit below. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> -static void __put_super(struct super_block *s)
> +void put_super(struct super_block *s)
>  {
>  	if (refcount_dec_and_test(&s->s_passive)) {
> +

I'd delete this empty line.

> +		spin_lock(&sb_lock);
>  		list_del_init(&s->s_list);
> +		spin_unlock(&sb_lock);
> +


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
