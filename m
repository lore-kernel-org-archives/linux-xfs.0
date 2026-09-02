Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512EC363C59;
	Wed,  2 Sep 2026 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788359579; cv=none; b=do5ANRCvhcIaedz0OlHMCpyDdPPQTgD5bZvgiqQZOvOZqbNMKlgKBmeQC5fbvcA5Jqo6CyRjG8cq//xtTvJ/Nkh3HYIzIXnIsZBgdpR79gGwsvknymxHkajU/fD6IgtLYjxIMEeIaixxljRWxII5QzgSy7T6lJ8GgPDU89tHrbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788359579; c=relaxed/simple;
	bh=tvOYIhXmJ5ORthCcXulkJeAM2DiWepjrJEgkD8hKhj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qew+sqv8plqu/OipDxC2jVnwum0peUphDHkn9m1Sy7Up4BDFihCkVamygiHTYntO2qNKMuH35xbD295EVMVf8Cxhar6Syaq8QK9fHYTk+MZ3VksRSeu0L0cOM8E7pOriEN0fYo8Nu6rYpLLdxpE2YabSe+QXs/ZI3hl5yN4n8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lvyoeX4/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lvyoeX4/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ab01GFbRgvcQHW6lL+IHXL/vCP0OE9+HzNvqx7bK8Yc=; b=lvyoeX4/6Vwomt2sMai7wj14hi
	ARoojLR0eZqqFcrrSL/ug31s4vdX7ivDA1QDLkXUuWaz6Y/Y53G9xR6NRn3ynXfAbZvO73Ew1bSNc
	YS74Y40H3Sl+gVS/uY1xopeaBGrzmlE9kcBMz/pj++3feuBNVX4fy2ATX/v8ZU9ADL21Mq3UV+7tN
	aRGqshmRXmmq4e0aPivaolpHUnmi8xDq5rjTy3utjWf/hnuFNiQGVh8FLCGU0/puWrg/+tVBBmh84
	0DHeT+0gdmoP3eebKfUW0vZ70D0t4u4Sf6SmdcgVKZ0GFCVbNWOUx8BKnft8AAFNfqYyR72SiNFvZ
	TSdaW+PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1m1E-0000000ExRN-3hmi;
	Wed, 02 Sep 2026 14:32:52 +0000
Date: Wed, 2 Sep 2026 07:32:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] iomap: simplify writepages reclaim guard
Message-ID: <apgzlDZiLthAD25Q@infradead.org>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Sep 02, 2026 at 09:16:51PM +0800, Kefeng Wang wrote:
> index 0a5ebfda90f1..6306ca747f3b 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -2077,8 +2077,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
>  	 * Writeback from reclaim context should never happen except in the case
>  	 * of a VM regression so warn about it and refuse to write the data.
>  	 */
> -	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
> -			PF_MEMALLOC))
> +	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))

You can drop one set of braces here.  Otherwise this looks good.

