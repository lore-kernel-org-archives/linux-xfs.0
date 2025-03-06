Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF841DC98B
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 07:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741246158; cv=none; b=ZN8OSFo15U89HNxTqhs4OurlO7yqZmziBuPjQEYGwNFeQCga3HKIsmjuJ/PomW2NmiFaTG0B+QFDY0mtNYaOWJSt6y00dglit7Npn9WWGUBSvFGDRQeE/kYL/0OCrxZYf3JFaljQ0LaoAfhCEsd3gO0E5x3TwwiK9/sjosekvWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741246158; c=relaxed/simple;
	bh=BQ6VD5DAh6M5CxqXPOV3e1mg0SI7rmgAspuauTvxxZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7tPPw31wpNZBynOJUC5iEczRNrRn2dqXWd/bjkSUD7DlAt8qd4o9J0uPraJGM/hBi+DZBlvzkS33YoUg1Wq8mto0L1C/XvI6MtlFqZNajIbFtFzHOiV7Q43V37tmntIrJ0v0YEXrdR6FoMMGJ51HMdtBculBIproCRJlaZP0kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bN799kMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bN799kMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0F3C4CEE4;
	Thu,  6 Mar 2025 07:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741246158;
	bh=BQ6VD5DAh6M5CxqXPOV3e1mg0SI7rmgAspuauTvxxZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bN799kMC9xYnV1QIOuZpcDmI7MtWKxWwZOuyJrtJtKGagJc2U7Y4h+R/Qt6g5h5tG
	 FHrN1n69O8wuETnQB1Etk6oIYt1KBvtwfqzxuBNUIi2LTYV2wKwWarMpbRxS1Od3Fi
	 6d4349WugPk/74vOAUPtxVrj0h52M/43ctMgz3kjLERzXR1yUSdv3iv3F7LwmXUE8l
	 rmaW8jNPVFPR7f8Tv5H8DmqaerfFsWSeDtzEoL4QkqBTTRfANulSnvrR1+NRGa6Mds
	 jB1J5NnVznWZUXhAFO7Q0OmzMrztRJaMJ5kQzeCdx2U5KJiwK3lEZ3+Rpesjco1rXy
	 ABK2fRObi3vMg==
Date: Thu, 6 Mar 2025 08:29:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use abs_diff instead of XFS_ABSDIFF
Message-ID: <2xlkbwy2t66ybmo5gjio7pxchovmvvfp5cdttnvy2jnksp6zau@aa2luzbtesvf>
References: <bYNAZb1AYBMnSX2WjwzxlEtG-CSnpls-tn4L3TzS12FWuq2epxg6oMdtXM3Otq9nSX-dJZLoI6xou25ArMpSJg==@protonmail.internalid>
 <20250303180234.3305018-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303180234.3305018-1-willy@infradead.org>

On Mon, Mar 03, 2025 at 06:02:32PM +0000, Matthew Wilcox (Oracle) wrote:
> We have a central definition for this function since 2023, used by
> a number of different parts of the kernel.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>


Looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3d33e17f2e5c..7839efe050bf 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -33,8 +33,6 @@ struct kmem_cache	*xfs_extfree_item_cache;
> 
>  struct workqueue_struct *xfs_alloc_wq;
> 
> -#define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
> -
>  #define	XFSA_FIXUP_BNO_OK	1
>  #define	XFSA_FIXUP_CNT_OK	2
> 
> @@ -410,8 +408,8 @@ xfs_alloc_compute_diff(
>  		if (newbno1 != NULLAGBLOCK && newbno2 != NULLAGBLOCK) {
>  			if (newlen1 < newlen2 ||
>  			    (newlen1 == newlen2 &&
> -			     XFS_ABSDIFF(newbno1, wantbno) >
> -			     XFS_ABSDIFF(newbno2, wantbno)))
> +			     abs_diff(newbno1, wantbno) >
> +			     abs_diff(newbno2, wantbno)))
>  				newbno1 = newbno2;
>  		} else if (newbno2 != NULLAGBLOCK)
>  			newbno1 = newbno2;
> @@ -427,7 +425,7 @@ xfs_alloc_compute_diff(
>  	} else
>  		newbno1 = freeend - wantlen;
>  	*newbnop = newbno1;
> -	return newbno1 == NULLAGBLOCK ? 0 : XFS_ABSDIFF(newbno1, wantbno);
> +	return newbno1 == NULLAGBLOCK ? 0 : abs_diff(newbno1, wantbno);
>  }
> 
>  /*
> --
> 2.47.2
> 
> 
