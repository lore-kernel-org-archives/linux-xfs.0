Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8BF33E373
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230585; cv=none; b=YDsURPnQmD2WTo/mrVVI4FLMbYXSvzjL5ijGThBW4kTNNi245OJo/3DQfYdZNs2T55+IjaHOHudivL4QX1XzWMWsYW1DK/XtCojtcFmapS5yGxO7ZCTjdzPPCLRPdtZx/mFkpanmbT+mQWGQAzLdTUZySt+y3AhGiJnxMcxsCgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230585; c=relaxed/simple;
	bh=gLS1+UUE6PoKDRHi0ttEDgexY7Xk39WAVcqG0J6VmgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRZCb3tObOE4Jsnyi5RqdbqS8sT+6g2F1vyf5wtGRA/+LMCQfiFp1tGR8w3MTiAq9VKz0vptVivW6LdfUaXs3aeNjEC4f818pAwg+AdUXmYBrqHDNbYGbXXdu/F/JZLzWS/oGtQEjFTgQAekwGavewEFHSzCurf5mgjIReLLugg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ulCdwoZA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ulCdwoZA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P6vMWD60+uqGW4r7hi9mwrK8hJv/HH2ScavqrmAwg9A=; b=ulCdwoZA20B/yZ6lr4Dga4qy3d
	DNBNuak1/IVSjTOze3YRT9e8dkzCESPM5eCjVl5J59Qr+ShNLwFp7rKf+TdOF4v0NfiQP19ISNFG1
	R3JsWukdCCMiLOsihu6iKYUT3zXfCPEGFvBpDWWPnwXv1EY+jXouPKdvwMrpkkNWLJhtPQb8ebFVw
	CtIh4WAv4Xd4fiRT+myzR84uMkCB65g0xXx1xWHSQ9uMxULjm6KlcgjaynLQkAkxCqEJP/mlbRqJu
	nZsVn7WlXsNwLVEHljQz2rEqpC2OGFwZCwR5B293huv6ylQyi889iVcI5XykDlk/xBCUqiuuWhAWa
	EEQ25ReA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLH0R-000000063HA-32Ee;
	Fri, 08 May 2026 08:56:23 +0000
Date: Fri, 8 May 2026 01:56:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] platform_defs.h: fix __counted_by_ptr annotation
Message-ID: <af2lN1mpbsExz7oz@infradead.org>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
 <177819182658.3486034.17713563256078765686.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177819182658.3486034.17713563256078765686.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 07, 2026 at 03:11:27PM -0700, Darrick J. Wong wrote:
> diff --git a/include/platform_defs.h b/include/platform_defs.h
> index 5a829db66e0899..5d1bfb1baf94db 100644
> --- a/include/platform_defs.h
> +++ b/include/platform_defs.h
> @@ -331,6 +331,8 @@ struct kvec {
>  #endif
>  
>  /* xfs_attr.h */
> +#ifndef __counted_by_ptr
>  #define __counted_by_ptr(member)
> +#endif

As a fix this is obviously ok, but I wonder if we should provide
the full kernel version here that actually checks?  Or just not
bother as sooner or later the kernel version will be in most
builds?

Also maybe add a comment that we'll pick this up from kernel
headers from 7.1 or newer?

