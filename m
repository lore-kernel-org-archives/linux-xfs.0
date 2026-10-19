Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F04133F383;
	Mon, 19 Oct 2026 09:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792403554; cv=none; b=h3tQ1igpdIANRrMuAftjN9Mzbefc/n7blm9qjCwOYcMgJsz+98fsFFffkt0tHrarl8Y5bhk8ItiwWidbgv+fGNsPpYAYFFcn5vn0rFNCHCB0YhFlEexFy6PhP2ukMCTeTUT5Z2H1V7hekFt/IZ2Nr0R1KYOZPpmrCThjGJ8nJc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792403554; c=relaxed/simple;
	bh=WvTtg8JCOogctn7ZSS15ZrjyvEQJ4j+2UdlxuxFQnTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CfiBFQvZrR7GyJkM+yMTQuGzCdp0oNMqfmU0ZDeD2Nltxtddj27SaHHVhxlVDfBTA1oj0ZzVyh+la59qopzAdK2yzUk7yicXfN0TB1danUVUEvnAjuq3sMp1C27gQ+kIne9lli9mnBL8KNTbEq/24yr3Jy2qtuo8IYfvLxWSzIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DapX6O+I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HkvNOVKW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DapX6O+I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HkvNOVKW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DapX6O+I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HkvNOVKW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DapX6O+I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HkvNOVKW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6896E1F44E;
	Mon, 19 Oct 2026 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792403550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/XjywU63jHK3zYfOZqk/GFYoCnttMlmfWvXQ5qlU98=;
	b=DapX6O+Ip4pKRXdlJVwKoYbFSgZmnci+oTZVGWx9N//wk+3Co0A6Gy6VjLwyPbJnXuzAkL
	nK/2Yk9eDEsEWraU+H6ro4FbaBRxl+xMkoYT76R16fauUCeKeP7bK2SBFwKH5znABsckFq
	6f8cRPlmgFApKa7bh+P/Y4scW5VQEgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792403550;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/XjywU63jHK3zYfOZqk/GFYoCnttMlmfWvXQ5qlU98=;
	b=HkvNOVKWZPcLczlyzJhxbC7tMzVsoibO8LGhYXd0PSctA5J8hm3Rc9LMb4abX/F22nZPqn
	qBMliAhGPtxMP+Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792403550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/XjywU63jHK3zYfOZqk/GFYoCnttMlmfWvXQ5qlU98=;
	b=DapX6O+Ip4pKRXdlJVwKoYbFSgZmnci+oTZVGWx9N//wk+3Co0A6Gy6VjLwyPbJnXuzAkL
	nK/2Yk9eDEsEWraU+H6ro4FbaBRxl+xMkoYT76R16fauUCeKeP7bK2SBFwKH5znABsckFq
	6f8cRPlmgFApKa7bh+P/Y4scW5VQEgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792403550;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/XjywU63jHK3zYfOZqk/GFYoCnttMlmfWvXQ5qlU98=;
	b=HkvNOVKWZPcLczlyzJhxbC7tMzVsoibO8LGhYXd0PSctA5J8hm3Rc9LMb4abX/F22nZPqn
	qBMliAhGPtxMP+Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F3B4134B3;
	Mon, 19 Oct 2026 09:52:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id emzKBV7o1WpYOgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 09:52:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BB917A1413; Mon, 19 Oct 2026 11:52:25 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:52:25 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 20/28] gfs2: wait for a pending withdraw before
 remounting read-only
Message-ID: <wauqpgtmmf2beg3pc2kqlbizrigd4ew26do4zqch5ilwdjy4cd@brolwbx25sem>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-20-60743a3dc326@kernel.org>
 <CAHc6FU5bdAjABRm=bnH68b2f66TZTDZ8sPdatLB2fS7-55U=yw@mail.gmail.com>
 <20261018-ungemacht-sodbrennen-hausordnung-42d33a4f7098@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018-ungemacht-sodbrennen-hausordnung-42d33a4f7098@brauner>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Sun 18-10-26 17:48:34, Christian Brauner wrote:
...
> On Fri, Oct 16, 2026 at 02:32:01AM +0200, Andreas Gruenbacher wrote:
> > > diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
> > > index 83b8bb6446e5..1535ce2b7aa8 100644
> > > --- a/fs/gfs2/util.c
> > > +++ b/fs/gfs2/util.c
> > > @@ -122,7 +122,7 @@ static void do_withdraw(struct gfs2_sbd *sdp)
> > >                 up_write(&sdp->sd_log_flush_lock);
> > >                 return;
> > >         }
> > > -       clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> > > +       clear_and_wake_up_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> > >         gfs2_ail_drain(sdp); /* frees all transactions */
> > >         up_write(&sdp->sd_log_flush_lock);
> > >
> > >
> > > --
> > > 2.53.0
> > >
> > 
> > this looks good all around, thank you very much. Can I add it to my gfs2 queue?
> 
> I was planning to just provide a stable branch for everyone to pull post
> -rc1. Then you can just pull that in?

On a related topic: I didn't find any branch with this work in vfs.git - I
wanted to check how all the things come together after adding the generic
emergency RO bit. So if you can push some inofficial branch for now it
would help me... Thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
