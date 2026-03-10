Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE6E312825
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 08:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773131964; cv=none; b=WyBriK+LoMoSasEWWUR7u2pFS012wpUv5jJO3SehKoJ3Zj7IUMMCcsITI7r5MrXKaAzsv4RlSNPnJy3fR1Fcxbsxy2e5fj6XG6Q3WfE7eCsaw2TSQdMk6JFn1XCs1r1Xqqh6tCxsU/f/7GOKQIc28oJ49lvt2QXhnOsqDsFoDIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773131964; c=relaxed/simple;
	bh=gF4GMKi2WD/alzq8MPaZcVS/jHZnbSl7yZrQqFMeP0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mfH0TAxk6J2l4tTJ1ANfRR4bUFKhBxU/jdrBGm5MTUKtdh6IDYaH/dA+LvgBtfiWtUcrHUap1kE4xqftbFigki8QpFRkxsRoNvsWqGHVYtFN0j4JLPkfpL9eQGZc/GHGTXBZjbbDs3c2hKPzqDfaFUizAAYTFqTibTeoyTXuROU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjK+0egE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjK+0egE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C378EC19423;
	Tue, 10 Mar 2026 08:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773131963;
	bh=gF4GMKi2WD/alzq8MPaZcVS/jHZnbSl7yZrQqFMeP0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QjK+0egED80w3MFozj3jNB2bvza8k5i0TtEMihE700UDMUnKWXpotXRpgEAvuiJ2t
	 o0LEZrL0n84SU2Z9thbEcbFw47B0IX3zvdeL5sTfIuFGV6a9AU+PA9zPstq3LH1vDF
	 ouweaZ51p9XbjaVubNvD4z07pLI0jDEpVDrYfKwgmcw8GHYeOCyynrpvI+vCVmsLrM
	 73m/iUcoVIPIPMccGvqTlZzP3OkP6y+DKcLjOjKf3omfF3YQSg6pHL2eGC5MHj4+fU
	 OHc4EVzHWjsCQFibWSJa+LqjG7x7/gvsC/Owtt3BX/PD2hxHFoUFZTkgah7RRBk6gd
	 KbqeSlmqIoLkA==
Date: Tue, 10 Mar 2026 09:39:18 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, 
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 2/2] xfs: ensure dquot item is deleted from AIL only
 after log shutdown
Message-ID: <aa_YIKWS7P_Dlj0k@nidhogg.toxiclabs.cc>
References: <20260305084922.800699-1-leo.lilong@huawei.com>
 <20260305084922.800699-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305084922.800699-3-leo.lilong@huawei.com>

On Thu, Mar 05, 2026 at 04:49:22PM +0800, Long Li wrote:
> In xfs_qm_dqflush(), when a dquot flush fails due to corruption
> (the out_abort error path), the original code removed the dquot log
> item from the AIL before calling xfs_force_shutdown(). This ordering
> introduces a subtle race condition that can lead to data loss after
> a crash.
> 
> The AIL tracks the oldest dirty metadata in the journal. The position
> of the tail item in the AIL determines the log tail LSN, which is the
> oldest LSN that must be preserved for crash recovery. When an item is
> removed from the AIL, the log tail can advance past the LSN of that item.
> 
> The race window is as follows: if the dquot item happens to be at
> the tail of the log, removing it from the AIL allows the log tail
> to advance. If a concurrent log write is sampling the tail LSN at
> the same time and subsequently writes a complete checkpoint (i.e.,
> one containing a commit record) to disk before the shutdown takes
> effect, the journal will no longer protect the dquot's last
> modification. On the next mount, log recovery will not replay the
> dquot changes, even though they were never written back to disk,
> resulting in silent data loss.
> 
> Fix this by calling xfs_force_shutdown() before xfs_trans_ail_delete()
> in the out_abort path. Once the log is shut down, no new log writes
> can complete with an updated tail LSN, making it safe to remove the
> dquot item from the AIL.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: b707fffda6a3 ("xfs: abort consistently on dquot flush failure")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_dquot.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 2b208e2c5264..69e9bc588c8b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1439,9 +1439,15 @@ xfs_qm_dqflush(
>  	return 0;
>  
>  out_abort:
> +	/*
> +	 * Shut down the log before removing the dquot item from the AIL.
> +	 * Otherwise, the log tail may advance past this item's LSN while
> +	 * log writes are still in progress, making these unflushed changes
> +	 * unrecoverable on the next mount.
> +	 */
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
>  	xfs_trans_ail_delete(lip, 0);
> -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	xfs_dqfunlock(dqp);
>  	return error;
>  }

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -- 
> 2.39.2
> 
