Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA50A2D8370;
	Tue,  4 Nov 2025 11:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762254312; cv=none; b=eXXoQ4cy5lcaLLNXwvnJRmf9j53MAVIhAzgMJon5Jp9C5wsd/CtbuETt6FWjv2AQtZg3JX7InEqZE69cSRt4pDqaSzDkK3WHje3Z8UAtmO5pdOq9moiZwWCRV98b39xomhJwpXFUObnlVIaqpg2lYHjAs0Tru6wABBT+cGcvFoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762254312; c=relaxed/simple;
	bh=x7VFxaEfFJcXYW8kQ2jVyHo5VuvXNFiqYqtA/C/VNcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPJl5U6vxFR+qlO7gVpd3sec322awasE94mIvy0PnGQz95hj7TUZyteCXYcKTis310IiI3YHpVEwekkj0NcRsZ/TCesy5cdnIoy/lattEIkwiqozaGxqeUha9ijin2YGa0CM9eE7uMFQ46GA5a/g7xhgxN/5pEksyhzyACxtLdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=co5dbW7Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="co5dbW7Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x7VFxaEfFJcXYW8kQ2jVyHo5VuvXNFiqYqtA/C/VNcI=; b=co5dbW7QbBK83kIUm3gH0igDSA
	PVkMt2hg5qLblPAsI+4Vi4y2YtZG2BugMVNq4ZZTIzUbhnZqawMuIfS3f/lAQMMDibHJ0uGgDg3JX
	OSAvRPTav8KbRkfVSjHUSr2RvLpBvqnejyuCsSQJMlSP63i0Po4kJuKyiHcliogDx3UgdDucL0QV2
	5G9cBUCM2dQWz8l4f09Jaa8qqiY0J3vhOtGZBRi7qpJUgM5E72ywh1UULQrV+HwK84b8Wg9OQqxOa
	sa1NlfZ2ZD9070rbebqg7/qDEGBwpI4vxctc85i+ErVSm8V7QD915w+fVH/P1zrCGHsWA59Vr+pC6
	cCGguqqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGEqZ-0000000BgZq-3zNW;
	Tue, 04 Nov 2025 11:05:07 +0000
Date: Tue, 4 Nov 2025 03:05:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: Re: [PATCH v5 5/5] block: add __must_check attribute to
 sb_min_blocksize()
Message-ID: <aQnd4-RRe4K_b4CA@infradead.org>
References: <20251103164722.151563-2-yangyongpeng.storage@gmail.com>
 <20251103164722.151563-6-yangyongpeng.storage@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103164722.151563-6-yangyongpeng.storage@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -extern int sb_min_blocksize(struct super_block *, int);
> +extern int __must_check sb_min_blocksize(struct super_block *, int);

Please drop the pointless extern here, and spell out the parameter
names.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

