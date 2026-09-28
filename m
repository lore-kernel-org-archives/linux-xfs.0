Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E1E46EC69;
	Mon, 28 Sep 2026 08:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583049; cv=none; b=E9YCghEPDOG9khkO+j6xI2sSZHCrGxV+VPRFhMV1FtcALbhF2Kw4znl6tx1/pXIoRa+r6WnUynG2Vy9ioMM3zTxTrIHxDbuKpf2Ru/96XAcTvZQmJ47uwBacH2XLyhYTBEypU36oL6GH/3fMiLlTn4FZ9LlvwNJV3F6sYm9Og5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583049; c=relaxed/simple;
	bh=H713CJxMZT0XHn5MJAfJ32enxqxfwl1eho1k00oO23Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpLVdz1LOEqpXZcTLbqKX0x9n07qyoyFAdHn2/zJu5/ih1IzbbBEVnTlRk7jXVVWzXGdzngIF9ONb8DEkoe9+7OqzRZ/oLGa3z/Rhwx5qkxpI/XaBJmEJrLUAg4wO142P1FGHLHLPr+cOPVCOKUmkFFQFkBR4JeTgUywuGLdjWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2zVVmB9i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2zVVmB9i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WEPVcTnKuHw3XgoOCZuQeMOjAvsj66bSu0LxdlPGsps=; b=2zVVmB9iFox6UEMr4OUaTcrpgj
	Os3VqD02LBaXn3geqj4XOtlQGVdHjH0KCfTV4qpTUkQwA1QisO/xL9LDZsCZNlqpiCxvZ/tijSUuK
	Q5qvaHCwst0R2f0b31wByl2VMRQwglxLHilatZBsAz8QoeP9D+2Ls6wSBsYo040Ni+N9uOLXxIGjx
	tvy/3NE1JFYxG3by4Mmx+dzm78URuXpkWEsKGpcd0O/XTaLDx+rmGMMahm2YlcLOk6YPPTloL5uV3
	+7zO7QVpF4JI0OP4gKDnXQKd7b1a+mgs/NnSONtYXLtWJ173OwUt/QRVyzMXQmGzKyxBIbFNqSurx
	VKnTHe0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6Re-0000000025q-2jh5;
	Mon, 28 Sep 2026 08:10:42 +0000
Date: Mon, 28 Sep 2026 01:10:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: don't fix the directory tree if live update
 fails
Message-ID: <arohAkVr2vD6nKRT@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612852.479634.517512730050227315.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612852.479634.517512730050227315.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:18:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that we don't double-check dl->aborted one last time to
> before committing repairs to the filesystem.  This is important because
> the live update handler could have set ->aborted if it encountered a
> runtime error.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

