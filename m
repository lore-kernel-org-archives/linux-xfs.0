Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBA25916B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367537; cv=none; b=OrfZlW4mi3x6gVrGSSqK0MA7w9zp0vw14oJP2R1ZeC1EcSsLYCiB+tulPgrybTnrLE/SnXiAUP3U8M5TJ50dg5XhNtaCFsA4BRolqrvJaQi4dHyFuW6ITatX6FhQgqrFqER91mAQhA4Mu25HpHrPJVOpfRnWnc0Y47GMM5gYkXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367537; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlvsdToU79gGKPfNvWkEYOfl1XYBZoscfTGb8UrpexyFBWYU0aWMqsjHJZEpFoUGl7DzX2BqD74OcjhE2rG7/2WcXKpZYzEOoNgBjp3Umu63kIrTrwOa0AcnlpD/Q50se8LtJ2AMBTg8dROkYJGBr9Lpkqu5y9yZQNkD6DRMfT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4UdE5C8w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4UdE5C8w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4UdE5C8whsQ7+S5GH99BjjZBqh
	xjanrHhCriXSJL0FhbVZWSanrUakyC3MSlfhyoswU7NPH01/B7TiSj9rRTjPsg1pU57wMectZ/sWT
	XRCGNOH1vbbqn15fT7NvCc7UcUZSwths8SZ2fkNKCH9s6mOXDa3yIz3f0/axjOQm2rpQ/vwdSc9iQ
	P4tdn5SO0jxBdQEyoBMTx1hKvS5Bc4grKBFQL3O+3YM4sThM3briq3RfJmtzG9RRlXUoNncvLLVIw
	d5bfQ2ea7/j99Wu5nx3wwRh0xSq+h+drcjvMIcz6CZF0I95nQz3A+FZsbF1+jEwCOJrmVWCZXaJ+a
	/Qlw5lMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWjA-0000000C4O2-23ns;
	Wed, 13 Mar 2024 22:05:36 +0000
Date: Wed, 13 Mar 2024 15:05:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_repair: double-check with shortform attr
 verifiers
Message-ID: <ZfIjMHKP_HIovbGu@infradead.org>
References: <171029432867.2063555.10851813376051369769.stgit@frogsfrogsfrogs>
 <171029432882.2063555.14424210570382825212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029432882.2063555.14424210570382825212.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
