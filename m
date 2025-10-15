Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1022D6625
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563628; cv=none; b=o3N/a0LSPcIn69YCuyhmVPNhaylv2vdlWv5fqO+c6LemgndTL+cgIKH1RfCkCU4z9ev+T/3GGVv+DzbVNPBqPDV8OQVfK+4WQSxWk5G1fAoKeIiDiOYxhHAdOTXuNo7Z/4eC4mSzPrac0zUKYRFMfqr84Wq6YJghVmCBoOmCEXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563628; c=relaxed/simple;
	bh=j6k1z5PyY4PiD/tLLT0TNF1TO//gZlQvqVwDbHcqEFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEJ2x1f5OvWrmFLzMcNZWwwPFKrM0BcDMW/FWqEmu6+WUvmeymPITWoD3ZnduMZoLJnTZguR03V4diL3od1D9jvv5ZE3dlGO24Qw/ylz8bs0MKH3movsjOat5kVOQd6Ypvl6D3Z3zT826tUuQxKL5Bfk2QZrVFaXRsYoZ6v27xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aC6WZhxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aC6WZhxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4319AC4CEFB;
	Wed, 15 Oct 2025 21:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760563628;
	bh=j6k1z5PyY4PiD/tLLT0TNF1TO//gZlQvqVwDbHcqEFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aC6WZhxdRIIuGA7Ft8+/iB6DydKB/74STHv93J8RIV+at4B2mDEfSrWh3ARa1adHP
	 omqL1mYg7N6vmXRk12e1NlO7ExyGIxI5VVErr9oiKnhjYa0fZ1u+dGW5Av0KuCi8zP
	 YglyHiXkyTmBImF1j3HX7XhhBnrw6Qct7syY01/Hm5rIbsKef22gVl0BdIQRTDY1HE
	 kxhs1mgr4H2V+Ntot3R1LBGqY1GcPDy8cvUiqvp+b52SNRJdrM25sdVA7+dKZ1XU2G
	 JS2Ayf66thyAcYirRb8Jq7NWUtier+xdjh/gw3TyxvqedDrx5jshY15upzObMOXVkm
	 +lLjep8OfRYkg==
Date: Wed, 15 Oct 2025 14:27:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc
Message-ID: <20251015212707.GM2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-18-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:18AM +0900, Christoph Hellwig wrote:
> xfs_qm_vop_dqalloc only needs the (exclusive) ilock for attaching dquots
> to the inode if not done so yet.  All the other locks don't touch the inode
> and don't need the ilock - the i_rwsem / iolock protects against changes
> to the IDs while we are in a method, and the ilock would not help because
> dropping it for the dqget calls would be racy anyway.

...and I guess we no longer detach dquots from live inodes now, so we
really only need ILOCK_EXCL to prevent multiple threads from trying to
allocate and attach a new xfs_dquot object to the same inode, right?

Changing the i_dquot pointers (aka chown/chproj) is what's coordinated
under the iolock, right?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm.c | 32 +++-----------------------------
>  1 file changed, 3 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 7fbb89fcdeb9..336de0479022 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1861,16 +1861,12 @@ xfs_qm_vop_dqalloc(
>  	struct xfs_dquot	*gq = NULL;
>  	struct xfs_dquot	*pq = NULL;
>  	int			error;
> -	uint			lockflags;
>  
>  	if (!XFS_IS_QUOTA_ON(mp))
>  		return 0;
>  
>  	ASSERT(!xfs_is_metadir_inode(ip));
>  
> -	lockflags = XFS_ILOCK_EXCL;
> -	xfs_ilock(ip, lockflags);
> -
>  	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
>  		gid = inode->i_gid;
>  
> @@ -1879,37 +1875,22 @@ xfs_qm_vop_dqalloc(
>  	 * if necessary. The dquot(s) will not be locked.
>  	 */
>  	if (XFS_NOT_DQATTACHED(mp, ip)) {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		error = xfs_qm_dqattach_locked(ip, true);
> -		if (error) {
> -			xfs_iunlock(ip, lockflags);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		if (error)
>  			return error;
> -		}
>  	}
>  
>  	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
>  		ASSERT(O_udqpp);
>  		if (!uid_eq(inode->i_uid, uid)) {
> -			/*
> -			 * What we need is the dquot that has this uid, and
> -			 * if we send the inode to dqget, the uid of the inode
> -			 * takes priority over what's sent in the uid argument.
> -			 * We must unlock inode here before calling dqget if
> -			 * we're not sending the inode, because otherwise
> -			 * we'll deadlock by doing trans_reserve while
> -			 * holding ilock.
> -			 */
> -			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, from_kuid(user_ns, uid),
>  					XFS_DQTYPE_USER, true, &uq);
>  			if (error) {
>  				ASSERT(error != -ENOENT);
>  				return error;
>  			}
> -			/*
> -			 * Get the ilock in the right order.
> -			 */
> -			lockflags = XFS_ILOCK_SHARED;
> -			xfs_ilock(ip, lockflags);
>  		} else {
>  			/*
>  			 * Take an extra reference, because we'll return
> @@ -1922,15 +1903,12 @@ xfs_qm_vop_dqalloc(
>  	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
>  		ASSERT(O_gdqpp);
>  		if (!gid_eq(inode->i_gid, gid)) {
> -			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
>  					XFS_DQTYPE_GROUP, true, &gq);
>  			if (error) {
>  				ASSERT(error != -ENOENT);
>  				goto error_rele;
>  			}
> -			lockflags = XFS_ILOCK_SHARED;
> -			xfs_ilock(ip, lockflags);
>  		} else {
>  			ASSERT(ip->i_gdquot);
>  			gq = xfs_qm_dqhold(ip->i_gdquot);
> @@ -1939,15 +1917,12 @@ xfs_qm_vop_dqalloc(
>  	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
>  		ASSERT(O_pdqpp);
>  		if (ip->i_projid != prid) {
> -			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, prid,
>  					XFS_DQTYPE_PROJ, true, &pq);
>  			if (error) {
>  				ASSERT(error != -ENOENT);
>  				goto error_rele;
>  			}
> -			lockflags = XFS_ILOCK_SHARED;
> -			xfs_ilock(ip, lockflags);
>  		} else {
>  			ASSERT(ip->i_pdquot);
>  			pq = xfs_qm_dqhold(ip->i_pdquot);
> @@ -1955,7 +1930,6 @@ xfs_qm_vop_dqalloc(
>  	}
>  	trace_xfs_dquot_dqalloc(ip);
>  
> -	xfs_iunlock(ip, lockflags);
>  	if (O_udqpp)
>  		*O_udqpp = uq;
>  	else
> -- 
> 2.47.3
> 
> 
