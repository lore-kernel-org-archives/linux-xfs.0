Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B65209F22
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 07:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633200; cv=none; b=ZcIOyj7c/BH1KkQIUA8JJBtGuRQJT+um5JhEY7MbzVtRTXZDzeP4lEBCCdZfICyFi5GIWdtSncwJUcuWZzi9kDUNx6g7x3pRyICMXnznvtbaPSqWKl1s4gJZ8XJvgocqBBiueGTuFxvzSBCbVevfHNAvgkolXPXQveDeKgO4HKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633200; c=relaxed/simple;
	bh=nRg5mkpgQlWPD3wvA6rNPzXVHxYblP3q/IQ1Bo+cE7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUh7hZYjDIGn1t4sSbaSQpLAre6h7N8T9f/ybQJersCtHZNinHj96klsRwp/SkuELIbJFFnX8JU8z14OKRdvi0pNB8g+Rhk+VLfIMBELRO2ueDIdakLKDfeyIKE7tGOKR6hpMAi2+7FEDgaFBwA3ZhExG7YSRQy+WhID7lCPMVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CBBB0227AB3; Fri, 11 Oct 2024 09:53:14 +0200 (CEST)
Date: Fri, 11 Oct 2024 09:53:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: pass the exact range to initialize to
 xfs_initialize_perag
Message-ID: <20241011075314.GA2749@lst.de>
References: <20240930164211.2357358-1-hch@lst.de> <20240930164211.2357358-2-hch@lst.de> <ZwfeiYzopK-iD24Y@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwfeiYzopK-iD24Y@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 10:02:49AM -0400, Brian Foster wrote:
> > -	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
> > -			&mp->m_maxagi);
> > +	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
> > +			sbp->sb_dblocks, &mp->m_maxagi);
> 
> I assume this is because the superblock can change across recovery, but
> code wise this seems kind of easy to misread into thinking the variable
> is the same.

Which variable?

> I think the whole old/new terminology is kind of clunky for
> an interface that is not just for growfs. Maybe it would be more clear
> to use start/end terminology for xfs_initialize_perag(), then it's more
> straightforward that mount would init the full range whereas growfs
> inits a subrange.

fine with me.

> A oneliner comment or s/old_agcount/orig_agcount/ wouldn't hurt here
> either. Actually if that's the only purpose for this call and if you
> already have to sample sb_agcount, maybe just lifting/copying the if
> (old_agcount >= new_agcount) check into the caller would make the logic
> more self-explanatory. Hm?

Sure.

