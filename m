Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2708E48C408
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790282679; cv=none; b=FQfm+puVsP1UD3Ow236fkgNgdmN1CLCRYZrhj/vpcc9nsH14w4oGNH+2ODk1I5yhHNH1guWChobKbUsd0r0Ch0AQrC0aVLqZ8l9ANFjT6LBDMohy/JwT5evwRvzpA6XH5t/6leHpOVdIobznBVNygp6jeaq2oQbWeVc2IGC3ZD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790282679; c=relaxed/simple;
	bh=QRfO/qzgvQx1CY2DMQEnnTzDbsQrZ5dNDbt97tsafeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRh24G04h6X5PUDtmZM6cDsll/HaouNsbYTf+oqPSI0ws4OlgvDaUWrztSZwj/8DFV2f10EO+jJIYshQZKc1pCH6tjfg2n7Vr5DjiLNg/7gZ5ngQz3X+5lt9Qb+4jrLP9AArHRImHRRXorm8VuyAqRRrbmKVp8Y98o80okHbM7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUmIzUdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUmIzUdr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 994C51F000FF;
	Thu, 24 Sep 2026 20:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790282677;
	bh=xYdBFdiDfbmHApAhiFbwsgRfXhHQ8FMcp/Q0YoWEavc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fUmIzUdrvwvqCjpEpd9C4YPzK7yWx4u4svM61N1ON/Cb2EBlv7tdeEoLgMF1jiGZi
	 jniC2YwLQu0xTchUbnYgkvG7eynmsc5zYnr7chbgnW41EbCdIMev23WZj31e7MvsZY
	 oPkkm9Qh9qd4gd6f98MA0jcrOUn4E0Wdkvi1Kpfz30RNGGN9ZXqAc847KD9C9giEEF
	 cajgNPMTEyy/Hbva55ceZJOLT5w9prl9PGPprXkrdQLkVCXvmMSm0nxlTP5F5p/fUA
	 9m/t/PglN0mOFWDvfRN8ZWbjBGV8/3YpxVDUGNwdvIoSLdCh1Y/Yw9nafK8WXZNtUu
	 1nV1QzxX2I5TQ==
Date: Thu, 24 Sep 2026 13:44:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/32] libxfs: add DIV_ROUND_UP_ULL
Message-ID: <20260924204437.GC2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-5-hch@lst.de>

On Thu, Sep 24, 2026 at 12:03:54PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/xfs_platform.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
> index d09fb0aae00f..a61d50de9dc0 100644
> --- a/libxfs/xfs_platform.h
> +++ b/libxfs/xfs_platform.h
> @@ -212,6 +212,7 @@ void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
>  #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
>  #define round_down(x, y) ((x) & ~__round_mask(x, y))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> +#define DIV_ROUND_UP_ULL(n,d) DIV_ROUND_UP(n,d)

Er... shouldn't there be some sort of u64 cast here?

--D

>  
>  /*
>   * Handling for kernel bitmap types.
> -- 
> 2.53.0
> 
> 
