Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795293674;
	b=bRZiCzgmkerDiY880W0eQYr3YsA0Erf1RYHHPhFRTeqAePnjn7SMsL84iZVwgQQnlhRd
	 AVLl5+zxcRMwp99FuYEixfTUknivutG2aTvsa83eTemV+CE52Mh0DfzUGNoG3wcKAGA2/
	 hnVdL4BAPsJoTvDYgYuyb+KETk0vqw3N+T0aWMeIg1ZT8yddgl335v4hPJsF2PvsAcXte
	 QRNvaQ/fcKslz23RDq+t4Vtlx/BEjPVSoLirGzBTlZRbuQiPOn/fc79JBCARApqEf9xr0
	 Y2OSj7XIHTtC/UAQdYdIs38v6FjgI+J0xx12LvKDxYtfp40WrbTra7GWRNhfAcdRdlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795293674;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=hmRMq/jyaz6ubqP2Q/8QAmwoitBfjKyHf2qlq73z/v0=;
	b=1Z7UYkXnU1oDnm1ddLIfLMNii/sA+3r4ZoL0TGxLnGPgDAO/hH49w3z9Y7xtymUzbiwk
	 Yibn9gl9t+SSV05ktXuxXLxMS1Yu6J1vBvhwwkqfk8gSTLyr1GwwqruMuAxow4EgmT5gC
	 A5/AH8ybgvIXgdanJBUgy2DGuyEXC+rc0xTt8lLeEKSoaPkJf6xvaR2n3BNGAWQzHpA5W
	 K1QkIObaaRp3eFPJ9jjUBqX93WFx/1dEvdzLa6WPKjuc0YjIhNVUFHtnGsdqiO39od102
	 CElfkVhnrc9tgcgatmzO5BzuA+kEFJQ+atuUtE2wGEQeV+jQGLXYa38Om+afxrgONJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="asgtto/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B841606A320;
	Sat, 21 Nov 2026 20:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asgtto/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C82C1F000C0;
	Sat, 21 Nov 2026 20:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795293674;
	bh=hmRMq/jyaz6ubqP2Q/8QAmwoitBfjKyHf2qlq73z/v0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=asgtto/P/mqBPw1Axj+fEFZsvYqeSF/ZmIFH4PnCav4vjk1EbTjJ0mTk50wXzXd3A
	 0oPFL4L3Soh2pKh6TNWZ0JSsVbLH0ArdhUWSpj9CqFwFPmMUVqG1r5h5vC44+KPoXl
	 IR2BtKSF+byzNkv20T34sbwoIxBfP2Au8bsE80sR6c0kF2VA8MPzCvevXGiZgqVo4c
	 Ih2S1i5XOt/camX8d7qFp4AF4rSFWnUSEIfOE7Bamymi/uFcvttZy8TP3iTO4po1sD
	 USsdPvR/w9Ks6xkidDC065RYjoqD8Vpq4iibvN1DrVToa1VhYtqvYCgR9ESKu7c95F
	 yRPPqnQHCa93w==
Date: Sat, 21 Nov 2026 21:41:08 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, 
	fsverity <fsverity@lists.linux.dev>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>, 
	linux-xfs <linux-xfs@vger.kernel.org>, dsterba@suse.com, Christian Brauner <brauner@kernel.org>, 
	tytso@mit.edu, chao@kernel.org, jaegeuk@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 4/7] iomap: use fsverity_is_building() to check for
 fsverity IO
Message-ID: <awFTapiR9KK9H6PC@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-5-aalbersh@kernel.org>
 <20261120222302.GD3048696@google.com>
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
In-Reply-To: <20261120222302.GD3048696@google.com>

On 2026-11-20 22:23:02, Eric Biggers wrote:
> On Fri, Nov 20, 2026 at 04:50:26PM +0100, Andrey Albershteyn wrote:
> > As fsverity inodes are read-only, the only write IO happening
> > during I_VERITY_BUILDING is fsverity metadata.
> 
> I think this is not accurate?  The inode is not a "fsverity inode" yet,
> and it can still have dirty data in it that is undergoing writeback.

XFS flushes data folios in _begin_enable(). Make sense for me to
have data stable on disk before starting the build, if any error
happens in data writeback we won't spent time building the tree.
That why the warning below.

But as I_VERITY_BUILDING exists now, I don't think there's
requirement to sync data before starting the build, I will update
the comment.

> 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 6d843b168d5f..0a176741e7b0 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -1930,7 +1930,7 @@ static bool iomap_writeback_handle_eof(struct folio *folio,
> >  	struct inode *inode = wpc->inode;
> >  	u64 isize = i_size_read(inode);
> >  
> > -	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
> > +	if (fsverity_is_building(inode)) {
> >  		WARN_ON_ONCE(folio_pos(folio) < isize);
> >  		return true;
> >  	}
> 
> This function no longer needs the 'wpc' parameter: it can be passed
> 'inode' directly instead.

Sure, I will update it.

> Sashiko also found an issue with this change.

That's related to my response above.


-- 
- Andrey
