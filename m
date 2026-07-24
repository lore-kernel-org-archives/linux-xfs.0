Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55BB4779A5;
	Fri, 24 Jul 2026 23:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784936381; cv=none; b=PCHk10Zt2mEZElyGAOnFoEQactb+gxZouPXvQEDyjZzzU2nngDArY4202qbeMaZFi5MarZkzmikf31Ru50KkUn2BjgecvCKjmFjTGtajULH5Jcx0dS7AV2gW2goTFgl8eUnruxi++NMpm6AVHBOpo0aMqFoPd16CdRpb219TEiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784936381; c=relaxed/simple;
	bh=PGlhSsVhs0q3g8Whw93NI52xKBzegASqTSeRRFBjxLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zom0aQMs6Hyx6aYXeByxaJ3j8V0rJyZ73+kWTjiEKSxuswVn3EnGwqQilr2cnoEzjW73K9ymMgYzA3SG9q33Jsuz1+IhWlgJVUh3WsPCoUAgopLs3sRvWTwXJ5UTaKidv6VJGaWYv1MRWIShFQtRStO/4bWqf5Y2VpjyfVWS9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEQfFFdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEQfFFdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817A71F000E9;
	Fri, 24 Jul 2026 23:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784936376;
	bh=goIlfZdhjdT3tIGjuN909d/KJf7uRaDedvTvGTi3EZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oEQfFFdfTLpZP2umUFeVIz3GgOK5wrRf5ZBgxwL/tDWEEtvr3MjoC9lH4rUgIyJFn
	 A9kER4SRt3W05s7bS2SstzlNEWtWwidZn09PLOc2ziyP5SUqJXGvawqxkjSeKYEUUb
	 c7NAX19yVkOoOA5aOfwLb/ilQ5Yb8MsKIF9E/mAJSCpsBQv3X09cvlJoAx8pVypEa7
	 iSPOWKf2Ww+tC+RZzKw9wwDjiZXDAwysoha4m9Txcs+nz0eqYAYdgH+D6c4Qf5VATB
	 NEz79vcH5IUy2/EHPsrBNjnPNF69cxHT/zy9s4x0G7OlahobnvoEG/Es68ToZI4I9/
	 nBGO03ubfBTXQ==
Date: Fri, 24 Jul 2026 16:37:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 02/23] fsverity: expose ensure_fsverity_info()
Message-ID: <20260724233744.GB1901@sol>
References: <20260721184346.416657-1-aalbersh@kernel.org>
 <20260721184346.416657-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-3-aalbersh@kernel.org>

On Tue, Jul 21, 2026 at 08:40:39PM +0200, Andrey Albershteyn wrote:
> +/**
> + * fsverity_ensure_verity_info() - cache verity info if it's not already cached
> + * @inode: the inode for which verity info should be cached
> + *
> + * Ensure this inode has verity info attached to it, it's assumed the inode
> + * already has fsverity enabled. Read fsverity descriptor and creates verity
> + * based on that.
> + *
> + * This needs to be called at least once before any of the inode's data
> + * can be verified (and thus read at all) or the inode's fsverity digest
> + * retrieved.  fsverity_file_open() calls this already, which handles
> + * normal file accesses.  If a filesystem does any internal (i.e. not
> + * associated with a file descriptor) reads of the file's data or
> + * fsverity digest, it must call this explicitly before doing so.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int fsverity_ensure_verity_info(struct inode *inode)

There really should be a note here that if the file is also encrypted,
then the encryption key has to have been set up first.  This was already
gotten wrong when it was proposed for overlayfs to call this.

Do we also need a more specific contract than "-errno on failure"?  The
caller in xchk_inode_setup_verity() tries to distinguish between
"metadata validation errors" and "runtime errors" by checking for a
bunch of different error codes, and I'm not sure what that means
exactly.

- Eric
