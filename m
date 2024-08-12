Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ED0191
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 17:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723484398; cv=none; b=iZ9Lj+8ZB9Kfb/xDrEViba2kDWBYeaxGQhHj5ulg4/J6tcpqjwugUjGqyXj3tPts+eaSfnd+wrS5o5WKdVh/HcbrGsGppStdGlrVgCzcYdtjp7Ird6/0lRvOtMQvNtqzXeOMFaiCNp19PkZuYEu8lfgBOocuOHM50iRyBo7WBKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723484398; c=relaxed/simple;
	bh=Hm3a88Grx2ytVguesxqHOm/zG8ZYMsXpEff88DKi6Ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aclJkvuxfOjxprmMOAwquloDTNBrMts1ngCNST/ibRDiV09sAcrSNojEpP990IGGqaEQg+NaBwXwN5BWT2J2a85aXx6trfoVJKNHR6mGMrdlnwFdw/EkJXUBTRtDMV4ALxBMPmYmr50Uk2ngMO/af/rlDPy42OGREUEN5a/T2T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emvdOLkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emvdOLkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF6CC32782;
	Mon, 12 Aug 2024 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723484397;
	bh=Hm3a88Grx2ytVguesxqHOm/zG8ZYMsXpEff88DKi6Ak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=emvdOLkdMSW5XcBlqaaLrP9jRfRcCcEB/Lsz4dGmP3CD0ZVBXti4K3+rw9smkMok1
	 ABE4L3Os5041t6ukf4vKIV79PgY3leD76rfAOVqCWODBJ21fOOm81Seg0HXaMf8g/V
	 59EIMrIHIWu4Z8j0n8nPY3NZcZFm48miauz9vYuLEdSk+YaVp1C79zlGf9Dg8Tr3CL
	 py5RYi1I/RqqzYdDOouY8fy2VmfbJaAhHFIDWF9+VXRLitvyxbTC8HTANAkIRo25Jn
	 fJ/HkmA0RomNGd3PedujzX4O+Z8q3+Sbmqcjg6v2fwKb7l1mSIM2Y5cIpA8wPbtbyA
	 EqiP91Mv2EV1g==
Date: Mon, 12 Aug 2024 10:39:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix handling of RCU freed inodes from other AGs
 in xfs_icwalk_ag
Message-ID: <20240812173956.GZ6051@frogsfrogsfrogs>
References: <20240812052352.3786445-1-hch@lst.de>
 <20240812052352.3786445-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812052352.3786445-2-hch@lst.de>

On Mon, Aug 12, 2024 at 07:23:00AM +0200, Christoph Hellwig wrote:
> When xfs_icwalk_ag skips an inode because it was RCU freed from another
> AG, the slot for the inode in the batch array needs to be zeroed.  We
> also really shouldn't try to grab the inode in that case (or at very
> least undo the grab), so move the call to xfs_icwalk_ag after this sanity
> check.
> 
> Fixes: 1a3e8f3da09c ("xfs: convert inode cache lookups to use RCU locking")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ae3c049fd3a216..3ee92d3d1770db 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1701,9 +1701,6 @@ xfs_icwalk_ag(
>  		for (i = 0; i < nr_found; i++) {
>  			struct xfs_inode *ip = batch[i];
>  
> -			if (done || !xfs_icwalk_igrab(goal, ip, icw))
> -				batch[i] = NULL;
> -
>  			/*
>  			 * Update the index for the next lookup. Catch
>  			 * overflows into the next AG range which can occur if
> @@ -1716,8 +1713,14 @@ xfs_icwalk_ag(
>  			 * us to see this inode, so another lookup from the
>  			 * same index will not find it again.
>  			 */
> -			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
> +			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno) {
> +				batch[i] = NULL;
>  				continue;
> +			}
> +
> +			if (done || !xfs_icwalk_igrab(goal, ip, icw))
> +				batch[i] = NULL;

IOWs, if @ip has been freed and reallocated to a different AG, then we
don't want to touch it at all, not even to check IRECLAIMABLE in igrab.
I think that sounds correct so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
>  			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
>  				done = true;
> -- 
> 2.43.0
> 
> 
