Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CCB200C8
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708323957; cv=none; b=IcngbbRlZ3kMKLpidYgXN/9/5uu8WUlgFFEyPyerzQvWvTCm54PLHzbXu8CFYnQ4RtmqS2thGWFl5KjJiRfndSAlWqL7CGe1DXzP86JbWevjIttOmo1EQAdHyk7xw1bU1Ae936iLWHGDpT6gD2uTsM9GDjn/6ULfTha4TWO4bS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708323957; c=relaxed/simple;
	bh=HbxFFLCA0lp26jXdaNoc2OHLPg9DuLdaP2SO1dtyvJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8e+WlRU/7kUCoPPBb3DD2UgungufAJmljr50FVJrUM9saDuyK8crExvEdHbcANCATnDxoHZ89PV9aCYI1Xq/cBtmGb6pmsS5puvI5FwgLRVAp5U4kCaAb1AVTrgqPljF8sE/IUqw70sG/vj9aZP41iBIVxHnZ/aYHuC1e5cdfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0034668AFE; Mon, 19 Feb 2024 07:25:44 +0100 (CET)
Date: Mon, 19 Feb 2024 07:25:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/20] shmem: export shmem_get_folio
Message-ID: <20240219062544.GA4346@lst.de>
References: <20240129143502.189370-1-hch@lst.de> <20240129143502.189370-6-hch@lst.de> <Zc9oxYc-amPs0X3V@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc9oxYc-amPs0X3V@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 16, 2024 at 01:53:09PM +0000, Matthew Wilcox wrote:
> I know I gave an R-b on this earlier, but Hugh made me look again, and
> this comment clearly does not reflect what the function does.
> Presumably it returns an errno and sets foliop if it returns 0?

Almost.  With SGP_READ it can set *foliop to NULL and still return 0.

> Also, should this function be called shmem_lock_folio() to mirror
> filemap_lock_folio()?

shmem_get_folio can also allocate (and sometimes zero) a new folio.
Except for the different calling conventions that closest filemap
equivalent is __filemap_get_folio.  For now I'd like to avoid the
bikeshedding on the name and just get the work done.

