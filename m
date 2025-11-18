Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A252641CA;
	Tue, 18 Nov 2025 06:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763445637; cv=none; b=cP+yumdMAjuwLQ60GZpQGz9osApylHu+IIUFdR3eTCbaeoCCWJIOg5sKmU8enMlaMi6GI6/NDixhgYg1G/mTbdl/Ax0imeUtD+gsZATLpn6oPHBj+jcRtZgpzfR2gPAP92RDhbzS3qUlRcGVA42mVYLBAIOECxJWKvx3AocmWPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763445637; c=relaxed/simple;
	bh=aQobgrNDigOprbkedfnRfbvg1VICfAhKxEpRXAZuLic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tq3GaE4h5eg+eZa+FVvZ4ySmNdNxYTm31wylXUhkWn1p7Lzfp2WqBs+nEU89n/RwbkMpDiLTvtG8GaX7JjW+mp0u8xc73kQdhlSVMyhon7nWa4BbT/z64QRugM03bhOa3EeTGP7tvAd/vnhbtgIaHp5k1ch+YnvrRxq/+gclBXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA7EA227A88; Tue, 18 Nov 2025 07:00:32 +0100 (CET)
Date: Tue, 18 Nov 2025 07:00:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: work around sparse context tracking in
 xfs_qm_dquot_isolate
Message-ID: <20251118060032.GD22733@lst.de>
References: <20251114055249.1517520-1-hch@lst.de> <20251114055249.1517520-4-hch@lst.de> <20251114170623.GK196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114170623.GK196370@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 14, 2025 at 09:06:23AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 14, 2025 at 06:52:25AM +0100, Christoph Hellwig wrote:
> > sparse gets confused by the goto after spin_trylock:
> > 
> > fs/xfs/xfs_qm.c:486:33: warning: context imbalance in 'xfs_qm_dquot_isolate' - different lock contexts for basic block
> > 
> > work around this by duplicating the trivial amount of code after the
> > label.
> 
> Might want to leave a code comment about shutting up sparse so that
> someone doesn't revert this change to optimize LOC.  That said ...
> what is the differing lock context?  Does sparse not understand the
> spin_trylock?

So in case that my cover letter wasn't clear enough (or not widely read
:)), I'm somewhat doubtful about wanting to actually merge this upstream.
It just feels wrong to me.  But it was the list thing to need a clean
compile, so I wanted to demonstrate it.

