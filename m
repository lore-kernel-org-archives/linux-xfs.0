Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36221F9F0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713285129; cv=none; b=ZWYnIW0uwT0+AxAp+VZm3lWaYr+6TWNEFCtoQiXYU5Jw2YuV4IBbSOpLwrIgRbVGnhGM+NqpZjuGHP8irtFWF8NqmNuZxxVAqcaFF6oCg0ntJEm+IrMgQ93r0QJCS6u5f1CE9I4IKPknlILwbezFZQKjcLHC1LGUhVqhOjIb6oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713285129; c=relaxed/simple;
	bh=Qh2TGxD2PzNhuRCSPEYb6Q/G7s5iUXQR9UFQFY6jKA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IP7hnttGUoPqPHAD+Pz1PqvkiCCT729GnVFhslYJRddFFxEg/S6Dy+gJO28EGbpi6CJVSgPE1PlIDxQFwPu/4kVeK1a/fqhneEqUVGMeWEW87JxfI3MCCcYR7/dhH27RSxjMKDQV+4N61/Yx+PByizcr8w30DrANbADBjHnFtWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A1FZN5sx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A1FZN5sx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mqBrz8eRRfoMNjskBIjN96z5g75FG4XjSElU05+mlnw=; b=A1FZN5sxTbN+FG/cMxQwg5fE/P
	JjTJrctb8MITwX8uVBPtNZzRzquF++axxj28FLPFeVxo1Vcz/jkm15EOEICgXm1yRRGQmTmsSyJgY
	WVuQqHbKGT8O5BnWrYvPxPPBmOcrSedNH1BM17/AauQ3jAk20Z1iZ9X8Wod+tsiYU0i1uLPXUG+dz
	q4A22gQP8Th1MbffkU+jZDa2eUh7oiEPoeSKQLXtekfZaacf8z4AkqzYoHosPMp0cbpmSGRwCUJIf
	TInA590g+WBZbvJ/5MS+M5XSux+efUGwch10f2Yfh42z2obPFBHXdOLpCl2Czw4Sz7AxgjsgMaa6A
	Ibj5TXSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwlj5-0000000D1rv-2zSv;
	Tue, 16 Apr 2024 16:32:07 +0000
Date: Tue, 16 Apr 2024 09:32:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_db: fix leak in flist_find_ftyp()
Message-ID: <Zh6oB4cBtbSU7iyi@infradead.org>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416123427.614899-2-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 02:34:23PM +0200, Andrey Albershteyn wrote:
> +		if (!count) {
> +			flist_free(fl);
>  			continue;
> +		}

This looks good.  The more obvious way would be move the whole
loop body into a helper with two clear exits, one that returns
fl, and one that frees it and returns NULL..

