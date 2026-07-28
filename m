Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9372B157487
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 03:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208661; cv=none; b=C6mfOJRmFxu5jFpMaslV4vlubAHkjqk8eYpnRpcH+jRXCmZZgfnSVmnKUbTpkoFIIfwIyWN+LZlXZVkviz+/JeoK0bB8Dc4DQ1/wxJ3TcaU1MNHLtRjF+aFcFgzgSL5T5M56I2yHrx1u7HvLqN72NVSHfkv9A2fMYneTHg0OPsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208661; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFnIft+Vc7tqKhC4cd3xUtDjUysWOIWb/NC84TH50k20FNAfA2gsHII4JmR9vp+o7gdq21TG5cJOrRIoIjLw/G+1WLyxtQRu5jm6JxLOU61mDJ21VjR8qjPRblfrmJE167zlIRHrVJR0P0Wl8er/YbH183DUU0vfX32aTLykQ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1+aP1ylo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1+aP1ylo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1+aP1yloHbuoNpbh1XFsP6uA46
	DuNF0EPaDRIvENWVkyUpjNMCeZqq73SVuvMD4RtjdkruO5NRGsUzRQGRL74SztVl99JPXzHrlsQAl
	bHoCMGxV13KD6VNwLYukb+/lK9ICioxuUB1j/cknyz0TeKL6DORY+1XlK1lfyBFm5wmVXm0paYUOD
	xq884HjD+7Hg2+j9zlZyxWKqLNVaxKrkPtKwkYiKAVYOIQj6xEYlq1R38lvSRVaQ2MuudRfnbE+i0
	WZ7P2cdiz2Lj1P8xAfWkMJZ7UE5n1R/rWpDQ1SrAEO1HO+yN08sfLgBkKCIWgck2IhXqMoKIfzU+Y
	Sdq4/iDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYK4-00000004Jl6-1KhU;
	Tue, 28 Jul 2026 03:17:40 +0000
Date: Mon, 27 Jul 2026 20:17:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 2/2] xfs: don't swallow dquot recovery verification errors
Message-ID: <amgfVJ-ULUmZkxXm@infradead.org>
References: <20260727023849.3247961-1-leo.lilong@huawei.com>
 <20260727023849.3247961-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727023849.3247961-2-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

