Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B2945030;
	Tue, 25 Jun 2024 11:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719315186; cv=none; b=BhHm29h1FxDaGFMOoIzozSAQnyDhGfv/6hqkke3PUHNC72fwUMBeRDGMCLSY3gLGno6m6ifECBwDfWArsTi+oAXbw2OTupIpIiKLTwJAw7oQxAleuHlhy9yI5oq0FB4v3jMgWNpzkIA+N6r5tlNAzMgIAcvAWJ4B1WEPEpoSm0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719315186; c=relaxed/simple;
	bh=vlT+s5VdBsOn58dABQJWG/biDqHMJxLfM62raEWUr28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zt7ar+cqI8StG6Na9OigSoKzlaRl7Btk39vf5JcAKJb9XQAXBeT1S5Ns8/vgLdpTaV2380kgKu+vX5++fbwHmd546joU6ftBM5GyBd3GWjpXlPrEhXEm6+bU4l/X8XbTh7TZi+qQyACK4MPvWJbNPu8aajjfcJCiDxTbb0RPiDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZuLgxSW1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZuLgxSW1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=evcwJ4iY84vyTVwT6BoaU/MuOEgepiWQ8bZi3sFqHwU=; b=ZuLgxSW1t8pmfx6LuohN/rbkMJ
	BJseIXdcbDmDDEhoiHQTwCErnngRBxMz/YHr4JVFV6s5MLBO7CIrC1qA2HvuLPfh161SjGJxL5HuK
	SUFyxzhDzeJBS2P/6f7oYzM9WQXbqWZz7WWDdubwAcLZkMM4dkyr3PlQrKaFzkoaM+WQQGTGgZ807
	R4hpENruTMqROtw6l5r8+QXF2W38HRsIEyVHC8D2qhexCc8khI7QSWJ+ap0UewaAF7oqzBTenoeIL
	70iuCb2gqQihHf2ctzMIKDBqRjueDv2tglHjVbHexKHd4OlBW6Qhyv3dlvXD9iKJ7Zso9utLP16ks
	eeoYgJXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM4Q0-00000002YIL-1cc0;
	Tue, 25 Jun 2024 11:33:00 +0000
Date: Tue, 25 Jun 2024 04:33:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: alexjlzheng@gmail.com
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, alexjlzheng@tencent.com
Subject: Re: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and
 release it early
Message-ID: <Znqq7GUFnwFj-SFI@infradead.org>
References: <20240623123119.3562031-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623123119.3562031-1-alexjlzheng@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2526,6 +2526,8 @@ xlog_write(
>  			xlog_write_full(lv, ticket, iclog, &log_offset,
>  					 &len, &record_cnt, &data_cnt);
>  		}
> +		if (lv->lv_flags & XFS_LOG_VEC_DYNAMIC)
> +			kvfree(lv->lv_iovecp);

This should porbably be a function paramter to xlog_write, with
xlog_cil_write_chain asking for the iovecs to be freed because they
are dynamically allocated, and the other two not becaue the iovecs
are on-stack.  With that we don't need to grow a new field in
struct xfs_log_vec.

>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  		struct xfs_log_vec *lv;
> +		struct xfs_log_iovec *lvec;
>  		int	niovecs = 0;
>  		int	nbytes = 0;
>  		int	buf_size;
> @@ -339,18 +339,23 @@ xlog_cil_alloc_shadow_bufs(
>  			 * the buffer, only the log vector header and the iovec
>  			 * storage.
>  			 */
> -			kvfree(lip->li_lv_shadow);
> -			lv = xlog_kvmalloc(buf_size);
> -
> -			memset(lv, 0, xlog_cil_iovec_space(niovecs));
> +			if (lip->li_lv_shadow) {
> +				kvfree(lip->li_lv_shadow->lv_iovecp);
> +				kvfree(lip->li_lv_shadow);
> +			}
> +			lv = xlog_kvmalloc(sizeof(struct xfs_log_vec));
> +			memset(lv, 0, sizeof(struct xfs_log_vec));
> +			lvec = xlog_kvmalloc(buf_size);
> +			memset(lvec, 0, xlog_cil_iovec_space(niovecs));

This area can use quite a bit of a redo.  The xfs_log_vec is tiny,
so it doesn't really need a vmalloc fallback but can simply use
kmalloc.

But more importantly there is no need to really it, you just
need to allocate it.  So this should probably become:

	lv = lip->li_lv_shadow;
	if (!lv) {
		/* kmalloc and initialize, set lv_size to zero */
	}

	if (buf_size > lv->lv_size) {
		/* grow case that rallocates ->lv_iovecp */
	} else {
		/* same or smaller, optimise common overwrite case */
		..
	}

