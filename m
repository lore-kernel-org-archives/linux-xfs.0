Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35A31DFC6
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710807853; cv=none; b=NJDNI52UW1i2MlUQ2YgrOKyDq/k/ODqlHArWzPKdfKI/VmfDEcH7bovuKmlxRDdYQ7aHVyiHhDHP+EAyHk7Ko+tziw74y9GKrY+rCNgIdlFNaH21P/OkpM/GPr5I2NI+iaNV55W2itAjqWOVExJBhLnq9hC19MTcjG6n4oFV41c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710807853; c=relaxed/simple;
	bh=KYsb4RiItdZdOHy51BSJOBNrUddh9a+5olKUsO3oVwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGl7r9MrWC8qHqCSsEabILdbTpUd00379gxkxytwbYcLpQhoxd0twLttSgSo3zEIicZ8BNjK5vsOAF3JyHgmUhCDJQVuzz+onDmrKFPqx/PAhSQVRn6ht6SERAE++3YBqOVeOg3VG94To8rLXxZDXwHKWYYih2URvo1BX+4yIx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iG+HtTzf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iG+HtTzf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ombH6Ji1kBx47qaVdMyHH8Znqnv+6OvwFj/LziepZSM=; b=iG+HtTzfAX3wN5pFwz4nH3Faxq
	ndf2KXLqnU0d1aiGlWHyWiWy2NtN+h9mH7F9caKZq8pi1a00fxk1cJlvqPExXD42WTG8cwVmnGZfA
	IOrgEil4bcX/tjKx6xQsM8pG7F0MhpGi2rpUVwd7teH9BvQnpDK070/URu552sbStTwhzN+mfiCZv
	l4ODuHZRMs4nf7lT3ANegtbxuEV4rPN6nARgSmMpX6vYk143PbnGmqtQJjebE8UnPjBgTB0ga0GKn
	kfHuqjm5PDAPMogRBMds87lDEdkXkEdHev9jbbr1dh7CslrO26hUQehu6YEmfremgnHitwiSIRBrz
	36BqbcZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmNH0-0000000AfwZ-16vL;
	Tue, 19 Mar 2024 00:24:10 +0000
Date: Mon, 18 Mar 2024 17:24:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] xfs: use large folios for buffers
Message-ID: <ZfjbKh1Yifn7Ok8x@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 19, 2024 at 09:45:51AM +1100, Dave Chinner wrote:
> Apart from those small complexities that are resolved by the end of
> the patchset, the conversion and enhancement is relatively straight
> forward.  It passes fstests on both 512 and 4096 byte sector size
> storage (512 byte sectors exercise the XBF_KMEM path which has
> non-zero bp->b_offset values) and doesn't appear to cause any
> problems with large 64kB directory buffers on 4kB page machines.

Just curious, do you have any benchmark numbers to see if this actually
improves performance?

