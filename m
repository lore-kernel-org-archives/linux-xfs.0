Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795088843;
	b=3zVRy+223Xn6ATbVJcMNVdGq6A044pYA+NQNH4BQL3ZvxdiK0iR3M0xbRF1AefNH2ltM
	 trECOCTpIW2X2i4tUH3Evh95V8NyeezkpbvBm/i+naK8IP/RB7p7apCA2ssMax5sKQ3fK
	 QxFniwvhlA3KsNN9iNZwRHLyo9Nt5V0aXGEQsTqmLN6aSBRr0VLZg0VlZ25lWY16wpBMT
	 YpfsFivmBeuV16cQe34sTMemSjWIwwKzSHNlsXT1q8w0MSYB9t5HAf4PiO9wMNjNJcvUn
	 ak5iiPQ0MQvdrpqw4hI4zWrzV11VFkCa8rjj3TNtfElOhayI+eG4cCa6eyPxfuiiJSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795088843;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=q50xZglJSQkIE53wq9zfiZcGFbsNHFsOyMevLI/3AeI=;
	b=rFOHJZ/VCH4wAoga/SaDTluzUcJDFZcnEFU08ddUk6sRXGT72RxnhROcGEHTzbXigtpm
	 sW2jhzR2YgyZamk1qqRJ8R5jn75fsy7iCUAQy/PazwcW1xuLfXpHq4yVVIjcPNjdpjdD+
	 x01MynZY42nDXkG6l4MB9r3xXLHOqJ81r/FIoV5rrnFAuHeaW9auSMBRRwirGsz8ZnG/Q
	 s5f+P8XQR3uzZvMAcBDuAFp5odnoxVIiagyDjTFcNpHCRCimSuKE3ZUFNnDQMDIuVsDmP
	 ASZiZQclFfUVcVh5diMUfr6xEd+2duBtYhj2Drh473cC/sD/Oj/gbwVs62amTrP5JDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xdElVJ10;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KlLSZEEV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xdElVJ10;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KlLSZEEV;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C666660A2616;
	Thu, 19 Nov 2026 11:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C666660A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xdElVJ10;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KlLSZEEV;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xdElVJ10;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KlLSZEEV
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 849C22245B;
	Thu, 19 Nov 2026 11:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795088840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q50xZglJSQkIE53wq9zfiZcGFbsNHFsOyMevLI/3AeI=;
	b=xdElVJ10THrGGvOwxke2KLbIvACJi9VoJmYrjUAFBca5LZpvjNtV2BgAwHjvNSOqzqWfxt
	RBGicArJy1j10swLBWJEyILIKTCunyFJcD13Tdf+HEAd1MvV5UWrhRMauezH+EopXtemmO
	AFoNMzmBvaC0dK6rFBCoIM4tWeeV0WU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795088840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q50xZglJSQkIE53wq9zfiZcGFbsNHFsOyMevLI/3AeI=;
	b=KlLSZEEVp7N5vWaw8nNZr2qd2TDzQqe6ZlOHNMsPiZZoD2zr3rYHA2ld15hF4eAr+Tb775
	W/+xKuqbG9qQFXDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795088840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q50xZglJSQkIE53wq9zfiZcGFbsNHFsOyMevLI/3AeI=;
	b=xdElVJ10THrGGvOwxke2KLbIvACJi9VoJmYrjUAFBca5LZpvjNtV2BgAwHjvNSOqzqWfxt
	RBGicArJy1j10swLBWJEyILIKTCunyFJcD13Tdf+HEAd1MvV5UWrhRMauezH+EopXtemmO
	AFoNMzmBvaC0dK6rFBCoIM4tWeeV0WU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795088840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q50xZglJSQkIE53wq9zfiZcGFbsNHFsOyMevLI/3AeI=;
	b=KlLSZEEVp7N5vWaw8nNZr2qd2TDzQqe6ZlOHNMsPiZZoD2zr3rYHA2ld15hF4eAr+Tb775
	W/+xKuqbG9qQFXDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CCBF1334C;
	Thu, 19 Nov 2026 11:47:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RRZxEMjh/mphYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Nov 2026 11:47:20 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E78C2251EE; Thu, 19 Nov 2026 12:47:19 +0100 (CET)
Date: Thu, 19 Nov 2026 12:47:19 +0100
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
Subject: Re: [PATCH 08/13] fs: Provide inode_or_folios_dirty() helper
Message-ID: <2kervbcskm35fxdgke4og6shatan2pjmetm52nouyha66oiasm@kvuwuqusd7oy>
References: <20261116171044.6938-1-jack@suse.cz>
 <20261118145941.1063127-21-jack@suse.cz>
 <CAHc6FU7qgJ1R-bz2icUyQTQFs7_mKt=tat-ut66K-cgn-uet3Q@mail.gmail.com>
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
In-Reply-To: <CAHc6FU7qgJ1R-bz2icUyQTQFs7_mKt=tat-ut66K-cgn-uet3Q@mail.gmail.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Thu 19-11-26 01:25:06, Andreas Gruenbacher wrote:
> On Wed, Nov 18, 2026 at 4:00 PM Jan Kara <jack@suse.cz> wrote:
> > Provide a helper function checking whether inode itself or some of its
> > folios are dirty. We'll use it in filesystems instead of direct i_state
> > checks. Note that this check returns true also if only timestamps are
> > dirty when lazytime is enabled.
> 
> This is confusing. Can we just say this here?
> 
> "Also returns true when only the timestamps are dirty."

OK, changelog updated.

								Honza

> 
> > This is what users really want.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  include/linux/fs.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 025f5d890689..f602deacf953 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2228,6 +2228,13 @@ static inline bool inode_is_dirty(struct inode *inode, bool datasync)
> >         return inode_state_read_once(inode) & mask;
> >  }
> >
> > +/* Check whether anything in the inode itself or its folios need writing */
> > +static inline bool inode_or_folios_dirty(struct inode *inode)
> > +{
> > +       return inode_state_read_once(inode) & I_DIRTY_ALL ||
> > +               mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY);
> > +}
> > +
> >  static inline void set_inode_metadata_writeback(struct inode *inode)
> >  {
> >         spin_lock(&inode->i_lock);
> > --
> > 2.53.0
> >
> 
> Thanks,
> Andreas
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
