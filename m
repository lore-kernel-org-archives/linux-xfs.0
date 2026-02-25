Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C853D1CA7
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041931; cv=none; b=eCcLCqkKD6s28WkiE3hx1ciERorHREiqb2MhRBYBbUTcLs/mG52SCYZnMwmrdIaHquSxg+pl9ifWXe5vVq+NYDKKHTM8SkTYuFZni3qQ+P039PUQ0zVevojwpIzWtZf/4ZWUaiq6vxhjUcABUw6ChyIIH4meP5s+xWHR3ObQMX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041931; c=relaxed/simple;
	bh=HBCRkLO0SLuGFTH8/Y18hc/zBoDcBkYC95IQYQBVyB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ouf1WX+nbvOZ04eH6PNNQ0PLHC9Nrhjt+zIzZiZGgYnjGYaqRgXtJYsM/V04Dxy/2MfaKpxS7daZxutLUOKVjSktGScXfcfP+AF/LEC1txk7eTt7tSzJlUPAjBf5V18pa9N7z5g824ftUlX3IOmGA2w1oufQK8YcK895H7FXm6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WMexfqvi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WMexfqvi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9Tw7UXzP1TYPAi8Q132xKTrgw+Ok5561KXU53Jsj6G8=; b=WMexfqviHZJiq2U1Wt3nlzr47k
	JTtBpq7jnOxcNbSL4pJxPTVqiZfAlmbzikvn0PMsKVFbUaydE8BVTSi9Phb3kmzneLO42P24gMvBg
	GsqAaaYuE4wmSkA6xgmPHiIC7TiwxsuXnJAcikL4kO09pGF1pf/Z3Hv81FgfQ3Fbe9nR+jjZ0EjXt
	hvxozXZ1vu/YvTcvO72VZZvUnCgGIDTC4oPD67an83gwmJsLnaXJsniZIFDpkdtvBtjrtz2b14Ue1
	xtmIGtqiuXZR84eq80kRJW48XIkqdX331drTvU1r9AE6xT9Sjy+ixLk9xgGRYpCKuzT9rRAAYVxS4
	UgZeaS3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvJ3P-00000004hAS-2Qs2;
	Wed, 25 Feb 2026 17:52:07 +0000
Date: Wed, 25 Feb 2026 09:52:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, cem@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v10] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aZ82x5UQWSex4AWU@infradead.org>
References: <20260225083932.580849-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225083932.580849-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	} else {
> +		if (xfs_falloc_force_zero(ip, ac)) {
> +			error = xfs_zero_range(ip, offset, len, ac, NULL);
> +			goto set_filesize;
> +		} else {

No need for an else after a goto.

