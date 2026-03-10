Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF703491C2;
	Tue, 10 Mar 2026 06:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125107; cv=none; b=gvZfnxG6yp5iNkbOm9bxIdPsd8BZh1RpWhQTGLYDqxbD25X/8DNMlal4Pwk7ZIlbqg4Z9DreNTTTuFnLfAFJuWY2FD2D2qdSLckKAJojF77OW2UOzo3KOUNVVC24w3YL0ghV0xsvkuc++17GNfnbezJFeOdtKPyX2wpG32+RQ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125107; c=relaxed/simple;
	bh=8N8Xkhc0dX4leii2PCJdfk697cNOJJ7durSohUZVp3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuP3OnChJR05Te+l9kHX5CjuTRSQ2/tsPwKceaa72x1R7Ubj0bpJzDl2GEA9fhH9FpM2miwrffm2vooBR99D0XNbdGlWvZJM72eNcy7ANb7NfHHbf4HF3rAfGz3vIubhB8B1gnfWHXiB+KqCDiGLELtzoayiMehZv6XpMAghHrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F2rHjzR5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F2rHjzR5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SRIRNiVyMNvRyW+hWEHfrNuUrTbHsSV/xUQcmLHmJCg=; b=F2rHjzR5K+O553Dg6TL8yYNUKO
	uPtkGKK6I6VR7h9Lqb6pIGkcqjbCDLtC4IfcMvsHnA95esJ4IH4nCoKpnIzlHmnH68ydhB5F3SNMv
	DelJ6k01n4cBLV23zvNtSkHwFeMo0aJ7LIJUDNhfTvN3O+wbxjdMrVf1j7Hmy2ZGz6IDpcRApeK39
	8h1IeBrrUSSY+65SD0Q9+PW/nVnhToycBLOiBIvY8tPB8Gzsk0tbWfx8jns8Q9XcWoQ26/bF57xyL
	Y0uXoImp9w02qV78bQPxcmDGBMx9Jdq30k0z7ipwQqw4s84KmXXTQSpV/0nPSUV3r/kttEknxWjsJ
	wlP1UxWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzqq0-00000008naY-1jMz;
	Tue, 10 Mar 2026 06:45:04 +0000
Date: Mon, 9 Mar 2026 23:45:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 0/8] iomap, xfs: improve zero range flushing and lookup
Message-ID: <aa-98KuvCPNUhtRE@infradead.org>
References: <20260309134506.167663-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309134506.167663-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 09, 2026 at 09:44:58AM -0400, Brian Foster wrote:
> Christoph discovered a regression with zero range in zoned mode on v2 of
> the series. The problem is that the zoned mode iomap_begin() relied on
> the hole mapping flush to handle the case where writes are pending but
> blocks have not yet been mapped into the data fork for the first time.
> Patches 1-2 lift the flush into the begin handler, document the purpose,
> and clean up the logic a bit. They are inserted at the beginning of the
> series to avoid regression from removing the flush from iomap in patch
> 3, but ordering is not critical as zoned support is experimental.

Thanks!  I've run this through my usual zoned testing over last night
and it passes without regression.  I'll also add it to bigger automated
CI, but I expect it to do just fine there as well.

