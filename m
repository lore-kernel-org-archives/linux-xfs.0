Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661CB344D8D;
	Thu, 28 May 2026 08:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779957141; cv=none; b=t7A3pyGy9fS6MFTWpiBhHdtb8ZuwN1MuXyhb8I9oMUbmu4CRmLph14CWTfe/8No+ijXDhGIoPGt1gWweoAwNTk2047+m5TyP7LNaoRhuaoP+61Pt0qRib6eyxWRkpHbn+D29un/MDY81Pk8Yf95WtBNJKxdjnFiSP+ceRvk9GAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779957141; c=relaxed/simple;
	bh=rIQZwMDyivvmtv+uH2qOsAQdCEvaSo6CqnLyeQe1Sdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kF38n161Sq4CTLRKQGslASh6VhrLulP/V2fXdkmIDrGEAw5uIAhcYKWxAtaohZFTwUn4BCwW85Ye/gefUq+4xwJr3Gkq/GvAhWorrXflzBZCqQZ1IimEMFIvgNt26ZYJ+cqxb9jxvXm/UTI1TdwwD5O3V87qg6M4HakFlAU95Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sQQ5iUPZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sQQ5iUPZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NACssQqiHPa5C0J4CzuPcBTjwgYXZP4Zqu7eJ4aobww=; b=sQQ5iUPZ+bV9g55weFzbGx5BRs
	sF0Q8ZftPn/LMDgirZ1WMQo8YZn7OarRIBf/q0mbv3+BnzqG7ad98DbH1tcI/nJW8RkdByyLvyVG9
	WGJha8iNQcTcoNEM6u/0ggmFuJ7zDr7aOJaKS23JDUIGY2t16RndhIS9E3sWtFHppUal61rjVSPVq
	jgJYucmqhMBHGqPGW3FGN+dfjIGay0H6sHFpbtyOY8CHXaN6jlB8AA+uzDB1yKLvgwlVJ9nUtRNP+
	pupfkIoQFa21fPHc4Ven7E9uUwQFh7EOKzMKA/znBkvlppZIL1Fdix6VLLrCkMZ0uTbA4zf02SpaV
	6302xKrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSWA3-00000005OXh-1d7v;
	Thu, 28 May 2026 08:32:15 +0000
Date: Thu, 28 May 2026 01:32:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zerocling0077@gmail.com, 2045gemini@gmail.com
Subject: Re: [PATCH] xfs: drain inodegc before quota teardown on mount failure
Message-ID: <ahf9j4G0sdSx0Ti5@infradead.org>
References: <agwh6darf9q52za7@infradead.org>
 <20260528053128.3036120-1-rollkingzzc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528053128.3036120-1-rollkingzzc@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 28, 2026 at 01:31:28PM +0800, Zhang Cen wrote:
> This was not from normal xfstests.  I reproduced it in a KASAN-enabled
> QEMU guest with a disposable quota-enabled XFS image, then forced a late
> mount failure after quota setup while tracing the inodegc and quota
> teardown path.  The failing ordering was:
> 
>   xfs_qm_mount_quotas()
>   late mount failure
>   xfs_qm_unmount_quotas()
>   xfs_qm_unmount() / xfs_qm_destroy_quotainfo()
>   xfs_inodegc_flush()
> 
> with inodegc still able to reach the dqattach/dqget side during the
> teardown window.

Can you come up with an xfstest for this?  I guess you'd need a new
error injection point, but that should not be horrible.

