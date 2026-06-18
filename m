Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE9B3EF64F;
	Thu, 18 Jun 2026 10:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781778474; cv=none; b=XBrRJtXZMDyD7XOXDIKv/bYucUAAFN8U79pX8jBVj3+Zqfuy7PLXy2Xpq5MtnkJuxhNgWGdRLGT6puWF0chAHVqSgVIGdaiS6aKSxCiQM3xaFbJxcn5Qq7GARc2SSxn3KCmh7bHOa32utyUD1s63rpcK1HbYjhuCO5oc8Z8wvtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781778474; c=relaxed/simple;
	bh=opaVuOSnnnT8IZNoJ3aT7c7J4fMuIyEHLrzEEbEMdRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOolTiOGVeR9zMtDI/vuSddQHO5B7QRKi+QKBqKEFeK3XM2yXe7TMufCRZpgGnFI8NBd9IzoKSMzs9CGJd8eEhrkYhOU8KQ3IYQluOwiceeflgoz26Reui0crH9ddSrCVIhS2H3OSMuXpBCbIrnQKCVaDIZj3nT+Jke7e3H3w80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bPHXN7C+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bPHXN7C+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MqBGkk6wcSdrc1kSrODb8jDMwhC8Pa/nfcjc2VhB0y4=; b=bPHXN7C+YXigi+F6P6JvV90i+r
	XOjKWBv/hissgNpqsqcfL76SFwxKQnft2HYEGoIFWlc0gi6AwEbUV6R61M87exV40xAKJUfOhwFgx
	yxAy9GsE8NJLaXMK8tbm7zkOC0lnbQQTlAc+w+lphGp9fUCTRlYSHsVLlvc5UoaBs8SwFC42xL8J3
	VV+p9ihxB5I9FiZt1W04ZJZgybkwLAncAzprmG9MXP1D2lbntdt4o6TQIK/bWEgsXUJJtUEsgXCfb
	OR9FmG0HdKH6Pj6oTrGDrQa9I7QNaqmwJq1pv5o1Hpwuyif/zWkzGzuIhV8N7dKUJJpSTGXVmZ+Lr
	+wNatRuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wa9yL-000000016Nj-3qaH;
	Thu, 18 Jun 2026 10:27:45 +0000
Date: Thu, 18 Jun 2026 03:27:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"zhaoyifan (H)" <zhaoyifan28@huawei.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	yekelu1@huawei.com, jingrui@huawei.com, zhukeqian1@huawei.com,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
Message-ID: <ajPIIU1JB9e0ksBt@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
 <ajOzy2NPD2GlXcNt@infradead.org>
 <7a38b823-59f3-419e-9070-cbc848f6f1fe@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a38b823-59f3-419e-9070-cbc848f6f1fe@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 18, 2026 at 06:14:03PM +0800, Gao Xiang wrote:
> I think this patch can go alone seperately because the
> correctness is okay and cross-subsystem git merge is
> a bit of churn.
> 
> I've pushed an chunk merging patch individually to -next
> for this cycle too, and it should fix too many bios issue,
> but even without that patch it won't impact the correctness
> (just less performant.) I assume both patches will upstream
> in the near future.

Thanks.  I'll get this patch dusted up for a formal submission in a bit
and will send it out.

