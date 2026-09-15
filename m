Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4544684F;
	Tue, 15 Sep 2026 06:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453773; cv=none; b=ouc7aDTBBTiNwFa7iSDYGgRTUyoWnTXPkq0DAXXo9OAngrIcBBbsIdw7Z660ZprEM72UqRblOih/CRkwfYm6CLGPPxdnLmAd+Pejz+YRDDhZdJoxftrkiHwyKs2CAjV3HqzH9QwKZKGZ07IUOcorJqrqw1IthkV/+KE+5GHQq+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453773; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2TmWgP+2qG5ipmHwpQ6pSvhQXhjgfLiyYkWaR9ow9/RoCQUD1rFelkkC5hfhgDhe8+uKHHSA5zHk8d2TwT489a2Y7lNpZeX7G2cbwkrfyyi2VmJuwvPzkMAMTiHPJZwIZYq2Bi6rgtBGw0/QgvJFyeTtBBXk1Tu9+aoa74m/3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n6i5xQi6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n6i5xQi6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=n6i5xQi6pJxjjyBgtHs21fY6/S
	oKs4nTsSEbvy6QTFLe0dS9fZGBWdiAIBlA2x09s+OK099z/BEEdavFJBVcDYqVL+f7b42ynfzqMSh
	BTZ/TrCugE4w+POt9xizoI79iKt0DxYe5hPa3g8mRtN9fKkeHYV5ZLtvqmOWkSRUsFtxoHXPIxBFd
	TXQIqA2g3m436aEe9EWCe4EPdRXAB+b8disBAJbecfBv6qJE0yamsbh2hp/+iqFEi8C1/GHCPNIRi
	YkXvv9siXc29xul3sw4X+c61uqWJPq/BNWWUcARjkFtr9wcb109ymo/1pFzg1l1TjWfRHUM8cD2sz
	zbU5N1DA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6MfQ-00000005LUv-3WZW;
	Tue, 15 Sep 2026 06:29:20 +0000
Date: Mon, 14 Sep 2026 23:29:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: don't cross reference rmapbt with bitmaps if
 they're incomplete
Message-ID: <aqjlwHTEolKxPoay@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048585.3061055.4137479524844786489.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048585.3061055.4137479524844786489.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

