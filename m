Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DA8EAD5
	for <linux-xfs@vger.kernel.org>; Sun,  9 Jun 2024 06:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717914787; cv=none; b=EvOAMFv1bfSz9NyxdgXlfZX6sCYBJgAg4NlWQAR1fF/xGyRcpvlRmJcEW29neptw6+iRUq7FkkYUVv4UiZkOArh3y8I/jHPUS2kOIahC6jUMQuZ1T5fzKgDTl1i+y1LYfPgsCEO6w0x0eCmunSHCavybQ1nb54GJue276XKrZXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717914787; c=relaxed/simple;
	bh=amqnp3ihUj3ks4kuRQ1uohjuccJFRYFEEvX6i8gUZ8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHAk1/jA1hsmuMpk1kL3gTDIIauYUJgnCzhIOBKZwK1Vd9csuset8Rg3oReCKpbkJGJUQj72U58E3z6/uPV6RQ10r439e/+n6dvP/aI1qu4EkUXfr2gAeT+dvLvumdH45IudpN5baZXm5roijoSK5rOJeHb3FfiGmvQ7mcJXJ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SH3CnTJA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SH3CnTJA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lrgaYtSMkJ0QvFZuHSnyJRUuFMPLPvn+Znm7/4E/XYY=; b=SH3CnTJAmjfKjf1+YwOig9XJ9u
	Sg7/WeImt2mN2aMZ/ND/dFk75yFs37KUe5uLQx7Z2hbSibaamuJq1AtZ/nOr7fa3MnQkRrBrkIyk/
	8DGR9R0JmjUQZF/vBSoNlBaz6jMm8l9fva5N9uj7X45A1qpD0Wd8ZAB8f/vKSDtIQ3ab7MkaKZbi3
	DwZA/PIrS5AtXK4lLPt+ckSRDABLnPTIkh4ZUQx4BDZczFepavOP+4eNMJ+JZydDAcaDX78hLN8eo
	NTBw88cHWyKGp032YAG/l3ybggnPDRc4kaD0z5tYaO0bqE7TQu8GzaSNGVtkSjTo71AvWWAyTVN7Q
	a5d41U0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sGC6x-000000020Bv-2D0a;
	Sun, 09 Jun 2024 06:33:03 +0000
Date: Sat, 8 Jun 2024 23:33:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow unlinked symlinks and dirs with zero size
Message-ID: <ZmVMn3Gu-hP3AMEI@infradead.org>
References: <20240607161217.GR52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607161217.GR52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 07, 2024 at 09:12:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For a very very long time, inode inactivation has set the inode size to
> zero before unmapping the extents associated with the data fork.
> Unfortunately, newer commit 3c6f46eacd876 changed the inode verifier to
> prohibit zero-length symlinks and directories.  If an inode happens to

", newer commit" above reads really odd.  Maybe just drop the "newer "?

> +	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
> +		if (dip->di_version > 1) {
> +			if (dip->di_nlink)
> +				return __this_address;
> +			else
> +				ASSERT(0);
> +		} else {
> +			if (dip->di_onlink)
> +				return __this_address;
> +			else
> +				ASSERT(0);
> +		}

No need for else after a return.

With that fixed:

Reviewed-by: Christoph Hellwig <hch@lst.de>

