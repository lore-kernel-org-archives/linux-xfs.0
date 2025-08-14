Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F74322D78F;
	Thu, 14 Aug 2025 22:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755209784; cv=none; b=ZvH8lCMugfvIalX5cHvUJ5k82tpUn/sEutzbNOzFQHsGBcMdk35LtrBxFrGc3y4pfmtYyqlJVgXhQZOfJD+uwSzfzlny/b1qJn8TQwCRtA4Yk8JrrrMa9oa8jqi3KM8gWiowx0m+B0U5zx7MCQCyT1sTB+Psty3g/MkgtniRnW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755209784; c=relaxed/simple;
	bh=DGKJ0X14A+iJxb1MR4mBNAXUDwjcwcJkSd/Mx2UnfRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkuXMZMNBmxQJwxA7si6SlGbk+soiDyEChE92GtoRJtTb2JzXcEhFUbrjdeFWrh9mNTkJxsSWBREtLYcvXyRjFzCdhvqU7wb/Fs3+YRkT4Nz3FhkwmGXQNP+1Ddhks84XgD0GKrzx2ZvkKBytsiwIF6pqtCE87yIApsCGLN1XhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiF9ttuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiF9ttuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0466C4CEED;
	Thu, 14 Aug 2025 22:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755209783;
	bh=DGKJ0X14A+iJxb1MR4mBNAXUDwjcwcJkSd/Mx2UnfRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PiF9ttuPiNjnDphzPUu26Uj/m0aWRFnQPRl/RUN0AlaOfeot1Ug2brelGPYzTTgpz
	 cz7mLhCU+h19ye/f+oiLOBAJJ+oh09QK2IkQ1MQlpUwBblK4+4YG9abb53uJK/GaUZ
	 I6EaAdKDOE7Ycnm8+7A1Rd2XpokPXl1gVUw8TcVpIum4LSI42pwzd/8N8zIqfxJTD5
	 +2Qo+PIHmWBj4r3p3k5+4GMDdgaQwR6j60JZyikXROSScfyyTCRugvt/ctLFwD5tiW
	 y4ip2CITZ7Wy2oBmi/3WR2f9TE5sXqpVP8yWMggGf+OkcgRk2QGZGA9pH0KeQARLl8
	 1lXyFXdQ6Q0Aw==
Date: Thu, 14 Aug 2025 15:16:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <20250814221623.GT7965@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
 <aIopyOh1TDosDK1m@infradead.org>
 <20250812185459.GB7952@frogsfrogsfrogs>
 <aJwfiw9radbDZq-p@infradead.org>
 <20250813061452.GC7981@frogsfrogsfrogs>
 <aJwvi03EX0LWzXfI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJwvi03EX0LWzXfI@infradead.org>

On Tue, Aug 12, 2025 at 11:24:11PM -0700, Christoph Hellwig wrote:
> On Tue, Aug 12, 2025 at 11:14:52PM -0700, Darrick J. Wong wrote:
> > Yeah... for the other ENOSPC-on-write paths, we kick inodegc, so maybe
> > xfs_zoned_space_reserve (or its caller, more likely) ought to do that
> > too?
> 
> Can you give this a spin?  Still running testing here, but so far
> nothing blew up.

Running inodegc_flush() once doesn't fix it, but doesn't hurt either.

--D

> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> index 1313c55b8cbe..9cd38716fd25 100644
> --- a/fs/xfs/xfs_zone_space_resv.c
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -10,6 +10,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_rtbitmap.h"
> +#include "xfs_icache.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_zone_priv.h"
>  #include "xfs_zones.h"
> @@ -230,6 +231,11 @@ xfs_zoned_space_reserve(
>  
>  	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
>  			flags & XFS_ZR_RESERVED);
> +	if (error == -ENOSPC && !(flags & XFS_ZR_NOWAIT)) {
> +		xfs_inodegc_flush(mp);
> +		error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
> +				flags & XFS_ZR_RESERVED);
> +	}
>  	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
>  		error = xfs_zoned_reserve_extents_greedy(mp, &count_fsb, flags);
>  	if (error)
> 
