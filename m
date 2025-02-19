Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980B017BB21;
	Wed, 19 Feb 2025 06:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739946054; cv=none; b=Y4Hgg/aIYHjTtVrbKwK6S3HXCUiSHWR9c6mK3gH2TkIcA1Wz/fuNSfcRl7ySt9ux62u02qus19R3F5ewLprxED2CAxY/D788ngDpPte9n+5K+HnvaJc0/YDz2qjvrGGfzfJl0Aih0VuT5cT416/FhooChLpI3nDa8i3K0eN3VVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739946054; c=relaxed/simple;
	bh=cw8erjyMkd4i/MnuO5QXPDtaTE0b1jWGbICEab5yusU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mIP+s8iOzRdiaVbVj2hm795Ys6Wy8+hh2dp2jICuaGNeuyz/1FOC7LENjN2sJnYPW7u+Sjoh+taVJmB2jOjJXZTC/60LfuvnqfDnYJ+fwXKNYfQdx9Nb/Z/n4oCC/4H9dW+kpu2Q9aYv4qHdCOgR1Xpr7Zi3q6+QS01r/b9EG4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Eow1uCfa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Eow1uCfa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tu7nrOk3OlEwTy8yuUntAGWxW9V7EfgGZdf+XZ64vhI=; b=Eow1uCfa8iJhP1z6LdlEZS2xHT
	6ASTavyTvvi0HCAg0QWE4bu+sxxD/0rhT+mIRC+BkfJtq5LclbamMX1XgIrwwe2Ko0HapLcc62IyR
	3XgAD5Nsp4Cq6wCTa1AlDFp8iA6esbQtFyBI3GwuIoHDtLfpdTiDBM34449dy1zjr9VIEoLWfqPev
	mPf38pFos4yH6Ds0Uhm8Hc4nhSkGzv5AxEwc0yRKl6ioNxhJh5/yYWE8wqST0xa47NLCO+iyDk0pu
	WQJ7ue7BCurqeAzkQqdLwJJui/jG/jdLiE6oXTNvhb9KukF9EHQQ0nbl8ZNJb5LAWyP0kf4cB/YwY
	a/TLgNQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdS0-0000000B1RQ-3o7H;
	Wed, 19 Feb 2025 06:20:52 +0000
Date: Tue, 18 Feb 2025 22:20:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCHSET 02/12] fstests: fix logwrites zeroing
Message-ID: <Z7V4REM7dikydQXJ@infradead.org>
References: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
 <Z7VyWPjJM-M59wJc@infradead.org>
 <20250219061336.GO21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219061336.GO21799@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 10:13:36PM -0800, Darrick J. Wong wrote:
> Alternately we could make the log replay program call
> fallocate(PUNCH_HOLE) on the block device before trying
> fallocate(ZERO_RANGE) because AFAICT punch-hole has always called
> blkdev_issue_zeroout with NOFALLBACK.  The downside is that fallocate
> for block devices came long after BLKDISCARD/BLKZEROOUT so we can't
> remove the BLK* ioctl calls without losing some coverage.

FALLOC_FL_ZERO_RANGE on block devices has been around since 2016, so I
don't think that's a problem.  The problem is more that it isn't
supported on dm-thin at all.

