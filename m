Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF88F513;
	Fri, 13 Feb 2026 07:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770966797; cv=none; b=GUQmex37Q6zdErL4y0+JYvp4M7CjTvA7N2WFeBoXIfmA6x9sTZC0ukHnBiMMr/Dp9oGXAUq88FSB0fgutEOn6taVI9T5gAroP0k8uQ+S0tMvyLhrgcOUsfqPo5E2aawhBFJHlyO7HZ9k3LHht1RtKv813gERyqL6pmxD3nWGwlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770966797; c=relaxed/simple;
	bh=ridJfcppgOw5+wpXl2qlGnbRAq8TgCzZpkwK1XdMNAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6jDDoDUfJmmk/j9P+n9fA3x4qm/Ujwjri35xMcyRk54981gaLL0Ieaft/mJ60r4hvdpRZ+dLYiW+yjCcERrCtWKDt5m+yvWXzjbdFA4rJyO+DUowPLJ713Ih5BnEgTvbzYrqUoph1O/b+jHJS1KjxBqufk++kr2TOcyXuCUYD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tmEL4sdP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tmEL4sdP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fr/7vbjk2VgaMiCyzktoHbG4J5+qI8tCe1xARnKsQT8=; b=tmEL4sdPgilGtQ0TACN/kr9avU
	pBi/6rmH2AIElhvp5cB+BaD5GCbytSqqujBqYFmS8aEoo9N9Wk+FRbdOfqQ0ZhQTqgRSIW9QSszp8
	95+WJGfIkBmWNkzCDdmO3XXABjE3QQz8zTAUR01jRUbyJQLBgjf3uSbB1+iZC0+7E2Fi1VUxo3y2Z
	Q4ZCmapd0pqgXzJLlJoVFCzvpJON/LvtyEQly23aE9E/ZfkYXq7Oq1ab0f05hvoRW4IDK/ltzoQcx
	gFGLjIq1KYoe/Lz/0b4SxSKnwgh0pIB40LpE79CaXRJzWeVnCukfe3O2agW4563PIsEXkR3xfULmK
	gZyJj2Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqnMW-000000035cC-449U;
	Fri, 13 Feb 2026 07:13:12 +0000
Date: Thu, 12 Feb 2026 23:13:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fstests: add _fixed_by_fs_commit helper
Message-ID: <aY7PCGwxpwxx90yW@infradead.org>
References: <20260213070148.37518-1-johannes.thumshirn@wdc.com>
 <20260213070148.37518-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213070148.37518-2-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Feb 13, 2026 at 08:01:47AM +0100, Johannes Thumshirn wrote:
> +	local fstyp=$1
> +	shift
> +
> +	[ "$fstyp" = "$FSTYP" ] && \
> +		_fixed_by_kernel_commit $*
> +}

Minor nit, but this looks a bit odd to me.  I usually prefer the
full blown if:

	if [ "$fstyp" = "$FSTYP" ]; then
		_fixed_by_kernel_commit $*
	fi

but if you want to short cut it, just put it all on a single line:

	[ "$fstyp" = "$FSTYP" ] && _fixed_by_kernel_commit $*

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
