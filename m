Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48305345756
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 21:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768254663; cv=none; b=FEG4aQnrYa0kslzFu8FH09tPI/ke+kd2oCTDpTxVJV/mQs2Omb4BySAgUdgKIgFA/PuhX6peiV1Q/mli2wkC+tj7tXU2jhqOExrZutKDKfyVu7gMUkyn11OVxULFMasqM+0PMYFQJHnyikbbP+MfyCAu5fx++gKa/GjkWEhTayw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768254663; c=relaxed/simple;
	bh=q4/Sozn1xHQAlDZcgjIe06jGYC0KBt/W2e5hMVSJ1QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnjFNIxB+kI9QQN5Q0yLNQHwr67Ll8IRHDpt7xN0KvxnHzWEBlIKdFLmIqWoQliH9VdgeCAZwfp0rKUuDYZnUbzHX7N6hqAnPtmmAU2Hoqrg2x8OixHSAHhMvN2F0yONcOPrlLOVl3HZuQ0mQEvrtnL36Gfmkq1Qwis723qwsfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjKs9ZCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjKs9ZCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FF5C116D0;
	Mon, 12 Jan 2026 21:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768254663;
	bh=q4/Sozn1xHQAlDZcgjIe06jGYC0KBt/W2e5hMVSJ1QY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fjKs9ZCz7u9LdNhV/I9h4K8eMK3uUqhyNuhWKnEtuErognawBvEWTkgGCjQAiTKBH
	 hH1iKnBE5TvcDt8mAYuydWzm1IamZXmqXDCs1/1wHP0iTHCMZdZOC7OaHtgtoeeqFA
	 staJbHDW01sD163bHkBdgizyYuxurGyvbr7YeFx3PDWqgClLVCdtnFz3PtePtoNC8y
	 R7VhtfXT8nfF9Y8E3cvn80wUGX/geQjVmDCb7QZAWGbv9x5iig8Bd5kQsnNopAsddS
	 KeLFYGlm4t0XZ9F9c+4pAYxoVaDxoQ5epXkFUTH6roLrSWY9V0jM5yenZBBRPu2nbk
	 MXukLcwAJlk9A==
Date: Mon, 12 Jan 2026 13:51:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hch@infradead.org, cem@kernel.org
Subject: Re: [PATCH v2] xfs: Fix xfs_grow_last_rtg()
Message-ID: <20260112215102.GE15551@frogsfrogsfrogs>
References: <9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com>

On Mon, Jan 12, 2026 at 01:54:02PM +0530, Nirjhar Roy (IBM) wrote:
> The last rtg should be able to grow when the size of the last is less
> than (and not equal to) sb_rgextents. xfs_growfs with realtime groups
> fails without this patch. The reason is that, xfs_growfs_rtg() tries
> to grow the last rt group even when the last rt group is at its
> maximal size i.e, sb_rgextents. It fails with the following messages:
> 
> XFS (loop0): Internal error block >= mp->m_rsumblocks at line 253 of file fs/xfs/libxfs/xfs_rtbitmap.c.  Caller xfs_rtsummary_read_buf+0x20/0x80
> XFS (loop0): Corruption detected. Unmount and run xfs_repair
> XFS (loop0): Internal error xfs_trans_cancel at line 976 of file fs/xfs/xfs_trans.c.  Caller xfs_growfs_rt_bmblock+0x402/0x450
> XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x10a/0x1f0 (fs/xfs/xfs_trans.c:977).  Shutting down filesystem.
> XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Sounds reasonable to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6907e871fa15..2666923a9b40 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1324,7 +1324,7 @@ xfs_grow_last_rtg(
>  		return true;
>  	if (mp->m_sb.sb_rgcount == 0)
>  		return false;
> -	return xfs_rtgroup_extents(mp, mp->m_sb.sb_rgcount - 1) <=
> +	return xfs_rtgroup_extents(mp, mp->m_sb.sb_rgcount - 1) <
>  			mp->m_sb.sb_rgextents;
>  }
>  
> -- 
> 2.43.5
> 
> 
