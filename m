Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4763B3C00
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772549055; cv=none; b=KcixtL/QHOKXsMl2Xmsuy2nnnOshs8/unU5chbKEVUxPRh8VX9ZfOqLrmRqKLChFsp9F/MtrvTdpqZAWlUHjKhhbqx4WbJx434UsP1U9JUaTfZjwXHCYZvdTs2ngUMwub0qbAtxf81MBp69AYxnhhGMFwhahl5Ig7p8IkDSDOVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772549055; c=relaxed/simple;
	bh=vkeRiTfz/9h6/unxuca+euTnMBG1ELrl/3t5paGuSSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdoPczQrTDZQ4KSE0emx7ot16iI6ewkz/rkfsMW1MjyJsRi67jVGzL3hF+eQgENgP9YCh1kmU3hhSYxgXtqsvA5W7KdH4rFr4Ql7UcssJQymUbTXI/WjiS8hHU6VEDPny6CeYoPslJh0m+PbO0Je3KTFmv92oC+aLkuJSn7luhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NGmjxWxQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NGmjxWxQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=trPQLvUuTUENTsZkmOYiiTdfd8eLbvIULPI5xBsL1tA=; b=NGmjxWxQtAa2Crdpm1/dXEFrwA
	IqhJjett7yJ8cnosu0gPHtH36jl1tPtfGty8TYTfY5mDBfvCqMnqzD7MM5uFq1RrYTVtTlPT00ibf
	MnI/zrIaLPVoHXNA+j0JMytQwFzXoJLd379Pa5uHIqPLEZcHNw6kOVa6EKFGzBPfanpLy1bnil5rM
	VuZNWwMjOBFvvS5oAJp2pL0hpgVOTmwJtVfmJh/mHRUC1soHWI7okm6Smt1z8T8laCkD6qc6Nsrb2
	0uM4SizYWfa+jIFbjBV2Ip1nn0DUwR0xXneL9mMDPQ+eQ1XR+767y0LC00l33m857kDjnrePEov0z
	NbSYlyJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQyr-0000000FLuj-0759;
	Tue, 03 Mar 2026 14:44:13 +0000
Date: Tue, 3 Mar 2026 06:44:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/36] xfs: move struct xfs_log_iovec to xfs_log_priv.h
Message-ID: <aabzvfIxUWD2jK_e@infradead.org>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249637996.457970.5988457332713577268.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249637996.457970.5988457332713577268.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:15:16PM -0800, Darrick J. Wong wrote:
> +++ b/include/kmem.h
> @@ -60,6 +60,8 @@ static inline void *kmalloc(size_t size, gfp_t flags)
>  
>  #define kzalloc(size, gfp)	kvmalloc((size), (gfp) | __GFP_ZERO)
>  #define kvzalloc(size, gfp)	kzalloc((size), (gfp))
> +#define kmalloc_array(n, size, gfp)	kvmalloc((n) * (size), (gfp))
> +#define kcalloc(n, size, gfp)	kmalloc_array((n), (size), (gfp) | __GFP_ZERO)

Maybe use check_mul_overflow like the kernel version?

And avoid the overly long line and maybe even turn it into an inline?

I think it would also be cleared to split adding new core helpers into
a separate commit vs tagging it onto porting kernel code that's using
them.

