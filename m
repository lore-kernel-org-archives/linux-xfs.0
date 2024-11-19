Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736AB199B9
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732033144; cv=none; b=nzTJMTUOb9kNZsRNkys2sAg65DVCFDyIhk83B6hTjYACrfgbNjhfZ5X8wQ4O35eIVsMUy39NOtrO+0PbLatvsKqeNR002ptJfhn2/TqykTpAxIbIDt7GYeTuuHBF1nVs4kRTt1w7qxVFxh7iytdtUpTsvaFHkjCw15w6v3n7Sdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732033144; c=relaxed/simple;
	bh=D0IOZCkAZbG9CWwGQNwwmxU9iU6vPiqjCW087T08Or0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f5RLG3XAzD5ox8OnD42ZJuO3OsPrcvJB1EsA6rEUZRlO/vshPhBNQV0Rzw42TI/S4GGcGmJnO/ybPdZShA0Gs/SU675ynCCavwsQ3OwYK4N/crJtdojWvw16Wr2iTtXEpaaL0RriGLdg76Eh9nMXgWqlM0T6Ktv15HmBJwCCuUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BFAF468D8D; Tue, 19 Nov 2024 17:18:58 +0100 (CET)
Date: Tue, 19 Nov 2024 17:18:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: factor out a xfs_rt_check_size helper
Message-ID: <20241119161858.GA14774@lst.de>
References: <20241119154959.1302744-1-hch@lst.de> <20241119154959.1302744-2-hch@lst.de> <20241119161543.GW9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119161543.GW9438@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 19, 2024 at 08:15:43AM -0800, Darrick J. Wong wrote:
> > +	error = xfs_buf_read_uncached(mp->m_rtdev_targp, daddr,
> > +			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> > +	if (error)
> > +		xfs_warn(mp, "cannot read last RT device block (%lld)",
> > +				last_block);
> 
> "cannot read last RT device sector"?  Something to hint that the units
> are 512b blocks, not fsblocks?  This is certainly better than the old
> message. :)

Sure.

> Also, should there be a similar function to handle the last datadev
> read that mount and growfs perform?

I'll take a look.

