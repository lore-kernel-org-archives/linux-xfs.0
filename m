Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A87369D5C
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790379233; cv=none; b=iYOEN/zAv9bnq1ATbeeiQMd9Wcc4xfIrfDgQvZMA/Y314hwbtDtEm6IuHAOWsB+w0OZx0mmtrXL68cXShvLjCoNlsLy0snNdtqG/dooZmhRt6DY7OYNRodw+Pf96dsw1syUb5X8gSkGSIBK581/bcQLFqYA09WP6io5sxJbfuT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790379233; c=relaxed/simple;
	bh=FmpHw+UbTwSCUhwk3LqWTt+H4GMzYeiEsyt08y1iX4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEbov1qRyTvpkTcwOHDcbtNwxlKIjPU4QIO8Z0fSYq56qz2KoH851jjjDp99KiJUXxFpR8GieRqXaHA+jbTX1eE1ptzBf4o/n4ihN1cRMuMghEusXor2ciZRcgbUgIONhoDOcuFw90XKxvq3HJcM6lTjp7iB50Kt0xUKMsmdwcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVPUohC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVPUohC6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 074701F000FF;
	Fri, 25 Sep 2026 23:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790379232;
	bh=ji4Sw5KV7VfSr1nEJtwNWJt82d4EbVauGZXZqv8ZKKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jVPUohC6WtJfHl8qaSeyLsPMQzfNsHAVDRm3Sw5YvNJLtFSxMTHpTSYwLXSZaGBfq
	 kUWzlkuNRCvSqieHr2+sJMIugMLpXKiUub/UtI1wi3UQSN2Bw4I5ZGO/dh2gAh95bt
	 NwHZMsMwK/bei6NRnpJeZOAqxGaKSqG9d+Rcgp+5PALnvVkLD0Cr1mtiaN13b8U275
	 nv9zI9aFnmRQW50jrNN4UL25OZU6LdH4ir9fSYG1/gsDjjeyZDaM2AX79JOcLAPWwA
	 ieBmrYWnYQ48PqvCuVaItQxi6gVfplPUDshuVlVEejp1eFTEAIyXeKMDq0l7SpETyh
	 cGpfw77FhKnxg==
Date: Fri, 25 Sep 2026 16:33:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/32] xfs_io: report checksum information from fs
 geometry in statfs
Message-ID: <20260925233351.GN2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-29-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-29-hch@lst.de>

On Thu, Sep 24, 2026 at 12:04:18PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine, though I wonder if we should report 1U<<rtcsum_blklog?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  io/stat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io/stat.c b/io/stat.c
> index e3b3574e0416..c6175298631c 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -286,8 +286,8 @@ statfs_f(
>  			printf(_("geom.rgcount = %u\n"), fsgeo.rgcount);
>  			printf(_("geom.rtstart = %llu\n"),
>  				(unsigned long long)fsgeo.rtstart);
> -			printf(_("geom.rtreserved = %llu\n"),
> -				(unsigned long long)fsgeo.rtreserved);
> +			printf(_("geom.rtcsum_type = %u\n"), fsgeo.rtcsum_type);
> +			printf(_("geom.rtcsum_blklog = %u\n"), fsgeo.rtcsum_blklog);
>  		}
>  	}
>  
> -- 
> 2.53.0
> 
> 
