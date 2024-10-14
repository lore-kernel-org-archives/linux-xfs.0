Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA02A14A092
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 07:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728892403; cv=none; b=m2cJ/Dzx84xzo5TFXH5oeAhF8W6IPgKIwWOU+Kf97SO6my0eMNXR0nrFSQatISs6jFSx86f18RTVHVTtDlQiWE49hl13T0IUfbzvdFHSNu+mrG9t+zyPgTpMWVja/Nfv4NlMlC3vtXqsSOKp39GG6A3BWf8IJGVDwREedohE7XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728892403; c=relaxed/simple;
	bh=g/EujzEDErgzob9kQ70jrG88pVYAxW48ZwF4VhQYJt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUAsTF6rVBRLU5pJUvxVkFBNo/ozoRHQQJGjIs6FZmGknh3CuTqXB00qnI+stdu1vk/wPg072q+pZVWv73aioUveXojU/+ByZble2+XghhYdew6htESs1FQsKcTUbtLzXDXG2TtWMXzw0nJJNIjJtNlzcwCnxNuGa/0giZbcqWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jaK6YlM8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jaK6YlM8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pE6gjxpqVm1EXfD04Ol5lEWTobtAV6Hg9XbY7AEac4o=; b=jaK6YlM8RzrcoYiu7jWrVMWIFj
	yKEiK4Nk+BXik+qmrpGZ6Xw1ilop+XdVVAQi/aMUpQkwlxp5fu2cse8qiaz41rBZdzz8V1l2H22nT
	BKfAp0YrJVqixW/LmlxaV4MUlFrQ/NZ7DOEI28NBuWlZiS2CuI6pLiri3h2vFLF4AuN6AOxki2LjW
	hICi/bv4WFhgUXjEmAGmNlTIRhqnH8/2Hw7cXTPMJzk8bImHKSzD93ATFm5bkKgXzm6elrevT5mWr
	DoV02U8MT0Ox1idQsy4sr6RTCoKHwrJS02L+Nh9ohVbmdgOwNV62u2OQ4cPr9Cz8bfhRFWd4LiYpE
	5V8qbL/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0FtK-000000049Kt-0U25;
	Mon, 14 Oct 2024 07:53:22 +0000
Date: Mon, 14 Oct 2024 00:53:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/28] xfs: undefine the sb_bad_features2 when metadir is
 enabled
Message-ID: <ZwzN8qs-BS8jIDno@infradead.org>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642083.4176876.2034736773059229041.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860642083.4176876.2034736773059229041.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 05:49:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The metadir feature is a good opportunity to break from the past where
> we had to do this strange dance with sb_bad_features2 due to a past bug
> where the superblock was not kept aligned to a multiple of 8 bytes.
> 
> Therefore, stop this pretense when metadir is enabled.  We'll just set
> the incore and ondisk fields to zero, thereby freeing up 4 bytes of
> space in the superblock.  We'll reuse those 4 bytes later.

FYI, still not a huge fan of the extra gymnastics for this vs just
appending the new fields at the end, but the code looks correct:

Reviewed-by: Christoph Hellwig <hch@lst.de>

