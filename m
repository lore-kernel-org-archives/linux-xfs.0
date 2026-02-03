Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B833419CD0A
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 05:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770095933; cv=none; b=MxpSsV4oJrNKKHdzagrRIBg66akPDWfonwa2rEAYRxg/160vETJ+I7jaov40WisAuWp2KvmTfHfWl7ckVi51lQbtH7HUuEwBG1+muG25k/+p3a5BuHGqnbhzjkMGcscO0nCW1bGU8oWpuROnEpnz8Fsd2rOOJkMmQmidWEFq5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770095933; c=relaxed/simple;
	bh=/CIR5uV5LPvQCYZq0GAS5ZHpnGAj5q6ibgFF+UsjCm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZwR0wwHw6t+67L1fnS9cuRKC6S+KNlonogMxHg/ejB/E8CdyhZfp6g0UvJvqJAwVv0YmGiWhzchtSkFr8C8fVSXvsiActkdYd6DhtW/Fu8e/lFmltSm/lrP/3W4zBbnsO1DUnb0yC46jz/jgO7+2jgBpnPtAa6SocIDEUID05s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WvbPpqI0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WvbPpqI0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JVe2a2bgSZ/1tq3EsrdaMhPg70DEVrc3bfFYmpT108w=; b=WvbPpqI0fI/ESzEIoEN4p7bJqL
	kckNAeDSObh06wNkON+lZjDKCKZeTF7KVK5MigGAIVXA//1yk4chXRmDEZsQ3XkGqqXySCevXqwo0
	xqpAcEm5PPZvheHPvXwHgtw+p+3qT1D80jiLRbQARmRBrxfh0kjzF5g6lBaaIfMeD4gba1ysvwiKu
	BzcyuR1+C+YtoASNlOwF7pBQOI5ZFEcjO5rhi0HbNWF/IkNhJpKXKordxlfPNXRipNe4v4gQ5z0u7
	r79a6rivUkPqDc1DwTdqgZfnF7zgV0kcJe6pVhjhDa6UgwSu/f6kdMorzp1BnCCWOaYDTLE7pDRxj
	X65x9SLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vn8oM-000000065XU-0fGd;
	Tue, 03 Feb 2026 05:18:50 +0000
Date: Mon, 2 Feb 2026 21:18:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub_all: fix non-service-mode arguments to
 xfs_scrub
Message-ID: <aYGFOhGdYys0sWWZ@infradead.org>
References: <20260202191405.GK7712@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202191405.GK7712@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 02, 2026 at 11:14:05AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in commit 7da76e2745d6a7, we changed the default arguments to
> xfs_scrub for the xfs_scrub@ service to derive the fix/preen/check mode
> from the "autofsck" filesystem property instead of hardcoding "-p".
> Unfortunately, I forgot to make the same update for xfs_scrub_all being
> run from the CLI and directly invoking xfs_scrub.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

