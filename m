Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447E627F747;
	Tue, 22 Jul 2025 18:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753209338; cv=none; b=VbaaDz+mB9Bbk583kwBOqU+oGzRWJ8hbfDYGrrKdgGw/vwmCnzvXT528CO+sUrwzv+NlXpcxm1pgJH5fwY/QgoVrBQvREPuwCt730k8AaxM/Z12l+vWzdoOjGAXNjfHuR454gck0jzqtgjxHdCki5UUkov7MMqYzDPezDTVhbVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753209338; c=relaxed/simple;
	bh=tmsG48jECFf0zV4CrIt7ct1LswYIhppt329VQrzKfTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m9DNE5qs4yMUVzbHR9O0D0lIKDmACbiy6tL1fhA/EVZk0voxqEEU3PHmtA6wDnZ4Vsx8AQvu62ScudHJjQWB1dxIblXSflDaHyUOXmTfJxMig3XPnIgoTN89hsgCPAtIdX2NvuzYo0ywk94r8u5eGWmDJeriLsIfjk1Evbq2Z0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMmetN+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMmetN+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977D5C4CEF4;
	Tue, 22 Jul 2025 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753209337;
	bh=tmsG48jECFf0zV4CrIt7ct1LswYIhppt329VQrzKfTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMmetN+WxlUYyGnFV3/cMZtG4rJoL57AMu9HBGuSoUcO9GAfybGpvaJay4JPzonov
	 4WSx4PEpRzWlSCUWnbrMyoqPk4ZK9iaDizsdyLKlFC+9rz+ICC89BX8XCs2DK3vyCp
	 99YCw99ZkqlaO71ZRwPY6tfNZUxotSTZMu8GOAlu1vzQfl4946yfBVLnIv9iJwM/9k
	 g8wCgL2VqDEpBypOyyqADzlbzzsHf9AlCUK/Z61Q9jPvnaaOtuRM1Z7xfPMjJlpdvI
	 T+yY6BdKiNfm6N2KDYP9KsK5B7R/vLVRV4vCoyjGvrpEeFOK6AttpQGzF9IWvWJ8gP
	 MLvBbwnSriobQ==
Date: Tue, 22 Jul 2025 11:35:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cen zhang <zzzccc427@gmail.com>, cem@kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	zhenghaoran154@gmail.com, r33s3n6@gmail.com, gality365@gmail.com,
	linux-xfs@vger.kernel.org
Subject: Re: [BUG] xfs: Assertion failed in xfs_iwalk_args triggered by
 XFS_IOC_INUMBERS
Message-ID: <20250722183537.GU2672049@frogsfrogsfrogs>
References: <CAFRLqsU-k2GYx4D9HUmu+tSTvmMbY_ea9aYwE+2yvHwLP_+JDQ@mail.gmail.com>
 <aH3fXv5tlfGtzVD1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH3fXv5tlfGtzVD1@infradead.org>

On Sun, Jul 20, 2025 at 11:34:06PM -0700, Christoph Hellwig wrote:
> The patch below should fix the issue.  But I wonder if we should split
> the flags a bit better to make things more obvious.

We did in [1], but did you have something else in mind?

[1] https://lore.kernel.org/linux-xfs/20220321051750.400056-18-chandan.babu@oracle.com/

> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index c8c9b8d8309f..302efe54e2af 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -457,7 +457,8 @@ xfs_inumbers(
>  	 * locking abilities to detect cycles in the inobt without deadlocking.
>  	 */
>  	tp = xfs_trans_alloc_empty(breq->mp);
> -	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
> +	error = xfs_inobt_walk(breq->mp, tp, breq->startino,
> +			breq->flags & XFS_IBULK_SAME_AG,

That's correct -- the only IBULK flag with meaning for xfs_inobt_walk is
SAME_AG because the others affect bulkstat output.

But it might be clearer to make this explicit the same way that
xfs_bulkstat does:

	unsigned int iwalk_flags = 0;

	if (breq->flags & XFS_IBULK_SAME_AG)
		iwalk_flags |= XFS_IWALK_SAME_AG;

	error = xfs_inobt_walk(..., iwalk_flags, ...);

This probably should have been included in [1] so:

Cc: <stable@vger.kernel.org> # v5.19
Fixes: 5b35d922c52798 ("xfs: Decouple XFS_IBULK flags from XFS_IWALK flags")

--D
