Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBFB16D9D6
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712761939; cv=none; b=PKJv1iiNRf6NTRkj70/9KFAQ1QsXMGH5/bJdxf2a89uBbBxEl8FXuH9gzOBT5dKiKhWwkqXsMtD8zEnySZPlLZB6h1dT0ItAnSpdY0m0E9dEomirALrAFVQUQgCsJ0xbpBFPI+RVS69Spvij6bqA0hFoZdxw4OPL3RwoJewdJEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712761939; c=relaxed/simple;
	bh=H32MXFQ457KNt3kDu501h+1klh1HnAd+QFnEmB6wA4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGEj5PD0yKDXvCDNlFpJhUB9NEX2DdSDzhn+bH1EnYLTaogOw2337qEK9SRWikYrXxscWkINzB3Km/Fq7qZgrFPX+ye47F+qocijnHiFtkV8+0tKmBVuS3kKZoip4ZW+usNhMGh+sXiG/tn7ne+GaLqYZJCIOwMHOJJiKBnhxpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2vTBi1aO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2vTBi1aO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eHe2JgzH8+aG36L/pBDCVM7CgbetFX/BdptuGTxCQi8=; b=2vTBi1aOmnv9hQJJB83po1xK7m
	8O6PaB1r8ThFqhlJ9xY8Z396Q90WdhRgIIuboBxOUW8y2oXSwe/AFsiGAkpxGhVubNN/QFqHkYEnc
	cg5uxUlZZstxTU6m8SDZjxrRjnFA17zoqFXhQ3FOoqDznq/WJdta16JWrXB8KdYphTxtfHGJ3Buhp
	Bafd37zmaDSIpD8VSqD3RapgejNjgo/mUzw2y1ykJFAR2P95ep5xA1IRKhdBVwOdmmVZyzuCKmV73
	6ygUhJ9soRhVa9wiRUnjbkOvKLFxhMBj2pLNwLZz7ylA9fJuMf/ZYusdEUDHDTVoelUy5VoKMoVGu
	+r14nMQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruZcW-00000007ian-29Bp;
	Wed, 10 Apr 2024 15:12:16 +0000
Date: Wed, 10 Apr 2024 08:12:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <ZhasUAuV6Ea_nvHh@infradead.org>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	/*
> +	 * If the caller wants us to do a scrub-by-handle and the file used to
> +	 * call the ioctl is not the same file, load the incore inode and pin
> +	 * it across all the scrubv actions to avoid repeated UNTRUSTED
> +	 * lookups.  The reference is not passed to deeper layers of scrub
> +	 * because each scrubber gets to decide its own strategy for getting an
> +	 * inode.
> +	 */
> +	if (vhead->svh_ino && vhead->svh_ino != ip_in->i_ino)
> +		handle_ip = xchk_scrubv_open_by_handle(mp, vhead);

Oh.  So we read the inode, keep a reference to it, but still hit the
inode cache every time.  A little non-onvious and not perfect for
performance, but based on your numbers probably good enough.

Curious: what is the reason the scrubbers want/need different ways to
get at the inode?

> +	/*
> +	 * If we're holding the only reference to an inode opened via handle
> +	 * and the scan was clean, mark it dontcache so that we don't pollute
> +	 * the cache.
> +	 */
> +	if (handle_ip) {
> +		if (set_dontcache &&
> +		    atomic_read(&VFS_I(handle_ip)->i_count) == 1)
> +			d_mark_dontcache(VFS_I(handle_ip));
> +		xfs_irele(handle_ip);
> +	}

This looks a little weird to me.  Can't we simply use XFS_IGET_DONTCACHE
at iget time and then clear I_DONTCACHE here if we want to keep the
inode around?  Given that we only set the uncached flag from
XFS_IGET_DONTCACHE on a cache miss, we won't have set
DCACHE_DONTCACHE anywhere (and don't really care about the dentries to
start with).

But why do we care about keeping the inodes with errors in memory
here, but not elsewhere?  Maybe this can be explained in an expanded
comment.

