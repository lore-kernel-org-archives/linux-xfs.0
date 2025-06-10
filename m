Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A539825E478;
	Tue, 10 Jun 2025 04:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749529679; cv=none; b=bmwQssE1H6XJTaeWx25n7qlrBnaJLoT/VBX9FKFg2BUT2LogXfmA/4par/+JSiuKounE2aCyiHXTDlGZPXlWzI1IxSCZfbw+Gg2cdFkNGzGvXSfYxROXZfk3ybubRSDlQIa66nqQioF2gqn9ClmLRTsxeu4oWWfTdciujryIBio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749529679; c=relaxed/simple;
	bh=xc2jraNj8qfaR1eHGVPTE+0Ue0g28eW0/XxirMLP8EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9Di5TWS0X/4PLb7hvBauJx/YjgeRGk4+0pOqngIqq3peR4IJiOq7weLyjiqaLBspjIBEtTvBvKiz0JTYF0wHivwmIlQNiYQu2emAmF9UDoGWzWqW7dfiIDcVjP8bB+wrsRB5qe4MJ6HYXW0xVF12QuE7oCDa1x00iqQZRsnVQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g2M9CK+r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g2M9CK+r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZWeBsIYxOyK4qvGfkitDUEtgO7QAEpZ3FajpbOXA4Tw=; b=g2M9CK+rKY3rRNeLZiIvZZvFjr
	K2U7bmhER29nEXIoel9xmTQpiGCVS/wdeyH2IPeNzsXxuv+aoCjmQbk34LXZd2gQY5SvHJVbbT+vX
	QXX3sM6Vx5ZtoosSr2v0XT58DGmdyBZ1Rsz+OLolkXGyLY5YEDZHuEv/YTtt3KmDHBG715IXy6wnh
	snJoxSNHhYXMT6K+vsL5Lj2GhrWSHjOMmq7UziNcz1P8ehhV8ydSkc14GGNpkP9wtvQXTXR+apASe
	tZGXrvnjIP/NR9L+zPvsf7bTB+4gQiJxNrzfAZ+vGLILP7j5js2NGEZGxu6CBgupQEWmSI/d/A5Y6
	mjMUv6Dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOqac-00000005kXb-0mNw;
	Tue, 10 Jun 2025 04:27:58 +0000
Date: Mon, 9 Jun 2025 21:27:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/7] iomap: optional zero range dirty folio processing
Message-ID: <aEe0Ts6c6Jnt-JNp@infradead.org>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-4-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605173357.579720-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	 * folios in a batch may not be contiguous. If we've skipped forward,

Start the sentence with a capitalized word?

