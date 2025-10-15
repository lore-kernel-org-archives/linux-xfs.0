Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB174223DEA
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 20:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760560073; cv=none; b=SFiIRzvptlpSuBkH3JjP/qGFHU8Fp3Lux2hNI2ITrOAGp06lgyW1YIncIwTxI5ORmchGggHburRjOlZ1ThwJXVWW1H3R4DO5ErXxwR7i6qr5Jp7fMv7GslD5PLUNkMy7dbvTi9lxL3j69W4YV193ocU7S6wmOjXAWaP29vHCQa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760560073; c=relaxed/simple;
	bh=/cNjpI2LbL9HX/ebt0JwENGc/ovJbUfelo5mOa1F89g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q6UJzV85VJ2YzSJKbYuZuv508CA88evHa0aRegQysnnUBiAOdZOZppAQt38HYjIJ0RbcZJs+q8Ske/FRycREHAJfkzL2CfZHfDl0oDlOiUQj2UoGHuV05FjtqXmx5YXuYnHH9waB+1zbM+QB4664pzOXvDwazcHS8WFHY0J+ueE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/xCfbXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/xCfbXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E16C4CEF8;
	Wed, 15 Oct 2025 20:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760560072;
	bh=/cNjpI2LbL9HX/ebt0JwENGc/ovJbUfelo5mOa1F89g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c/xCfbXrvg+u0o0lmoJXPFRG49Z9d6HBmgZrhQMx+hCuo5OEPSbbT7uDnXuu4xjgi
	 PXei51JAxHQFyR+7sbmzFwrbtPV2wUXn8PCGg0no5iFakoI/OVdA9givAPqV943D3j
	 ZtWuiOe4YsUerIIivVfDIxCJc/7396eSKH0MZ5Y4k6DZqryfnZjB8FfvyC+2JdTfnR
	 Ftgpq6nYA1ZVwKGZ2O7uUMR7ORoAfFBhYyX0JKIYIyPS/vk1gWFjjZbJk7CtithRZv
	 ryy8F4JjbpTh0s9U4kJUzSQ8llhCNICvupC2chv7wNwtnlYTAVqAnw8cQhdfFqAtw3
	 hK+KLH15KZ9qg==
Date: Wed, 15 Oct 2025 13:27:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] xfs: don't lock the dquot before return in
 xqcheck_commit_dquot
Message-ID: <20251015202752.GH6188@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-4-hch@lst.de>
 <20251014232244.GS6188@frogsfrogsfrogs>
 <20251015050043.GA8015@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015050043.GA8015@lst.de>

On Wed, Oct 15, 2025 at 07:00:43AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 14, 2025 at 04:22:44PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 13, 2025 at 11:48:04AM +0900, Christoph Hellwig wrote:
> > > While xfs_qm_dqput requires the dquot to be locked, the callers can use
> > > the more common xfs_qm_dqrele helper that takes care of locking the dquot
> > > instead.
> > 
> > But the start of xqcheck_commit_dquot does:
> > 
> > 	/* Unlock the dquot just long enough to allocate a transaction. */
> > 	xfs_dqunlock(dq);
> > 	error = xchk_trans_alloc(xqc->sc, 0);
> > >>	xfs_dqlock(dq);
> > 	if (error)
> > 		return error;
> > 
> > So that'll cause a livelock in xfs_qm_dqrele in the loop body below if
> > the transaction allocation fails.
> 
> I think livelock is the wrong term, it's just a leaked lock.  This gets
> fixed towards the end of the series, and I'll fix it by reshuffling
> the series so that this only happens later and at the same time as those
> changes.  Same for the next patch.

Ok let's see how far I get with ignoring dqrele/dqput for the rest of
the series then. ;)

--D
