Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96253DA7EA
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2026 15:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326991; cv=none; b=TBCj83jH15ccSsMTatlsrqJJZPdp1n3ZEow89dQLETJ0PmAcD2wIZQW5t7Hsx0fvXTJcq71+Hk8hVpA4xAAXj9fYjjaD97q1D5q4tVvCVdcIQ2BTwhaiyzlVouAQBCOrbliHcDnahVsyIiImXslqrSgIKubor6KRkHODjUQtsCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326991; c=relaxed/simple;
	bh=ERuBwiKA7cNOxPGa26G/eiFiuszJdqd1F2QBLZJCA2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CcQijShWiTy0RVZ2ofGrosRSYBfqas+r9z/jbQWPySUsSkXYiI+Dp1dLmgTYGUSgcn/pS8dvDZGkrcO9sdD67dmGEaD21csuwwmkY7809LfUcxMjSDSDjzuCNCtSIDmmCho3vjcV+zwTQllSPCWcisqI1O01+jRUWKZira7BrVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ECO1cgQs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ECO1cgQs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=btWzzYZRmTuSRiItw9DYShXPZbaWdufGunNUJULJPzI=; b=ECO1cgQsiFYiuwU2PB+UoZksHj
	dS7CRRj+eZB3GJCMTH0A6foNljiDVP0+lNvUp/YVjjdGk9r3JA4PQBh70CYKfdnt4QbVFoh9PfQuV
	NHq7GTshApy5IoZPA+MYtQytPRiLs8y9BFOeeXxQYNYC6KqOBh0UoNh2KCi4f11ldScQ2jYkfYMla
	UCXX5YPM3/NSxiWz5uA1yYhOkQXrZ2bIRGsqrRejq7Dib3pgnWI3cKQdS1oNCm+Cz5TgyUp/DR+ob
	EomMNFjIscJlnQ4bEdRsqEUJv0PfdJ0rPJ3P8jNWoVhXsZafFx+nGeG2T80VCxZpNTXZqevn4uOYf
	8BdgyYjg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU4NO-0000000BMLn-3XZ0;
	Mon, 01 Jun 2026 15:16:26 +0000
Date: Mon, 1 Jun 2026 08:16:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Romain Naour <romain.naour@smile.fr>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: include/buildrules: fix ltdep
Message-ID: <ah2iSidP71J0jx2H@infradead.org>
References: <20260531194553.1378795-1-romain.naour@smile.fr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531194553.1378795-1-romain.naour@smile.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, May 31, 2026 at 09:45:53PM +0200, Romain Naour wrote:
> Unlikely the xfsprogs build system misbehave when a directory in
> the path contain ".o".

This sentence doesn't parse for me.

>  .ltdep: $(CFILES) $(HFILES)
> -	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
> +	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o:,\1.lo:,' > .ltdep

The change itself looks fine, though.

