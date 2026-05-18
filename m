Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94793F39C2
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 13:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779110642; cv=none; b=r2biXIPDtfE3abCfbNrcq6lieHM0+93pTcoV9RWu916BK+8nT+GvR3akeLh+CKAiH4zL+L6yFraqHKXeHhlt+AISSCFa1FHzywj10lf/gASRWKI1tR3YxFEeFBdWUNtM2yZK+cN/cA0i0UK96F6XHEMZ0loVkU1gQy4KkyT6NHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779110642; c=relaxed/simple;
	bh=pHpEluYx5YPv/44/0PzGpRev/3bz5wNrIK83fRCUuqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cy8DPZobtUB+mXisE2J7cjaInQUQlcAh7G0qS3E0HkMNs1lcqeyEoXJBKcU5mlRv82Fm9NC0OB9wr62hG3atL8QPW5XN8qNIgomG02h+BocPnmo6gqEFiqho9oEPX6sZUahtSfagNP5gtPwvWKfBvOHc3AaQMD4fTtRd7S66i+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVKWjlGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVKWjlGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4E1C2BCB7;
	Mon, 18 May 2026 13:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779110642;
	bh=pHpEluYx5YPv/44/0PzGpRev/3bz5wNrIK83fRCUuqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KVKWjlGu19kVtdqLf6oYe2lrnkQXkKtEz/sEjN7nAWXNOyh/KUcoVmB1A2yF/+VPT
	 3mb2Qz+i/RUx4XTDTJWWhCbqiur3m0jxC+JlusijqW5c/MKI0W2ISKdVrJw5CWF39W
	 l+/tQEe+DKWg1Rz8YnOMS6DsMGOF+oNZoi4Fb/gF2GSAvAhA5zFnSadG5ITrfCFoW1
	 rYZh4l2pdNS5cmFIqtDPgBaIqQM6+i46nDh69h4kqI9DviY7Lcyw1x5cNqYOK2n68S
	 njOTZr9ULlF+6uyTVxtbD+TdE36BZ5zUv5Zwn4O3pt++cylytlCjRJ7NIeN24Rk5kv
	 +3tx1YLlknaeA==
Date: Mon, 18 May 2026 15:23:58 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: add a xfs_rmap_inode_owner helper
Message-ID: <agsSq64M1VbxMMqD@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-6-hch@lst.de>
 <agrzt5K9OVTPObMs@nidhogg.toxiclabs.cc>
 <20260518131639.GA7774@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518131639.GA7774@lst.de>

On Mon, May 18, 2026 at 03:16:39PM +0200, Christoph Hellwig wrote:
> On Mon, May 18, 2026 at 01:14:31PM +0200, Carlos Maiolino wrote:
> > On Fri, May 15, 2026 at 03:50:26PM +0200, Christoph Hellwig wrote:
> > > Add a small wrapper for initializing the rmap owner to i_ino.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > This and the previous one, provides very little gain IMHO, do you intend
> > to get rid of xfs_rmap_ino_owner and xfs_rmap_inode_bmbt_owner? It seems
> > to me they could simply be replaced by these new helpers instead of just
> > wrapping them into these new ones.
> > A little disclaimer: I didn't look into the next patches yet to see if
> > it will all make sense later.
> 
> My direct aim was to reduce uses of i_ino so I looked for common
> patterns.  I also generally prefer APIs that pass typesave objects
> over those passing integers as handles wherever possible.

Agreed. both xfs_rmap_ino_owner and xfs_rmap_inode_bmbt_owner look good
candidates to fully replace their 'old' versions giving all their
callers have access to the xfs_inode (if I didn't miss any user).
