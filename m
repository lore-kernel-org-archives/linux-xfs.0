Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B532231CA4E
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 18:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798771; cv=none; b=Z6IAiZJPACPbXI/mGpusay22jm3X0sAlaspykPZ8V6ZiBlza2QDdsRBpkh3eN3QlyzKbnV0keialzqHYOfw1eGYxj5kZNlXKJHL8kML2Y2gPyujeXKcTOZPgbtgcrSooSOTSTITHO7rI5+Z5LwsWyBpfrOVdgzheN+wQIZ+26Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798771; c=relaxed/simple;
	bh=ZPyXajBXRgiThsy2ldtLgRRGEQTbQ9KdgcQStbfB9MM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PSphqdxBZEOO0r08ppkD7d2xBF+QdvrHWPLmoXEsmJgKul6KIz/whWtD7HO/SMrV5OllMyEfmz2WVugySjvt0msv0q9L8emu8ACXrJm4oM1M9/XHX5niDKiEsgLo2E8gv0fgdE77EZyk4BCw9mvhlJCbQXP2gO0MpUy1DTVcRyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXDXOP4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXDXOP4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DD7C4CEFB;
	Mon, 10 Nov 2025 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762798771;
	bh=ZPyXajBXRgiThsy2ldtLgRRGEQTbQ9KdgcQStbfB9MM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QXDXOP4VKnw2Hu3K0WzgodDc37jyqg12HQ9X0+BvjB1lEpogxqtohtw58MMucF2hb
	 cegZues926FmKfbunaLb3aoCglDER1oC5ma7rIeXMzaPk1mKrL1e4Mg72GUt6OkErj
	 xTx8I/qRgCnW6psUR6ayUfeH6+QQkqwMy1n99KNOiiNMILinTjp9/BWEehG09We9uk
	 XeMEtwAfrES5MT+EV76l3w981IAzO1xYn7TY/ug7YGGlSsn++NhvXnYLPFm7BzVDDe
	 U6tK4FuaP/NjGtRc5/z7AweZGlPe43flezR+KThh10n6fa98rVjCOd3oa9634Hw4uD
	 UzAUpmZwzy06A==
Date: Mon, 10 Nov 2025 10:19:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc
Message-ID: <20251110181930.GW196370@frogsfrogsfrogs>
References: <20251110132335.409466-1-hch@lst.de>
 <20251110132335.409466-19-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110132335.409466-19-hch@lst.de>

On Mon, Nov 10, 2025 at 02:23:10PM +0100, Christoph Hellwig wrote:
> xfs_qm_vop_dqalloc only needs the (exclusive) ilock for attaching dquots
> to the inode if not done so yet.  All the other locks don't touch the inode
> and don't need the ilock - the i_rwsem / iolock protects against changes
> to the IDs while we are in a method, and the ilock would not help because
> dropping it for the dqget calls would be racy anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hrmm.  Code-wise, this is reducing the ILOCK scope to the
xfs_qm_dqattach_locked call, so it looks correct to me.  So:

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Zooming out a bit: As far as taking the ILOCK is concerned -- I think we
still need to do that to prevent [ugp]id changes to the inode while
we're doing a potentially expensive ondisk dquot allocation, right?

--D

> ---
>  fs/xfs/xfs_qm.c | 32 +++-----------------------------
>  1 file changed, 3 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index a81b8b7a4e4f..95be67ac6eb4 100644
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
