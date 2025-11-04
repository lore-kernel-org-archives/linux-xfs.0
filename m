Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4464331A7C
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275561; cv=none; b=I4oQ8ApYHU3o1SlySPCEHngvv5xgh+E2pE+2yEI8qWpntg0h12bpfFYEWxlGX2G34B1cEy23b79Nvee39L1f4ttEd+wJveLYdt8bfb9yO7VjpAQNUrwCijkuuTi66p2FFnbCbJnTqePWpRJixlMEd+zNJJmIEENmRQDCEJWjmpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275561; c=relaxed/simple;
	bh=BgeMGJJg+cDFVmmfQeBA83QxORGOUn3CHNmF3dde81c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQZMcKTuUVHUkgfBaoZq2y05N4XNX7auGZz13mO6DwS9LT+J/P4V0p8OMAeCpNd16l8DmKJF0HnZa22fGskuz/65s39C9sr+7HRFYSyV2giDZgskSvoXg0Kvvq0dIOrPP1+8WwmmKG3Nau5Ms6YSH8l9wrClTbOKsTP93t8CIYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNHXXdhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNHXXdhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674D5C4CEF7;
	Tue,  4 Nov 2025 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762275560;
	bh=BgeMGJJg+cDFVmmfQeBA83QxORGOUn3CHNmF3dde81c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mNHXXdhJIYmoShGtr35oE1U8eJvZufxGTQIVHSDlr4byNoQySfahp5yaqrP3+X0hO
	 MDi4qZ8q1wvA0T6t0O75ZrMVyZVfkTWuauYctLoCbz37z+zieD8bo3okP8nPgy2G6A
	 pWHoSYxOsrX9tgyeZzgiBxNBHq+gp3XBsvbLTkBO/t2iq9E8W0HwlV1NGp4ZO5itEu
	 ISHwTm1wh77tyBrA5USMscNCxIuTwuvA0TZRP4+Rt5J3uAxBIvOvBn6atr3lSaIhEc
	 n+J5Vn/rs3BqzB7Up3IjfmyKhSOvYRQF12HSI4YPcXFWbndNJi6oid2xsR0YJt23rw
	 QYFNbxfLTagFw==
Date: Tue, 4 Nov 2025 08:59:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: free xfs_busy_extents structure when no RT extents
 are queued
Message-ID: <20251104165919.GJ196370@frogsfrogsfrogs>
References: <20251104104301.2417171-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104104301.2417171-1-hch@lst.de>

On Tue, Nov 04, 2025 at 05:43:01AM -0500, Christoph Hellwig wrote:
> kmemleak occasionally reports leaking xfs_busy_extents structure
> from xfs_scrub calls after running xfs/528 (but attributed to following
> tests), which seems to be caused by not freeing the xfs_busy_extents
> structure when tr.queued is 0 and xfs_trim_rtgroup_extents breaks out
> of the main loop.  Free the structure in this case.
> 
> Fixes: a3315d11305f ("xfs: use rtgroup busy extent list for FITRIM")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep, this fixes a memory leak.  I wonder if you could combine the two
into:

	if (error || !tr.queued) {
		kfree(tr.extents);
		break;
	}

But I don't care passionately either way.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_discard.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index ee49f20875af..6917de832191 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -726,8 +726,10 @@ xfs_trim_rtgroup_extents(
>  			break;
>  		}
>  
> -		if (!tr.queued)
> +		if (!tr.queued) {
> +			kfree(tr.extents);
>  			break;
> +		}
>  
>  		/*
>  		 * We hand the extent list to the discard function here so the
> -- 
> 2.47.3
> 
> 
