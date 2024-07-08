Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D642FAD55
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720459460; cv=none; b=ntBYwJjEEjy7d5PfdTV89efjJaJH/PVXZWBwMulZp7NUapguXRCZCDLE2wJjH8GllvlRS83P4HW17SehYuc1BC7J7k4LtFhKB2HgIlFChqOcp6wqoyffkBQAt+SUA/zmwcMK0zUB2FVjH7aidmIhqhJ04ppSUYhLsl/cD62mlU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720459460; c=relaxed/simple;
	bh=3I9FMgbDn8Bv/UScplOZwFzNRhJs8ZPO61ZAN+4xpSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYla7tevV5g/s33dhzy5p0eMXykD3mf+StFAAkPoBpLdoXP+uz5XONNB4sN8cQTfZp//zmkr1IWIc3BCDty/5hXrbgKIFvpVTMqxOQxCGGO4rwbHeIURKErCsDz+rf2Xg/9FTpiSJ2VLfleKB/dj6vghXemRgKbarzdSDiJURZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CX6eoLZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CX6eoLZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C601C32786;
	Mon,  8 Jul 2024 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720459460;
	bh=3I9FMgbDn8Bv/UScplOZwFzNRhJs8ZPO61ZAN+4xpSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CX6eoLZrZ/3go7jalAYERRw7KjEqdf5G1yGMiHkYinzKAbEzz1g6wyIQ+4n8yaQpJ
	 xNnBFEkQ7zOAiKEzEHIKNLy7AKDxa8ifQd8bA7oksGfz3h9zkQ1L+ROybseIW35r7R
	 pSFRu439w5Ogu3xNfyOwNM8d2LMI8H4g6/HsdaQ9xZyOGxu9Y9VYCKBtoqmzAlRvBZ
	 nlzMfE3HzrfFmwo82yyhBGIAwCocMcoRznhwL3vHVwm6gqsWSWcvK/gQFzrVn2PL1l
	 Vnr8hU1UlnlkaBnAndpntCNpYk2WF6U3+zbZizTNLh6wdAMjEx34ujfs76J82amYr8
	 t5C9EdOnC2TUA==
Date: Mon, 8 Jul 2024 10:24:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix rtalloc rotoring when delalloc is in use
Message-ID: <20240708172419.GL612460@frogsfrogsfrogs>
References: <20240708120257.2760160-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708120257.2760160-1-hch@lst.de>

On Mon, Jul 08, 2024 at 02:02:57PM +0200, Christoph Hellwig wrote:
> If we're trying to allocate real space for a delalloc reservation at
> offset 0, we should use the rotor to spread files across the rt volume.
> 
> Switch the rtalloc to use the XFS_ALLOC_INITIAL_USER_DATA flag that
> is set for any write at startoff to make it match the behavior for
> the main data device.
> 
> Based on a patch from Darrick J. Wong.
> 
> Fixes: 6a94b1acda7e ("xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1)")
> Repored-by: Darrick J. Wong <djwong@kernel.org>

  Reported-by:

> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 5a7ddfed1bb855..0c3e96c621a672 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -12,6 +12,7 @@
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_bmap_util.h"
> @@ -1382,7 +1383,7 @@ xfs_bmap_rtalloc(
>  		start = 0;
>  	} else if (xfs_bmap_adjacent(ap)) {
>  		start = xfs_rtb_to_rtx(mp, ap->blkno);
> -	} else if (ap->eof && ap->offset == 0) {
> +	} else if (ap->datatype & XFS_ALLOC_INITIAL_USER_DATA) {
>  		/*
>  		 * If it's an allocation to an empty file at offset 0, pick an
>  		 * extent that will space things out in the rt area.
> -- 
> 2.43.0
> 
> 
