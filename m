Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795089918;
	b=TNJyJSr3LhRzP0hrHCUHicV3+k12iCLOYFQ7PMtKUZTHZOJVtyo2SDFWa5wuPYxY+pft
	 jF9WR6UoZ8GqXCpRmoZAGBX4N7sgDV1y18u/nJmT30eDOo7izQBHALLlAcNV3UmLlFyvW
	 TELfdVOu0e5CD2F1olvjamFe2j4UqMOLNhn3dUyWe0xZ5VCAJkkH9C5xydAK/OPtSBaun
	 lYktGIm8gdXDo2eNdJOP/pB50Igr+Cc8k+Wmezd9A4MW6swZ3jORrreYq8QCoeWx9/Y2P
	 upyTcOfKXXcElX6M6L8oxzjmRb3pIP+gp7yOWAI3TkceKNUKt1Z+Phl8oPKWCi9BwMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795089918;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=Xb5uhigok+fG+H/V0Hc5u+aMSaJU26bxca+7DPwga78=;
	b=vkBSUDVMM4IvYHNU3o2t3L4sywEnoXbvmtlbhgk4kqWwKgd+Rx/zwZtq7l7fjoH6c8Ef
	 79W+Cx0ot/v8jzxKOyIDSTHZSGfjAcN0w19gSICLywMQldcapiHqobQBe1RHib48WHo6i
	 MHzTL1lYmeZ1G4EeHFgKosg2KG6RqfvsreKDzqEQS2XuKeBBTl3YVZKhSCpEXeYyVFz5x
	 746tTw5ljGwPyAHZ5imJE6cN67r1eon90yt7P1trMDnXQ0ledEjj3ostskOsSnZtzLi3e
	 gX8VmYkOzvV9mIkS5O0mxgcZytsxsUkRkKlbwdGGVPSmGJfrsvDhl7SmYV84yyDnxOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XItPl4K9;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IKyWuvMH;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="moCRy/S0";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IKItGg3T;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B75B606A320;
	Thu, 19 Nov 2026 12:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B75B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XItPl4K9;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IKyWuvMH;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=moCRy/S0;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IKItGg3T
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2073B1F794;
	Thu, 19 Nov 2026 12:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795089915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xb5uhigok+fG+H/V0Hc5u+aMSaJU26bxca+7DPwga78=;
	b=XItPl4K9yBPNEbR+i48nztZFTfZePovvmjxrtUWzV7t3pJHWsLvotPeDf9LAT3HSCqfhY8
	bGuo/6/SkBbvKfgcHOaEQmU/dYsBbO3VcF0akfeTviyiiI7CnbH2hHo9UpXo3s67FqINJM
	j7Y5odQoVgx6VesBBW9EUz/9RDnOEPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795089915;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xb5uhigok+fG+H/V0Hc5u+aMSaJU26bxca+7DPwga78=;
	b=IKyWuvMHWIIuL0u5TNknnUT0iNqyDuB98gqSEucxa2rN5CNs8vcx9pXiib0OK9mb4JLCeJ
	SNDH23/VUw88nMBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795089914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xb5uhigok+fG+H/V0Hc5u+aMSaJU26bxca+7DPwga78=;
	b=moCRy/S0bhttPKCuY8+B3uiIFtRYx1U85K6aJ0ix0PCDE8NhvCLMmlJHwSUQ8ERgXS8Fjz
	s9Og7YsUfDqhr1+pUsavMyk6qfsBcNAXF2ze5dIgkCAgdeikOYIQPDaHJebW7Wlh5AebhQ
	/CCFm4kmPcz7EWRdMt6Zdy14uVB9NO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795089914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xb5uhigok+fG+H/V0Hc5u+aMSaJU26bxca+7DPwga78=;
	b=IKItGg3TQdPqSC99KFVidzedRX9ZjbwDE2tKnUSep43QiC/xxxyp4MWf3fh0G6sh5s0sCL
	pU9AxvibZcCIusAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9D1C1334C;
	Thu, 19 Nov 2026 12:05:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a0q4MPnl/mr4cgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Nov 2026 12:05:13 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7BB4A251FA; Thu, 19 Nov 2026 13:05:13 +0100 (CET)
Date: Thu, 19 Nov 2026 13:05:13 +0100
From: Jan Kara <jack@suse.cz>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, devel@lists.orangefs.org, Dave Kleikamp <shaggy@kernel.org>, 
	jfs-discussion@lists.sourceforge.net, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	linux-afs@lists.infradead.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, 
	linux-block@vger.kernel.org, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	linux-nfs@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 06/13] gfs2: Avoid racy dirtiness check in gfs2_fsync()
Message-ID: <wo5723b7wrmu35q5qffzs7zzqwnojk3ireel2jkit2kxgv6bra@yd3gbigdmmdk>
References: <20261116171044.6938-1-jack@suse.cz>
 <20261118145941.1063127-19-jack@suse.cz>
 <CAHc6FU7NoZua98SGP9Kuga58gAcco6X__u=kOPfsUqbefAKLFQ@mail.gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU7NoZua98SGP9Kuga58gAcco6X__u=kOPfsUqbefAKLFQ@mail.gmail.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80

On Thu 19-11-26 00:35:42, Andreas Gruenbacher wrote:
> On Wed, Nov 18, 2026 at 4:00 PM Jan Kara <jack@suse.cz> wrote:
> > Check for I_DIRTY_PAGES state in gfs2_fsync() is racy because
> > __writeback_single_inode() unconditionally clears the flag and
> > reinstates it only later based on PAGECACHE_TAG_DIRTY tag. If
> > gfs2_fsync() unlocked read of i_state hits in between, it will not see
> > I_DIRTY_PAGES although there may be dirty folios in the mapping. Check
> > for PAGECACHE_TAG_DIRTY instead and use inode_is_dirty() helper for
> > inode metadata dirtiness check.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
...
> > @@ -760,12 +760,8 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
> >                         return ret1;
> >         }
> >
> > -       if (!gfs2_is_jdata(ip))
> > -               sync_state &= ~I_DIRTY_PAGES;
> > -       if (datasync)
> > -               sync_state &= ~I_DIRTY_SYNC;
> > -
> > -       if (sync_state) {
> > +       if (inode_is_dirty(inode, datasync) ||
> > +           (gfs2_is_jdata(ip) && dirty_data)) {
> 
> this adds back the I_DIRTY_TIME check explicitly removed in commit:
> 
> 3aac630b5ce1 ("gfs2: don't worry about I_DIRTY_TIME in gfs2_fsync()")
> 
> Could you please clarify what's going on?

I wonder how you remember this after five years :). Anyway, the truth is I
forgot fsync path is calling sync_lazytime() as well before calling into
->fsync and even if I remembered that, then it would be fragile for the
helper to rely on that (and there are already users of inode_is_dirty() and
inode_or_mapping_dirty() which want it). So to summarize you are correct
that the added I_DIRTY_TIME check is unnecessary for gfs2_fsync() as it
should never trigger just for that but it is also harmless and the helper
is more robust that way.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
