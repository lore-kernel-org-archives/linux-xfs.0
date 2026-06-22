Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB9935675C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 10:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782122729; cv=none; b=NRae/z24opHMQD+KQA1QZYpfuRzTVH25Ah8N1gNv87PQMGnVrBrLz53xjVH2a1qIinR4CAdRu2lxAPHsyiquD/aGBdEJABTyDS1SjhQzmxg8Pl/yeJ41RPiipeGcas7LoCYZeE9eBe3QJH84fXisnVlTtb7TZNinsD9PFB5AKR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782122729; c=relaxed/simple;
	bh=bhIjjc0KXaCEFtJjJPe6KgPqQqt/cpExHPp53//Rrq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNZMRCYSZMUprgxcFq9/6Ka+C8XdMj0jwq/MQR9t7nBD7YkXRe+RxxDNMTGXb+Gy0Q0ue6kZ24eefd9zCYSaVfLeiCJ9VyRs3dMDeIzPwGy/wU20UJwepVIHRlPXGgDJ1pKxlkXbNOIUUyuNclSNfx51LVT/qmVq8zdvdK4JM2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HUXRwWVr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bqvNixvS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HUXRwWVr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bqvNixvS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HUXRwWVr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bqvNixvS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HUXRwWVr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bqvNixvS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C47F76BB4D;
	Mon, 22 Jun 2026 10:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782122725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IxsoSdtRP+h8CXeuehRhJPfEFrSpuqSMj1ylTSUbGWY=;
	b=HUXRwWVrBE/NHJ0Zj3HmAK40TKqKr31BO9c8nxrjQ//2WVDwNJ6RgwAmy89fudaCGTSZoQ
	e9H9MVaW0KloR/Bx2EIKYMyg8n8MgEIpMmICRt6chCPunqGPOgPsYi4eHUVSeejcyDm/t4
	IbNcTGWnUiMZpBPFr9cs6ygzx1wkdv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782122725;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IxsoSdtRP+h8CXeuehRhJPfEFrSpuqSMj1ylTSUbGWY=;
	b=bqvNixvSAob+ANz6QMI3kywIp0s6YG3lFUDRKPtcPUwORvpUK6cfcPw8YdwqoWSTzIKd8H
	9mWLAtf/nqkQc1Cg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HUXRwWVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bqvNixvS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782122725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IxsoSdtRP+h8CXeuehRhJPfEFrSpuqSMj1ylTSUbGWY=;
	b=HUXRwWVrBE/NHJ0Zj3HmAK40TKqKr31BO9c8nxrjQ//2WVDwNJ6RgwAmy89fudaCGTSZoQ
	e9H9MVaW0KloR/Bx2EIKYMyg8n8MgEIpMmICRt6chCPunqGPOgPsYi4eHUVSeejcyDm/t4
	IbNcTGWnUiMZpBPFr9cs6ygzx1wkdv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782122725;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IxsoSdtRP+h8CXeuehRhJPfEFrSpuqSMj1ylTSUbGWY=;
	b=bqvNixvSAob+ANz6QMI3kywIp0s6YG3lFUDRKPtcPUwORvpUK6cfcPw8YdwqoWSTzIKd8H
	9mWLAtf/nqkQc1Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBA94779A8;
	Mon, 22 Jun 2026 10:05:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UKDLLeUIOWqIWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 10:05:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 63B36A12DE; Mon, 22 Jun 2026 12:05:25 +0200 (CEST)
Date: Mon, 22 Jun 2026 12:05:25 +0200
From: Jan Kara <jack@suse.cz>
To: Carlos Maiolino <cem@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Lukas Herbolt <lukas@herbolt.com>, 
	hch@infradead.org, aalbersh@redhat.com, linux-xfs@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, ailiopoulos@suse.com
Subject: Re: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <yvjbtwfl4wfctmowoxpkzqhlqt42r2sns6p3t4j5ge3abv2ydr@degtb3bjzp4c>
References: <20260219114405.31521-3-lukas@herbolt.com>
 <20260219114405.31521-6-lukas@herbolt.com>
 <ptb5fg2wmlanfsvwawgcye6a2ezevrdnxfq4oxhwoialvgfjld@is3nzrdegqzk>
 <ajj5t_viQ7YiTLj5@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajj5t_viQ7YiTLj5@nidhogg.toxiclabs.cc>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C47F76BB4D
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	MISSING_XM_UA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon 22-06-26 11:07:58, Carlos Maiolino wrote:
> On Mon, Jun 15, 2026 at 03:17:29PM +0200, Jan Kara wrote:
> > On Thu 19-02-26 12:44:09, Lukas Herbolt wrote:
> > > Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> > > As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> > > and so we set lsu to blocksize. But we do not check the the size if
> > > lsunit can be bigger to fit the disk geometry.
> > > 
> > > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> > 
> > During our performance testing we have noticed that this patch changes the
> > size of log stripe unit on a disk behind megaraid_sas controller from 4k to
> > 64k (which is understandable as the disk reports 64k minimum_io_size). This
> > actually causes a performance regression (about 40%) for dbench with 1
> > client as it is very fsync-heavy and thus commits lots of tiny transactions
> > and with larger log blocks the logging overhead just seems larger. dbench
> > is kind of pathological load but I assume other more relevant fsync
> > intensive loads could experience a regression as well.
> > 
> > I think one of the reasons why 4k log IO actually ends up performing better
> > with this disk is that the controller has a battery backed cache (a few GB
> > large) and thus it's able to absorb smaller log writes and merge them into
> > properly sized IO so larger half-empty log blocks are just pure overhead
> > for it.
> 
> Sorry the late reply FWIW...
> 
> So those seems poorly designed writes which just happened to perform ok
> by accident. Properly aligning it to 64k to match its min_io_size is the
> right thing to do to avoid lots of RMW cycles for once. But I'm pretty
> sure you already know that :)

Yes, I agree the XFS logging with the old defaults performed well on that
machine only due to the battery backed cache.
 
> > This commit sadly doesn't contain any quantification how bad small log IO
> > is for 4kN or 512e drives so that one could weight it against the
> > regression for higher-end storage.
> > Anyway, I'm not sure something needs to
> > be done here as there likely isn't a value that works for everyone. I just
> > wanted to provide a data point that this isn't a universal win and maybe it
> > needs to be considered what's the most sensible default.
> 
> Well, I don't think 'fsync heavy' applications are the default, or if
> they are, specially on high-end systems, then I'd argue the application
> ought to know what it's doing. I do agree that's no universal win
> anywhere and yet seem to fix the sunit to the hardware reported size is
> the right thing to do here.

Fair.

> Perhaps you could leverage mkfs config files to set different default
> configs where you folks believe fits better your usecase?

Thanks for the tip. Yes, we are considering that. I mostly wrote this email
to share the finding, make people aware, and gather some feedback about
what people think. What default we pick for our distro is a separate
discussion we need to do internally...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
