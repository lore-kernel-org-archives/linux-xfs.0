Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9500A3EB0FA;
	Tue,  4 Aug 2026 18:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785868675; cv=none; b=n/LnL/BnY3P35FpL618sFEL0ZsRmyZbDQ3G+HsyCaqDgMlOz7IZ3gtLQ0qlynmH5mrKhjlxu9/fUGn1kaAY0Qyrce9ckKPOpKCESKUE2xGI8w9fuh9sEqxpeZAkRtDvfQ+wUjUSysD3mf4Jyz5zoe+Z17MNkhWX0cxWry/dWOSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785868675; c=relaxed/simple;
	bh=07cBacEHSGLAxN3NJZwdLIVfQa/OQXOqaKqYUGKOKZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lf8n0dsNOUhEeA5EaqHSWg28RjxaAFbZZovQffrLs+dQieM//j5sJbrIJdk+c+5I/rrXJfkPsbm2opW9y9SdE5I7z34NA2cNm0OxIMCJPVfn6axyPCLexJHb2ZZbxcVjM2SN1pVX7gktLuhFrb4h0kKTcrrx5sgOAkMoHkC07u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hp6rw9ri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hp6rw9ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E667A1F000E9;
	Tue,  4 Aug 2026 18:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785868674;
	bh=ehEaXeyHsLmTxWK7M3YlgnXecFCsvwQ93NjgKqgcras=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hp6rw9rizyKhIpvcVktLWi5HXvQ43+URj/96MqC/d6VpvipumAblyalS02HPyiNQ4
	 GzV7jGX0AtHAfEpB80iiBXIHiUXDbI8QQPLD1BEfbdO9uOyojdPHa9k1CZ8a+B6RPN
	 AOBX9+l2BbKq/L1nXUv/cpgVq83P4204ulINDCB/U5N1mcUYYZjNUybxC5/u3aFMqH
	 g/TaV2sSxtDpl9Uzhazk0F0X8pna/Cm05hUe2YeCRHdCWjd5y5ywbqssoA1TwEqD+y
	 Jurd8kjKsAC90UmXeVdAsZOHZ9rV1GQrtRJgzNveyUq/LTUycW9SN1YU43paaP2zZP
	 TMPtGi8b0HoBQ==
Date: Tue, 4 Aug 2026 18:37:52 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <20260804183752.GC2904385@google.com>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-6-aalbersh@kernel.org>
 <20260804174223.GB14046@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804174223.GB14046@lst.de>

On Tue, Aug 04, 2026 at 07:42:23PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 03, 2026 at 10:07:55PM +0200, Andrey Albershteyn wrote:
> > The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> > flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> > systems. Open code folio mapping and flushing to copy all digests at
> > once.
> 
> This looks correct, although to me optimizing for this feels like
> premature optimizations not worth the ugly code unless we have numbers
> to justify it.
> 
> If Eric wants it:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +		if (folio_test_partial_kmap(folio) &&
> > +		    off > PAGE_SIZE - offset_in_page(offset))
> > +			off = PAGE_SIZE - offset_in_page(offset);
> > +		for (; to < (vaddr + off); to += vi->tree_params.digest_size)
> 
> Style nitpick: no need for braces when comparing with simple
> integer arithmetics like this.
> 
> > +	for (off = offset; off < (offset + len);
> 
> Same here.

Well I didn't ask for it per se, but I pointed it out and asked whether
anyone will care about the combination of XFS && FS_VERITY && HIGHMEM.
Based on Darrick's email it seems the answer may be no?

If it's kept as-is, adding a comment mentioning that it doesn't need to
be optimized for HIGHMEM would help preempt any questions about it.

- Eric
