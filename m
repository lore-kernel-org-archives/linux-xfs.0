Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F32435C693;
	Thu, 10 Sep 2026 05:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019232; cv=none; b=AI456cko+zELAjLMUOQzwIzdSHdZvUi/wOJZYmmc5e1WT/kOGlJoZmS6Ja1kASgy/z571zZfCKW6oLDYKMA2919xFh/sLkGu/acERXK9xNIs1a6kEbZx6m0j8c1kHCJTbaBZ6tOXTUFUpPXn5Z2tWOlzfEgOx77/89qI7bWJa/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019232; c=relaxed/simple;
	bh=FJ7koKAA2f+/V0K2OwTWnxCPdISIL/nawt8+Y2wY2ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YSSs5IhnRgcNZDHujF48p/2wUVL0lbJR+fWtA/X1AkIcZBU3UwCb0eGvit1gEL5p8UWXAiXKYB+4+fmeM+CjemkJoQtw+mErgqnbbKRIPzig3L75Qu8bKloqG9ix9F2sFkHEcN5Tc8TCqTcF87+/6jdi6oP1zlwG8s0qz2bvpZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rbu5P+b0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rbu5P+b0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GfLKYZUgvxL1ahMi0OUAEXLtCuptGFsPyzgJaDdoa1A=; b=rbu5P+b0gKhmfHoniTHQeIpdmW
	XZAOFK/cR0q1II3k5bdMPFeVTHmMiFQiwkCSIDIzrRbBb320pnjc4UEUNhDn6iG0YNZmH3mFFkJZb
	QMBgfU/sLem7PTpXB4+D9cRNZkMnNsU8P8ig0U871JDqZ5U1VSvg/KA+e+WSzsow3XKuGW12kn8m5
	M6CL8HGF6hVHZwpnyguCfd34JfXZU3312iIFDH+0/VuntKcZIVIql4h57GTFtkz9+hO6glinlxA6V
	JtdJc6X2bndHJp0eAbbrwHgHWXAxm9c14WmPLfOTNIz5qGXnVM7ALDShomySW35sO5af+V7Qa1+yw
	2piWhWJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4Xco-0000000DTZq-0r7E;
	Thu, 10 Sep 2026 05:47:06 +0000
Date: Wed, 9 Sep 2026 22:47:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Yun Zhou <yun.zhou@windriver.com>
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <aqJEWmUN3Jsajoyl@infradead.org>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Adding Yun Zhou, whoch touched this area recently.

On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> xfs_btree_split_worker() calls xfs_trans_set_context() and
> xfs_trans_clear_context() on the caller's transaction, overwriting
> tp->t_pflags with the worker's NOFS state. When the caller already has
> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> the caller's NOFS protection.
> 
> Use memalloc_nofs_save/restore with a local variable instead so
> tp->t_pflags is never touched.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, if you have some spare time, it would be nice to kill
xfs_trans_set_context/xfs_trans_clear_context as follow up given that
they keep causing confusion.

