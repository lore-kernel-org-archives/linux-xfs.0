Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2233491D6;
	Tue, 10 Mar 2026 06:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125363; cv=none; b=uOE7LBV4gfpg4co83Au9P41zIZnDCcpFN9AsQT+Wu/lVZf2UHEJEnUA5k4K6xaAdo119nn9FIlVIEf42ILcO8Har+MiNgcAt3wJNc2C3lVOEozF6PTJLKAVzFWlmAPh0YFmOZ3Fwr+boY+Cn5vJgFXG4G/+YSxzjmtGJOKDLYkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125363; c=relaxed/simple;
	bh=uAF4o0leEMwDLazxXNHhL25cjRl4PVyvXBbWgEyzkMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwrB7eSY2UznkvfcwCnNuRQ2HHPHBgfJEuBT8vo4jea1M/60fow2v9gyfGEgtokb45hwlK5sgCzcB0LcukVd2uSkoTVSiIQ66H/YQyeEc6BbD+9VtqnvcYGaJHjU1dhZgxUHbo5c3toQo8heynuUAQXweHr8eTPTAYQG8OwxuQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bEmLIcJt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bEmLIcJt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jY5q9eCXubiyMKmE+dIdz3WHi3tv9hyrg92kgVnsJaM=; b=bEmLIcJtEiYSbsHzyE2pCm6KF1
	n6iprY9GAdwBgkl/HVFq6oU/NXoEvERPIG8vn4bIDiQbVn8j+YxId8Hda6ikgF3kmJKq6XSiScCs/
	2yabUHZZU1pPK2qN8QcAbkCj2lEt3Urbhl7/L1HduP+gL2HdWYrHdlGooN8DwsfqYoA/hiLxl1CRv
	XGnKIlHj2tP5s38MveslzJIBzPaik7PwApvjYcKB0KMELpguZKqF/dVzzNCwhgpjipzjeJaV8PfTC
	VcRxHEwTFRx46v3JRwf9gMEYRADNSGdemPxgwNfYtn8jGUS1Gvjm6xd5163GdpEJV+kar4+hpAucE
	xx+wWiAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzquA-00000008o9Q-1MyB;
	Tue, 10 Mar 2026 06:49:22 +0000
Date: Mon, 9 Mar 2026 23:49:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 8/8] xfs: report cow mappings with dirty pagecache for
 iomap zero range
Message-ID: <aa--8r_jDhBxZrjP@infradead.org>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-9-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309134506.167663-9-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 09, 2026 at 09:45:06AM -0400, Brian Foster wrote:
> +		if (offset_fsb < eof_fsb && end_fsb > eof_fsb)
> +			xfs_trim_extent(&imap, offset_fsb, eof_fsb - offset_fsb);

overly long line here.

Otherwise this looks good.
