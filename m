Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA37D29ACC6;
	Fri, 24 Jul 2026 08:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784880402; cv=none; b=U2Jtke77w931mTWL2lBN7BGHRe4+YvWra820RgluSpeyLdKDBybJFe1CDiRZHndEVb57WHfEh0QszRypNZ5UZ+w5lgISpFVDdZGnTXLmbFQ1wzOkem0WHNUvBRXp21P1pzxQnD5pN1IKGqOmzOHkxDUyJ8SUZCJ4o7TNk4cX75Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784880402; c=relaxed/simple;
	bh=iZb49ZeIC+UUeJAJg0ic4cIg8pru2gqiTZch+ZYYZaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSWD8Yz0fgDMQQ/8vCKep/rducQWDREl+cBghrC9HgcptFbYdBp2R/FtJKcWjGbrolgA0Uq+QQlFpNiofTSV00bYOEduHHR5KW4Bajd16jeXZVhP42ZMYcYWla5RQPbb0IXu4xXjY0Veqa76Q7TFaTVYu87nnYnQ1r3WZkGPs7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FplthexN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FplthexN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lRFSQKrcBGLBSZK0JXnqHj4EHiTao/X/9EHPqozoT6Q=; b=FplthexN004VK53QwUsnttWJYV
	+x3Cg1h/ayQ8fnXf5mef0vMFB8flqqLkJSvRHPWfb+9OfHkxnzk6dQjJwta3vqiNcuk9F6tLYk6nv
	xBjvyior8D8U3vaB7CsNqmzhKE7NyyDVS07vIQP075jpAzTzfKl5eAAAYSzMSbLXxn2h5H7/6z/wq
	ncy52JYPhcp+bPYDwzHhw0XDPYxV6PuL6fmdHx4aKMg69IcC03aF1UlO5okqiolj4wAREb1ZhWA0n
	v8ufm06t/YCme6STC96eXxgoJNDUzDZymig3dcu1blL/h1/czhwF1K639qE7ZLyS5nm397CrXdtrp
	bRmCAw/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnAvT-0000000Fkxf-4BfY;
	Fri, 24 Jul 2026 08:06:35 +0000
Date: Fri, 24 Jul 2026 01:06:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] xfs: fix nofs context corruption in
 xfs_btree_split_worker
Message-ID: <amMdC5fvYcsFXNmA@infradead.org>
References: <20260720050522.3101824-1-yun.zhou@windriver.com>
 <al3dypUNu1VNZErK@infradead.org>
 <3f683dea-fdee-416a-8112-2db000c4cf4e@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f683dea-fdee-416a-8112-2db000c4cf4e@windriver.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 24, 2026 at 03:54:10PM +0800, Zhou, Yun wrote:
> Thanks a lot.
> I'd like to understand the scope you have in mind. Should the removal of
> xfs_trans_set/clear_context and current_set/restore_flags_nested be part of
> my nofs series, or is that something you'd prefer to handle separately?

I don't care too strongly.  Maybe we should a minimal fix for the bug
in ASAP, and then we just need to agree who cleans up after that.
Happy to do that myself if you don't have the time or aren't interested.
