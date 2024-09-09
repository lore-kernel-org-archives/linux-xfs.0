Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B9D17837E;
	Mon,  9 Sep 2024 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725889343; cv=none; b=LJzUXppTgxLuepXV30jXzdPAqVIyR2o8u13pXXwk14AfaumeRQQb3FFPtRd0JxD9ZGvrwXAmPjiRwnK7tdxPPuMwQSmr1Iu8LBR2AFMF1olbP4zwdF5JdwfHiq6soIKEa6T3ShT/c86dGCNvW1sMOXIRVDXb/n9aCAZ3wefBZ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725889343; c=relaxed/simple;
	bh=1xOQ+SrUyK1XctD6tG1Lz8cGa91L0c4m645b5dMTXcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0TbWp5q+XXDfdfDBNqLeK0N7Kgr9qGD2VybuhdcxSQt/abnGMHHbqENgN7FLiSY6XXkhOw76utsA/gPdywqsDvBjN+oVN0SIiobb1FYD7ReZUkppgtb8qusA/d8frdCLjdyOriRuPHIqTZYGoLLSRh1yMt4LhW1FPuzzel/gnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dkujTfpo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u0gIcJB5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dkujTfpo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u0gIcJB5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dkujTfpo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u0gIcJB5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dkujTfpo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u0gIcJB5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6FF5121B5A;
	Mon,  9 Sep 2024 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725889339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsdQsd1qQw3vTcAFj0pdzRvqKHcUPey10FOvWU27loc=;
	b=dkujTfpo04Bex7Ahl4pxwkc81LBXxUDkFzB2qWVuQnQCT/MltKoJqZf/6VWd4HglbxGwZi
	rjW7S38C+lNL/ECnysl/UKEbwLUdX/wAa5CldVqYhityZHC7QlStSQxyvhd/Onm7k8JZc6
	1kR4VeSN9N7shW7pt6kQLW6iOXn4R/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725889339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsdQsd1qQw3vTcAFj0pdzRvqKHcUPey10FOvWU27loc=;
	b=u0gIcJB5ML6uXrFpfUtVgpiHFu+NVkUCSJ201ZT+qyjoK0UhoiNrlCIuh+CmsNDQtHrVX/
	iOMaN5N3j429SzBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725889339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsdQsd1qQw3vTcAFj0pdzRvqKHcUPey10FOvWU27loc=;
	b=dkujTfpo04Bex7Ahl4pxwkc81LBXxUDkFzB2qWVuQnQCT/MltKoJqZf/6VWd4HglbxGwZi
	rjW7S38C+lNL/ECnysl/UKEbwLUdX/wAa5CldVqYhityZHC7QlStSQxyvhd/Onm7k8JZc6
	1kR4VeSN9N7shW7pt6kQLW6iOXn4R/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725889339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsdQsd1qQw3vTcAFj0pdzRvqKHcUPey10FOvWU27loc=;
	b=u0gIcJB5ML6uXrFpfUtVgpiHFu+NVkUCSJ201ZT+qyjoK0UhoiNrlCIuh+CmsNDQtHrVX/
	iOMaN5N3j429SzBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5852213312;
	Mon,  9 Sep 2024 13:42:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xB2OFTv73mZ2ZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Sep 2024 13:42:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 117DAA095F; Mon,  9 Sep 2024 15:42:19 +0200 (CEST)
Date: Mon, 9 Sep 2024 15:42:19 +0200
From: Jan Kara <jack@suse.cz>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: add CONFIG_MMU dependency
Message-ID: <20240909134219.xkz37p5biid22u6k@quack3>
References: <20240909111922.249159-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909111922.249159-1-arnd@kernel.org>
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[oracle.com,arndb.de,kernel.org,linux-foundation.org,suse.com,gmail.com,google.com,toxicpanda.com,suse.cz,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon 09-09-24 11:19:00, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> XFS no longer builds on kernels with MMU disabled:
> 
> arm-linux-gnueabi-ld: fs/xfs/xfs_file.o: in function `xfs_write_fault.constprop.0':
> xfs_file.c:(.text.xfs_write_fault.constprop.0+0xc): undefined reference to `filemap_fsnotify_fault'
> 
> It's rather unlikely that anyone is using this combination,
> so just add a Kconfig dependency.
> 
> Fixes: 436df5326f57 ("xfs: add pre-content fsnotify hook for write faults")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks! I've noticed the error from 0-day over the weekend as well. At this
point I'd rather handle this in a similar way as e.g. filemap_fault() is
handled in NOMMU case. I agree users of XFS (or bcachefs for that matter)
with !CONFIG_MMU are unlikely but fsnotify_filemap_fault() can grow more
users over time and providing the stub is easy enough. I'll push out fixed
version of the patch.

								Honza

> ---
>  fs/xfs/Kconfig    | 1 +
>  lib/Kconfig.debug | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index fffd6fffdce0..1834932a512d 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -2,6 +2,7 @@
>  config XFS_FS
>  	tristate "XFS filesystem support"
>  	depends on BLOCK
> +	depends on MMU
>  	select EXPORTFS
>  	select LIBCRC32C
>  	select FS_IOMAP
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 7c0546480078..8906e2cd1ed5 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2862,6 +2862,7 @@ config TEST_KMOD
>  	depends on NETDEVICES && NET_CORE && INET # for TUN
>  	depends on BLOCK
>  	depends on PAGE_SIZE_LESS_THAN_256KB # for BTRFS
> +	depends on MMU # for XFS_FS
>  	select TEST_LKM
>  	select XFS_FS
>  	select TUN
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
