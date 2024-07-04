Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54130FC0A;
	Thu,  4 Jul 2024 06:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720073119; cv=none; b=HIgY35w1hf+3cbCxM74M9NrELA1sGO6z1cU36E5wWHibhPU79c+jZV9P2b3FdgLKnAZUVH2pRfTMSpQN2oZyJs5KL/O1cYb6G6uHEF3bkzkdKSwLSnrKLZ6taKC1pw1rg7KZFEsWcwJYCYiSjyw5O4Zk25+OQLY4jdp2dS41VjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720073119; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebaUYwlvhZzlIN6YfCYczFpKlW04CuxcsXhlalSMFATu7PkzqbuPIFy0/PQpk6IXSg418zTe72Wz6tk9uKN4iKHQndemeqVbiIdjQM5g7TG3KyH1SooDibMF2hFvz/wYQMnGJHpsrRluAxULJBZnsTMObWD+ChHFMn+fwUw2v7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sKcxgyCs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sKcxgyCs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sKcxgyCsMyIZMev00PA+8o6O+e
	6dr0MCtv1BqyPC2iKxis7A+De+y1/6Bw7WTrBevK4VhQlkxJEcz20oe59mvPENtz3MQPdgA0bzLGK
	Y5A9oaV5kMepG6Mqn7916Ah/wCkJezMTPO1wqeYXo3HARQ4HYNyJvx/YxdaPVWWJ1jEwiWv3cGY7r
	oIsjCX0GTXIoB7vUt3mbLsT9cx12x0FeSZ4kSPSTZPgRbpfQv8lhCB4mqYRyaO4wssNqyeysqrp9P
	ksfTslTKmyd/h68NXwPJ715IOgTk54ArJaOw4FC7YCxnUGuqvP+eDF/F+A45CZRr7WE40OR90p1/K
	l+lFelAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sPFao-0000000CI8Y-0BB9;
	Thu, 04 Jul 2024 06:05:18 +0000
Date: Wed, 3 Jul 2024 23:05:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] fiexchange.h: update XFS_IOC_EXCHANGE_RANGE again
Message-ID: <ZoY7nkrSH7iNNqB2@infradead.org>
References: <20240703213645.GL103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703213645.GL103020@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

