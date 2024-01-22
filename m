Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20838FBFF
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 06:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705905665; cv=none; b=FUuKffRnMzUaWjBPW2A5upbxLqRvvg8tcg7HpfeMERNJq8MuKvuh74LYigEEA8w6/+Kuh4cH2oVj+2N+f/qEVR4IeVZfS5p6Zjn1VcZixTJ/za2YlITWOxMJA/FMr+lKcB+4KdF2nJe8kjy/37d6SED6uXqA6s62A89IzF7eCxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705905665; c=relaxed/simple;
	bh=JyLVogNGNZ1BROULmBv7h+zmh6r0U05SHTnqZnunzMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnqE/XHt4F9bP+V0GQvj59mao/gTo4mPBgtYQyihCyTIoDLyOe3X0nwGyoiIipBGNA+oOd3WmG3Dm1IfbLrFLgoUb0hU+b8eOSklahQFr1rAmVhjr5jLH8UmK1av8aYmyhMl3oho4/8ISh969COryBHBloNNqRixBhe+ZcPCYkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WipcF8Vy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WipcF8Vy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JyLVogNGNZ1BROULmBv7h+zmh6r0U05SHTnqZnunzMQ=; b=WipcF8Vyn/TFv3DIkIqgvhNyaC
	7TjSs8wU7IijGdo4sTHhtvd68furHm8JormEFIpnt1lpTmpnDQVCh65cCRQ+MVDX2/er3QH4/t7pb
	gGDtnzyqswFyFoazLreku60HOy+HStUxfFXrR+R1WU7ZFC6mBySMNp7xMvOgO26w54KvAmSDIwIOt
	vpt/6BoeNfZT6ZMqI4waE15E+cCpJUhrfqkrxT4zd+QLxcqV7pQs+q9SllO74nNGmvQ9YAJc3lON6
	uuj6siInUnnlwVtK7IH2X7hAhNZwMMS0OO6TOUbFocLqy/QAILJP6EvT8LR6pDTVK/lUraIIY3VQk
	ywv5i6YQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rRnzT-00AlSI-0S;
	Mon, 22 Jan 2024 06:41:03 +0000
Date: Sun, 21 Jan 2024 22:41:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] xfs: unmapped buffer item size straddling mismatch
Message-ID: <Za4N/56HM1nEZ87K@infradead.org>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118222216.4131379-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 19, 2024 at 09:19:39AM +1100, Dave Chinner wrote:
> Whilst touching this code, don't bother checking mapped or single
> folio buffers for discontiguous regions because they don't have
> them. This significantly reduces the overhead of this check when
> logging large buffers as calling xfs_buf_offset() is not free and
> it occurs a *lot* in those cases.

Nice.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
