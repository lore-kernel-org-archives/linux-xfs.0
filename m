Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CFB3CF02F;
	Tue, 16 Jun 2026 05:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781587140; cv=none; b=N2e5ZH9IlD06rozCrnhSQPqGT54N8oa2dautpFSegn+f12piPbQUhXRrcu+N332nBNpUAiqPLrgnVRoKF6PW7Kmkj8rAhtN87Tqpd4079dwNc4dhn30kShorRcAPNx2VFDVOu6guAT3JkEDPzOOJFKztzlFQRTDNB7E6YXSfEM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781587140; c=relaxed/simple;
	bh=auJWAW/KvLjl1iYvS+m6yiX3/vFiUXgoXHpUHwezcbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pt/Xq9fGUt9BN4eaE5Idoh1/z61pE9GpD88FUaMo+Iq5vDYx+YjfbjNFbTsXPIFOKH2tkQu7kRW98/jM4wzTtQO6URwjbY1INQNMYuA9t/up9MlS2W2T6xZR+oRCw4rtd2Ylbe1XycxoNmTeOoSLRiRbFTRNmdeZQh7gpatWAaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mwXXOplr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mwXXOplr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gt+vcbhrtqJ+O1ShQXxtiWR4nUZSmr3RMSGrf3Qsazk=; b=mwXXOplr8MbNqmgwSK2mML5q/c
	QR8dLeLDhzGIdVyEcRqriP41CERNhXbRcErG+2rWrttuqj8lPd7mzwNplY0sqE+V+xeIywBqP+qlx
	4ukqrOacpZj0XBtnfpVla+vd4mg8NPZ3AtOld3YQWmFj5ePoU/RPPaZLKH8cnzdWogggv1nImdxAz
	uQ/13pJ5y4b5aWLrhAueY7XxbLZqllXKFHmx6Q1pUN1eL4SELys8Zpj9SFcHytyHp/UY3WDdyjO/j
	O3/eWcBmiv7oEppq0OmYxEIHgybV4eQY7H8t9m3OnEPxCp+jGRUpgjpfUl4hn2Fwqmttgi9cok6l8
	cC/BLWZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZMCP-0000000FF0V-3nWB;
	Tue, 16 Jun 2026 05:18:58 +0000
Date: Mon, 15 Jun 2026 22:18:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] iomap: reject NOWAIT and BOUNCE direct IOs
Message-ID: <ajDcwRtWIao-T5NM@infradead.org>
References: <cover.1781253428.git.wqu@suse.com>
 <3d739b6dc37e34ca2a2a3780d12d0288a4060d57.1781253428.git.wqu@suse.com>
 <ajAU1yLd32BCiCNj@infradead.org>
 <efa3f1f9-20c2-44c0-914c-5e34a40235a1@gmx.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efa3f1f9-20c2-44c0-914c-5e34a40235a1@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 16, 2026 at 08:13:27AM +0930, Qu Wenruo wrote:
> It looks like NORETRY can still sleep, thus again breaking NOWAIT
> requirement.
> 
> I think you're talking about GFP_NOWAIT?

Yes, GFP_NOWAIT would be a better fit.
