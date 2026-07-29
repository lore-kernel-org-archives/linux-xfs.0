Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AA448CD68;
	Wed, 29 Jul 2026 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785335320; cv=none; b=UUFSmSiQ8C+OTTJ2COLxzcKg7kENFedb6F9ZjjitIomt6ceDwk0pGrHfK6vAY+lB1lIFV9u4ohkj+i+If8SP6n/CzfKOhlGn3OKtuYaLhUtRTZZ5aRstxGfJmydHVDSgXvw6qUJgCpI50TnN+CsCXSRrpjZTv6LYT6CC4hcKkcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785335320; c=relaxed/simple;
	bh=6q3dudzqLcXucHjNmfXCEcKTm3aAQRPJOKqPqpbb+b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nI+uTXpxbeEkTQWXAvNpRc7Aq9ugjS4pB7/7uigNBSNcXq9IcSc+fkEJmDdBYtxR1wAJM5q2b0lHctPtNuL6jv80qK0MzScd6sHn+7snUa+46jZSncv9LvrIb2WEoxSXwxNJ65zv4lQpi7VcSPozKuAlXMktkTmdpSb8yjdiGag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fyBmHKj0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fyBmHKj0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d1XbhqS58zWGKwcY55TcrGACO7nCpTaK+DpAf+RyjMo=; b=fyBmHKj01lPa3V8Ns7pojb2wAN
	NsMls1BGQOQopCzIqm2JBp20VaTv6D7AHCQZ9pvA0EWAeWUBkcQJcB0iQeRNt0Nc3fyDpNYTpDAkP
	5yFCgIFLeVFdcweDTv1frD2ot2VwpCMDbXxyPSFuQ3U/QVlhIOXI8NmXDVVd0M3tXqllfLOBTNSqN
	1uHa9FE/BJ7DimqSxmd6C5BEMRfqcvrOT+FGGOUaP0ZGZx2RP6dB0/0zfWDB+ekqzuiOK+8+sDZv5
	7nkas5c5DIpCaWd/mGhEdWsJ3nq/770nfrl5UI8fS2ed7/2DabY95ebvp7AbB6zCCQtr2jXo2TB3D
	TqcGWKRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp5Gm-00000008GFg-0ejd;
	Wed, 29 Jul 2026 14:28:28 +0000
Date: Wed, 29 Jul 2026 07:28:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hongling Zeng <zhongling0719@126.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Hongling Zeng <zenghongling@kylinos.cn>, cem@kernel.org,
	dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix fallback data device flush for realtime inodes
Message-ID: <amoODOM31YmofPlR@infradead.org>
References: <20260729073918.64505-1-zenghongling@kylinos.cn>
 <amm6-JkURolQqXDo@infradead.org>
 <6A69C0F0.8010206@126.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A69C0F0.8010206@126.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 29, 2026 at 04:59:28PM +0800, Hongling Zeng wrote:
> I understand that for realtime inodes with a separate RT device, the RT
> device is flushed before xfs_fsync_flush_log(), and therefore the
> post-log fallback path is intentionally limited to data-device files.
> 
> The only case I was worried about is whether it is possible to have a
> realtime inode while mp->m_rtdev_targp == mp->m_ddev_targp, i.e. the
> realtime data target is effectively the data device. In that case both
> the early RT-device flush and the post-log fallback appear to be skipped
> when log_flushed == 0.

So the internal RT device does exist, but only when using the zoned
allocator.  And the zoned allocator doesn't support overwrites but
always writes out of place, i.e., every data write must log updates
to the inode and bmap tree from the I/O completion handler.

That being said I agree with your that the current handling is
inconsistent.  Maybe you can update the commit log based on that?Also
maybe rename data_tarp to something like file_targp as data is to close
to the "data device" name for the main device?

