Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B4934A791
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 08:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765872390; cv=none; b=UMgNvNXYZ2wD6TrQV3LZD+pAy2w3PNXSiy8NTjO5mfrEQu2HUjCdcs2h8gefk7+0C+w0J8CYada08grO6n+IB3ZtX5pw2gFD2IVg4dJr3F+ZIN0yxuXjXIDfcXiPtO8YKoL34P0P/ahA8y4CsIWKPb5jZMP/lNd9aFsd9/IC83Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765872390; c=relaxed/simple;
	bh=9PHw/9xqBQgYLxS8w/CdwS+3k/N2A68PVNuUJjO5WbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjCCeiChYniS8L4KyNo6FHHKhVRnbxLHhnIfj8daavYBTltyOGV9KO9HDrxWM5+wOQoD6YmegACItr/lzvysesSXHpgNBur2ILTNjMWqo7zNiMxQgoY5CerTzdVAk9oTCcUZEHKlJuc7PLOkL2IeCVWaBd8cifrxxGPbLUP/5t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 21598227A87; Tue, 16 Dec 2025 09:06:19 +0100 (CET)
Date: Tue, 16 Dec 2025 09:06:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, bfoster@redhat.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <20251216080618.GA3453@lst.de>
References: <P_OCd7pNcLvRe038VeBLKmIi6KSgitIcPVyjn56Ucs9A34-ckTtKbjGP08W5TLKsAjB8PriOequE0_FNUOny-Q==@protonmail.internalid> <20251215060654.478876-1-hch@lst.de> <ffgi6wyu52fnaprwf3yh55zu7w54jnzeujfqhojpevntzfd4an@bpjnajccspt2>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffgi6wyu52fnaprwf3yh55zu7w54jnzeujfqhojpevntzfd4an@bpjnajccspt2>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 16, 2025 at 09:03:42AM +0100, Carlos Maiolino wrote:
> > 
> > +/*
> > + * For various operations we need to zero up to one block each at each end of
> 
> 							^^^
> 					Is this correct? Or should have it been
> 					"one block at each end..." ?
> 
> Not native English speaker so just double checking. I can update it when
> applying if it is not correct.

Your version sounds correct.

