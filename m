Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D80201113;
	Fri, 24 Jul 2026 06:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874631; cv=none; b=fTnXloM/KBX36rLzUQTXmJpALsnr8b16CqPHNIcyWnKx9vd4WCt7fxexywtf4RcLC0lzSg73fGG2+DxFoCSsH8k71sRCVz8JxKnH+sQSAZ/LAwAuNHVkxHM5yl5AaFljwPjcLBShi19U5MWUay6Oo7gqkYDhNkDh9jcdAHQoo5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874631; c=relaxed/simple;
	bh=pIaHSD7ygJPxsyh+FcChK3+DCvczPYjlZ8K76IPRqE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCx7Er/uXQQhLgXRA3Jr8yjD9DNmBPWtpCIL0VfWXIhr67DYp48J5rkn1Km2GbWabj1oUrsuDViDKbjh6M4DpJMNE9mPhOVXQXvEfpUGq3wt2AC9MTrhzh5F7Um3G+DfE0qerW88Ze8VkIrlUrrCiwURbIFbnguFKkfSMj77T0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9GQQvzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9GQQvzc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D3081F000E9;
	Fri, 24 Jul 2026 06:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784874629;
	bh=zC/EoX5KRllmn6rSEMxaoQlkg9/jDlUIWEZVadxbSoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D9GQQvzcriQTHiPBKvlqgMjpSVjRZRcvMpSgTCG3WhVvMmbb+MLNrAvWlUQHVF776
	 vbf23N5TSd797DRb9PLFYTbfKWYRHIL7w3Q2XhYMCpz9A/aNDH0E4PpGM2VwkBh9La
	 CCRomqO6yTm5PHcc2RLP2xuaaZJ+lz0GFED/8yfv7zuupSBa5lFQolp9BEGwOksVOs
	 uardDqYNvE4pT2ITLWCCzeXaIVz1g2/V6zdj/5V1+5TADyOABadhMgr1JE5XUY7/se
	 McqtFFxUi5cKr7wa/RAYVOtME0uccuyagYftQe8jncZd8fMGz7JMvundX5cRiNllT2
	 og+ZkFbIvT4vA==
Date: Thu, 23 Jul 2026 23:30:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: fix another iunlink infinite loop bug in online
 fsck
Message-ID: <20260724063028.GN2901224@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
 <178460419658.830862.2707474521987278261.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419658.830862.2707474521987278261.stgit@frogsfrogsfrogs>

On Mon, Jul 20, 2026 at 08:26:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xrep_iunlink_resolve_bucket is supposed to reconstruct as much of the
> incore prev and next unlinked list pointers based on what it finds on
> disk and in memory before we move on to relinking the truly lost inodes
> back into the unlinked list.  However, it's still vulnerable to infinite
> loops that come in via the next_unlinked pointers.
> 
> Fix this problem by checking iunlink_bmp, which at that point in
> execution represents truly unlinked inodes that haven't yet been
> processed.  If a bit is already unset, either this is a loop or the
> inode has nonzero link count.  We'll deal with the second case in a
> subsequent patch.
> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/trace.h           |    1 +
>  fs/xfs/scrub/agheader_repair.c |   10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 00fbe1b9c2354f..14aa0ec1f09e4a 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -3538,6 +3538,7 @@ DEFINE_EVENT(xrep_iunlink_resolve_class, name, \
>  	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket, \
>  		 xfs_agino_t prev_agino, xfs_agino_t next_agino), \
>  	TP_ARGS(pag, bucket, prev_agino, next_agino))
> +DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_infinite_loop);
>  DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_uncached);
>  DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
>  DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index edd406a97b7ce9..da2265678d17f5 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1355,6 +1355,8 @@ xrep_iunlink_resolve_bucket(
>  	int			error = 0;
>  
>  	while (next_agino != NULLAGINO) {
> +		unsigned int len = 1;
> +
>  		if (xchk_should_terminate(ragi->sc, &error))
>  			return error;
>  
> @@ -1417,6 +1419,14 @@ xrep_iunlink_resolve_bucket(
>  			continue;
>  		}
>  
> +		/* Inode already seen?  We're stuck in a loop */
> +		if (!xagino_bitmap_test(&ragi->iunlink_bmp, next_agino, &len)) {

Hmm.  Having given this patch a little more thought, I think
xrep_iunlink_resolve_bucket should have its own "seen inode" bitmap
for inodes that it has seen in the loop body rather than trying to reuse
iunlink_bmp for this purpose.

iunlink_bmp is created as the bitmap of inodes that have zero nlink,
but once we start fixing the iunlink bucket chains, it becomes the
bitmap of inodes with zero nlink that also aren't reachable in the
ondisk metadata.  The inodes that remain set in iunlink_bmp are the ones
that have to be put back on the list.

Loop detection, OTOH, just needs to know what we've already seen whilst
walking the chian.  That could be nonzero nlink inodes due to corruption
problems or whatever.  So let's make the code easier to understand by
using a separate bitmap like the agheader.c iunlink verifier does.

I'll go fix this patch tomorrow and repost.

--D

> +			trace_xrep_iunlink_resolve_infinite_loop(sc->sa.pag,
> +					bucket, prev_agino, next_agino);
> +			next_agino = NULLAGINO;
> +			break;
> +		}
> +
>  		trace_xrep_iunlink_resolve_ok(sc->sa.pag, bucket, prev_agino,
>  				next_agino);
>  
> 
> 
