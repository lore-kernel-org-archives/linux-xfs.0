Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F6318E2A
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 07:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742542377; cv=none; b=GT4xhMY4eZW0sFAVgsVHcXQ1wSCLVyhP+tdZj1MuB+xWpsYjlkTUHP34HVoKaOm4stPMtd1KOnTElnluax4OLYVlHtDyHUSlqmhlVO744w9ZSqdxryCcfytlXV5uxzmK9b+w9DFq4P4pdU7MzlXuJPc1+XMWQdVkzrMMtaJ8W/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742542377; c=relaxed/simple;
	bh=GlC/13WwyZTBe1ZrcUXNOZSvVmXjY+KpL8J7mYzBVeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAGFj4XFAEdJXARqYeKNHD/SHYvFE+SuJ9XTxlaRucC7oe/UdMJKwWLW3JpMnfHaLIvp9RchUM1GtQ3iX1eoR9qiCgIxWDjFxNeW/7Bssgd4aPXSwEi1ePvzG7cCQwi5M6TuQ97vXcGKhSqTvztzFOtwOLJb1BfjuVHl/Vd2t1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=byxaQTn6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="byxaQTn6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GlC/13WwyZTBe1ZrcUXNOZSvVmXjY+KpL8J7mYzBVeY=; b=byxaQTn6yZo40KRWYhlkeWTWnV
	OonbUCJcyXYM5pjIosfPIRacgORJYqktzZg7/C+hDv4d3fMZSfwFl0V0wa7J/DlCMgOVomER1FQi6
	fDEFqojaFmHYm5a7sRPsfUbi4O24U0hk9VFV69tqWo6C6lw/PIwKrLKdrmsD+/EZUfkc99SKHO09c
	zcOYM37txn3sV6WBFaj4+L4MPpVcsAh3E8+UiswG/7ZJ5XthIqrXFv5ODOZSU2fNtGzqDJq9gYCD0
	mZlGIpTAQGV8Ss+n+xDc2Yc9jBct+GT1hKmwzbA5y4vNiANkXeD3N09XgP9mUqWB8uo/3Ke+fH6rc
	uBwTFigg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWsC-0000000E6qI-0bx5;
	Fri, 21 Mar 2025 07:32:56 +0000
Date: Fri, 21 Mar 2025 00:32:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: bodonnel@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfs_repair: handling a block with bad crc, bad uuid, and
 bad magic number needs fixing
Message-ID: <Z90WKKkLtqFvMNkK@infradead.org>
References: <20250320202518.644182-1-bodonnel@redhat.com>
 <81461ddc-bc91-4bbe-9828-956a67488856@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81461ddc-bc91-4bbe-9828-956a67488856@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 20, 2025 at 05:21:22PM -0500, Eric Sandeen wrote:
> For anyone interested in evaluating this problem, here is a cleanroom'd
> reproducer metadump image that demonstrates it.

Which makes me wonder again if we want these kinds of images stored
in xfstests somehow (or figure out a way to create them by fuzzing)

