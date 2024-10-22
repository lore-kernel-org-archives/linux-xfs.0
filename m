Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37BD1E529;
	Tue, 22 Oct 2024 05:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576087; cv=none; b=CjQv/X1pYrkGVWcLIXKI/4/KSfNOMaY03EBDD44QOlZFr9WlZcWEh2zNK4vyyqVXyd49uQ1LxuXnCIouOzRod7ZczCeoCvnLXX6AWbKdGkYksryUFfuExo1JzAmcp0qZ5Pol5rmjTuLVOt0TRZRRz4YGOjPskRj30SB6scxkFLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576087; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d0WtRX/7J1XmGg1L2SWv1rAbsL2UqonCvqzGMQDgSxrr6l6iJpUr0Qr74kbZ/cXFPC/v7SRlc5zRVh+YjtZn/QAct+IM+MaQ+tQeAKuHlTR3JwMJnuFt57ONvd5D4D/qWYFXpNncvaAXk/IVgME5tyoo8MfZfdCmbbbsUrOuF5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OvEFETNb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OvEFETNb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OvEFETNbmC1N8nLJtlAESXt5Yc
	c/jVJdFxXcY7cFg4N+G8+URK7F4L5X+xOhNdZRt3PrFCrkzylmoAskQxF2TPGCGjQqdp1ttx4XQN2
	LmU/9Ye5/4/iJVsjG3XK4I96ESKcXK68+lF99uBCDwJgW6KDKXFBIc+UX7dnbsl4k+wzzNbOzXzYi
	bF0QecNyt/zlupeAYrtWlgXG4K/Om0hsYUvFoYN2rgi8j9UonaTzZnFcxd1/G/sMiNzDd2u9uYbnF
	527J7kfLJW8ElgcVC7jWFW10dzIvD1CE3iebAzLof15wJHsHB/mZ/sA7k3m348r9ZEaM+WbnF/qAH
	RlGjjnKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37kT-00000009iC6-1XAg;
	Tue, 22 Oct 2024 05:48:05 +0000
Date: Mon, 21 Oct 2024 22:48:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/161: adapt the test case for LBS filesystem
Message-ID: <Zxc8lT63jRbl0R89@infradead.org>
References: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
 <172912045624.2583984.16971966548333767345.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172912045624.2583984.16971966548333767345.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

