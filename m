Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9252A3C1F45;
	Mon, 31 Aug 2026 08:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788163409; cv=none; b=kiQ7PLFLwvqy366DjwcShWuSYJFz1HlRPwalCYtkYbSXIP2GeHg3VSNU04e8eykIWm80JHv2mS/5MKtE+S1hIye1cra/gkE4q9fMCL2b3Dp4QCvAnuH5DN+Wz10d5WYtfdoRQV6JPD8VVtjIyJJiJI7f09Z/nmER99hjAvsb/+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788163409; c=relaxed/simple;
	bh=utJIVDgpyi4bIdsWjV27OFcW2yZ2usSMRMT5vGnq+28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4q0OzSq+c8934gI/Lc1vSmXlK3SoThPeTQ9NB+Ed1sLn0rzZ3XIysh4RUVqnDa67hfuDRxdK8XPx4WwHSO3X6B1ydcFIwWOsoLvCbZ91+gXJGDvFuH4cH+bHdi884ne0ScgzN2oYNf0Ue8Av9Y2i4/tSIQdKs4aVpAi76uLVWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLBOvPXx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLBOvPXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9A31F000E9;
	Mon, 31 Aug 2026 08:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788163408;
	bh=7ZT9VoEoPjLrLkynIo5pykiMCxgEyddfGrqTqgrZW1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JLBOvPXxAiBgbr9KnWFwbRS/RANi0eFUjvbuSAneYU/GhDtqSzz4VnlSgy8YFTqsr
	 BJbIM0D3yjITlML7lT1xYF+lkebP0YzrvKrPj3aJHK5BpjeNqYEqCCcVPuiuSkz/wA
	 sBXjzLftIXimt0UgBbV9iulAveVfyitLZJXZVj+1JQM2yCqfJ7ys4v1IFgZabswRMT
	 anW2uNlte2G7BIgr6zvYnLuOy5Z/YNgSFkN9mKzkQMpn72jlXYeYeuRfBW9gTZSSf7
	 GM97y7fcCs6axDknvuN6kTkfzLyAyViOLzOeDfiNrKLWI/SupX3wyz3EI6fFzIjlUp
	 T3odBuVXZW4RQ==
Date: Mon, 31 Aug 2026 10:03:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, djwong@kernel.org, 
	hch@lst.de, jiapenglin@tencent.com
Subject: Re: [PATCH v3] xfs: fix exchange-range reflink flag clearing issue
 with  INO1_WRITTEN
Message-ID: <apU1D-A8jtdYAcq6@andromeda.toxiclabs.cc>
References: <20260728071921.81156-1-jiapenglin@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728071921.81156-1-jiapenglin@tencent.com>

On Tue, Jul 28, 2026 at 03:19:10PM +0800, Lin Jiapeng wrote:
> When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
> can move the reflink inode flag from the file that currently has it to
> the other file, as long as exactly one side is marked.  This assumes
> that the file contents, and therefore all shared extents, are exchanged.
> 
> That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
> xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
> from file1, so an exchange can complete without moving every mapping
> that the earlier flag-swap decision accounted for.  In that case the
> post-operation cleanup can clear the reflink flag from an inode that
> still owns shared written extents.  Later writes then take the
> non-reflink write path and may update blocks that should still have
> been protected by CoW, which shows up as data corruption between
> reflink-related files.
> 
> Fix this by disabling the reflink flag exchange whenever
> XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
> proceed; the conservative outcome is that both inodes keep the reflink
> flag.  The regular reflink flag cleanup path can drop the extra flag
> later once the inode no longer has shared extents.
> 
> Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
> Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
> Cc: <stable@vger.kernel.org> # v6.10
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>

You don't need to send new versions just to add RwBs to the patch, we
can retrieve them from the list.

Also for any new versions, please add a changelog so we can easily
understand why the new version.


> ---
>  fs/xfs/libxfs/xfs_exchmaps.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index dcd0bd0b13b4..3efed37cb98a 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -959,6 +959,16 @@ xmi_can_exchange_reflink_flags(
>  {
>  	struct xfs_mount		*mp = req->ip1->i_mount;
>  
> +	/*
> +	 * The INO1_WRITTEN optimization can skip exchanging hole and
> +	 * unwritten mappings, which means we cannot guarantee that all
> +	 * shared extents actually moved to the other file.  Clearing the
> +	 * reflink flag of an inode that still holds shared extents breaks
> +	 * the CoW write path, so refuse to exchange the flags in that case.
> +	 */
> +	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
> +		return false;
> +
>  	if (hweight32(reflink_state) != 1)
>  		return false;
>  	if (req->startoff1 != 0 || req->startoff2 != 0)
> -- 
> 2.50.1 (Apple Git-155)
> 
> 
