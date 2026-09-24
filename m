Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5B148EC9D;
	Thu, 24 Sep 2026 20:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281791; cv=none; b=Df5konhTo+KnShXwMGH+ctjRBB8MgnL5Q6lbRmET9VkWu5Mm8BEytPaND7UT1KwgiZ1h/+/sqc4kH93ZUgFjGSecPmCjw9pC2bdZGotZc0TMd4HydTBO1HBtp6j0Kb4NFNb0yLvh1BvtWjIurR55otB9q0zenCob/6S/hvks+Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281791; c=relaxed/simple;
	bh=YVcQXet+amcUuSTnauf8aYPPaPtno5fCaktlsl8cZcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PfoKaRH4pSCJqMrdM8syRJ94u5vxkFczDIrLdZkhFPzQmJbL7MUvr99B794YSgpG2p/Evx5S7uYCXlibb5pc5/SE/vONZdWuUYEyYVMIXOI88SI2IBedxeCVUjSbnruVx/IAWSOdSTqlvOmUHN1qH1qDnJ06vysTRwfOpekCyHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NdPG0sMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NdPG0sMc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2F6771F00893;
	Thu, 24 Sep 2026 20:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281787;
	bh=O4ao1Vy3Mhec4U7W72ai93OuuL3QZUyU4pVR57mkens=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NdPG0sMcYQ4rjFRFOmRrICDHSk8DiLBRE694iFRW3izUQ+LFnYEaDMDxSrx1Wn0JX
	 Trgbtzamu8MPB/kJXAZl4UC2tNbfDEY7jkLEuOR38UemQTjWaTo3fENMcjRrttvpGo
	 bCGNe/N4U7/PIHxEoicK6NJWl1jyQel4Ff/MFTNfDTtrNvOrNmL7pZ3cdvZgrn7NSq
	 CG9sAIbpbTm5TsIUqqvbK1rIZ4M6y/Vb9mlWL6gDN9e+fKrlZixBpdKVJKRB7q5g5f
	 fzyIKbJelN67/JmPYjfV+vY4p+Co0zOzTeHQo1C9IE1RdZMJzHswLssKercPXzG2g0
	 gQI51Alq82n3g==
Date: Thu, 24 Sep 2026 13:29:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 01/21] block: export fs_bio_integrity_verify
Message-ID: <20260924202946.GZ2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-2-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:33AM +0200, Christoph Hellwig wrote:
> From: Damien Le Moal <dlemoal@kernel.org>
> 
> XFS will need to call this in the iomap_write_ops.read_folio_range
> implementation.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm not the arbiter of exports, but to me this looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/bio-integrity-fs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
> index c8e91ada8ca6..20d0a3d52932 100644
> --- a/block/bio-integrity-fs.c
> +++ b/block/bio-integrity-fs.c
> @@ -74,6 +74,7 @@ int fs_bio_integrity_verify(struct bio *bio, struct bvec_iter *data_iter)
>  		bio_integrity_bytes(bi, data_iter->bi_size >> SECTOR_SHIFT);
>  	return blk_status_to_errno(bio_integrity_verify(bio, data_iter));
>  }
> +EXPORT_SYMBOL_GPL(fs_bio_integrity_verify);
>  
>  static int __init fs_bio_integrity_init(void)
>  {
> -- 
> 2.53.0
> 
> 
