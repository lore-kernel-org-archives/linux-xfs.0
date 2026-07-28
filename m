Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CA4314D15
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 03:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208634; cv=none; b=bZdUaR/whFrluju+hPPcM3MX5c6Y2N+D7PqfJDY6/ClbrUjSSvASCZ6IYZec+gCIG5ySmLFgiNQt+5HWn0oh4nuuF2pn60+AxyHtnGF2sp0ZWMRApEOm9bBaILERPRj4DOCLPV4j7PbWV8kO/X1l+pWZo5Y3X5s5QAHs48NLWRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208634; c=relaxed/simple;
	bh=graztm6os8ubsO5udrUu2S+p5NmnjHQphPKa8eBNpnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGh19tNvJDgundBmBtCllbJrONZKwPO6Z7Bic0Tg9MlLxwWHxJWeMxURhm1kVI+ziaaHmkfwI0Su+zf4+pgkcL7+TZGbWjYk8bnezYB1E3ExhXpXV4st5gZm+zmBGtSTlzjlca5jSPO5u8EKZPURAVvBQlZKLj5jejwSr/+uo4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sw8S+S68; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sw8S+S68"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8r8I8OtKuwRCFguw1ssSrIpbQ6G3eoiqtGD6WbH5GjQ=; b=sw8S+S68Fe301+AmjiK+iloBip
	m17KTftNGV0YKMuAVq2o1z4uPj6XbSZNZSmlRORTLiKNu+dw3qmyg02Vft2gxxKtnGq5gqchagVw1
	VtUtS4LZOwTAxJK+TU1ni1KDXVnnnNGzxZDCl1rAMTRAnK02WJO12PvAx0hVMRs7xhvY6r9caFVTT
	04AdyM4C7NnKl9BhQr9kWCnYnZDS5Pt3E+sWHmDHTiYP/+r5qi1vvmhVG+Augac8IIiQgGazR8TKF
	NNECg4o4DNPPIRGCTVsrE0QUrzatoOLW+ru1rmJm1j9pdMwc0bHS9HG6a4mbDojIcw9esIUhhlhh5
	3B6m3E3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYJc-00000004Jhi-1CqL;
	Tue, 28 Jul 2026 03:17:12 +0000
Date: Mon, 27 Jul 2026 20:17:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: fix ilock leak on error in xfs_dq_get_next_id
Message-ID: <amgfOIzdMbfix_nL@infradead.org>
References: <20260727023849.3247961-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727023849.3247961-1-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 27, 2026 at 10:38:48AM +0800, Long Li wrote:
> xfs_dq_get_next_id() takes the quota inode ILOCK before calling
> xfs_iread_extents().  If xfs_iread_extents() fails, the function returns
> immediately without releasing the lock, leaking the quota inode ILOCK.
> This can leave the quota inode locked and cause subsequent quota
> operations to hang.
> 
> Fix this by jumping to a common unlock path on error instead of returning
> directly.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

