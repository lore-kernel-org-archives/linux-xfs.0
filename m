Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B15C285C8B
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 06:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761200486; cv=none; b=roq0R/3q380E+Q6TjWLdPd/uRReHZK0PLlmFZWAE7B08KeoDASbAvcwPxrJsRES7N6U8F7QfvKOqIg1pEclD/6oC4d5ydjfkvIWFsrL0/Bn0XqX2Tq5ZqdNYzu7st1teqd3J3nf2OO/yOcOiYzNAH2rWL09WUJs9z3D/XQB8mV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761200486; c=relaxed/simple;
	bh=rsii62TFPT7PmC+eKNC6bbkG3tVbpx1ZiWCB5Gpm4hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U64p+uAF1nwKl4fVtGNUIiZBrG3vSbY88101bboHUYQlp+qKUlG66d5LWU4edHr/Gv43V1Baw4ds8px+gunMKuIOjrT85rrIlRjij37kvCYu+HiEEmBv4eCB+itnve1PeN9Vefx8INe9u4Fbxqnv2p/zsLe1DmREI9zE6EnUuwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4+MkW65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4+MkW65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E538C4CEE7;
	Thu, 23 Oct 2025 06:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761200485;
	bh=rsii62TFPT7PmC+eKNC6bbkG3tVbpx1ZiWCB5Gpm4hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H4+MkW65MYdspScMG9W2hALSbbbBb1P7S/OO/wyjuIEQx8Jn8OOVeVI5LcMHcRHC8
	 LyYqTzML3+hSh1UlWqXBWFCkqNqB0V/sgST4BpB2x8oBonGFESmR06bUDZCM+H0DK3
	 TAPisxYAT+FuDVUCtNSPY3HjjjriYAifdk1w+n5MqafQf+2A4otojHTH5uHKGrUfmD
	 6wP+7DninMT2y2OA/I/NJBhsYIkjdtNWDtXB2UJGBJ8uojPCdD3NQvWssbPNWxJSZs
	 m9mhaf1T7t9NxaDrIToZq97H95az5iAny8CAIawKPVTcSa3uIhbVJ3ubW1CZV8K8og
	 ZxNa8Rdhi8uEA==
Date: Wed, 22 Oct 2025 23:21:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: document another racy GC case in
 xfs_zoned_map_extent
Message-ID: <20251023062125.GQ3356773@frogsfrogsfrogs>
References: <20251017060710.696868-1-hch@lst.de>
 <20251017060710.696868-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017060710.696868-3-hch@lst.de>

On Fri, Oct 17, 2025 at 08:07:03AM +0200, Christoph Hellwig wrote:
> Besides blocks being invalidated, there is another case when the original
> mapping could have changed between querying the rmap for GC and calling
> xfs_zoned_map_extent.  Document it there as it took us quite some time
> to figure out what is going on while developing the multiple-GC
> protection fix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_alloc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index e7e439918f6d..2790001ee0f1 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -246,6 +246,14 @@ xfs_zoned_map_extent(
>  	 * If a data write raced with this GC write, keep the existing data in
>  	 * the data fork, mark our newly written GC extent as reclaimable, then
>  	 * move on to the next extent.
> +	 *
> +	 * Note that this can also happen when racing with operations that do
> +	 * not actually invalidate the data, but just move it to a different
> +	 * inode (XFS_IOC_EXCHANGE_RANGE), or to a different offset inside the
> +	 * inode (FALLOC_FL_COLLAPSE_RANGE / FALLOC_FL_INSERT_RANGE).  If the

Or (eventually) this will also be possible if zonegc races with a plain
remapping via FICLONERANGE, right?

(Like, whenever reflink gets implemented)

I guess the zonegc write completion could just iterate the rtrmapbt for
records that overlap the old extent and remap them until there are no
rtrmapbt entries returned.  Then you'd be able to catch the
exchange-range and reflink cases, right?

(Not asking for a reflink-aware zonegc right this second, just checking
my understanding.)

If the answers to both questions are yes then I've grokked this well
enough to say
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	 * data was just moved around, GC fails to free the zone, but the zone
> +	 * becomes a GC candidate again as soon as all previous GC I/O has
> +	 * finished and these blocks will be moved out eventually.
>  	 */
>  	if (old_startblock != NULLFSBLOCK &&
>  	    old_startblock != data.br_startblock)
> -- 
> 2.47.3
> 
> 
