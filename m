Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7C42853F8
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 03:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760673051; cv=none; b=IqxGYew1yEudKJCO3PzMqYq7UP9BD2q//w2Vj5YJMamoyM6xDkzuweP5xNo1NCp1TufRy9sd42DCLDT/TD31XjOaoLsLXoppFMJ7hR4D4AcK6ysVhO6A17aON9y/fcfC4Z+73Y15ipP+0vAPB20U6CvP7Chi/sZNabegcqdbGnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760673051; c=relaxed/simple;
	bh=yZklGeBURGuIaTBsDmJmGgllPfBlgnlf9sh6kC0DWL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p15A9N5g8cw2jS2oRNmxYPFfFKzz7bT7il0m8fQH8wPQdkOpS1cqbKSQWWxWT787h9uRWfK9b41Od3PfDt5T+bI0z3hv287YSCKjo0b1OOfDBBWD3UBLJ4LBtP/E4O2QGlsEtS36PM3cB5Ums8laOyij1K4uJn0XR8vktF+LAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CFD4E227A87; Fri, 17 Oct 2025 05:50:43 +0200 (CEST)
Date: Fri, 17 Oct 2025 05:50:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs: reduce ilock roundtrips in
 xfs_qm_vop_dqalloc
Message-ID: <20251017035043.GA29428@lst.de>
References: <20251013024851.4110053-1-hch@lst.de> <20251013024851.4110053-18-hch@lst.de> <20251015212707.GM2591640@frogsfrogsfrogs> <20251016042348.GC29822@lst.de> <20251016155941.GA3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016155941.GA3356773@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 16, 2025 at 08:59:41AM -0700, Darrick J. Wong wrote:
> > > ...and I guess we no longer detach dquots from live inodes now, so we
> > > really only need ILOCK_EXCL to prevent multiple threads from trying to
> > > allocate and attach a new xfs_dquot object to the same inode, right?
> > 
> > Yes.
> 
> I wonder then, if there /were/ two threads racing to dqattach the same
> inode, won't the radix_tree_insert return EEXIST, preventing us
> from exposing two dquot for the same id because xfs_qm_dqget will just
> loop again?

I think so.

> [Though looking at that xfs_qm_dqget -> xfs_qm_dqget_cache_insert ->
> radix_tree_insert sequence, it looks like we can also restart
> indefinitely on other errors like ENOMEM.]

Yes.  I have patches fixing that as part of moving to xarrays instead
of radix trees.  But I suspect a resizable hash table might actually
be the better fit, so I didn't look into submitting that quite yet.

