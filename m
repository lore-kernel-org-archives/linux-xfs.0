Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C2D33ADB1
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 15:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774883426; cv=none; b=YIUyZrqAzm1vysD8qhEOgciiYlyJlLAEmUdA+yvmmfbha2zXHXKudXjEVDSTpFy8q5dnPS8ppQDSdnPeVFxHXyyShCarHToRQ5Gt2e2+OdaEAs3owBoW/krpv6DJh2pvxZAHLsMfEikX1BYewHhdI6LQ22KPAQt4yYry2j64zU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774883426; c=relaxed/simple;
	bh=AcDKgdqmQpmwpzkMRvLgvkHS3PJd+NJrvImZLwoy5gk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qNNBjpYs5Kjx4XoqYNJwIhGVx2N3fjI4xsVIUpvOA4WVg9175Raqla8O6yTWqxt9KbuAH+RZrOk3iRqX2nPhU+cBClxtQGEya8XILaAYWQmv2uZ9oggyKsiIh9omWeTUYrxJfgQh3UVHBIrgf/LXG7W/HFmJ8YT4h3gB3NIvx1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZ9f9Xp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZ9f9Xp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C38CC19423;
	Mon, 30 Mar 2026 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774883426;
	bh=AcDKgdqmQpmwpzkMRvLgvkHS3PJd+NJrvImZLwoy5gk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=QZ9f9Xp+uGQdft1sylJwxbJWKKiS7iHQSjoq/3NBk21fjTrZ5upPO9FAZQy/NpkAv
	 kLxcDRAoq0GDxdvd+pfUtaqoYOtmX1V1S0fCLVobvADULqRzSDhTLVz43lpil830zY
	 gSQ0qgpj39lvMMc8ZtcfBNlOSTFeWC5G84lNNKzkBOXV4gzk6h06Wq2vhj85UBXZFB
	 AmVPVNJcrjj+Db7D0s+1HZG5VWFGOdV2xqFoNOkAsJ6Ah6kZVifmyudzkXUaxQj6ma
	 amLPGC23AQy3IGzuyd3zdIsxruEFOQc/zcQ5Ud1K2DRYZ3RGN3w9cgOroGCpCIpM2U
	 tGf5guQbE9muA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260323075102.2952705-1-hch@lst.de>
References: <20260323075102.2952705-1-hch@lst.de>
Subject: Re: buffer cache simplification v6
Message-Id: <177488342488.47445.13885438172744263496.b4-ty@kernel.org>
Date: Mon, 30 Mar 2026 17:10:24 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 23 Mar 2026 08:50:50 +0100, Christoph Hellwig wrote:
> this series has a few old patches that simplify the LRU handling, and
> moves back to only having a per-buftarg hash now that the buffer hash
> is using the scalable rhashtable.  While some of this looks like
> performance work, performance and scalability is unchanged even on the
> 80 core dual socket system I test this on.  Besides cleaning up the
> code nice, it also happens to fix a syzcaller reported use after free
> during buffer shutdown, which happened incidentally because of how the
> tear down of the buftarg vs the perag structures is handled.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: don't keep a reference for buffers on the LRU
      commit: 67fe4303972eb6f911f62e2fe6ac7628b17d95c0
[2/4] xfs: use a lockref for the buffer reference count
      commit: d02ee47bbeedd10d36cc408f92e645447cf5495d
[3/4] xfs: switch (back) to a per-buftarg buffer hash
      commit: 497560b9ef42a4ab22ada7f1ea975a89cd3c5dfa
[4/4] xfs: don't decrement the buffer LRU count for in-use buffers
      commit: 8166876aadef90744bb26addc9c5a16b1c8341b5

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

