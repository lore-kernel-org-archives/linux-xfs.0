Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BDF3101B6
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 08:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583394; cv=none; b=jP08eRTEi3lxdy1SL7KEn2uWfjzTvzvM/GCD9H40Zrey6cuUFGKqFHVjYePlTuEKLSUjlIkWmly4dGqDG7cMvhXoCNmGk481qxXKOrQ784Duy48spiuXuQuTtASxBBbSYMIpJ9IfkRipImIfbkrpY1gMzwu7GPcnsgL+D1jcB6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583394; c=relaxed/simple;
	bh=h3lGoo9ghQCvrJ89suS6VpSL+SPgsZDOEvcuxkNEwpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUlL1jg2JpPVFq9zb0iX241G34FFEQBqs0FvBQ43Q0TkppU6xf1RhpXzoUwn/AMaUlcRkfYzEqYG3YwlrMAU7fwD9CcXByXUYKlJqYHK8EdDhLrTyCSDIvt/pSxj73/0qFut0oBVVud3/WW4Xl9XoyxNI9XgjssHGzr+icurCcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SwWPowyz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SwWPowyz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hSYBnvHT0JbKASqBnhHKaGtkEmtQ62Ic1nXDsBRXucc=; b=SwWPowyzhJEASP42w3NRM2BjuU
	Y8Ke7e/iWWg5YcfC9nBgtlvAt1n48NfIPcj89sUEgcxJwofmQ+isCUMeHPQJff+1iyy525aZlukRb
	+x4DWGaYeHHZftWzkPAwK6s4/00Cgj6jZLTV0V4GBFu7u3lQpKsiT7AUIGfS+qatTXk40ZlYMUfir
	idCC14i1h3EcTFTcjFFXxKaY6lOPVPbuTuwSOoDEtbRogDvwpn1KyzFxjQV1E4AT8tHZ0fsipg/2V
	gLxkKR2IKmHl64mwC5YlP2Fp6A97UVATmUKwS71dHZdLgSwyYudBpGxUyIcv/yMRz5XyRuHg+Ptyn
	bVJ7621A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6XI-000000003M9-3aMa;
	Mon, 28 Sep 2026 08:16:32 +0000
Date: Mon, 28 Sep 2026 01:16:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH 0/3 V3] libxfs: better cache allocation error handling
Message-ID: <aroiYIl-CQ34_qee@infradead.org>
References: <20260925194535.397036-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925194535.397036-1-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 25, 2026 at 02:41:42PM -0500, Eric Sandeen wrote:
> OK, 3rd try.
> 
> This is to handle an underlying problem that an actual ENOMEM cache
> node allocation failure is indistinguishable from "current cache full"
> and so ENOMEM may send us into a pointless cache-expansion loop which
> ultimately overflows the cache size variable, rather than just reporting
> the bad news up the chain to callers.
> 
> Darrick suggested "I think I'd almost rather we change cache_node_allocate
> to return int and the cache node as an outparam since we do that elsewhere"
> 
> on the last review cycle, and so I've done that here, I agree that it
> is cleaner.

Sorry for chiming in so late, but wouldn't it make more sense to keep
returning the node, and have a bool for what to if it is NULL?
The 0/1/-errno pattern already requires a lot of attention in the kernel,
but in userland where we have errno and -1 returns that are usually not
specifically checked it feels like even more trouble waiting to happen.

That being said, the changes themselves do look correct, so this should
not be a strong objection.
