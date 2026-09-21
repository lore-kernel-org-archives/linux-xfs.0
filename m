Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE4383993
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979058; cv=none; b=Ss1Ird2K466d2vHXP8jRJPcGN6onJvK4xH250BsQmSdxLVrB/y4XcTkAAdryEsHcsbQ0DLb5R6+HPSUyVAvcPYHWZz10te2HqWWT9rxgOBKOy+pLZlevYmsQHRxMM8HT36XUkzCUym2XY7/jWcqgJ/XomF9/7nV3fStWdaGbkno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979058; c=relaxed/simple;
	bh=gkM+i4eWWNXh8TSX7UCtycphWAJiYeLbvYm9gLwFwt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fN6ZHFuXwdAll9G43MjdbBVB7zDhMEARuV5moy20Tas82Qu56GzeX+QBHTrofk0hB7X8pAT17UPBQ6VaYih2I/Jd/CjZ3i7M5c6xfoO9CGKoTsyhlwWhfW2va9C2Q2i/CNg94BQaZMFTs3mWmroQVCq80e9Gnp8EBo16itIXTDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JqbD4S1d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JqbD4S1d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ea4GgHJbFA1O6fpQEV3CMHJ3szBs+5zpCZYCktpHfO8=; b=JqbD4S1dG8U/myTd9v+QOUmmlU
	galGYH9oLI58M5Innzno2G7q9YQrDv68RaE10HXHgbHEzjPnqRYHcH9yxC6Z6heX6dBE8A6sEiz5D
	ZVbbXca7MNCSuZOpzzn2OeQ+N4KIc8+8ciq9eEUnENdnPwkwkSTiVJeoLjdzcwt9p3BXhD9SxPbP1
	nAGtt5+lYpVoCO5/PyiUPvcr57NuU6D3APdDhPMeHU8sXHFVrG0UmEyK6G9OAmFy6DnsYDWK4RDuS
	Zsjn2lBVnEwMyqGhYJwHb18x1Xm73bc7IdqEykNsZR8hQNJhVnYy4V119i2oq+8PkErPeDVrjmvR8
	9yomd5pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8ZJt-00000001Kz1-3P6M;
	Mon, 21 Sep 2026 08:24:13 +0000
Date: Mon, 21 Sep 2026 01:24:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH 0/2] xfs: dedupe realtime rmap btree code
Message-ID: <arDprUJAb7QP1EVx@infradead.org>
References: <20260918181324.2472127-1-sandeen@redhat.com>
 <20260921034003.GG2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921034003.GG2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 08:40:03PM -0700, Darrick J. Wong wrote:
> In general this looks good to me, though I'll add that the same sort of
> code deduplication could likely be done to the refcount btree code too.

I thought the same while reading over the patches.  Also the exported
in patch 1 threw me off, but it didn't actually export anything.

I'd be tempted to just merge the two patches as that's easier to follow,
but otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

