Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13F828DC4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 12:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771505852; cv=none; b=B+q70M6z2GXmfFhz0aZRWUaOzZBw8mfO+s/5m6u9MFIzti5+iroN1Iifl7H4nDvtURydhpvZDfOcRfebnfhMihyuH3fRGSMpszhl9IaAdSwu3ACxdcfZx11yEB2hNlUSlWwWZnHuGZIG04dMkSdziXOAkQliNLib9x0Z2eVKpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771505852; c=relaxed/simple;
	bh=vSjoQUNTsrGTAlavStuZdz2z8sYpFT9US/7aTxxbJXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYFWbZmjUmsYYR6N4w0tbJ5D0RhgxcHDNGF9mJlTvl8HEnhr1NJMPa/sr5Hj/5H68QQ3t+jaE+7c+t/umEybIlnIjTMlCDAcahk+wzagl2czzlCG0WTCMAib7OyreDi8gmKF2jHriWO3/ZEFLp5bkwNVq+RKvcp/YYZTrcVrJzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhgMVVsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhgMVVsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA69DC4CEF7;
	Thu, 19 Feb 2026 12:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771505851;
	bh=vSjoQUNTsrGTAlavStuZdz2z8sYpFT9US/7aTxxbJXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QhgMVVsHzJ1tBhj0Btkz+XbVK1VTpPEBktyDCazDsFSN4y9R56ZR1iKt7iWt9hR9l
	 6q07wlIB5zTDoS3i+2CPU8fGeCzlqOqgJKkOJ8lkn044x8fuBoNyKL5oJ1KsLJ8OeA
	 ArE1EeLvnrX6Q/16OJXEApHODnFBZ4qsAeYCA86HgMY7T7JJI7vYoV54v3ulgDba8D
	 Bqb1dxMn4jVGDFOwuyuTq5ns3gUx2/9p1Mym0KMJAMN/Q/8kW+LfhyVd01VAGmlT6J
	 YWVV1i2jE2Mgu3LdXJG58hbA2tan9x1lxBC3XIpXU2wI6L1SLUOuWP7Q9HIxdpHxLP
	 /08Gaw/0cXGcA==
Date: Thu, 19 Feb 2026 13:57:27 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: clm@meta.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix xfs_group release bug in
 xfs_verify_report_losses
Message-ID: <aZcIsgfMQKmXJ4SS@nidhogg.toxiclabs.cc>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925451.401799.12258119310555841656.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925451.401799.12258119310555841656.stgit@frogsfrogsfrogs>

On Wed, Feb 18, 2026 at 10:01:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Chris Mason reports that his AI tools noticed that we were using
> xfs_perag_put and xfs_group_put to release the group reference returned
> by xfs_group_next_range.  However, the iterator function returns an
> object with an active refcount, which means that we must use the correct
> function to release the active refcount, which is _rele.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Fixes: b8accfd65d31f ("xfs: add media verification ioctl")
> Reported-by: Chris Mason <clm@meta.com>
> Link: https://lore.kernel.org/linux-xfs/20260206030527.2506821-1-clm@meta.com/
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_verify_media.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
> index 069cd371619dc2..8bbd4ec567f8a1 100644
> --- a/fs/xfs/xfs_verify_media.c
> +++ b/fs/xfs/xfs_verify_media.c
> @@ -122,7 +122,7 @@ xfs_verify_report_losses(
>  
>  			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
>  			if (error) {
> -				xfs_perag_put(pag);
> +				xfs_perag_rele(pag);
>  				break;
>  			}
>  
> @@ -158,7 +158,7 @@ xfs_verify_report_losses(
>  		if (rtg)
>  			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
>  		if (error) {
> -			xfs_group_put(xg);
> +			xfs_group_rele(xg);
>  			break;
>  		}
>  	}
> 
> 
