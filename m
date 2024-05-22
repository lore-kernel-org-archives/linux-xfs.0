Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9951177117
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 10:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716372012; cv=none; b=gMbeP1zY7cLdatSKejUIa9PJ84D3J6N9ImtGNAqtQCCSefLWsjCFvhDclpgauVGfDPXopcgMdJ+vTex0aGQs6gtHMxnMW/I6LloAdMMBSQsycHyjdEmS1aKNt1GcDPRWpZZmzxpd2F6P/iUkDB4Qu36f2xX6QuVbh7R6uDrRU/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716372012; c=relaxed/simple;
	bh=pqK/vq/5jkJy4HG1OMHAYhgdYfEdZpq3fUY9ypkr6qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNeiwej9tZEjQ3rf/TYabwO10dXZWfu0WsOQIGX8dUnlBYb61bbuW2Z/MXGtc1oeQih8KW/hhavByo//Yq6p6ZnMoFRD3IlKtXx6GZNyszJ4SWKQWWrTwsDyQBuk6bk2MAeupfxfVdnXiZViLmn/gypg4bNlo6UHj6TXWQDcle8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FO6fTS/M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CxeJxE9B; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FO6fTS/M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CxeJxE9B; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FO6fTS/M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CxeJxE9B";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FO6fTS/M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CxeJxE9B"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 968F534C70;
	Wed, 22 May 2024 10:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1716372007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9/ETceqGTYVoiPjk4K7THgyHBrzOk+V+gE0Q13umQU0=;
	b=FO6fTS/Md7EG4G9mD2jOgb0ZKngdAm0C3f9A7XZupymcMpPneE4QtfrUFa9la+Ygt7zlxM
	lqqc3WkJXjf/2OlwV/bcKb5uJtNq8nyqtotSbmU8xfFHLLmzFgxtr+aXr85KeGjMX4LICA
	37mgKWajnaXdo01oTgu1+sixKjjA3ZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1716372007;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9/ETceqGTYVoiPjk4K7THgyHBrzOk+V+gE0Q13umQU0=;
	b=CxeJxE9BbTKOFaJjEcd8Z7UfaaSkgkKmEwfRp2DgGchtGu4HzpKuqh6jDmqPofe1SQ4bhC
	HYViKq20uiqrGnDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FO6fTS/M";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CxeJxE9B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1716372007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9/ETceqGTYVoiPjk4K7THgyHBrzOk+V+gE0Q13umQU0=;
	b=FO6fTS/Md7EG4G9mD2jOgb0ZKngdAm0C3f9A7XZupymcMpPneE4QtfrUFa9la+Ygt7zlxM
	lqqc3WkJXjf/2OlwV/bcKb5uJtNq8nyqtotSbmU8xfFHLLmzFgxtr+aXr85KeGjMX4LICA
	37mgKWajnaXdo01oTgu1+sixKjjA3ZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1716372007;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9/ETceqGTYVoiPjk4K7THgyHBrzOk+V+gE0Q13umQU0=;
	b=CxeJxE9BbTKOFaJjEcd8Z7UfaaSkgkKmEwfRp2DgGchtGu4HzpKuqh6jDmqPofe1SQ4bhC
	HYViKq20uiqrGnDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8171313A6B;
	Wed, 22 May 2024 10:00:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dyaVHyfCTWaiFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 22 May 2024 10:00:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3508AA0861; Wed, 22 May 2024 12:00:07 +0200 (CEST)
Date: Wed, 22 May 2024 12:00:07 +0200
From: Jan Kara <jack@suse.cz>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and
 FS_IOC_FSGETXATTRAT
Message-ID: <20240522100007.zqpa5fxsele5m7wo@quack3>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520164624.665269-4-aalbersh@redhat.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 968F534C70
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.01

Hello!

On Mon 20-05-24 18:46:21, Andrey Albershteyn wrote:
> XFS has project quotas which could be attached to a directory. All
> new inodes in these directories inherit project ID set on parent
> directory.
> 
> The project is created from userspace by opening and calling
> FS_IOC_FSSETXATTR on each inode. This is not possible for special
> files such as FIFO, SOCK, BLK etc. as opening them returns a special
> inode from VFS. Therefore, some inodes are left with empty project
> ID. Those inodes then are not shown in the quota accounting but
> still exist in the directory.
> 
> This patch adds two new ioctls which allows userspace, such as
> xfs_quota, to set project ID on special files by using parent
> directory to open FS inode. This will let xfs_quota set ID on all
> inodes and also reset it when project is removed. Also, as
> vfs_fileattr_set() is now will called on special files too, let's
> forbid any other attributes except projid and nextents (symlink can
> have one).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

I'd like to understand one thing. Is it practically useful to set project
IDs for special inodes? There is no significant disk space usage associated
with them so wrt quotas we are speaking only about the inode itself. So is
the concern that user could escape inode project quota accounting and
perform some DoS? Or why do we bother with two new somewhat hairy ioctls
for something that seems as a small corner case to me?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
