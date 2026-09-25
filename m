Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5328039769B
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314705; cv=none; b=D1WZhsoR95COqDO3Mvt54xiQ7gaN4HacV29As8dfi/718IjC2TqG5Fn2yMuCDCpqRNp4DdFtFbI3TjLFBX0rjD2ilw71nC3cIexfDjnJDN6ropcYj5R9L40ts/2ChucP48XcX7xUM+uyKPIWnJ0QX4YoUzWtoJv0ZRQ5Ut8j3yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314705; c=relaxed/simple;
	bh=Xx3VymjLkuV9JfDNVNhE3octK47B6nFyhlDgRNtibBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aiUeUxOyYbhvk31suLffLSBI1jV5WpgF/poAfXasWqRjgauojE8HD1BOI9HKtQGh+ASD3O+H6q32UlPU0ZoGPXOHZubVZNUHa8LoniuQHtbw/PZa6iotE+b8gqZxLgfNkEceweUmj95mC4l5uA2FdCmfdiupda7HJ1YBSU96KKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UEha/YvO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UEha/YvO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QbYfFTKjhppabRd7ywHN51/1JIYY0BLG4jWTnJMDyDs=; b=UEha/YvOS/xYTpg6azhmBpntXD
	mN7SzslLp5KR7qnSMn/A00GuHvhzp/Jds2eT/ypXtDaPYVRPtZeOV1o195uHUwsED5jH88E8xcqiV
	+19Ezeo1b7feV901sk4wP84/lRJRUEYYSejzgD25vlrLtoD87fbEGQWKJU0NEUhicQ2qD8mjOkIsH
	Ycp3dBDRD2s99ee/WlF0DNtoCCBlQU/dvdhzNtfn/oKJDwXm1Ke3U72ck4DBAFGsCMdfS1uQLgps6
	JRIFSZX1zlmS3CXAAG5njjYSnJvXOszpFkPFJShdB7WadrrAl5F8JkZJVcaSc8K3TN4qZJ7ViLmqe
	umDNy1JA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9ydb-0000000Chsr-3cJh;
	Fri, 25 Sep 2026 05:38:23 +0000
Date: Thu, 24 Sep 2026 22:38:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: write the primary super immediately during
 repair
Message-ID: <arYIz6DKvtj0EOLr@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932197.3344850.10179874390293040672.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932197.3344850.10179874390293040672.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 24, 2026 at 09:12:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xrep_superblock has an unfortunate flaw -- it won't even try to repair
> the primary super block, even though we have a live copy in memory that
> we could log and write to disk right now.  We should do this, because a
> crash will render the filesystem unmountable on recovery.

Can we have a test for this?

The patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
