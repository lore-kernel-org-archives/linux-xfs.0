Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB0D3C5857;
	Fri, 25 Sep 2026 04:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311741; cv=none; b=j5ZonywCToIpq57fmUufx4T1nP+kytSUYqejvBZFsgl42VZS2mVaO78PNVZU+bJXxNmLh50fl5DhyMQkkBoe5vdpus+p1ezSVviaNZdccEKYziiN98MvR7HbGJKRxpNMLKBjBMceu985A3LO77U5z2RHOwa4TImBh4h+QhGMq2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311741; c=relaxed/simple;
	bh=xeZMm00cq1ucAu0NBvg/3ZoA3JT2I574LMpHAhmS5ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=keNQuRFwtzCZJ9dfc3MAMaD8lZx7hNtYA0OMBa23GYmRo5CyxQzqDXZwpSslOsCNjsh/xYxqawLOy1Td7v+P+RsYecxIAR+eeeMDmjjqY4U9MkLwbvbqIg92CN3ZsUSUzI3Irh6bszdr+1QhHwYldEgUEVTgeq7KZAwIO+UPCfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=au56LCcq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="au56LCcq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GsoRQ0uuAuufBuo10SyAWxiYnMHdCRwAcrXikpluL5g=; b=au56LCcqbjnCnvnan0F+vvdNh4
	bnaslkBOTVJPKcPp0h2zoQQK3YxvRzEy2dRVYOhYoUMrqg5mCW0qwwgnX9A6JHU7UN5KchTkfVhKC
	buaSsDFT08zAzq72gQsL41w4SH79nzaA5ft9SHzJ5qX60BTQNww813Twn52s33lfYW4KXj1sCN1M1
	FLj9sBdjzhY5f6ZrbEQ4+LkF2k6ztDkAAJKXUyyXtkaqeaVNUckujOP9oLmzbLCJGuvOjNyouargO
	ZZrvK1O8DiWCoYyHm9NgDPHKkNspJio3sQGLPW+WOaCL32Xw5tC86oygG2d+Y0jQZvD05FmQQaqzG
	xzFqMsLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9xrj-0000000Cd0b-30Yu;
	Fri, 25 Sep 2026 04:48:55 +0000
Date: Thu, 24 Sep 2026 21:48:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <arX9N5ruzSmp7bmJ@infradead.org>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-5-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091203.198225-5-parri.andrea@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
> -		loff_t pos, unsigned len)
> +static void iomap_dio_zero(const struct iomap_iter *iter,
> +			   struct iomap_dio *dio, loff_t pos,
> +			   unsigned int len)

Please drop this reformatting.  While not all of the kernel agrees,
the two-tab indent style is technically much superior and we want to
stick to it for iomap.

Otherwise thi looks great, thanks!
