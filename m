Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4424F33D6F0;
	Wed, 14 Oct 2026 08:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966359; cv=none; b=Hlia471pNx+xFZ1eh88QKbd6LUIOmpR6R/to52EX20ZTA+uN5mlIfv7eVxz8c51rBhWLJY74g+xL+Y3LFkbhXzz25BAA0rw7uhgiILsx2PIkhCKySmAUx7V76jBQdPq2udY+OuFDS78IdevDVoUWqPLo0FbPrkoXcIW9XTr7S8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966359; c=relaxed/simple;
	bh=pRjUQmX5fgxdggDGPVnjqIoX7rvR4GtuVghx7SmOJwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ul59AND9L2mD834guuncZw9igcGTpzQ30PVk47ORf3jVgsSuj0u82I45NrrbuK5bbY8U3Pop5vbosxXDX1P1CVJx1HwlKy+/0weoU1YOEyUy2EA9gxzrMP9taDTG7DdKExmNcKvGP7xb1p530OqCTPrGCbI8AuNoOpVmlG3pQ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HztVtRGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HztVtRGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC061F000FF;
	Wed, 14 Oct 2026 08:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791966357;
	bh=09DAzaX4Fuwb3+q7JqnXIJERvX0WipHFdF2tSk1f5PQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HztVtRGRSkW14xPT57UXWv1t8tHSSvSovydaOYLHlXnyh8KB/GRhlbB9yOzmRHaIM
	 Y7Nlec/09F/zk7iskEkoPCwUIYQjtGVyCxVmVDhFhoGEJVAvplcLlojv3L6qxLdcH9
	 FNOmS5A3lWtq8o9WxNBql4DUlKHJLNmTm5d2bFsiMBgLRG3Qa2Un7hFiRtvNpRCKft
	 b99E0jtabF9MErkfAb6ORDhYdNEz7fMQPUAcb8qfObYVKKibt9KGoeVGz3IfTgc0K2
	 fjJ94ODnjuirzMHX30X+3zDv6EVpc1+yDrLr9yKcpXehtNiGH68U2ih+TaZNIdo1Y4
	 fehOy4h2F2LvQ==
Date: Wed, 14 Oct 2026 10:25:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: only written file data blocks can be shared
Message-ID: <as83KAiPFgW0ZCSF@nidhogg.toxiclabs.cc>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
 <179186107268.1898400.2017479521256451856.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179186107268.1898400.2017479521256451856.stgit@frogsfrogsfrogs>

On Mon, Oct 12, 2026 at 11:06:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
> will count any rmap owner towards the shared count.  However, the only
> blocks that can be shared between xfs files are written file data
> blocks; and the only blocks that can have single-refcount entries are
> COW staging extents.  Fix the checking code.
> 
> Cc: <stable@vger.kernel.org> # v4.16
> Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs

This patch conflicts with Eric's:

1d55a102780 xfs: re-use refcount scrub/repair code for rtrefcount

I'm just stripping off the rtrefcountbt part of this, the final result
is here:

commit 634b63baf05062988456a0bd5df2696c14ea2949
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Mon Oct 12 23:06:46 2026 -0700

    xfs: only written file data blocks can be shared



> ---
>  fs/xfs/scrub/refcount.c   |   12 ++++++++++++
>  fs/xfs/scrub/rtrefcount.c |   12 ++++++++++++
>  2 files changed, 24 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index f8c51d8fbb3da5..a900d13c9e27c0 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -129,6 +129,18 @@ xchk_refcountbt_rmap_check(
>  		return 0;
>  	}
>  
> +	/*
> +	 * The refcount btree should only have records for written file data
> +	 * blocks or for COW staging blocks.
> +	 */
> +	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
> +	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
> +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
> +			      XFS_RMAP_UNWRITTEN))) {
> +		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
> +		return 0;
> +	}
> +
>  	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
>  		/*
>  		 * The rmap overlaps the refcount record, so we can confirm
> diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
> index 3d916d71a135dc..00da8e98506d63 100644
> --- a/fs/xfs/scrub/rtrefcount.c
> +++ b/fs/xfs/scrub/rtrefcount.c
> @@ -144,6 +144,18 @@ xchk_rtrefcountbt_rmap_check(
>  		return 0;
>  	}
>  
> +	/*
> +	 * The refcount btree should only have records for written file data
> +	 * blocks or for COW staging blocks.
> +	 */
> +	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
> +	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
> +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
> +			      XFS_RMAP_UNWRITTEN))) {
> +		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
> +		return 0;
> +	}
> +
>  	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
>  		/*
>  		 * The rmap overlaps the refcount record, so we can confirm
> 
> 
