Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46AFEA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945120; cv=none; b=cV0XWq45Ovcg3qBVdf4jWauFoKMZ/vq9TgiHBSezyXaomcGqfhwgtpuFvYJc6x3t3qbynlCbBmTW5lOf8Usl072zBdMeqy+cOXpjuQIf9sGBpoF7iLIvuhbnmOwGNLUH7Ua6gWExX8ywAqDpvK1VUnyYuTY+oeCOawbigZJnAV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945120; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EFStcP6nuiMAwkn7pNdvVfzrE7r1o3MjZYUU1SFbsWkidLv5LhubFB3vdXixvWbWqnRJBnMt0giBPlH3obD9cQdGu2dIpOgHGTYmL4fv2nmEFdJ1BRzPYWa4ifV9qqwCt1RMIkzp5Q941kILAfWU2oqgPhre8ruJJxDrcgheo5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lSzOY74V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lSzOY74V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lSzOY74ViiqvxRZgv2ht/h0D+v
	lAsh+q2hIgGvtIUgp5yx4EcZgnt7LhddDB4Qcehleub0VD9QRTgjkcrJbcMC3FXhYfhTqVKvpMwBq
	6wxIrTUAQzk8X4moqOvu2DedIIlZQKfuFgdRvhvf3yDzgk0LzrRbvqaIbnFN49n5wwe+kIjt6PaPC
	JhipiSEq2ZQ2ffT5n+iuVYkMp+wAnEGxplb8FDeWQNCJ0JSqfdee2p002pLsPskhTQNgw/Vy0RNvu
	RrAuHzHmIY4UMwPCWKiYnYVL+fpy5hmNrraW1Ji756/QDueMC9CeR1lKkVFNfCRaVWCtoTall0t9T
	Gnqmrf0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW9G-00000007fwy-2LQf;
	Fri, 21 Jun 2024 04:45:18 +0000
Date: Thu, 20 Jun 2024 21:45:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] xfs: create libxfs helper to rename two directory
 entries
Message-ID: <ZnUFXiAtWHOBCffi@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418260.3183075.5528355196436694451.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418260.3183075.5528355196436694451.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

