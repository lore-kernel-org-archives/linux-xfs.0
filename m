Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB8032ED55
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771436543; cv=none; b=IYP5wWcTloFfHbEAX1NVVRu2eiEhhtEiHM+xmdRt3BmI29KvNO6MLeRQVH4Jwn1F35dEMMx+spnujUHQUB35ZwAuJ3VKfBsjdBCRSF9wXFTK+GyYAPOQG740UX654GlIkPPgAHfcFZhOcn6cm8quYE0yRXSD2a8L3azZ5GkWq9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771436543; c=relaxed/simple;
	bh=2uiAxrki8yx1TK1mv5h1jTPL6e6WpFnN+88mAqPN3DQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/vOGY09RrivjowyQzqRudtQ7Yi8GeRStSmjCeY1oPf10aIypiOJQWRU819o5mDFHg1/w4zTqFpD+T9+Zizv46YsWz64KOY1JshxgDkDvvM7fqGLADTs3XborlocUKFaYGkMeMe0uklLDxwi65eAoqJhGz7KIooccOBoTCYAUHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PxaekDEg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ch1fLl53; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PxaekDEg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ch1fLl53; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PxaekDEg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ch1fLl53";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PxaekDEg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ch1fLl53"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD9683E6D4;
	Wed, 18 Feb 2026 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771436540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=PxaekDEgryjgjhp7gu9pnwHOKrO1w+Ild6EkoruNjPFB9xcrTFRJHcpg4wM1iMrrwV9nL9
	+p0KTwTezVzUVsoU5P3776MvLd2UhU6GppBO19aXfEYGXEI4YmjE98DOMZwqZXE+v29yqa
	OocbOqqZx2qsYHRjfOgH9QO7hDMuz20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771436540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=Ch1fLl53jWDItA/wsG5VC6xmr8thrkEqqKnsTtBDCAFDTy5xXH1KMWTVFMiY+uWnyLcXY1
	EDZBrO7fKy55OdAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771436540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=PxaekDEgryjgjhp7gu9pnwHOKrO1w+Ild6EkoruNjPFB9xcrTFRJHcpg4wM1iMrrwV9nL9
	+p0KTwTezVzUVsoU5P3776MvLd2UhU6GppBO19aXfEYGXEI4YmjE98DOMZwqZXE+v29yqa
	OocbOqqZx2qsYHRjfOgH9QO7hDMuz20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771436540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvwZdWyBuPCaJq5onHfru+6aMaFDG/nTmYkmyAXu5og=;
	b=Ch1fLl53jWDItA/wsG5VC6xmr8thrkEqqKnsTtBDCAFDTy5xXH1KMWTVFMiY+uWnyLcXY1
	EDZBrO7fKy55OdAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7FA83EA65;
	Wed, 18 Feb 2026 17:42:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H2z8KPz5lWnlbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Feb 2026 17:42:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6949BA08CF; Wed, 18 Feb 2026 18:42:05 +0100 (CET)
Date: Wed, 18 Feb 2026 18:42:05 +0100
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <bf6eek2jagskkgu3isixqjjg3ftrkp5juf6lge3rjjutzzhbdd@vkliyqpsmrry>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <aZSjUWBkUFeJNEL6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZSjUWBkUFeJNEL6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,vger.kernel.org,kvack.org,lists.linux-foundation.org,anarazel.de,kernel.org,oracle.com,infradead.org,lst.de,gmail.com,suse.cz,redhat.com,samsung.com,mit.edu];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO

On Tue 17-02-26 22:50:17, Ojaswin Mujoo wrote:
> On Mon, Feb 16, 2026 at 10:52:35AM +0100, Pankaj Raghav wrote:
> > Hmm, IIUC, postgres will write their dirty buffer cache by combining multiple DB
> > pages based on `io_combine_limit` (typically 128kb). So immediately writing them
> > might be ok as long as we don't remove those pages from the page cache like we do in
> > RWF_UNCACHED.
> 
> Yep, and Ive not looked at the code path much but I think if we really
> care about the user not changing the data b/w write and writeback then
> we will probably need to start the writeback while holding the folio
> lock, which is currently not done in RWF_UNCACHED.

That isn't enough. submit_bio() returning isn't enough to guaranteed DMA
to the device has happened. And until it happens, modifying the pagecache
page means modifying the data the disk will get. The best is probably to
transition pages to writeback state and deal with it as with any other
requirement for stable pages.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
