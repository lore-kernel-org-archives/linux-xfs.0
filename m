Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43D83FC2
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 11:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742298896; cv=none; b=J484CkIqTnhqJB8o2VukPorPh9JuwDpfQxFTpu0nqPKEoK+p73pnuDwKBnJjLkJm9bQ0RyTXqzA8dHB0ar+2iHQd4kT1Qa5ttbbdJhHMOlh+l1iRYRIAyncfAHySqeyFKspFa5lywv8272bHTpeZffxMGt5hHcgyMXH5/TthMYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742298896; c=relaxed/simple;
	bh=UuQnK11szUW3aIY10+LVMnwpQncVk8RPeTBi5ZRC6bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qlUxP+C8FajkuPz83cQG38J5V5XH+IMvyVQaQl7B3f2K/81uQ9TY0eX/CLvrtfSD7Lo4hFE8KMOEXGYfc2nxfuLl0IjUA69tnW+pjX/Bl/FYknSPNMe2M/cy5R5iUPjNRsUrAln1RbvLJaLw4readOBE3UYQJLc5/oVkJf1aRAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iguv2hza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iguv2hza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A736DC4CEDD;
	Tue, 18 Mar 2025 11:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742298896;
	bh=UuQnK11szUW3aIY10+LVMnwpQncVk8RPeTBi5ZRC6bI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iguv2hzanX6bLCpEm/09vYojJ+IWRJMohnW3ArgrIco6NxI+uwIapHkGK0lVmvQ57
	 4BHY6OQc/dNiv5gWiyj0LGXPGwKRK6pIV14wPAnHEoRrbaHCPg8a2Kgamyl9fx5PL+
	 8xPXfTFf4YEQrD34fU2WG+4b5movkzXt0enc5EdQQQtc8cuQIbx8edKbY0H5pqvOd3
	 TSjMIe1MYEY6Ds70kqShvMcfDIwHgkCkbRCZv05yxSMQBWQ5Me/JFS8HJCMRK47kET
	 /NlXh8tmRrYCYiIw+JqlEEQ8SxB7vVegVBZCxhWoeC+eengj/NIEgdDZEfmESUk/MC
	 HVVo6gkGwMkrg==
Date: Tue, 18 Mar 2025 12:54:51 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix a missing unlock in xfs_growfs_data
Message-ID: <xqialb77fc6mu2owmcvr2sia7uid3kbmuwl2nj3bvpmtpkvn4q@touunsidymxc>
References: <20250317054512.1131950-1-hch@lst.de>
 <3DsXv2pyeAHMoCMX8LFIHUrzDkDRVbkGiIA7QJypqH6W0P-JKg8zfCiwMhkB29V1avjCJXcBOl7xNL1SAA4nUQ==@protonmail.internalid>
 <20250317054512.1131950-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317054512.1131950-2-hch@lst.de>

On Mon, Mar 17, 2025 at 06:44:52AM +0100, Christoph Hellwig wrote:
> The newly added check for the internal RT device needs to unlock
> m_growlock just like all ther other error cases.
> 
> Fixes: bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_fsops.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index ee2cefbd5df8..d7658b7dcdbd 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -301,7 +301,7 @@ xfs_growfs_data(
>  	struct xfs_mount	*mp,
>  	struct xfs_growfs_data	*in)
>  {
> -	int			error = 0;
> +	int			error;
> 
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -309,8 +309,10 @@ xfs_growfs_data(
>  		return -EWOULDBLOCK;
> 
>  	/* we can't grow the data section when an internal RT section exists */
> -	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart)
> -		return -EINVAL;
> +	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart) {
> +		error = -EINVAL;
> +		goto out_error;
> +	}
> 
>  	/* update imaxpct separately to the physical grow of the filesystem */
>  	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
> --
> 2.45.2
> 
