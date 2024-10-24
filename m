Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F922003AE
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729792681; cv=none; b=l6S2uZ62IkzjSxbgdmcQ6/1UmbDobCwqRPRbxqiDEjgo2eQCR6T2BlSqsFdDBpmhWjiUVDlh2RHkJcT98yWRPH5J5NC5c3bxazV8waXHjRCgrNKxEYkuZR/5FgC+qQRImDOnRHJ0eEVsPw8l2LcvszCYGEe1n5qYTTK5ePpXKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729792681; c=relaxed/simple;
	bh=zpDISm7vTmr7BBnekulIGqRlAwg4KKkvLNvzEYJwj2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8VulxE31zqTHdSlNHbkOkm0QaMWtqmzsCbV9XlgrZUrjpwDgNKV1juP4yzirTl6v/rD96C5la4NZO3L6ucgMHtuMTGm1VXrokiSzYGtPcyerMNwAnKyZ4+t1004LUO+zrFOvIwrM/JRBbhTqkQ+LZBGGfcQE4Tv4oeC5nJDDxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZDsW6cQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZDsW6cQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0352FC4CEE4;
	Thu, 24 Oct 2024 17:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729792681;
	bh=zpDISm7vTmr7BBnekulIGqRlAwg4KKkvLNvzEYJwj2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GZDsW6cQbynWiCHcJ9ehvZRXuYiGqf9TbUYeTReur0AOQMjzWt2nuu9DgT/fgHwgi
	 igpwwscBzTx54BG4MakCX/yuAp8GavcDYZkdsGFjqjdIAG5068Ut5KO0kXuL4srFdm
	 q+LUlOYgZgMLX6YSbCSM8xlCmYMYV+BeoxrfEF6nHr8bYC4tido12lm4ezI41OKRRv
	 E++5GsoRtzjSdiDBGkXfT+sjOaFTCwAvE5OZHSfLguML29XYi5z1XSsKnZUz3GZ0k8
	 SurPm/DEhQmTGsE1Y8mM+ZaqG5bAL0wm+bLNfu9JRcE71VO0dqKdtV8BnWJJ+3xRLJ
	 AlnpJkn4vkxBA==
Date: Thu, 24 Oct 2024 10:58:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] xfs: fix finding a last resort AG in
 xfs_filestream_pick_ag
Message-ID: <20241024175800.GA2386201@frogsfrogsfrogs>
References: <20241023133755.524345-1-hch@lst.de>
 <20241023133755.524345-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023133755.524345-2-hch@lst.de>

On Wed, Oct 23, 2024 at 03:37:22PM +0200, Christoph Hellwig wrote:
> When the main loop in xfs_filestream_pick_ag fails to find a suitable
> AG it tries to just pick the online AG.  But the loop for that uses
> args->pag as loop iterator while the later code expects pag to be
> set.  Fix this by reusing the max_pag case for this last resort, and
> also add a check for impossible case of no AG just to make sure that
> the uninitialized pag doesn't even escape in theory.
> 
> Reported-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com

Cc: <stable@vger.kernel.org> # v6.3
Fixes: f8f1ed1ab3baba ("xfs: return a referenced perag from filestreams allocator")
Perhaps?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_filestream.c | 23 ++++++++++++-----------
>  fs/xfs/xfs_trace.h      | 15 +++++----------
>  2 files changed, 17 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index e3aaa0555597..88bd23ce74cd 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -64,7 +64,7 @@ xfs_filestream_pick_ag(
>  	struct xfs_perag	*pag;
>  	struct xfs_perag	*max_pag = NULL;
>  	xfs_extlen_t		minlen = *longest;
> -	xfs_extlen_t		free = 0, minfree, maxfree = 0;
> +	xfs_extlen_t		minfree, maxfree = 0;
>  	xfs_agnumber_t		agno;
>  	bool			first_pass = true;
>  	int			err;
> @@ -107,7 +107,6 @@ xfs_filestream_pick_ag(
>  			     !(flags & XFS_PICK_USERDATA) ||
>  			     (flags & XFS_PICK_LOWSPACE))) {
>  				/* Break out, retaining the reference on the AG. */
> -				free = pag->pagf_freeblks;
>  				break;
>  			}
>  		}
> @@ -150,23 +149,25 @@ xfs_filestream_pick_ag(
>  		 * grab.
>  		 */
>  		if (!max_pag) {
> -			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
> +			for_each_perag_wrap(args->mp, 0, start_agno, pag) {
> +				max_pag = pag;
>  				break;
> -			atomic_inc(&args->pag->pagf_fstrms);
> -			*longest = 0;
> -		} else {
> -			pag = max_pag;
> -			free = maxfree;
> -			atomic_inc(&pag->pagf_fstrms);
> +			}
> +
> +			/* Bail if there are no AGs at all to select from. */
> +			if (!max_pag)
> +				return -ENOSPC;
>  		}
> +
> +		pag = max_pag;
> +		atomic_inc(&pag->pagf_fstrms);
>  	} else if (max_pag) {
>  		xfs_perag_rele(max_pag);
>  	}
>  
> -	trace_xfs_filestream_pick(pag, pino, free);
> +	trace_xfs_filestream_pick(pag, pino);
>  	args->pag = pag;
>  	return 0;
> -
>  }
>  
>  static struct xfs_inode *
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index ee9f0b1f548d..fcb2bad4f76e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -691,8 +691,8 @@ DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
>  DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
>  
>  TRACE_EVENT(xfs_filestream_pick,
> -	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino, xfs_extlen_t free),
> -	TP_ARGS(pag, ino, free),
> +	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino),
> +	TP_ARGS(pag, ino),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> @@ -703,14 +703,9 @@ TRACE_EVENT(xfs_filestream_pick,
>  	TP_fast_assign(
>  		__entry->dev = pag->pag_mount->m_super->s_dev;
>  		__entry->ino = ino;
> -		if (pag) {
> -			__entry->agno = pag->pag_agno;
> -			__entry->streams = atomic_read(&pag->pagf_fstrms);
> -		} else {
> -			__entry->agno = NULLAGNUMBER;
> -			__entry->streams = 0;
> -		}
> -		__entry->free = free;
> +		__entry->agno = pag->pag_agno;
> +		__entry->streams = atomic_read(&pag->pagf_fstrms);
> +		__entry->free = pag->pagf_freeblks;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d free %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -- 
> 2.45.2
> 
> 
