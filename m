Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5562F5A1F
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 23:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760484436; cv=none; b=b7JcY5Xnfhdf3SIbVSdGXHiew37jeoeHavfiA4SShf6CAQEydv37I6WAzFqChMtTndXS1VDmy4azzQgyCkugkh3T2biurf43PNmaJ1BcZsOeL3OdBvSbKxKuA83TVSwkGkCY+Z7DWxPEAQ2YTjvoIFlX77p0N7vNCbOeWf1UTyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760484436; c=relaxed/simple;
	bh=57qvY2JYZfpFs9NF2JD7zu5bTM8gv0YXshNQmIYlB2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7PWw7ycEQAZ2ywKmFD+Cw6tadk2vFNMgmmok3GpId/QMiW7G6bqwakfUqyjvLuCeUfsRLQVVV7o7DDxgmp2GNanun3yfP6MNGtvUzEYfp4MVpuLJU+PP2ROTn9w0Se1hqQRHo4dsb9tRRnDHBw7m3/TFzToF8Ew/qL3hYet6V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2z3FvtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2z3FvtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE742C116C6;
	Tue, 14 Oct 2025 23:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760484435;
	bh=57qvY2JYZfpFs9NF2JD7zu5bTM8gv0YXshNQmIYlB2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q2z3FvtM4286bUUJgpq7ZaYEsD1p0CoTzr8maRqvFq+Rd3jq9F2vxQ6iZshmsL0Sq
	 hhEbN6dGY8IgAdzADh3jFEXtQn6GhAkKN3fWIVLn5mc/VQVYwWxYimcxNoRgJ1Z1fM
	 JvmPpKwKdATWz6firUngn+OJkLemElG4YcRxFWVwYOt9JnUzU79ksreJWqkwGt9KQT
	 q8Em+JUfj+3MnRQSq/ucIXxHTqUW52x2pnezR2DHqbD85FErFL37wOv5zjkDiXbxaS
	 GM7mc071Z3xRMArlHW83vedhyEzVhj1Lb/J8/3lH3mGOQTCywjOiTqFSNyvNoVSQim
	 cF3fiSRfnB/jw==
Date: Tue, 14 Oct 2025 16:27:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/17] xfs: xfs_qm_dqattach_one is never called with a
 non-NULL *IO_idqpp
Message-ID: <20251014232715.GU6188@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-9-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:09AM +0900, Christoph Hellwig wrote:
> The caller already checks that, so replace the handling of this case with
> an assert that it does not happen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c    | 13 +------------
>  fs/xfs/xfs_trace.h |  1 -
>  2 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 9bd7068b9e5a..80c99ef91edb 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -297,19 +297,8 @@ xfs_qm_dqattach_one(
>  	struct xfs_dquot	*dqp;
>  	int			error;
>  
> +	ASSERT(!*IO_idqpp);
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
> -	error = 0;
> -
> -	/*
> -	 * See if we already have it in the inode itself. IO_idqpp is &i_udquot
> -	 * or &i_gdquot. This made the code look weird, but made the logic a lot
> -	 * simpler.
> -	 */
> -	dqp = *IO_idqpp;
> -	if (dqp) {
> -		trace_xfs_dqattach_found(dqp);
> -		return 0;
> -	}
>  
>  	/*
>  	 * Find the dquot from somewhere. This bumps the reference count of
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index fccc032b3c6c..90582ff7c2cf 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1399,7 +1399,6 @@ DEFINE_DQUOT_EVENT(xfs_dqadjust);
>  DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
>  DEFINE_DQUOT_EVENT(xfs_dqreclaim_busy);
>  DEFINE_DQUOT_EVENT(xfs_dqreclaim_done);
> -DEFINE_DQUOT_EVENT(xfs_dqattach_found);
>  DEFINE_DQUOT_EVENT(xfs_dqattach_get);
>  DEFINE_DQUOT_EVENT(xfs_dqalloc);
>  DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
> -- 
> 2.47.3
> 
> 
