Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C80718C34C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724432407; cv=none; b=pGWQEuM8Geu7Bstpc1G7cFXyhOIUBbXmvF6mo1HsS6bxbL6dfim3M73CzAcGozsF/AEPKm+cuYELy4CON3JYu50IrZ4970A/AEWx/R5+KnVOw8Ym50TSz8zp01OintY6f95x4aahzQsE8CPZIUK1S7Ei9U8e4dRDYqLZy9qE4M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724432407; c=relaxed/simple;
	bh=q9A2HENXFlkBeM0Mgns0TkPjsR8QWMS3BXz21oBusew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SV6NQ1QXulzv9jt0Rr8KlRs0BUE/l59iKuzZCs903MUI4H9GeAEFWZZX0/jxZdtzgIyHgNqK1pfGNv2irHgFuiTpvgo0V3VYwmS4ZXDO4U65aRwJLJ2X7JUABGkBfMoCYi6Tu2yO1cW8nHs+Ktut7Pm/UncCFJr9k3KD3kBc7o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7MUhYLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7MUhYLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2099C32786;
	Fri, 23 Aug 2024 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724432406;
	bh=q9A2HENXFlkBeM0Mgns0TkPjsR8QWMS3BXz21oBusew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A7MUhYLLundTVgj5nIKnTeWeA9zg+Q8gwIqh0eCqvhJvjL8nQYzovlZTniJ76V1mt
	 r9wCWEu9WO/qQlVaRmk8lAs79YxPfDExd41vnf5pYOhOE9006StWUd9Gw4AbCjInAa
	 a86il0FP8TheFAeVDNZQgWE5WHw6kkDQ2wdyf8Kpv0PQ8ijgkpEz+tnrmAEgPc2gjU
	 lkxBITWk4OpjXA1GsjYwE2cJy9mSlBFnYvFju2wG1teMslOSYl4DGISKsYZ0EAplST
	 3uslAmmyxDhGwc/ErolxLDBANRYoPCbcjp8ErJ6ZoFdG/bIDW4Kz89NKGMI35P2q78
	 udkpXCbENPVaA==
Date: Fri, 23 Aug 2024 10:00:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 2/5] xfs: ensuere deleting item from AIL after shutdown
 in dquot flush
Message-ID: <20240823170006.GF865349@frogsfrogsfrogs>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823110439.1585041-3-leo.lilong@huawei.com>

On Fri, Aug 23, 2024 at 07:04:36PM +0800, Long Li wrote:
> Deleting items from the AIL before the log is shut down can result in the
> log tail moving forward in the journal on disk because log writes can still
> be taking place. As a result, items that have been deleted from the AIL
> might not be recovered during the next mount, even though they should be,
> as they were never written back to disk.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_dquot.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c1b211c260a9..4cbe3db6fc32 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1332,9 +1332,15 @@ xfs_qm_dqflush(
>  	return 0;
>  
>  out_abort:
> +	/*
> +	 * Shutdown first to stop the log before deleting items from the AIL.
> +	 * Deleting items from the AIL before the log is shut down can result
> +	 * in the log tail moving forward in the journal on disk because log
> +	 * writes can still be taking place.
> +	 */
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
>  	xfs_trans_ail_delete(lip, 0);
> -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);

I see the logic in shutting down the log before letting go of the dquot
log item that triggered the shutdown, but I wonder, why do we delete the
item from the AIL?  AFAICT the inode items don't do that on iflush
failure, but OTOH I couldn't figure out how the log items in the AIL get
deleted from the AIL after a shutdown.  Or maybe during a shutdown we
just stop xfsaild and let the higher level objects free the log items
during reclaim?

--D

>  out_unlock:
>  	xfs_dqfunlock(dqp);
>  	return error;
> -- 
> 2.39.2
> 
> 
