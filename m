Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B1A3CB55F;
	Mon, 20 Jul 2026 08:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784534406; cv=none; b=tueaiMZzHNblCY7U/Z+2D6sHmjKovV0kn/vKyTa0GXpXbGtN9Nlx92q6XATc3HdPM4S7rQVZjtpxLS+MB8y9b8Lwt+74JeYJXUI7WOlNd+hkyqol5Klr7ylGrgBB+/t8qFogl2cDGCiUcis7FXnb5LVXHxnOAq0V8yWyke0ly30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784534406; c=relaxed/simple;
	bh=WvvFuA+VaRjOMPxnDzpjfzaecfdBhxXXS52lLscJPXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQLuB2w4jkjG35DGQwej9yg1C08HDfhCOsgrKfea2XfwQa+ulKyKtYem8VDzESGe3rB7ittGVSvYLaSY5B8SVwFxzUsoXnupJ1xBcFeAwWCZSjofrw/jXeqT+t7X+MtBU2RpQWkf8hFoi1SZXIqLEmra9nyCxq6DDqRKuDGh118=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XHPhbCk4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XHPhbCk4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l4jJC6ImrAi+dWTM73+51sE3H9Id5bZPLlTG0BgQIXM=; b=XHPhbCk4RdxvYRsesPdp/uWkst
	pbOqeU5/w/sg5rI9hh9KjlKqU3nCl6FqgWQPEoy5SGgKpAbayN3RRmuIgs2x6qzbm51c1ySxtQ6sI
	rncMMjAtrpaHW+jvp8olWwQHI8axY2G1/xeHyOjLT3HxiWHG3AvJYkqpw8i3ApDAE1UBbAAutq4Gd
	xm9lA+xiBo49Fibu6QlGiHcj1qhQmSBtHQHUJ5zOvvE4nq2riqZ7E7XvFZGD+agCYII21NpGBq5jR
	EtI9GDX9DH45P4KY5+CG6a9P7YqXveaEX8QCEsN1W7c/1PPqJdFZZptDza8XODuZn/4qJVrimYhnL
	Gq9zn2Pg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wliuv-000000069QW-1iHd;
	Mon, 20 Jul 2026 08:00:01 +0000
Date: Mon, 20 Jul 2026 01:00:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, djwong@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: handle NULL b_addr in xfs_buf_free
Message-ID: <al3VgW1ijbMf2P2k@infradead.org>
References: <20260719151124.3514077-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260719151124.3514077-1-yun.zhou@windriver.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Jul 19, 2026 at 11:11:24PM +0800, Yun Zhou wrote:
> When xfs_buf_alloc_backing_mem() fails, xfs_buf_free() is called with
> bp->b_addr still NULL.  The code falls through to the folio_put path
> which calls virt_to_folio(NULL), dereferencing an invalid address and
> causing a kernel crash.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

