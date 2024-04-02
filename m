Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47F522079
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 12:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712062330; cv=none; b=fOhn8kp082eiRah9WpYUeLyANP6UaVvJfYps/ERO9RQoB2B9av6Dr6gzGRiHyF2nNwoYAyudUoc7XvIdr2rEv2rkwH39XGiD7jxy8Tykzj9mZGA+1anZvIsD15ndp8poWB4XcBV51JxyyaNVvCFdq3b23Fiqo+fzJho9pq40vVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712062330; c=relaxed/simple;
	bh=fPTm8EwrxCKUCKlXtMQ46fsMh23VPD/sF98j59+9tqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4I3Bsg90R9+KjPQZoL73q9gVnsZXGjPprDOQrx80Ufd6TjusvueWABGp165uaTteI+h/MZz380qup5DyLdQEQncAE5D1x09QrM4keTfHkNtpbFnAASYeeEHul5BbRXzK3G0Xr3MAwvz6zSJux/tPvj7aRWg0BdLYvMOQBGu1hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FTLg/Qpb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTLg/Qpb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712062327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=udjv9FB82NBjappNOEsAL426nV2L32B7yhwcIFshiA0=;
	b=FTLg/QpbkEVjYVzNCxfYmLbcjrtBs5/fM9mcM09KKFK9ky0Ek4/bru0tGM2XkUzA3v/4ro
	6RQMNavR9RgHCW1EHll8Tju8sw6DyolIUNx6AySAtvr6abm1Vyex7y7oLg8JCmQCI5FASw
	APHPtOM0KirwA9kYQdh2dm3N1UXPfNw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-4TCrKqbLP4ObfkTJoMVCDw-1; Tue, 02 Apr 2024 08:52:06 -0400
X-MC-Unique: 4TCrKqbLP4ObfkTJoMVCDw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a46852c2239so346864366b.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 05:52:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712062325; x=1712667125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=udjv9FB82NBjappNOEsAL426nV2L32B7yhwcIFshiA0=;
        b=cmA1JSqe5R1z6loBTJpmu15WSl129NPI1AfviAQn3ykt2GEJQLhknd28EMI/LS2r95
         w/ABI2y9TMePzVV1gAZI6gmxtbWMJx0ax2Y1p0P1cWZXDZRetUKXv7TgMmun2xUSVC+z
         VVVfzbGMVL7eNxjuhyzXQVuOZJSXtD82A2xfpX1g8B5gHI7U6Xz6lBnN9sXCP94YRQcI
         +pusptESuBnM36JqQmyhA0X2JnzV/C3l4VOpbZIh+oftMPGj6krhhiHGMXRxdaB9XzCd
         QRa7m5is340WSpWhl6IIPgZxOXbDxFwoCuzBVyAqe5NuTYo08N+hB1+Hpbpsh4T39PEJ
         fzoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSlQQAsO1NsQoMuFT05o4veeCTUSx9FpZH2OkG92+8zTB0afjqzRXyqHaHdTUWyaqXkFy9gRJoFqb6eQeiBLcdG7BKulqvc7nk
X-Gm-Message-State: AOJu0YycE0AgS+geeUR56h4E2M2H8C+TjT69dfqy29vHzQlJ8R2BwwN7
	i6fSurvhSHNwI56sUQHv5XyIALCE7SZWdBWBm3M7cre4rsFOtpE2jiYiOHEqPxZxO3TDQ0woRtd
	yKZtgrG7NBrE1udvx1IoNYLMI9PESw31hnVce4aiKpFi7kho9EjUq2YxI
X-Received: by 2002:a17:907:26ce:b0:a4e:67ca:1040 with SMTP id bp14-20020a17090726ce00b00a4e67ca1040mr5256400ejc.14.1712062324654;
        Tue, 02 Apr 2024 05:52:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5KO71h1979wkCqoKkC7ot0dVk+kkaLg4kpoiFC8fXUDFCkH0e2YdCuNNW7DymBtRtxiSpAQ==
X-Received: by 2002:a17:907:26ce:b0:a4e:67ca:1040 with SMTP id bp14-20020a17090726ce00b00a4e67ca1040mr5256381ejc.14.1712062324120;
        Tue, 02 Apr 2024 05:52:04 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id wr1-20020a170907700100b00a473a0f3384sm6544357ejb.16.2024.04.02.05.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 05:52:03 -0700 (PDT)
Date: Tue, 2 Apr 2024 14:52:03 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 17/29] xfs: only allow the verity iflag for regular files
Message-ID: <rdonyolmknblerpfl37uvt5i5ica3sjoy2kpmdlcue6qb7pauv@myouxj6bfxjb>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868843.1988170.2809557712645656626.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175868843.1988170.2809557712645656626.stgit@frogsfrogsfrogs>

On 2024-03-29 17:40:30, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Only regular files can have fsverity enabled on them, so check this in
> the inode verifier.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index adc457da52ef0..dae0f27d3961b 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -695,6 +695,14 @@ xfs_dinode_verify(
>  	    !xfs_has_rtreflink(mp))
>  		return __this_address;
>  
> +	/* only regular files can have fsverity */
> +	if (flags2 & XFS_DIFLAG2_VERITY) {
> +		if (!xfs_has_verity(mp))
> +			return __this_address;
> +		if ((mode & S_IFMT) != S_IFREG)
> +			return __this_address;
> +	}
> +
>  	/* COW extent size hint validation */
>  	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
>  			mode, flags, flags2);
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

