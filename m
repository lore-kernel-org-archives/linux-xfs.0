Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B7A1A3AB7
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 12:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727179591; cv=none; b=F5iKZgNM/VfErArK35k5FfNbf/CCok5+wKmX8rtaYrrooqgCbnHWS87RP+VifAKovcDsy9cIvAAgEodV5krL4fruRfIJ3z4W8GTh8wKyGRIT2i6SwbLRmIAgxWfDskLCz+NE0ODjRwb5KpTeVBCsdB6k8I6uvSzN0MgB6TM6djs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727179591; c=relaxed/simple;
	bh=ib3yF73dE3TpgrNCDdCu3js9TlsbdZHGkB+vOwYRBE0=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=H0l9EMQMyEQAKdoCGzo7EzzFD+viq5Zz+W1G7tm591wDnsNEWjWcWLHVOk2D/cQ7Pdln0kRYn7sSJCt/KlZOL5m/U6DuK7dXkEFeYY8FjEOUlM3676jIImkLkOcAYIAJKuOHyLTfbt+++G5yHI3rgCXBwdfL04IgX0FlylSkvzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8Nq1S5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8Nq1S5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A8FC4CEC4;
	Tue, 24 Sep 2024 12:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727179590;
	bh=ib3yF73dE3TpgrNCDdCu3js9TlsbdZHGkB+vOwYRBE0=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=t8Nq1S5MnH/lasv3WGT6DieK2ayLA7/H206vjSZ56+EuqUc+VdjyILzMJKYXTEZEq
	 HjMnZ+Zay3mRY6Ol82msocmrkUh1xWx+Pb+rFGU5OORUvJJx63EX3QpqcQYzdSKkvd
	 gtrpd4tIKMyw4jiYYZLD1wfWUR0guHk3eclmlYQdBYcnnJ+PMjUdhAvPfE67INnhqX
	 QT6VuUIhRbceSD567JvEFjBB+C4UYAs4b86+YPuV+Nx9jyfRD93anrW+IxshuLhu0Q
	 aPSLMf0x3ecqsvCrwdb3gaP0lSEoA+lNBVY065aFIgIjSOh3DiPgnypUQPXw/Cm2kt
	 xVOU+Ik57vyXA==
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
 <20240906211136.70391-3-catherine.hoang@oracle.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 CANDIDATE 02/22] xfs: fix
 xfs_bmap_add_extent_delay_real for partial conversions
Date: Tue, 24 Sep 2024 13:15:53 +0530
In-reply-to: <20240906211136.70391-3-catherine.hoang@oracle.com>
Message-ID: <874j658ddn.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Sep 06, 2024 at 02:11:16 PM -0700, Catherine Hoang wrote:
> From: Christoph Hellwig <hch@lst.de>
>
> commit d69bee6a35d3c5e4873b9e164dd1a9711351a97c upstream.
>
> [backport: resolve conflict due to xfs_mod_freecounter refactor]
>
> xfs_bmap_add_extent_delay_real takes parts or all of a delalloc extent
> and converts them to a real extent.  It is written to deal with any
> potential overlap of the to be converted range with the delalloc extent,
> but it turns out that currently only converting the entire extents, or a
> part starting at the beginning is actually exercised, as the only caller
> always tries to convert the entire delalloc extent, and either succeeds
> or at least progresses partially from the start.
>
> If it only converts a tiny part of a delalloc extent, the indirect block
> calculation for the new delalloc extent (da_new) might be equivalent to that
> of the existing delalloc extent (da_old).  If this extent conversion now
> requires allocating an indirect block that gets accounted into da_new,
> leading to the assert that da_new must be smaller or equal to da_new
> unless we split the extent to trigger.
>
> Except for the assert that case is actually handled by just trying to
> allocate more space, as that already handled for the split case (which
> currently can't be reached at all), so just reusing it should be fine.
> Except that without dipping into the reserved block pool that would make
> it a bit too easy to trigger a fs shutdown due to ENOSPC.  So in addition
> to adjusting the assert, also dip into the reserved block pool.
>
> Note that I could only reproduce the assert with a change to only convert
> the actually asked range instead of the full delalloc extent from
> xfs_bmapi_write.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 97f575e21f86..0ac533a18065 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1549,6 +1549,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
> @@ -1578,6 +1579,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -1611,6 +1613,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
> @@ -1643,6 +1646,7 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			}
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
> @@ -1680,6 +1684,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING:
> @@ -1767,6 +1772,7 @@ xfs_bmap_add_extent_delay_real(
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
>  		xfs_iext_next(ifp, &bma->icur);
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_RIGHT_FILLING:
> @@ -1814,6 +1820,7 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_blockcount = temp;
>  		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
>  		xfs_iext_next(ifp, &bma->icur);
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case 0:
> @@ -1934,11 +1941,9 @@ xfs_bmap_add_extent_delay_real(
>  	}
>  
>  	/* adjust for changes in reserved delayed indirect blocks */
> -	if (da_new != da_old) {
> -		ASSERT(state == 0 || da_new < da_old);
> +	if (da_new != da_old)
>  		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
>  				false);

I think we need to allow space to be allocated from the reservation pool when
da_new > da_old. Hence, the last argument to xfs_mod_fdblocks() should
probably be true.

> -	}
>  
>  	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
>  done:


-- 
Chandan
