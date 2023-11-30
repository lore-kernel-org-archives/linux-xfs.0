Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kM1osEti"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E951BC
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y0H5qjJrzKV/gbG5rW5IfhTQwuRkT0lkWndswOHWcz8=; b=kM1osEtiUqZZSY9J8iGX8T2GfX
	bIWxiMK0Cmy6cLLJ130/fdavB5EAWCFknpcy9Dhrjeh1BqZQzj1WzeSNWeT7LyVA5ouNpg/4Uqol2
	KWIkOM6mzhg3PfuYvVByvG4L1bbe1Ol2VwU49FBNAnLl/geGp/t8lazP4NDwlslb+/dxlr9yg7dL9
	UHue0vu/pGS1oz4Tz9+cH9fhjkuSezyxxnb0a86NTU23YYiEXhghtBK/gegbppP/slQQ+1eSVqHSz
	0+kzuerIxeFRRPLt+IADKxY0O12v84RIxfsKGoR8fs0nRkLcxWlcFom1SyT1R3j2IcTlDq2YD9cpl
	o84qF+Zw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZgD-009yUF-1H;
	Thu, 30 Nov 2023 05:33:41 +0000
Date: Wed, 29 Nov 2023 21:33:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair quotas
Message-ID: <ZWgetfZA0JLz94Ld@infradead.org>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928871.2771741.2277452744114090363.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928871.2771741.2277452744114090363.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> @@ -328,7 +328,6 @@ xchk_quota(
>  		if (error)
>  			break;
>  	}
> -	xchk_ilock(sc, XFS_ILOCK_EXCL);
>  	if (error == -ECANCELED)
>  		error = 0;
>  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,

What is the replacement for this lock?  The call in xrep_quota_item?

I'm a little confused on how locking works - about all flags in
sc->ilock_flags are released, and here we used just lock the
exclusive ilock directly without tracking it.
