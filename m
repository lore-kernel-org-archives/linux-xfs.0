Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8CE2D0614;
	Tue, 19 May 2026 05:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779166956; cv=none; b=f8MFcOZBhoyWpolBnXJwIU4+lxMh+8Jhl4kUk5bz0siK3i3NcLCW6YfVWUA6NKprQ9TtACSqJfG3XJFABke2yvcWVJXNL7zPuHSObjd94NhOfPFuoUoAoW0h6MGlmCiiFq9IsfUgnUWTTan+PDlxF1PeysBxu0zR8/WVFowe9IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779166956; c=relaxed/simple;
	bh=G/MwVnRNmnlffI9t1jADX2c/PciFvlX4MBcc9PKFdGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hcnbazgpuBYKWiq1LLNkMBA1aeEdJ13So3JpGnYncFrsPaiKlvcxzji8aTqLp3UCO6VBuQuWeMZtc6AhkU4qnGB7F3u7+mDGEcbLRvW8kU3NgcaHbKjsskSn164ZynsBCmwTNqLVtoAqQCIgy0tVzSAiR2H2OLKYGm8wMySI63M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FpwEk2AE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FpwEk2AE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B76C2BCB3;
	Tue, 19 May 2026 05:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779166955;
	bh=G/MwVnRNmnlffI9t1jADX2c/PciFvlX4MBcc9PKFdGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FpwEk2AEaj7Qwoc7IYARs4GKL8lk6InSSnaRUX8OGnoS7JISSmxouOv5URbBddOEo
	 FhcPpsbisg3x9kpHDiDVBzP6zuPBcL5WU7eT94Y2U0RCrgi+O/u9UzgXx63O6/GIjb
	 OXKCo3ZbcfTp+KRNm9zHRAg+WncHjmAAfu07/Wru8nTiSTThP9EZnQcSl+Q+T1b4/A
	 pd27Uz7C2Ilap+dpsyK+ky9mzt9p4uWFIjQhVJWk1QI3KfDt1y2tYKVakD1FF1eFLT
	 eePUc0bxER7FOumRlFXuj1VY3uDRh3gZyHJHUtCQkl0a12WpDx+4DnABIJf1Lg4k8Y
	 pOsNirKm/+4VA==
Date: Mon, 18 May 2026 22:02:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: detect cycles in recovered unlinked inode lists
Message-ID: <20260519050235.GI9568@frogsfrogsfrogs>
References: <20260518013143.1532327-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518013143.1532327-1-michael.bommarito@gmail.com>

On Sun, May 17, 2026 at 09:31:43PM -0400, Michael Bommarito wrote:
> Two XFS walkers follow on-disk AGI unlinked bucket lists until the
> NULLAGINO sentinel and trust the links unconditionally:
> 
>   xlog_recover_iunlink_bucket(), reached at mount time when the log
>   needs recovery, via xlog_recover_finish() ->
>   xlog_recover_process_iunlinks().
> 
>   xfs_inode_reload_unlinked_bucket(), reached post-mount via
>   xfs_bulkstat_one_int() and other inode-reload paths.
> 
> A crafted image with an AGI bucket head pointing into a cycle traps
> either walker forever. With the mount-time walker, the mount(8)
> syscall itself never returns; the kernel thread is uninterruptible
> inside the loop, so SIGKILL on the mount process is queued but never
> delivered. With the bulkstat walker, an XFS_IOC_BULKSTAT call hangs
> the same way.
> 
> Reject invalid AG inode numbers, bucket mismatches, and repeated AG
> inode numbers in both walkers. Mark the AGI sick and return
> -EFSCORRUPTED so callers handle the corrupt metadata instead of
> walking the same on-disk list forever.
> 
> Reproduced on a crafted image whose AGI bucket holds a self-cycle and
> whose on-disk log is dirty: a stock kernel hangs in the mount syscall
> indefinitely, while the patched kernel completes log recovery,
> reports the corruption, and the filesystem shuts down with
> -EFSCORRUPTED.

(Does xfs_repair fix the problem if the mount fails?)

> Fixes: 04755d2e5821b3afbaadd09fe5df58d04de36484 ("xfs: refactor xlog_recover_process_iunlinks()")
> Fixes: 83771c50e42b92de6740a63e152c96c052d37736 ("xfs: reload entire unlinked bucket lists")
> Assisted-by: Codex:gpt-5-5-xhigh
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> ---
>  fs/xfs/xfs_inode.c       | 29 +++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c | 26 +++++++++++++++++++++++++-
>  2 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index beaa26ec62da4..f930d5c823c77 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -4,6 +4,7 @@
>   * All Rights Reserved.
>   */
>  #include <linux/iversion.h>
> +#include <linux/xarray.h>
>  
>  #include "xfs_platform.h"
>  #include "xfs_fs.h"
> @@ -2859,6 +2860,7 @@ xfs_inode_reload_unlinked_bucket(
>  	struct xfs_buf		*agibp;
>  	struct xfs_agi		*agi;
>  	struct xfs_perag	*pag;
> +	struct xarray		seen_aginos;
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		prev_agino, next_agino;
> @@ -2873,6 +2875,8 @@ xfs_inode_reload_unlinked_bucket(
>  	if (error)
>  		return error;
>  
> +	xa_init(&seen_aginos);

Why not use xbitmap.h for this?  Is it too memory-inefficient over an
xarray?

> +
>  	/*
>  	 * We've taken ILOCK_SHARED and the AGI buffer lock to stabilize the
>  	 * incore unlinked list pointers for this inode.  Check once more to
> @@ -2897,6 +2901,30 @@ xfs_inode_reload_unlinked_bucket(
>  	while (next_agino != NULLAGINO) {
>  		struct xfs_inode	*next_ip = NULL;
>  
> +		/*
> +		 * The on-disk unlinked list is corrupt if it points outside this
> +		 * AG, into another bucket, or back to an inode that we already
> +		 * saw during this reload walk.
> +		 */
> +		if (!xfs_verify_agino(pag, next_agino) ||
> +		    next_agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {

Does online fsck need any corrections w.r.t. these new findings?

--D

> +			xfs_buf_mark_corrupt(agibp);
> +			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> +			error = -EFSCORRUPTED;
> +			break;
> +		}
> +
> +		if (xa_load(&seen_aginos, next_agino)) {
> +			xfs_buf_mark_corrupt(agibp);
> +			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> +			error = -EFSCORRUPTED;
> +			break;
> +		}
> +		error = xa_err(xa_store(&seen_aginos, next_agino,
> +					xa_mk_value(1), GFP_NOFS));
> +		if (error)
> +			break;
> +
>  		/* Found this caller's inode, set its backlink. */
>  		if (next_agino == agino) {
>  			next_ip = ip;
> @@ -2931,6 +2959,7 @@ xfs_inode_reload_unlinked_bucket(
>  	}
>  
>  out_agibp:
> +	xa_destroy(&seen_aginos);
>  	xfs_trans_brelse(tp, agibp);
>  	/* Should have found this inode somewhere in the iunlinked bucket. */
>  	if (!error && !foundit)
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 09e6678ca4878..8ca70bbbfac81 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3,6 +3,8 @@
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> +#include <linux/xarray.h>
> +
>  #include "xfs_platform.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> @@ -28,6 +30,7 @@
>  #include "xfs_ag.h"
>  #include "xfs_quota.h"
>  #include "xfs_reflink.h"
> +#include "xfs_health.h"
>  
>  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
>  
> @@ -2726,11 +2729,31 @@ xlog_recover_iunlink_bucket(
>  	struct xfs_mount	*mp = pag_mount(pag);
>  	struct xfs_inode	*prev_ip = NULL;
>  	struct xfs_inode	*ip;
> +	struct xarray		seen_aginos;
>  	xfs_agino_t		prev_agino, agino;
>  	int			error = 0;
>  
> +	xa_init(&seen_aginos);
> +
>  	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
>  	while (agino != NULLAGINO) {
> +		if (!xfs_verify_agino(pag, agino) ||
> +		    agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
> +			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> +			error = -EFSCORRUPTED;
> +			break;
> +		}
> +
> +		if (xa_load(&seen_aginos, agino)) {
> +			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> +			error = -EFSCORRUPTED;
> +			break;
> +		}
> +		error = xa_err(xa_store(&seen_aginos, agino, xa_mk_value(1),
> +					GFP_NOFS));
> +		if (error)
> +			break;
> +
>  		error = xfs_iget(mp, NULL, xfs_agino_to_ino(pag, agino), 0, 0,
>  				&ip);
>  		if (error)
> @@ -2771,8 +2794,9 @@ xlog_recover_iunlink_bucket(
>  
>  		error2 = xfs_inodegc_flush(mp);
>  		if (error2 && !error)
> -			return error2;
> +			error = error2;
>  	}
> +	xa_destroy(&seen_aginos);
>  	return error;
>  }
>  
> -- 
> 2.53.0
> 
