Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CEB645
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 06:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712125177; cv=none; b=ejBRbs7EB3ggd3EDCjmd26Ryz+D7LrAjXs6HsEQu9LU9Z//eBLmf9Vc5+6F4/9bb+P9CdZf7IeaAKJ8C6lM/R12U3q1r+bK4C5lqN76+MCPEkyG9T4qwcKaplkadKo0D7l5D4/yIY0hxwfh6cEFEzS1HUYe362iux3K68GhzuK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712125177; c=relaxed/simple;
	bh=4Wzng8NcRSnT4wJ/5wJOanDDrXRyhC1ayQrSvQIswOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=paqOk9RrL79DOou/seCAYoUzT5d9wl6BxOJHR5QfHIp/H4QQSuyJQzN1ELwl+MYS6Fw2pgk1r/EgHWkqrCp5g7I+KuoXKIK3y6PBKIftytrneUYho5Gfq+y/F3+nsbpdy5tOZ8GlFMr6wsSKsEw8xTaRNegHLEJ8POFRUXW8IGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QFPX8eoh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QFPX8eoh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nNowLMO+auq/oLPs1qOhh5SS0ZqtoSLVZkfaRBDOays=; b=QFPX8eohVIQWOpWvEKxrJrZff5
	LJHrIXRjB4Vh6D9YjK+Ken9bpJwqs97H0VEcsvfVpjtLidCeOuEscYyeXhor1/2SWQmd3yt8bqQgT
	Dm1vViXnlmTqCFHOdi8szGyAvcnVob0U+l7VWarRP+h7aJe+4VfI0pFwp4AgO+gBqysulAlIBBvua
	JHvnjiWmjx9OZiCzgFO0dgoiPq7vmLqzRiiaWBeTVieajOxQIuDIChdt3K12kI0QoAacX09uzHchi
	Va9349yFbERMn+aXXVCd8u5ZkJmTpJJdrqKMufbEHDmeIDTttvnWp6jEIZ+ZLD9KUj3xyN6xHOGtP
	JXfZXrDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrtyA-0000000EEcd-2SiZ;
	Wed, 03 Apr 2024 06:19:34 +0000
Date: Tue, 2 Apr 2024 23:19:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org
Subject: Re: [PATCH 1/4] xfs: use kvmalloc for xattr buffers
Message-ID: <Zgz09nfD7CZLFLjY@infradead.org>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-2-david@fromorbit.com>
 <Zgzdk8GhHXGJpN5o@infradead.org>
 <Zgz0WroNAbTDEpFu@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zgz0WroNAbTDEpFu@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 03, 2024 at 05:16:58PM +1100, Dave Chinner wrote:
> > Can we just get the warning fixed in the MM code?
> 
> I'd love that, but until the MM developers actually agree to
> supporting __GFP_NOFAIL as normal, guaranteed allocation policy this
> isn't going to change. I don't want to hold up the LBS support work
> by gating it on mm policy changes....

Well, let's give them at least a little more time and only add this
patches to the large block size series for now.

