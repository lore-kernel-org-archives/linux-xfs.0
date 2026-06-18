Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496583002A0;
	Thu, 18 Jun 2026 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773694; cv=none; b=unAg17JPJCOpWVwjdvUFXO23nZjZ6VlHptO/fPq6OmLQOxcFvkcHdeixIsYg/YQ97z3iNPWJmbsrOtCZSBpylHci0oShVwGIPt/jEdL3yE0tRalvJzd2QMEJjDQWotPpxUAgpHCn5NWZczc/GH02VUt1Z7+ZIoFsc6GOd/hJ3zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773694; c=relaxed/simple;
	bh=gfSrckcHQyoUgjYKDVXmoh6mLVyEiDdBExVER+swGiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ikpxH+mzoXoM6QVdf5YURvVkhKXThVu0u4bXdGUWTYj8SptGpzVAzNaHU164qw1+zn06ZE9AJG6/zSDhonjTe3h5W+jIynSVyiJTxhD/K/OU5sPQ2ka9SeldPrt+0Nta9yIug9LyX/Xv9LyvHzqOjlgu3dGTli93VEVSd+4ONeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=au3NywWB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="au3NywWB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FgcTKf0RyLC5PpOE8rfAPR/SwhzB/QavyW3YdrbgiQk=; b=au3NywWB4QwXWyseo5vvCjbgwU
	NENJ8DtjHQp+Ub2Gi8TXqTh77HzWMxVjMOOV67kioFFxopngljT3ILuw779Do2yjMbUzWx6YbzTG/
	TKgFpkRVQVtQmmsTu2LwgDC+VNWSPEfUWf7SMsqzSWYoB3kPpWu+QcBmBL85n/EKLnJn6dfqF7MAO
	7ASOtrJY80d+kAc4gOt3eiqaBhgQMrqAEFBJTEuGa5iill2l8u6AA7HJb7MipIZspadnv+loc+JKz
	NMSu/MqiVr3fgE0ESCWkm/pfcuFfCkmfFWoiYAtzYQQpVzjcb79dl4htDeHXhyWt1EmrcX8nF1Dzb
	kDeWf+Mg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wa8jM-00000000tuj-39Eh;
	Thu, 18 Jun 2026 09:08:12 +0000
Date: Thu, 18 Jun 2026 02:08:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Morduan Zang <zhangdandan@uniontech.com>
Cc: brauner@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] iomap: guard io_size EOF trim against concurrent
 truncate underflow
Message-ID: <ajO1fOJZlmICeSAv@infradead.org>
References: <863D407CB3ECEB04+20260618053820.506635-1-zhangdandan@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863D407CB3ECEB04+20260618053820.506635-1-zhangdandan@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 18, 2026 at 01:38:20PM +0800, Morduan Zang wrote:
> However, ioend can be created before a concurrent truncate shrinks
> the file.  In that case, end_pos can move below ioend->io_offset
> before the trim happens.  The subtraction then becomes negative, but
> the result is stored in size_t io_size, causing an unsigned wrap to
> a huge value.
> 
> A wrapped io_size can mislead append detection and corrupt
> completion-time size handling, since filesystem end_io paths consume
> io_size for decisions such as on-disk EOF updates and unwritten/COW
> completion ranges.

Do you have examples for this?  I.e. did you hit this with a workload,
or did you just look over the code for issues?

> +	if (ioend->io_offset + ioend->io_size > end_pos) {
> +		if (end_pos > ioend->io_offset)
> +			ioend->io_size = end_pos - ioend->io_offset;
> +		else
> +			ioend->io_size = 0;
> +	}

I find this a bit hard to read due to different paramter ordering,
i.e. why not:

	if (ioend->io_offset + ioend->io_size > end_pos) {
		if (ioend->io_offset >= end_pos)
			ioend->io_size = 0;
		else
			ioend->io_size = end_pos - ioend->io_offset;
	}

