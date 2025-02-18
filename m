Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE3C14A614
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739867462; cv=none; b=mwueaNVSIwMGiE27V8eNA8ycA75vimv42irXDIIoZPgWCynvXRfY0Klz/NF9uzmv4aCHfEfZaks5oS6xiPBk+lUDV4SS5YUTwSRSsJK3kIPc9QXWXgP9RMH6N0RvciBdS0zmJ6DlzxOB8RBaMI7OUgvqBMUIfrFi6RfZNTNWyt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739867462; c=relaxed/simple;
	bh=9VtGtvfK+7UzennBQPH/y8QET6S4ivcT3jIgw948x2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SotVARPD8xM3thV+3xpsxB4Xpo2BULOuPn0EL93Tt6aP0CU13IwzEHr10shWKJ2VEUvlNN6LnSscAT2KhQhfbjhOJLDc6nk3jSUzAaIPMs0VcDp4RT/IpLqbKdZiKZXQsViENgt8p93njfciL4BVCrNKpO5MpS11BYLFagsNKu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ft+YSrGL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ft+YSrGL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=yOTi56SfhhNFwDe4d/KIll5p8ktrPz80A3kxdYRZp/c=; b=Ft+YSrGLOphknqITOuLEzPx47O
	YTwUWx8RlDw6aphRneoX5VgYQxblMA8TxZQAiLI4J7nip25xQfydQIX2+21x+Jw4pJCKDie0pOuhd
	J2+S5secjUFGm2EyyLFVptS5csbx+j6zEiPhtkQbcPtuQ4degWhlRvtOpl1e6/jhlDfH5FDpul1Ua
	ngBQDqpGotWTb0fHNEVD2//2tpBKkv3OM8A7VQjLcietMlE9813KuFMgDK1qtyNu6eZkaw43NB0n8
	wrf9aLCBCY1xrY1DOA7tFH4dEKyIDe8GtUWCL1XQcMNIJZaO4OUkwlMpFhvgjbqtrv+b7Y+0tEDIH
	K1abrh0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkJ0L-00000007ILX-0aTn;
	Tue, 18 Feb 2025 08:30:57 +0000
Date: Tue, 18 Feb 2025 00:30:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <Z7RFQQoC5J7Dl6HC@infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <Z6WMXlJrgIIbgNV7@infradead.org>
 <323gt6bngrysa3i6nzgih6golhs3wovawnn5chjcrkegajinw7@fxdjlji5xbxb>
 <Z61wnFLUGz6d_WSh@infradead.org>
 <hljsp2xn24z4hjebmrgluwcwvqokt2f6apcuuyd7z3xgfitagh@gk3wr4oh4xrt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <hljsp2xn24z4hjebmrgluwcwvqokt2f6apcuuyd7z3xgfitagh@gk3wr4oh4xrt>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 13, 2025 at 02:26:37PM +0100, Daniel Gomez wrote:
> That's a good question. The stx_blksize field description indicates the value
> should be referring to the fs block size that avoids RMW.

One that is optimal, the RMW is an example.  This what Posix says:

blksize_t st_blksize    A file system-specific preferred I/O block size 
                        for this object. In some file system types, this 
			may vary from file to file. 

> So I think, if devices report high values in stx_blksize, it is either because
> smaller values than the reported one cause RMW or they are incorrectly reporting
> a value in the wrong statx field.

Or it is just more efficient.  E.g. on NFS or XFS you'll get fairly
big values.

> The commit I refer in the commit message maps the minimum_io_size reported by
> the block layer with stx_blksize.

Yes, and that was my question again - minimum_io_size for block
devices is specified even more handwavy.

In other words I'm really sceptical this is going to be a net win.
To win me over you'll need to show a improvement over a wide variety
of devіces and workloads.
