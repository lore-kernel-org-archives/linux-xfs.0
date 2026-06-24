Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7E33AEB4A
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 12:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782304005; cv=none; b=e7veoMkriSWAYsc0JAomZzki/iu93tSAfS5fQ/+qq1ZPqcCytS5wmYaNFkAC0tKj73MqNraAeHarptD8mcQlT5Ye1Dk3tJXNSd2lbiMmDeQOCdMEALIcgRypxqFzjUKKJFGkINbXlS2a8I5qYdGwh8qyaEBS/UVz8Z+e8Ga55pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782304005; c=relaxed/simple;
	bh=xEeXPpUONT8BEUnlVOo3xNnLhLtZMhot1pdXN9JrUrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRJRSAjtP6k570QvasxOPEnPfq7N2dtHH5aFJwT3S1iFDmUVTC8ynU3QGDTnfeTd9jB/ttEMGnGDzpnLi3f9uZSCzCj5sksJC7qypYBsft1g71lYhM/qNS2S6W7tza7y0/nbCg2ydpzdsBL9umzyL5q5mFAFYeKQ2Ah7C8YTpxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zcnLpBe0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4OSKfbNj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EVGshRi5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eOm18lmJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zcnLpBe0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4OSKfbNj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EVGshRi5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eOm18lmJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EA64A6DACD;
	Wed, 24 Jun 2026 12:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782304000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=giw8b3cKlmFqu+40f+9Z1p6kA/+4llBCwG7tDurM+bc=;
	b=zcnLpBe0qLEcbyJX251kEE8Vi2h7SxaInJqWtP54seabvNskH8wSfyztpKYIh7WFM6oUck
	bLi2daKYRvj6EQRtgBJXAWTOKllH6/8ENVJete8qXo2t0VYPEFIahwOsnpr0Vos4UzgQPN
	ifQ0acYM8o1sW+0s4xDfSogQGNKkI7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782304000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=giw8b3cKlmFqu+40f+9Z1p6kA/+4llBCwG7tDurM+bc=;
	b=4OSKfbNj9MpyxwVry/dNUXUElj37VHRsEb4cptTTwglQYbslt9kErHIbMVUvEEw3PYj8Sz
	PLgWcsDOIEq9CpCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EVGshRi5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eOm18lmJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782303999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=giw8b3cKlmFqu+40f+9Z1p6kA/+4llBCwG7tDurM+bc=;
	b=EVGshRi5zutyRDch3WrOVDinK8XCNYuQv7nKVOr7iS+u3IV5YC0iVeJhKsUPbm1UyN+9K+
	H/Pqu4KXnHWnvvNhSPLg5R83h1idlVvN0s4tXCf1WLtqoITZz0N8hzVtpCcgF2CbLBog3l
	IVOR2WaswihBc+BYR3f+itSh5I1FTQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782303999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=giw8b3cKlmFqu+40f+9Z1p6kA/+4llBCwG7tDurM+bc=;
	b=eOm18lmJClroa9PvgOIwSFWh0DE/1xM7katyGwtBUuIDfSHAkYN+b3F/k2cLuuCpC6EOrU
	5LsypW7X1MN630DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD192779A8;
	Wed, 24 Jun 2026 12:26:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JZDyNf/MO2pRSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 24 Jun 2026 12:26:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7FEB6A093E; Wed, 24 Jun 2026 14:26:35 +0200 (CEST)
Date: Wed, 24 Jun 2026 14:26:35 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jan Kara <jack@suse.cz>, 
	Filip Blagojevic <filip.blagojevic@wdc.com>, Matthew Wilcox <willy@infradead.org>, 
	Damien Le Moal <dlemoal@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: update BDI {io,ra}_pages values based on the RT device limits
Message-ID: <rbrncqfmzbnj5o2yvieqtpl3dkb4qzafsai3sarmbta4fsqc6f@yruai3zv5llu>
References: <20260623142109.1838702-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623142109.1838702-1-hch@lst.de>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: EA64A6DACD
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Hi Christoph!

On Tue 23-06-26 16:21:05, Christoph Hellwig wrote:
> we ran into a bit of a funny case where adding an SSD to store metadata
> to a (zoned) XFS file system reduced the performance vs using a HDD for
> both data and metadata.  It turns out this is due to readahead code
> looking at the BDI limits, including the io_pages value that can't be
> inspected or tuned from userspace.
> 
> This patch has the simplest fix for that by just updating the values from
> XFS, but for a long-term solution this feels a bit ugly.  Other, a lot
> more invasive options would be:

A cleaner but still relatively simple way how to fix your problem would be
to do something similar like e.g. btrfs does. That is when you have a
filesystem with multiple backing devices, you create a new BDI (using
super_setup_bdi()) and set its parameters based on the combination of
devices you have.

The only downside to this is that blk-wbt has a layering violation in it
when it tries to guess whether there are task dirty-throttled for the
device which stops working for when the filesystem uses this synthetic bdi.
But I don't think that's too serious to worry about.

>   1) support multiple BDIs per file system.
> 
> 	This would work pretty well for XFS, as data for a given file is
> 	always entirely on one device, and the VFS writeback code is not
> 	used for metadata.  But it probably doesn't work well for other
> 	cases

Since looking up the bdi is abstracted through inode_to_bdi() (which
currently goes through the superblock), this would be relatively easy to do
but either the inode would have to store the bdi pointer or we'd have to
have an operation to query it. Just at this point I'm not fully convinced
the additional complexity / memory cost is worth it compared to what can be
achieved with a synthetic bdi.

>   2) stop propagating these values through the BDI
> 
> 	Have a way to query these parameters from the file system, either
> 	through a method if we want to be fully dynamic, or through fields
> 	instead of going through the BDI.  The downside would be that
> 	sysfs modifications of the readahead size would not work after
> 	the file system initially queried them.

Similarly as above. It makes sense but I'm not sure there are strong enough
usecases to justify this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
