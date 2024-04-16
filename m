Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB771539C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245727; cv=none; b=BGj1NtBztRDoNjV+ZVlcCol/cNIJw0RIGZ5WPokNDN6fefEK9HpuaVzwBJ2Wxm6AZ11jzsYUG91VIEuzB7EI7ecAWHlEQLDbNTPXwj4qh74pA6rkFsRYiMquRNft+D43IXZr18pfYSunSyVwR/Fq4e2jEOSudIFTQN22gj3i170=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245727; c=relaxed/simple;
	bh=xtnfvRZ65GpU8ESOOeVjiJCeEdWxB0vdbIuCthyS4Pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dYC0WfVahE7t4/Fz1vi3DAiHNyYzFDbxd31Frcmqdw6OklVN+KGUnFwaZ8xqAXvmHgJfThTgGm5Qv0lN/ih8KAIU4vGCdtq+SZYrGOCq/zVsAyV7saZZXoXMui1DZYbSjVX6iCmmDiBTH+ZGqw/T5SZRz5PKNj7KGfQxj2eKGzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VCB4fX6u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VCB4fX6u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zow2g9/N87Wttv4KOQw30gTJPn2ViZK2/R+Zq6j796Q=; b=VCB4fX6ueFDOhMQc3S4wwHphn7
	Wxslw5bqCW3tbIvGdLMfNTcKB9fRKKZIUDpHOovNtUPOnkvbWcFhBGrMY0Wm9Qtq4Y0SkuLr7UqZb
	1uNfQMd/3zlndZ3+Tvi7OEaXoyVZXtpMjgepHZ6SGZJ4MNXoegI8GMvni6WlrpugT4nunigCxWsj5
	m/2mhB2HQbQk0iuhHCDJnz/oj6W0koAOipHIbNzZ3tb3K1783voW+aoxRMKUW9jv6D1tCaEhCtV8p
	Q7C5aWEfSgqXTR1r7K28qTmzXb0QPsSP40C0/Ui/WzaxpLB26Q+niTVkigb2oLh5e2tIpg2Cq8nto
	oy2Ak3cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbTa-0000000AwjO-1HW2;
	Tue, 16 Apr 2024 05:35:26 +0000
Date: Mon, 15 Apr 2024 22:35:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: Re: [PATCH 4/4] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <Zh4OHi8GI-0v60qB@infradead.org>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030309.253873.8649027644659300452.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323030309.253873.8649027644659300452.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  out_free:
> +	/*
> +	 * If we're holding the only reference to an inode opened via handle,
> +	 * mark it dontcache so that we don't pollute the cache.
> +	 */
> +	if (handle_ip) {
> +		if (atomic_read(&VFS_I(handle_ip)->i_count) == 1)
> +			d_mark_dontcache(VFS_I(handle_ip));
> +		xfs_irele(handle_ip);

This still feels the wrong way around vs just using IGET_UNCACHED?

Or did I miss the killer argument why that can't work?

