Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A36614E2E8
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736403012; cv=none; b=LXNuRBNTI3kJdKdSffIQ31KsMmXlIDWUtKk8qGb/EPJbUS1indNAzNeuexjXXGEda7L4HGiIz/6lZDpGbn/xnaZ0+HZ8drw9bvPv/BhUmQADZLu3bLHIKwBYUuh17mIg72yrQN+p42V8IDAPBG8NozeLE6KTB34suPuVcMwxL9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736403012; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbgiYBUQEF4NA1hPH90AtbZVk4o9gAUSikzlciZ0MOOhXAcRQ41oEQ5gDEeuWoDn32ntLKqFTbeOp6ymmYKoUVGG29/0vei8JrFKczE0seRDKSVG+FS9XTu29hf6csHiLnVuuSsC+K1/ZHZQjjRtM5IBtiLZZFkTl+BfPZ6XAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xs6EXbBt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xs6EXbBt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Xs6EXbBtqDMVIYjN/fGw/xt4VD
	i6gecY0nE/x++yJaiYrfGGY1IlcSN45fsKPSzJJkvU/h+rPiG7I6Qqf26xgyyXlhQqawvpJaWd+D0
	OEojY0RD+wrkGtkuVmUgnJ5F9s1fyrXcTKI5YuVXom+RSIVChUJQ+5Wec94KpRssTqSqfsGD7wU/L
	qlHBYGOfZVD918jBDWhxcVHC+N5nQXJTFaQ7e5rXFylCcs56YV5/iapeJJnX00VWxzTNOfB3lzYnK
	+kGK0daSoCnT0LQCy7LiY03vYNaEHrABgrVAShd/94pFgGdeDOFGzkAkYPeKLZWFg940mbiegrr9a
	LE3JOCqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVlk5-0000000Atew-3t7f;
	Thu, 09 Jan 2025 06:10:06 +0000
Date: Wed, 8 Jan 2025 22:10:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH v2] xfs: fix mount hang during primary superblock
 recovery failure
Message-ID: <Z39oPcKof7J5YtF0@infradead.org>
References: <20250109021320.429625-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109021320.429625-1-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

