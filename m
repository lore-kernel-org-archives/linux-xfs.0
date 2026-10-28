Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201173;
	b=aMP/87YKU7NU8rVWLBkUBe2lzOYzpPxy0DcJAI0sWK9SVNGpPS+kUO1pvVAN2P1/ZwFZ
	 LQSAVcZu5XXmqjdJNVuy2m6VVqmxH8zv/tXNcbrJeDrBPFsj72jjAOcNTWY6TrvxcmzHf
	 1vUFL9YccQdpVjdC89VFN7HqW2jlU4csYOvzBLudkqR4/2Q+rpe/iWOKSf6NGhYs9iXtZ
	 wudRNS6qWn/fSnJTZkpv4myMKC6QFpOT+TATeOd0rfQKkHgeRYV5FIjffjdrY2wOP6jCe
	 k/uuxwVVPvEEuquehfiugGtEjgm9eoG5X96x4Ag6Zfw9strPJsJUWHCc97oBHF8ht6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201173;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=d3QX8HkpKzW24dy6tkl+E+KWErFVB8MtEi0s4fp+Xfs=;
	b=JCgzV1zw3/5dQEsIS/MSaUDq5Dxc2UY/Itzqc4vCTjBkDPYQ5gDHS9Wi+CoBRUe0v0+x
	 qZwDzCFZJE06zAu1pNEciF7wrrj7Zfyp53ONwUgEgXuz8vAXPNL0r5x6Z2bif+nZYGTqj
	 sNxrgNgXyPIBsq8coLWYEaSifmUdQp5TFZvlMYHYG0DPzIuBdjQq5D1CCJUgfaNJFQRDs
	 3D/oyPpBy+FSArL2niW3Fp9XFqS61X2jHB5v+y27y1uGItrqWYp8FEEQEa+H5kqvpEkzu
	 bSYVI+ZjUylxHW5YpajHlQIVIWK3ewRxU3zR8/GwYbvxt/1xb3yb3Xgk6Nfes2esJRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LDPs2fvW;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6E7606A337;
	Wed, 28 Oct 2026 15:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B6E7606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LDPs2fvW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d3QX8HkpKzW24dy6tkl+E+KWErFVB8MtEi0s4fp+Xfs=; b=LDPs2fvWTpQ/pWJA2JQaKTqqFC
	j8KElsYLRnlkcuPAFUrAcCcDx8A2pSdAU+ubWTc1qflpUbaWbzphrHrW4tY41j+i1d1MrX9JY5G6m
	t7l17c9HvEoTCqLZjMxcEg0kSa6O2Mex7ZwuZ3YjZw2BECeJNfZr1/Bugc/iHfnF/PZ2hYe2wpvrT
	6P2d9QnbSO0uEy7XltXajNp59yoEKOtqsk31eG/om2SbTcygoVJmVLnYvSSeAheXUVCRYeKiqhHJh
	wK9usDCsLs03ZuhL5DC/alNviwQvZ0kyEOt4WOgXd2il9g1X902nntg6NOWP15rnpYERXGyX8WSEZ
	OQQDDrFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5XX-00000007MxA-3i1N;
	Wed, 28 Oct 2026 15:26:11 +0000
Date: Wed, 28 Oct 2026 08:26:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Pankaj Raghav(Samsung)" <pankaj.raghav@linux.dev>
Subject: Re: [PATCH v3] iomap: only follow dio alignment requirement if
 specified
Message-ID: <auIUEwEzpgilJn_z@infradead.org>
References: <1559d839fc32f47db7e8da8c8b2a5ea9b63afb46.1793143679.git.wqu@suse.com>
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
In-Reply-To: <1559d839fc32f47db7e8da8c8b2a5ea9b63afb46.1793143679.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Can you please write a normal commit log for this?  I.e. explain the
problem and the highlevel fix in short sentences.  No need for [] tags
or xfstests output.

The fix itself looks good.

