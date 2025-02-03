Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05331FECC5
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738621613; cv=none; b=EVKxWgFR0Q/D2mPqz+KV3Zk7wiXuAuVghyMLLX7OooHaTY9TArPzfhxvFcxsVcT0Hev7vMNigfWvjGQlxw7SX7kYR7a8XRhvHNqd/tpnRKGQOaroG6e2nAaM2Dv+FuekH/sNxLhY0NqIgEAqqZUav2v4eM8xnIzmrXovEbvt/VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738621613; c=relaxed/simple;
	bh=uG3DEM3FXyuAdVVA/VZ8tbyZC8Gl8vidMdZCdMzdkjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dz1vDrug0YjacCpti9kmtfuondO2m7osXU06TIV1sqH3g5CPYFovuFMAuwPWwib1XX9AorVXJypN71Kn6E/BdVYABRpNmkzAv994c/KTXa+e4bk3Y+Y30VZR8fkgKimlk9hq1B+S0cqzliOj4Usad11W0m53JDTETudTAXULKQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyFZTSIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyFZTSIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3549CC4CED2;
	Mon,  3 Feb 2025 22:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738621613;
	bh=uG3DEM3FXyuAdVVA/VZ8tbyZC8Gl8vidMdZCdMzdkjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nyFZTSIzItrRQBaSXCNacOB4GxzT+2AbvdlhE7TlvhaXV8GczCxAudhPTJe8GxcKG
	 j2SBw2vJGgt0lNutluranIzbRal/Dm2vGYkYndSnJ9Pdx+q+xzaIbaAVKfDopILmaa
	 vwABsmdao3vrU8Eo+foiY/ZaELEQ/LFN3F20hSlE2tk5PKz3if0zwCjpuut2hMofhW
	 poLi0IavSNAJ+pY1rea+MJwSkrulCE4LAsYNEyjV55vWtEN+inSsoPXGdJWckHKc72
	 j2feoCyMpOgRTRYxU7pJPH3+/peF979yH9cxLfPBYrJlc/jNMPBDxWcJz5Ib69xYVy
	 /t6zwpJRojC5g==
Date: Mon, 3 Feb 2025 14:26:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: do not check NEEDSREPAIR if ro,norecovery mount.
Message-ID: <20250203222652.GG134507@frogsfrogsfrogs>
References: <20250203085513.79335-1-lukas@herbolt.com>
 <20250203085513.79335-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203085513.79335-2-lukas@herbolt.com>

On Mon, Feb 03, 2025 at 09:55:13AM +0100, Lukas Herbolt wrote:
> If there is corrutpion on the filesystem andxfs_repair
> fails to repair it. The last resort of getting the data
> is to use norecovery,ro mount. But if the NEEDSREPAIR is
> set the filesystem cannot be mounted. The flag must be
> cleared out manually using xfs_db, to get access to what
> left over of the corrupted fs.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_super.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 394fdf3bb535..c2566dcc4f88 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1635,8 +1635,12 @@ xfs_fs_fill_super(
>  #endif
>  	}
>  
> -	/* Filesystem claims it needs repair, so refuse the mount. */
> -	if (xfs_has_needsrepair(mp)) {
> +	/*
> +	 * Filesystem claims it needs repair, so refuse the mount unless
> +	 * norecovery is also specified, in which case the filesystem can
> +	 * be mounted with no risk of further damage.
> +	 */
> +	if (xfs_has_needsrepair(mp) && !xfs_has_norecovery(mp)) {

I think a better way to handle badly damaged filesystems is for us to
provide a means to extract directory trees in userspace, rather than
making the user take the risk of mounting a known-bad filesystem.
I've a draft of an xfs_db subcommand for doing exactly that and will
share for xfsprogs 6.14.

--D

>  		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
>  		error = -EFSCORRUPTED;
>  		goto out_free_sb;
> -- 
> 2.48.1
> 
> 
