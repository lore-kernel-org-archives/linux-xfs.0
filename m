Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761A352921
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769599847; cv=none; b=MNsn19m3bZQ9ntaPUA+XfokQ8VwU5rA64E+0GWY6PXNr9uPfJj3f9xcUuYHnfdojHN/6zu/1fbVQF3Tv4We+rZoR1vsYexvFdQLxIZfXpEy3QVew47BqRwiUIOLcGaQjqUpkGupe8OdKNUouoUHobtLSXmYOyFOEHhxS52Y13LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769599847; c=relaxed/simple;
	bh=OceKiEqvChuXAsJAqTml1LvEDccXsb8z3R0Eqx824KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lG8cstrd3g0ttycEYm9ZfOMt4CNNfKKWH0QAzf4E4CZdiH5E3RngG6NeOvOL5AAL79DxtcyZtxK43bbFndOSn1Jyu8+7h0VHvZaJdQam0H72HAm8znneHzHFFtIDcmHddWd7vuvkfh+58OujPimQnHnVEvf9cYdaY5gy54h2MPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h2b748dL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h2b748dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673EBC2BC87;
	Wed, 28 Jan 2026 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769599845;
	bh=OceKiEqvChuXAsJAqTml1LvEDccXsb8z3R0Eqx824KA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h2b748dLvbdAaMjbCSzM0PGxsBTdBka8sm8CotsS4pC/UdCC/jwpLxdwLnrjJjfOg
	 4YWpxJTTRI/xphEH3yidOqxRx3rnp0xbwsG/wNBRfKsMw5qxAfYuBUanAkATkbaJ/X
	 r9VcZFTYDisgdmqfwsw32KasCdKruZA+VZgLRZDkTTfaN6qWZNV02ebEERnMozYaDe
	 qv1MnPsaXt1NAtDYVSmk8nt9yjhqgkgE6YtBpONSIzVz1QKUQbL3k+YFt+XKgruTmR
	 9fDR/X3agEb/QZDCDHX1K93nwcwYU2FiCdcGBxXcVpxvrnDnT8rlf1/MZVo5Yl2EsB
	 B0Tqqt9Nk/74Q==
Date: Wed, 28 Jan 2026 12:30:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: don't mark all discard issued by zoned GC as
 sync
Message-ID: <aXnzWKot5VH8XDOf@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-8-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:47PM +0100, Christoph Hellwig wrote:
> Discard are not usually sync when issued from zoned garbage collection,
> so drop the REQ_SYNC flag.
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_gc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 7bdc5043cc1a..60964c926f9f 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -905,7 +905,8 @@ xfs_zone_gc_prepare_reset(
>  	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
>  		if (!bdev_max_discard_sectors(bio->bi_bdev))
>  			return false;
> -		bio->bi_opf = REQ_OP_DISCARD | REQ_SYNC;
> +		bio->bi_opf &= ~REQ_OP_ZONE_RESET;
> +		bio->bi_opf |= REQ_OP_DISCARD;
>  		bio->bi_iter.bi_size =
>  			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
>  	}
> -- 
> 2.47.3
> 
> 
