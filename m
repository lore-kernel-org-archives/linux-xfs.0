Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F1B36E494;
	Wed, 20 May 2026 08:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779265286; cv=none; b=s5XAj5nBogbfNVBFLfdvU/q6AIzh+wUAI4acXCn4ZOZudrN+EOyJdxhvqsN3N7RBITgD9t2VoXXOQ+uuI8iXm72zvL46Dx/f3zq8um77wKWaiWzMglQcfbH2LlcZ5h36rkRbEYux+st+4LBjzd97wStCuWDCb1qUIGtKqnpHwhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779265286; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRreZr+f/OEFvVTvlXYR0uTb4PdB4SmS4CS0kFW6UoVMgmB3mkdQSDPPRHK0Md2L5Cbbva8YfH/B8mHlq7jgVabr/k4DBjZRbPHqM0tNZu8L1WvJzzgXw3kUKOgh+BUnZZco/sDB6q7sniJwSsxnSOJTBQYwxJejqwQGkCROzMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d6xMt7Ar; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d6xMt7Ar"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=d6xMt7Ar3bVeIFU1LQHajKgBQb
	/GrKL+pUL1JpLsu/msjhbKj2fE6c7QusEdXpIPT5tL2wbtg+SmqqVXjXtXUXKTd6qB6wyTodHvY7i
	kqyU75xDudct5JgqxL9RNQnNV4g/4VA9Kridt4bRw6xOxX0KDUz6vygeiufO4GFDsxTqwTB7Pr++l
	iO+6mfuvwBmOYlBKYri+du0Zqz6WgeOPNX6jD22x8CThPA6w0ZMl7Dd7/zlC3HECMSKQiVUoJG4iq
	V0UIUvndAsqflv3Xq+iV7xUd8BGghLP9qcdu0qUgINvD7hO2XItiiMXw4dsr/lnjp6g/RGWIxT6ja
	z/anjqmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPcBA-00000003wZ2-06Bg;
	Wed, 20 May 2026 08:21:24 +0000
Date: Wed, 20 May 2026 01:21:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dai Ngo <dai.ngo@oracle.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix use of uninitialized imap in
 xfs_fs_map_blocks error path
Message-ID: <ag1vAySwz518n56h@infradead.org>
References: <20260520003503.2399326-1-dai.ngo@oracle.com>
 <20260520003503.2399326-2-dai.ngo@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520003503.2399326-2-dai.ngo@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

