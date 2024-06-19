Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54C3B653
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 01:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718759183; cv=none; b=QkzUmTgutBsOsTNrCXjbTZrkZ3oO/wlJJDCRcIDJI7kctGNU2XNHKUdUwXQLEmqhDG1+2t9pdk7I8JqWxzzoZOsmxNgJTxUUaxxlgYXSq0cwyiM1ev6x65FtIrRFj5CIe6xa7eJkV7jH6dXNBOO2hTHw5d8Dew2nEkbS4Y7z5V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718759183; c=relaxed/simple;
	bh=YKCle4kpNCxUw1jp2zG55YAZUvsHqBwJ6dDWBhrurgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mxpgn5i6yNWIgKR/M19Mh1tk7KQZn5zVf16wWQI4C2UhYsWQuYgDViD/1xTW9Ibg0glnGgmAb0nTjLFYrTpjTUKwdGs48NWRLGUZCrx60ch7oLP8DhC+0XwShR191SKHtawX766ORhEssw8UBZTqwCZKxUc7ywuvblOWIX7MarA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6jaHdXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6jaHdXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D74CC3277B;
	Wed, 19 Jun 2024 01:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718759183;
	bh=YKCle4kpNCxUw1jp2zG55YAZUvsHqBwJ6dDWBhrurgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z6jaHdXfzbbrhvqDBUrJNl7r4Dp5Zr44wbZTU0K1ReCpOH0RHTW7SjKZC1GzEebQX
	 MZJ3strAjkl+GUKrA2b/jkjasLw71KON8bEq/1avFawYo2VejJWo/5FTtHWGf1JpOw
	 DEcgBTEX0WhHhfjAcQBoGYca/jPNEbGXNLH0g7FDDNRb1tbUiUFTy7hGCKT/Vk3Epa
	 2Cb4uxO2XJrLxvTfAOWftxIlCFBkeggeMWiVWuWXTNzsO65JvsJVaxvlzwBZWOXsHn
	 KyFSbo00TTk99mhNpoEa3lyuhhPzpIYTJfuXXwPQFj0tnF+/EE2QB9kgKms1/i89jO
	 TIL+3XZ1F3A6g==
Date: Tue, 18 Jun 2024 18:06:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: honor init_xattrs in xfs_init_new_inode for !attr
 && attr2 fs
Message-ID: <20240619010622.GI103034@frogsfrogsfrogs>
References: <20240618232112.GF103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618232112.GF103034@frogsfrogsfrogs>

On Tue, Jun 18, 2024 at 04:21:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_init_new_inode ignores the init_xattrs parameter for filesystems
> that have ATTR2 enabled but not ATTR.  As a result, the first file to be
> created by the kernel will not have an attr fork created to store acls.
> Storing that first acl will add ATTR to the superblock flags, so chances
> are nobody has noticed this previously.
> 
> However, this is disastrous on a filesystem with parent pointers because
> it requires that a new linkable file /must/ have a pre-existing attr
> fork.  The preproduction version of mkfs.xfs have always set this, but
> as xfs_sb.c doesn't validate that pptrs filesystems have ATTR set, we
> must catch this case.
> 
> Note that the sb verifier /does/ require ATTR2 for V5 filesystems, so we
> can fix both problems by amending xfs_init_new_inode to set up the attr
> fork for either ATTR or ATTR2.
> 
> Fixes: 2442ee15bb1e ("xfs: eager inode attr fork init needs attr feature awareness")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b699fa6ee3b64..b2aab91a86d30 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -870,7 +870,7 @@ xfs_init_new_inode(
>  	 * this saves us from needing to run a separate transaction to set the
>  	 * fork offset in the immediate future.
>  	 */
> -	if (init_xattrs && xfs_has_attr(mp)) {
> +	if (init_xattrs && (xfs_has_attr(mp) || xfs_has_attr2(mp))) {

NAK, this patch is still not correct -- if we add an attr fork here, we
also have to xfs_add_attr().  ATTR protects attr forks in general,
whereas ATTR2 only protects dynamic fork sizes.

	if (init_xattrs && (xfs_has_attr(mp) || xfs_has_attr2(mp))) {
		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);

		if (!xfs_has_attr(mp)) {
			spin_lock(&mp->m_sb_lock);
			xfs_add_attr2(mp);
			spin_unlock(&mp->m_sb_lock);
			xfs_log_sb(tp);
		}
	}

--D

>  		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
>  		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
>  	}
> 
