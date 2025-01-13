Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEB4231A31
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 05:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736744927; cv=none; b=JDNOZ3iCP8M2zAOyX01b6d3F/cWkkfxLYLnLJwBKJp3u1cTDsgK+qmzMCEARKbFqcCrabMVJJjTolYVOJ+W7ZCudipNywdQ7owzHwldtmQOLEAigzRvt8EVPXlBvWTVKfjyDtInfisz1jaF2uplVp8zoln17YJpRag36jGayBPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736744927; c=relaxed/simple;
	bh=K4pI4fclFEW09u+PECdEyNKQYA0GIbeTDD701VcxIds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2VM+mpMxJHcGdDbWqGNaUM6xrYEtzWviNtOyWjUDJtcpeJQhSWn+19BCRqFnt4OBlcPFBX/b4MwFoIbhYx5Y1DHwrqVEE1Q8ba1oaKRiHtxYz1aESNloPYKlzLtmWzL62A/VVzqDYzCKjpQ2rpkCuWGYauPCVdTv8DPWcFBRmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNDV63vR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNDV63vR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EFAC4CED6;
	Mon, 13 Jan 2025 05:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736744926;
	bh=K4pI4fclFEW09u+PECdEyNKQYA0GIbeTDD701VcxIds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BNDV63vR15nxLpwEICvbXxyPHoxjdcnL0g9tO7+tuqajyrGnWOO0S5+kyzDd+XqTd
	 dmEa+c6VklgMWxn5vEry/cDg9D/8D4AcDs5t6AqTS9Cz/LBs/XEH+SgaX/zKbgpayv
	 7EiP0u3hX7vmhL8rm85Js+3zp7bxjSGxuWf5LDK8cKX6GThvYjptOkF4zRJLddxLFq
	 WmamEZ/+SnQs16OqrpY2q4LXES4uRunH5bmgK6ujqiLLoKvRhQQUkongpphqcyQYtx
	 v1q5AlWBUMu2F96JFEIuCkZN+MAj32UpluUCWLpbSSanQ/uvjsDXrFg4YOj5oQUG9b
	 SDfiNRCv48R+Q==
Date: Sun, 12 Jan 2025 21:08:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: fix buffer refcount races
Message-ID: <20250113050846.GU1387004@frogsfrogsfrogs>
References: <20250113042542.2051287-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113042542.2051287-1-hch@lst.de>

On Mon, Jan 13, 2025 at 05:24:25AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series fixes two races in buffer refcount handling, that I've
> so far not actually seen in real life, but only found while reading
> through the buffer cache code to understand some of the stranger looking
> locking decisions.
> 
> One can cause a buffer about to be freed to be returned from
> xfs_buf_insert.  I think this one is extremely unlikely to be hit,
> as it requires the buffer to not be present for the initial lookup,
> but already being evicted when trying to add the new buffer.  But
> at least the fix is trivial.
> 
> The second causes buffer lookups to be missed when moving to the LRU.
> This might actually be able to trigger the first one, but otherwise
> just means we're doing a pass through insert which will find it.
> For pure lookups using xfs_buf_incore it could cause us to miss buffer
> invalidation.  The fix for that is bigger and has bigger implications
> because it not requires all b_hold increments to be done under d_lock.

Just to be clear, should this sentence say
"...because it *now* requires"?

> This causes more contention, but as releasing the buffer always takes
> the lock it can't be too horrible.  I also have a only minimally
> tested series to switch it over to a lockref here:
> 
>     http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-buffer-locking

Will take a look; some of those patches look familiar. ;)

--D

> 
> Diffstat:
>  b/fs/xfs/xfs_buf.c   |    3 -
>  b/fs/xfs/xfs_buf.h   |    4 +-
>  b/fs/xfs/xfs_trace.h |   10 ++---
>  fs/xfs/xfs_buf.c     |   93 ++++++++++++++++++++++++++-------------------------
>  4 files changed, 56 insertions(+), 54 deletions(-)
