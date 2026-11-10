Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350264;
	b=n6Zcl0ygGQhG5POGR4qLCAJvYuYoz//7NGgJm2/XWdVIJQCJcfoJrjXjGmZ/GTxIVg90
	 fVqual5OofmgFVyi/e9wgLVqVBrxaCdkgkqkRWeY/kfoTBrr60vIP/Lzhv+P0Fj1s7tGK
	 /+eQZ7fj3mic8YocGpwPLP1WAF0M4vq7Puemv+mOV9/o41zsp/dqtUlAkYVki1NDgM0cQ
	 N3xM7oZCmDrfTx1ffG5iTFMxllIWHxcR0rsBmBUwAD7mOMk1016+rnzvZjp8keAimhhfI
	 ToqlQRQQPiIzOk/C7pMGk9QBt2y/LHUngEZiyjmCs8BlH+rBToT/8uVN1ML+9GUZAtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350264;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=n8XbVRklTf23qieQRD1VyauRsHNye3gZo1o86GLGMcE=;
	b=bWOrADltRIulWnzc9lzRt6DsK2DWSeMo1Ps7lKE9d5zJRXztTz9SRpTEpi3L1dBIx/La
	 t72xHcUF4YLRy3hl7p4dGtbuzpEK41qUkppZeCFwY2NU4oNremAWvMvMGLDFXPmBqoHP3
	 GD0r1qP6nM12drmcp6/6oGDsqY+yqLhSMX8nhkuIgDcyZuS8N5oA4qDdiIgQ+kn6GHhro
	 9saSExNWEpyAt3JgMiXP9XoX0NoqmAG/lVcVq9k4Iady4TWkxg81MV/Iz+LyCTQ2bNMtZ
	 uDvktHpBuw/LDhY7teAcVZeeX0g6Dd1LgGFPzeSTNACRjNcamxnlW3OekvaJYXp4cbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TOp9f9x7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15956606A31C;
	Tue, 10 Nov 2026 22:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TOp9f9x7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECE31F008A2;
	Tue, 10 Nov 2026 22:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794350263;
	bh=n8XbVRklTf23qieQRD1VyauRsHNye3gZo1o86GLGMcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TOp9f9x7TncAgXrdmTrTBClcnbzWo8BWTKAM5lNyJpIRpGbGEhz46LODD43Q+nLZc
	 f1xpTTvd20e+0sCXnhNoRGahw54LNb/ZkMI50VsPtUyBfiQhGj7dhxIFw2w1LskOMr
	 +i95YSLoHjEsKnX9gcyTmc0YVaq8S5qgkeyeic1dVN9dQ85JgYpbkIB3dYGlLhTboh
	 YccPuY1BUZpWnT6U90opJJObCAsUf7nNPLbQS8PvKP9+kWyN5/UNOLtGZjnuhfhcJU
	 sZ2DX/U7bFjKJaJCwIg17LTdTmBAX6tKkTyb++GMCGZICdU+DDLDvQnDvPIr0QZJBX
	 YzPlKGxyB9Z8Q==
Date: Tue, 10 Nov 2026 14:37:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, fsverity@lists.linux.dev, dsterba@suse.com,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Message-ID: <20261110223741.GE1907@quark>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-3-aalbersh@kernel.org>
 <20261110223526.GD1907@quark>
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
In-Reply-To: <20261110223526.GD1907@quark>

On Tue, Nov 10, 2026 at 02:35:26PM -0800, Eric Biggers wrote:
> On Thu, Nov 05, 2026 at 12:55:27PM +0100, Andrey Albershteyn wrote:
> > +	} else if (inode_state_read_once(inode) & I_VERITY_BUILDING) {
> 
> fsverity_is_building()?
> 
> > +static inline bool fsverity_is_building(const struct inode *inode)
> > +{
> > +	return inode_state_read_once((struct inode *)inode) & I_VERITY_BUILDING;
> > +}
> 
> It would make more sense for inode_state_read_once() itself to take
> 'const struct inode *'.  Then the cast wouldn't be needed.

Also, we should include an IS_ENABLED(CONFIG_FS_VERITY) check here, so
that it gets compiled away to nothing if CONFIG_FS_VERITY is disabled.

- Eric
