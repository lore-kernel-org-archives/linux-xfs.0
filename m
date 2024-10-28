Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4F615FD13;
	Mon, 28 Oct 2024 08:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730105114; cv=none; b=Sy0OgSF+hI/g+7Y0FOOWKxJ2ONSIwwajEXOJBrh3i9IzwOMvxSIExorT4cxMNW11w64XEMOEFchYLUHzUAxBa8fvrCs+WFbsJoF3qe5jUbRw6SuIUfYnoHI+lwnTZ/3hzrxoDSAjurnVmISwWjgEYnkuRKbXhg8u3n/2a8G6STY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730105114; c=relaxed/simple;
	bh=2Zpwz2bSMR4LVd6OXxJ3lWU2+EQOin0ipABjS29982k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ux7x4vvLsXTc4ODM4O6R5VICRadTsNMY6giHfx5xPeE25yLSLYBWs7yIIqs46SYQFZdJx/jnl8+HEImtm6W3SA8QsEAUeV0afIoHGhCfbNPK5i6Az0n0p6BEmYOAwdthAod9B96KLAE8WKGEiJLKlLUJa2Va5uu39/qNI4ucPq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ez0RTzPM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ez0RTzPM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LM3SYCDeYjDLgANDqKqIzT1gYFKc8DY0PdeRNcAFS4o=; b=ez0RTzPMnSvY6DR0JsKtgHNzXG
	MXdLYoPzKqqwGWkSPAntNLPDG+mnPVRzBlkvsxfvhIDKgyGwUOMgqH1/7DxKVZ1TSOvIYvhi0X0G+
	Areagl5lI2BZDKJfNvc/Eg4Ec1nim6NUVsIDyHctPPFlc/SIT+OR+mA7O146aRBsvoVuOBqNtokMO
	H5XcKurq+1cK+zD/99lmNeOKrMK1EiL9Si7lY2SHn7YUFA9bq4Y8VMzJNAfNHWcOI98Gsi/cim8sk
	xpKAHaRGZGz8LjB4bRPI1+9ifFxkgfj3ncK8DCCR60xD04masFjAzSOtES5lIJ6mQDMID8ulxhQ1J
	M5qpoYPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LNA-0000000A8Iy-1DvS;
	Mon, 28 Oct 2024 08:45:12 +0000
Date: Mon, 28 Oct 2024 01:45:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: notrun if kernel xfs not supports ascii-ci feature
Message-ID: <Zx9PGD6m8ySNaXSR@infradead.org>
References: <20241026201234.77387-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026201234.77387-1-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	_try_scratch_mount >/dev/null 2>&1 \
> +		|| _notrun "XFS doesn't support ascii-ci feature"

I would have normally expected the || to be placed on the previous
line.

Nitpicking aside:

Reviewed-by: Christoph Hellwig <hch@lst.de>

