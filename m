Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC81F78E6
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179946; cv=none; b=r7mi39F4+pE5N2Y56T2jen3sy4ItLSJrT/ViXxNvcUN1l68/+hPXKVDmWM4099ZaIZohxiaBUqE0NwEqW/05FvjN+SbF3Y55MzHbTzryLDsM3ORO/BxjKJKdHub83R5vFgmKPePxWDbfxvL6HUR5ZtfHfwRfsYqIfXnNb/steoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179946; c=relaxed/simple;
	bh=Y1cLcdEKMFsZVPsM0SrZBMrRcTtCoK5nuOXWObP+rAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ab0NR6VRfx31Ld5NcjxTGFuMxFGxpE9aL3m6E+OET3erF+/vdQSDp1lT+bOk1LJFKyuD0Wp+nBC7otiL4EqgIZwgqHbia2ItImXASrqcTfKVRm/tsti9oqUEObRf4th+kZRE0D02AookioY1urhkqaJr7FZCisKs4Vg/iRai2FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvxvNjpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvxvNjpI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 43ECF1F000C4;
	Fri, 16 Oct 2026 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179945;
	bh=hFvTDxqOkpyHVeZnosza19VfO5iHgrte91msmCWnrjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IvxvNjpIb8kdy8qoBnzK9yOYxjxxZ6IlFk8i1f4muOxGNZvzA5+NAevNbZ0K7lbQO
	 Jtl/lBWgHRVoubbIzI+s9HNcLSC+zibcJnXCPnabjoq+wIyC3B0Dip+7hM6shSUioA
	 uxTk4o6ZVU/sYxrz1HYzQOaRIV/ZLqxHuu8f1FT5By4YnpWeXzY38edwSYqLgBg4H3
	 AmXGDtESDg3iCiVSvhgnDOh60ACmm5/tNSgZJRw10R+X24fdiuFdwJqQZrXDs1w4RX
	 v70wc6NqKwZr2qlobZWrpAHBbOMZcHagYv5DQNxxwh8qYnBU1XwdiJfsarMehf+DGs
	 ENZBhoeTBJ5MA==
Date: Fri, 16 Oct 2026 12:45:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 3/8] xfs: remove redundant stat checks after
 xfs_inobt_insert_rec()
Message-ID: <20261016194544.GE107986@frogsfrogsfrogs>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-4-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-4-sandeen@redhat.com>

On Fri, Oct 16, 2026 at 02:29:03PM -0500, Eric Sandeen wrote:
> xfs_inobt_insert_rec() simply returns the error and status from
> xfs_btree_insert, which has already validated the insert or returned
> an error.
> 
> This makes every instance of the 2nd test in this idiom:
> 
>         if ((error = xfs_inobt_insert_rec(cnt_cur, &i)))
>                 return error;
>         if (XFS_IS_CORRUPT(mp, i != 1)) {
>                 xfs_btree_mark_sick(cnt_cur);
>                 return -EFSCORRUPTED;
>         }
> 
> unnecessary/unreachable code. Remove them.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index bb6e684f5467..fd916a2a005b 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -236,7 +236,6 @@ xfs_inobt_insert(
>  			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>  			return error;
>  		}
> -		ASSERT(i == 1);
>  	}
>  
>  	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> @@ -572,12 +571,6 @@ xfs_inobt_insert_sprec(
>  					     nrec->ir_free, &i);
>  		if (error)
>  			goto error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto error;
> -		}
> -
>  		goto out;
>  	}
>  
> @@ -647,7 +640,6 @@ xfs_finobt_insert_sprec(
>  	struct xfs_buf			*agbp,
>  	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new rec. */
>  {
> -	struct xfs_mount		*mp = pag_mount(pag);
>  	struct xfs_btree_cur		*cur;
>  	int				error;
>  	int				i;
> @@ -665,11 +657,6 @@ xfs_finobt_insert_sprec(
>  					     nrec->ir_free, &i);
>  		if (error)
>  			goto error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto error;
> -		}
>  	} else {
>  		error = xfs_inobt_update(cur, nrec);
>  		if (error)
> @@ -2254,8 +2241,6 @@ xfs_difree_finobt(
>  					     ibtrec->ir_free, &i);
>  		if (error)
>  			goto error;
> -		ASSERT(i == 1);
> -
>  		goto out;
>  	}
>  
> -- 
> 2.55.0
> 
> 
