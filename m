Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C559F6AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712119143; cv=none; b=qRcD5zdUw+enBcPuwsI6qZKXygOkwa3/aTzyKMJ1a2vVpochO1tDvEk19XfwS2WFJoHEm/5KhwdsBRsfgxXGivcgT+ZWcWPD5m3iFsbCTTkLbf2KYDeofBYyJLUJmTkCzsjvxLKH8J5qrYHZvhh6M3QjoVGSnhdCWz+ijhKjmsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712119143; c=relaxed/simple;
	bh=VeZTPEl64u2Hd3knMrxJpfQzFIbgUFOTloqb7XMXTVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnzti2XTCr9CF2EHmez9LNxpaSZ1mu2EknOKQPKGKd8zjqmzv9q0Q1gN0FzqlE+FpSuXc3Z3eTE/AIvxmNT7nebI5/74xlKyScefK6fUhL3tKssZ6pyvB6AH4uc40N+VnlOMsDdNtRnZ7egQibH65o6zLWh7KSwJTX5PC+SDDK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fztnHix+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fztnHix+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8T8uF0V8Rl9q+Ve9XptTiBX7GWilaIipInrUSrKT/XM=; b=fztnHix+qz/ma2wA2XozDUtL8D
	iH/RUcWHDrFEPOML3JE/TgykucZXwfTV1iSjldOortHbnM1E2gkAYpuiNpYW+NJXuSt7+5FqjGfUX
	CUORbOdg3+E219Qfa2dWRsQRQm4dCOZaOYcxEYZTOIA125dQe7gY+xLHIawRCrGvArAqsvlh5pECh
	XBTCJl7sosbYF130No2E2j0bbvF64UVyol2KYbtCrJSXrEn3T5PO6A67IXi6pb1qfXdHQJWKRU3GK
	91PWBS3fD4/nONkAiSk3efaiEsVRUvl1SZ1jCwCLCxAou+xcge0UOJSPCIPogVGX7KsSbIHFhv1S3
	fO2ubrLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsOr-0000000DyZs-1fpm;
	Wed, 03 Apr 2024 04:39:01 +0000
Date: Tue, 2 Apr 2024 21:39:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: fix sparse warnings about unused interval tree
 functions
Message-ID: <ZgzdZbV_VW-0dVot@infradead.org>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-6-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 03, 2024 at 08:28:32AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Sparse throws warnings about the interval tree functions that are
> defined and then not used in the scrub bitmap code:

Hmm, what sparse version and kernel config is this?  I don't see
warnings in my builds, and I also can't see where they'd come from.
