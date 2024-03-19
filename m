Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315A640853
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 06:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710831240; cv=none; b=uuANuovj96c0bvLMtlxYMH2Y0pYqyzBzvxmJ9caepqvvbChVTmOn5NQbT1soBVQewLsxEfp1tEqW3rxQ4dxaMXSwgX/Ot3vT6oCW/BFC631gPqpMdVHCSotfLcUApI1Tvz6Y3BDDYf3QTs/8gcJ8xPDvtGAWJ0q9s02wFug4QT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710831240; c=relaxed/simple;
	bh=egKaHke8/xkk+w936ZwPjBsFGrjTVQwZsYTxsx+Gxrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1PezkdSu9XNu7YubkG2/sHvqpC4tD3tKmclEtCuWRXCbmoBFKIYiLvahaguTbnVVCDOsWDZ4g4q0DzQ/ZQFgZ7opHQlKOr1BiOUdCj19HHrfLK/gilh0FsUH4juiNxALsgK7DwZHsWqW+pfLVSs3tRcaH8tyAkSyclde2OkWvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tL6RyVKd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tL6RyVKd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vfWhcb+/h4cR0FssfQeD62/jkZCiY6AZlYTj++a8gx0=; b=tL6RyVKdUB1MKIOZRWUjl6lOiG
	gc2uJW9bq2+6XRliTynkyUuMNpKvHfhgaySrk5RAqdwgHLAUbqhZtbAZfcyPHZZ3U8gHtsCnJ01Na
	B3uh+HOTSG/1wsQsAo488O2NV7JSrQliTY3hPuvyGge8L/2i7KIISvin+KwXlcyKWoLu4a54m/DH5
	lgGYkIz21tHU9fQieh5byVfNxPUeUN+0I+MBNnOejf5hS7O+luIHjZ8W469s+QNQQoBkvM7noLUoY
	K31Q16LT1zPaF9Xs1tN6LlBhzRRX7gciwLsymcLEdJOJmw1yzc7Yh9tKN9pLXRrUUzD6bqIeP0nBO
	hHbiY7qQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmTME-0000000BaUV-1kl1;
	Tue, 19 Mar 2024 06:53:58 +0000
Date: Mon, 18 Mar 2024 23:53:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: use folios in the buffer cache
Message-ID: <Zfk2hhhXU78WSo18@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240318224715.3367463-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

So while this looks good to me,

> +	for (i = 0; i < bp->b_folio_count; i++) {
> +		if (bp->b_folios[i])
> +			__folio_put(bp->b_folios[i]);

The __folio_put here really needs to be folio_put or page alloc
debugging gets very unhappy.

But even with that fixed on top of this patch the first mount just hangs
without a useful kernel backtrace in /proc/*/stack, although running
with the entire ѕeries applied it does pass the basic sanity checking
so far.

