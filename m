Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75B93C3C11
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939121; cv=none; b=Gz1EX8zcOYoEqXfil3JuiE5D8qjhmG4H9FADAvHZt6IZq0dVPccq82Z4tg54QGwkUjRNxgzY1gf2t2pJeizilmzfoJO4/NgQ+x9jLcccoibKQS4xMcEtpBu4/ty4bbRQcU3KUGBwdeOxOyVb45YO40kIIRJxSOvA8ZLkHR+RmMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939121; c=relaxed/simple;
	bh=fnnMWOmg4erbkV8Aaepkev9jpkAvfa/wK+eSHrHKjBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujyYjAnp3Io/xBqXqsilj3aLjHNAdDkrIdGnjEcG3s0PfPmiAIVbD6lenJHZd3+reilll9/DrlRS6aHgJEILID0XGzou7jR7taSmWlU/qtmC0tu+cKjlZW8qrx29xnuFFv0IY0cj7SbhpRwJid7gE/HFPqxUfllhpusiBZEX38A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwaEjdiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwaEjdiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68733C19424;
	Thu, 19 Mar 2026 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939121;
	bh=fnnMWOmg4erbkV8Aaepkev9jpkAvfa/wK+eSHrHKjBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BwaEjdiHIqUeopttwW0efSFRDcffx5dHrHjYTLTo3WT1dQO/VhYKNk0BIhQe8yEcI
	 U2qpRAXFzxJ6vjcsV3EbyM7vsgr2h7pZ09kP/rXBaQLrehhwUCIqCAnU+XNqyMpfb9
	 4YiJZ9mt20QgL+L0mH88ABJ6B9rkK3OCu7Dh5M8rbKrOyvSUcTr+4lGwZPtqPk9WBC
	 WmB7ZpDO8GwgFJeZ4WH83pW3nnSv6ZdKJI5QITI284UNILrYjxkgpAj1YOHnBtcCfG
	 MIvFS6hZdOt3e0G/TVF8TqxSSNgKjHrODCXN0V8Vbd2/wbONUOClJlVSqz6phmxfsk
	 3rdbUKjhpaWXw==
Date: Thu, 19 Mar 2026 09:52:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v2 1/3] xfs: fix possible null pointer dereference in
 xfs_attri_recover_work
Message-ID: <20260319165200.GP1770774@frogsfrogsfrogs>
References: <20260319010618.722448-1-leo.lilong@huawei.com>
 <20260319010618.722448-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319010618.722448-2-leo.lilong@huawei.com>

On Thu, Mar 19, 2026 at 09:06:16AM +0800, Long Li wrote:
> When xlog_recover_iget() or xlog_recover_iget_handle() fails, ip is
> not guaranteed to be initialized. Calling xfs_irele(ip) unconditionally
> in the error path may dereference a null pointer.
> 
> Cc: <stable@vger.kernel.org> # v6.9
> Fixes: ae673f534a30 ("xfs: record inode generation in xattr update log intent items")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_attr_item.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 354472bf45f1..8ebdd0926b89 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -633,7 +633,7 @@ xfs_attri_recover_work(
>  {
>  	struct xfs_attr_intent		*attr;
>  	struct xfs_da_args		*args;
> -	struct xfs_inode		*ip;
> +	struct xfs_inode		*ip = NULL;
>  	int				local;
>  	int				error;
>  
> @@ -653,7 +653,8 @@ xfs_attri_recover_work(
>  		break;
>  	}
>  	if (error) {
> -		xfs_irele(ip);
> +		if (ip)
> +			xfs_irele(ip);

Hrmm.  On second thought, there's a much more severe UAF bug here:

int
xlog_recover_iget(
	struct xfs_mount	*mp,
	xfs_ino_t		ino,
	struct xfs_inode	**ipp)
{
	int			error;

	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
	if (error)
		return error;

	error = xfs_qm_dqattach(*ipp);
	if (error) {
		xfs_irele(*ipp);
		return error;

^^^^^ here we return a nonzero error, having previously set @ipp.
The xfs_irele in xfs_attri_recover_work is, in this case, the wrong
thing to do.

	}

	if (VFS_I(*ipp)->i_nlink == 0)
		xfs_iflags_set(*ipp, XFS_IRECOVERY);

	return 0;
}

With that fixed, the xfs_irele call in xfs_attri_recover_work becomes
incorrect because the xlog*iget functions never return nonzero *and* set
*ipp.  If you found this via static checker, I wonder if that's what is
tripping it up?

--D

>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
>  				sizeof(*attrp));
>  		return ERR_PTR(-EFSCORRUPTED);
> -- 
> 2.39.2
> 
> 
