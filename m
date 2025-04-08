Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D321A3149
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 06:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744092228; cv=none; b=TXII+vGF9rmPEo3eOvMZPumumLz19hkVcSUui2s6Quwr4pqovOZAzRpP6gZPGIK/i1+EJPK8nLUKFW4xRa3DEsmwJV4TeRN2SuppIqMJ1GkzYqIf70NIJEW/URWxtjybZ7x3VQGmwbCWPg6tFDznDfnfSSC6wcorkp/afO6L2g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744092228; c=relaxed/simple;
	bh=PRsC9BVHJpPW8Yut6gf9c5kL/QS75r5YGJzYfItmNnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOMZhoHGxnOzOGSqhFL8yPsdy1kxcR2NGXBruwvDwWjtukTzndCsdL4+ZFk6hSLd9LO1G3hBZJLgG1gfosS4r4xvq7LR1Gnr8ytE9ixko+mpkpHcnFc3qV/Cbmck6lnmg/hxfwy7Vi9tvkmR36uCaQoxAYQzuXfJVuT+UfqZAmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTJRJEkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTJRJEkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50723C4CEE5;
	Tue,  8 Apr 2025 06:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744092227;
	bh=PRsC9BVHJpPW8Yut6gf9c5kL/QS75r5YGJzYfItmNnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tTJRJEkn9t4MF/tXpivi3yh/BLPHd01VhU+C6gWtrHAACa+fZ+Kp6Llm5YlVDvii8
	 xYvV8obCRnyCSuMxDPLtyptM1ML/BRUjxoHTCWiooaCuypVG+S/KK6kWjJiFfjdAOe
	 dB26geYEPkX4qHyOTFCg0ymMePl065xOxSZpSJPyoxOqEUCZKQ4jZivfpf27oiLrKv
	 x8f9Hd5Uz90GRqk05g5fAxsUp4ZeRxNBpGli4sAL5eMkOMnjOklEnpVvcTH0/NcLLd
	 3flph1KCcAUPIK5gDPmFapdHfKuE3xAFPIPfzsQa481jzWiV3u3Gdcl67SFw4VDP42
	 VUEsMdLztVqFg==
Date: Mon, 7 Apr 2025 23:03:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] xfs: compute buffer address correctly in
 xmbuf_map_backing_mem
Message-ID: <20250408060346.GG6307@frogsfrogsfrogs>
References: <20250408003030.GD6283@frogsfrogsfrogs>
 <Z_Sv7MWFnIXtq--H@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_Sv7MWFnIXtq--H@infradead.org>

On Mon, Apr 07, 2025 at 10:11:08PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 07, 2025 at 05:30:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Prior to commit e614a00117bc2d, xmbuf_map_backing_mem relied on
> > folio_file_page to return the base page for the xmbuf's loff_t in the
> > xfile, and set b_addr to the page_address of that base page.
> > 
> > Now that folio_file_page has been removed from xmbuf_map_backing_mem, we
> > always set b_addr to the folio_address of the folio.  This is correct
> > for the situation where the folio size matches the buffer size, but it's
> > totally wrong if tmpfs uses large folios.  We need to use
> > offset_in_folio here.
> > 
> > Found via xfs/801, which demonstrated evidence of corruption of an
> > in-memory rmap btree block right after initializing an adjacent block.
> 
> Hmm, I thought we'd never get large folios for our non-standard tmpfs
> use.  I guess I was wrong on that..

Yeah, you can force THPs for tmpfs.  I don't know why you would, the
memory usage is gawful on most files that end up in there.

> The fix looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But a little note below:
> 
> > +	bp->b_addr = folio_address(folio) + offset_in_folio(folio, pos);
> 
> Given that this is or at least will become a common pattern, do we
> want a mm layer helper for it?

Yeah, we should; this is the third one in XFS.  What to name it, though?

void *folio_addr(const struct folio *folio, loff_t pos) ?

I'm surprised there wasn't an equivalent for struct page.

--D
