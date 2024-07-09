Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5D715574D;
	Tue,  9 Jul 2024 21:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720562281; cv=none; b=T4xTT7Q0ETeL45MnSmQYOr2DFqhwY007xU/hgatuV49RCLn4uIMuQ2ulbgIcZ2Kfp1dnQ/bMlJokG9u/hoedLIqTJDDPg3HLyEstERUEssWP1AGyzzh0xh+jnIhEU09zP/GIqf2zLpzAoV9/S8U1afXfDD/odP687n8oC9IVHj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720562281; c=relaxed/simple;
	bh=0UnqKQZJ2AqhTn/B/aEXjJquoPhJbwDB378LYYynJO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R87L6cDE1nGG+oohLPDn9DLUaT7R4oTVYinzLgShhoiLEqeaE1GlmhXT3UvwPlsTxHYNxP6p6Q8nkYP4s+2oHt50ohrcvn2UnkynJ6JVyOQeiZIr9uMhp0SLWwlHsI5+XokGv74gPLlPmoUZL2Nk1z664Us9jJMVLQCe5qOgCwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ne1v4A4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ne1v4A4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E826C3277B;
	Tue,  9 Jul 2024 21:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720562280;
	bh=0UnqKQZJ2AqhTn/B/aEXjJquoPhJbwDB378LYYynJO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ne1v4A4vTs/D/dfmKPSEXTxGjT5m1cyRnYfJZfCTAUaKY5/zkcfd/PbpyUOxMToHY
	 fMO3OlAs4sQFbwmigjhUcuUWn8qm7V5GU4i/vYYrQazYPD2iVemimgD455yt0SH1yt
	 sPD7yH3EzaRdSV++IG86ko5IXRweSksCOeg41qC2kZsaXkeZqO1ux3fck4RMQlUZhO
	 m5sK0zUHm33HaKl9gZJkPqE4fKS7R+dEXcAJkFhrV00A+JIe77F3D9EXFengbsuiuL
	 Jp6c8y9wr/dPmtW7dR1Y95yEdeqY+0Z4NJw5E7lyKKlPlHvvm7czjV6v1v27ci8LvW
	 t0qoAyTvKYYZQ==
Date: Tue, 9 Jul 2024 14:57:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: convert comma to semicolon
Message-ID: <20240709215759.GC612460@frogsfrogsfrogs>
References: <20240709073632.1152995-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709073632.1152995-1-nichen@iscas.ac.cn>

On Tue, Jul 09, 2024 at 03:36:32PM +0800, Chen Ni wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  fs/xfs/xfs_attr_list.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5c947e5ce8b8..7db386304875 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -139,7 +139,7 @@ xfs_attr_shortform_list(
>  		sbp->name = sfe->nameval;
>  		sbp->namelen = sfe->namelen;
>  		/* These are bytes, and both on-disk, don't endian-flip */
> -		sbp->value = &sfe->nameval[sfe->namelen],
> +		sbp->value = &sfe->nameval[sfe->namelen];
>  		sbp->valuelen = sfe->valuelen;
>  		sbp->flags = sfe->flags;
>  		sbp->hash = xfs_attr_hashval(dp->i_mount, sfe->flags,
> -- 
> 2.25.1
> 
> 
