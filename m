Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350406;
	b=Uqbtb5GnOlGL13ToOAKT7564oJHg0JyToputNGWKDv6F1hF1YE66WL2/7uuex2lbGo6F
	 0y+k9K13IbUGyGOMf2JjZqTEAuwS2KsbyCG23t09wZUIqAzAWnj4aKstw2pHJ+oeC8TaR
	 rZEsF85pmDvZWLEYUQBUwlgFEH+bm5Tso1VOA+zdgsgj80m20+MkHUECBc2jw96pbfF5F
	 YgDTNG9ql1VepyQBrVqvCD1pvXvHJuk5BqUpOXbYQaGvnheN/0NsqX0R6qQXLCIfM4mWL
	 ZxnhmgGSIF+Q2bv8xHjI3x7Pzgv8zHMZ993tS9HZ3Ceg8Sf2d7fPIX4/gyBbMhCQt8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350406;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4iouw9kc7osx9xZEFyrpkl1mggM2R9WmYHa9c3AIRng=;
	b=jweapko2EPoe4YGIL9j94BZ7vNQmCpDO18iQ+8dwPiipTog9CHc8twxipwOg9MxJmRCC
	 aRmsFfXr4UAw1LWFGtIq+umR05Qn59oYyPVdXaZc3rnT181mjDAKNrBudozai1iz4sEdx
	 72wV+pVbedargfzcLNc7vAqmqyjrdQeZbs7MD+elvUsoGT8rKlJzUL8n5gkRXigB8ktMc
	 ntk1aGNKpQ76HfKspQR484WyS0BCMqK9vvch2dIvQbQWU9Bocz4tbRQamuwD7ELDHnsks
	 ZZb9jhXPGog2GuSYarQZ+YYPsBplXZSDJSO/Uk/3QAuxnRjNvDdO47k1zgrcY8fu7RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISY4GPo6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DEF606A31C;
	Tue, 10 Nov 2026 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISY4GPo6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9A21F008A2;
	Tue, 10 Nov 2026 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794350406;
	bh=4iouw9kc7osx9xZEFyrpkl1mggM2R9WmYHa9c3AIRng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ISY4GPo6d9hu862k51MLskyNBVJS45r1xWEsVdvI7Hzqyhdnfnq4Ug+2eAQ5VD8fH
	 FoOsff4V8+y6+wVYuMAOnOkUJ2HQDLCx4AFPBlGjPFt08ncGVXWF6OjD94ZSn15Doo
	 yJORIAtTbeMwT1bXXdwsDfvCb7U0sCfHaINhXR0s4uop3Ejdc6sV9RgOZ1ERp0OVOI
	 laD1dozcxPkmhOhE/nWRYFVbxxZpNT7N4jyJlwKzedox2VgqRuzStkTRgBm8Trof1U
	 jfkkMRFvT6nuq5mMgaMdHqrNT/ZT9ac3vFQDgoomWHkdLttdzGwAkQKsK+vum23YmC
	 313Yzqjqix2Fg==
Date: Tue, 10 Nov 2026 14:40:04 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, fsverity@lists.linux.dev, dsterba@suse.com,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Message-ID: <20261110224004.GF1907@quark>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-3-aalbersh@kernel.org>
 <20261110223526.GD1907@quark>
 <20261110223741.GE1907@quark>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110223741.GE1907@quark>

On Tue, Nov 10, 2026 at 02:37:41PM -0800, Eric Biggers wrote:
> On Tue, Nov 10, 2026 at 02:35:26PM -0800, Eric Biggers wrote:
> > On Thu, Nov 05, 2026 at 12:55:27PM +0100, Andrey Albershteyn wrote:
> > > +	} else if (inode_state_read_once(inode) & I_VERITY_BUILDING) {
> > 
> > fsverity_is_building()?
> > 
> > > +static inline bool fsverity_is_building(const struct inode *inode)
> > > +{
> > > +	return inode_state_read_once((struct inode *)inode) & I_VERITY_BUILDING;
> > > +}
> > 
> > It would make more sense for inode_state_read_once() itself to take
> > 'const struct inode *'.  Then the cast wouldn't be needed.
> 
> Also, we should include an IS_ENABLED(CONFIG_FS_VERITY) check here, so
> that it gets compiled away to nothing if CONFIG_FS_VERITY is disabled.

Never mind, it's already there in the !CONFIG_FS_VERITY section of the
file.

- Eric
