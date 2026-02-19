Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6282C0F8C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 13:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506706; cv=none; b=kgC6P1zFOySkLdPlUSCz3KqwTTAbPkFgxE/ZRdE2d+1Cdhjv+aiUa8z5tfwxic4msBSucUNjv2ewlQQ8W3T3DIbEZte3Lcm/0Slrh9ZbuhuxdckAeRkQfhGOQe7U4nOEIkCihjxD6uzUo768Bmn+zB1WdS+HPtyL5DhIt+i++eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506706; c=relaxed/simple;
	bh=q8VJMrc8n1rNzDm1g6nxCqEgajkXiV4bGGAfB++sHxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clca7Kdq+8KhvF5xTsXkzfW9EwXC06cYC9dtX30KzhGhtGkDFDs+J11opALbJj9DeKY93vUvIZLMdPADxaOtGVM9/Plv4rn3KelHNuOxP8f35K5M4gCo5RgKKfaapi7bYcTVu4oBaTBnGrI/c4Sxk19XpmGP3ZsQaWQ0Qs/S138=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPznEakT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPznEakT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73750C4CEF7;
	Thu, 19 Feb 2026 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771506706;
	bh=q8VJMrc8n1rNzDm1g6nxCqEgajkXiV4bGGAfB++sHxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iPznEakTTfHGuxMAVjU3VdAxvBQ/AGbUVeN+mqbNAsbFHVVX9ksyQ7eGb97Rb2v50
	 eTasU9MonZInXCqh461JjEO7N/DxlXaObcnU+RL3Qv2bpNDdp+hJJr0afd9P2dXxpG
	 wl86/ARm2lkZGyVYMpqtTwjdw30/XolRH99Evb5jx94c2xba19HkNwftSKmlDs42UG
	 vGHOFUrd7mS+jtsfpIUUSQIlQhWrEsYK24pj/kLlGrPhUj65AuXZW5xukKGoNqBFu3
	 AtNdggkDsADG6QgXZuAioOkpLq91GwaMNjj5Xk3DfHg45e+4DiR+XE2q2Mntlce7Zg
	 gLbItJFjGIztA==
Date: Thu, 19 Feb 2026 14:11:42 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: don't report metadata inodes to fserror
Message-ID: <aZcMBfm6ls3F88ks@nidhogg.toxiclabs.cc>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925516.401799.751825387607935746.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925516.401799.751825387607935746.stgit@frogsfrogsfrogs>

On Wed, Feb 18, 2026 at 10:02:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Internal metadata inodes are not exposed to userspace programs, so it
> makes no sense to pass them to the fserror functions (aka fsnotify).
> Instead, report metadata file problems as general filesystem corruption.
> 
> Fixes: 5eb4cb18e445d0 ("xfs: convey metadata health events to the health monitor")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_health.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 169123772cb39b..6475159eb9302c 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -314,6 +314,18 @@ xfs_rgno_mark_sick(
>  	xfs_rtgroup_put(rtg);
>  }
>  
> +static inline void xfs_inode_report_fserror(struct xfs_inode *ip)
> +{
> +	/* Report metadata inodes as general filesystem corruption */
> +	if (xfs_is_internal_inode(ip)) {
> +		fserror_report_metadata(ip->i_mount->m_super, -EFSCORRUPTED,
> +				GFP_NOFS);
> +		return;
> +	}
> +
> +	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
> +}
> +
>  /* Mark the unhealthy parts of an inode. */
>  void
>  xfs_inode_mark_sick(
> @@ -339,7 +351,7 @@ xfs_inode_mark_sick(
>  	inode_state_clear(VFS_I(ip), I_DONTCACHE);
>  	spin_unlock(&VFS_I(ip)->i_lock);
>  
> -	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
> +	xfs_inode_report_fserror(ip);
>  	if (mask)
>  		xfs_healthmon_report_inode(ip, XFS_HEALTHMON_SICK, old_mask,
>  				mask);
> @@ -371,7 +383,7 @@ xfs_inode_mark_corrupt(
>  	inode_state_clear(VFS_I(ip), I_DONTCACHE);
>  	spin_unlock(&VFS_I(ip)->i_lock);
>  
> -	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
> +	xfs_inode_report_fserror(ip);
>  	if (mask)
>  		xfs_healthmon_report_inode(ip, XFS_HEALTHMON_CORRUPT, old_mask,
>  				mask);
> 
