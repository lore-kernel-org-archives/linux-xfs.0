Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A06148A2B3
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769008285; cv=none; b=rLqa+ENvzRVgmDTKK25GScgJJsUZpwkgWyWuko0vulD6OJ5kBPH3f7uIlOiy6wElJqLFmNlxkpjxdZo2IrH4Mo1wrAxJ76svoFSEzmGn3AA92QFcOFioPyS7I1Rf1pQtM2DvcoehDmSOPCTadXZJ/TlQQjFkfxsKs/PibGav6mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769008285; c=relaxed/simple;
	bh=SK7e1cuOtcFHqluMdrskseGhqebNSe1KWCLxSsh+0Uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6a3+dV4q81/ABkeUcHanZ4dyU+8yw8jfI6QLZkcSPzFhRSPwDOiOH3iqdLXXFKPFc9Xnj7buIt9jlHFTdhkc6WyKZPF1AJ0PKTl6M/6zr9cWtPG5kTD+wDP4kNvH3sbeVpvZ00hcSlcE65jsBanUEvp72P28DB03uSwN7vMqts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FohrWf6K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FohrWf6K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dEX5eRFaMaqagQr7NXgwkUhJVCruiRuZqnRjB1HHxoU=; b=FohrWf6K2N0ACwZrh1lB2RMqeb
	LDkJHkhNhC9qulrOveYQdPgXV/hqPUdj6NHFjxYkX6lt5z37JohOW8ar37A/47qq2zIqx1yvovMu1
	NzTyh+jo+B1BepkeCEOxz9zHxyzrbhvZ8SxONZkNBhTliXC5h5iFNc9SqGFigvDogm9KVBcZH8KTi
	zbtFFU/4rl4kRBUdTAR8l00fmVs7wx8jiusUoiPdXiPBtnjHO22BolQeGFatb4hccPkXfCizZOjq1
	ld/LoSsuw9KYkm48+kCXjZKyaIid1HFJHIpj1L1l0A8gwfiNlJBK1hOh+ptkFKyBEpRrgAi6X9N3k
	MIWRCwWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZre-00000005hV9-23ls;
	Wed, 21 Jan 2026 15:11:22 +0000
Date: Wed, 21 Jan 2026 07:11:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: reduce xfs_attr_try_sf_addname parameters
Message-ID: <aXDsmixPvQHgWwOl@infradead.org>
References: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
 <176897695951.202851.14154735292129291258.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695951.202851.14154735292129291258.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 10:39:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The dp parameter to this function is an alias of args->dp, so remove it
> for clarity before we go adding new callers.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

