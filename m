Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091E358AC6
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 09:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712051525; cv=none; b=Hc9tPf0YubGYZKqRGFvVoHSITLGyNUqkiSAUVuuzF7bRqgmwsVu8zjHZKKTLbhSbiTlCJduWRE5zcIuUb3IFzmo2fZN4BsKoTw4uRKP11rOMLpdQYo1JRUrMVEG90BKsoEtlqtqTOSa2BiZesA6w4c4yZhjUgiHybw2TsA9KohM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712051525; c=relaxed/simple;
	bh=BuLeAglhQb+OLxYbcXbn2earzV76rOgrs3rntBWRzGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TAE+VVbgip771NA172SknursMeQ6yfiGN3NokjwFWi8OjnVHjK2i3gW8YZXqzK4uUvZ/kPGrEh/bcKdBgcYPeE1dR19IxMg4tzWk7XOCg6PjxwNlXNrIHFTZpaZlEXc60yV0VP+zeSjQF4k9w0W1t1Xjo0ZxMZBt5Hiq074LQog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DTAfKdVR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DTAfKdVR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712051523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xE74JKyaieEZ865fOLwKIWnIcIp4KmBPIzJgotjw5B0=;
	b=DTAfKdVRjqpU63z+4+x+deOH0MP5yYN+vJA0dgSWZJetOtMgbp/FJF3NSIxP3eYvCMEDbt
	u++otMtXDE8sK2gTWw6XFhJBKGovJnb8uCLwYo0uSZ+2/ucJvMoAAFa3n4G3LIZGQPAy5I
	3TvgKz+vRUnCpfWN2LCivgszwvfgImo=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-1mfI8ztaNdq4ft8Hw-U_dw-1; Tue, 02 Apr 2024 05:51:59 -0400
X-MC-Unique: 1mfI8ztaNdq4ft8Hw-U_dw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-51596f968c1so4703148e87.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 02:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712051518; x=1712656318;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xE74JKyaieEZ865fOLwKIWnIcIp4KmBPIzJgotjw5B0=;
        b=eXH8uBJ7Fprn//Ss6DI+JIrbNAiPjChpvXNytJg2PkXQf3sbbLqAROAfdVWXSbqRuT
         zsOW8P5grEB4pOpF0ovym4wTXBiS/lhBoQlbOsoj0zxnUst5YQyhi2roG4Mo077wmixU
         yyXSKiiMr+xZe8Pbo7+LWnjo815kHBiNv2so9nZYf+wELbl0goersBl0tIyDiZWGTlQR
         19HViGOSDWHbgVeXJPb+Izs6fUgoKZOne6n77Q0XuzsDGCFt0D63KJQQiyY/W2CsBz7q
         WECZJZnoNSS+s69hlD1ScgGbCMq3U5Jp2qWp4RYNInYVXpmkPWbxoHw9opo8XFiBerOu
         fOSA==
X-Forwarded-Encrypted: i=1; AJvYcCUV4YJFeeoCpj+WwVnUqJVXl+og2CIOF/2HmUWWjnVm2o9YD3umR10kY2mWCNqFDSxUF8JUznMJeMhWznb4Nk4rnikj7kDG5J9v
X-Gm-Message-State: AOJu0Yy9uGB6OpMgkhZkMSff22EjDMYG1a7tIf+3wkz57EVAt0yFmtDX
	EVOZ1mfaB1+gweSV8IcxpBkNwVs0BGd6jL6U3wj3IcKKs/03vnZAyt01yFc0s+TvV++0IFj8acN
	6jShbrzMlFDuCr6iOETveWSqEJ5uMo/CrQatMpmHxRHeTuC4fUwsnjOnuLoRB0dRT
X-Received: by 2002:ac2:5dc3:0:b0:515:d4bc:c63e with SMTP id x3-20020ac25dc3000000b00515d4bcc63emr6164314lfq.63.1712051517734;
        Tue, 02 Apr 2024 02:51:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgP8+1XbBJ5ff68r07k1FqXNHSiMuetoQuLpbDHs4hLQfzFExtQKN0mhpH/OIqMg/05NwZRQ==
X-Received: by 2002:ac2:5dc3:0:b0:515:d4bc:c63e with SMTP id x3-20020ac25dc3000000b00515d4bcc63emr6164300lfq.63.1712051517095;
        Tue, 02 Apr 2024 02:51:57 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id q17-20020a1709060e5100b00a4623030893sm6228283eji.126.2024.04.02.02.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 02:51:56 -0700 (PDT)
Date: Tue, 2 Apr 2024 11:51:55 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 01/29] xfs: use unsigned ints for non-negative quantities
 in xfs_attr_remote.c
Message-ID: <nx4hkurupibsk7fgxeh3qhdpeheyewazgay3whw5r55immgbia@6s253r4inkxn>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868577.1988170.1326765772903298581.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175868577.1988170.1326765772903298581.stgit@frogsfrogsfrogs>

On 2024-03-29 17:36:19, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the next few patches we're going to refactor the attr remote code so
> that we can support headerless remote xattr values for storing merkle
> tree blocks.  For now, let's change the code to use unsigned int to
> describe quantities of bytes and blocks that cannot be negative.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |   54 ++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr_remote.h |    2 +
>  2 files changed, 28 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index a8de9dc1e998a..c778a3a51792e 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -47,13 +47,13 @@
>   * Each contiguous block has a header, so it is not just a simple attribute
>   * length to FSB conversion.
>   */
> -int
> +unsigned int
>  xfs_attr3_rmt_blocks(
> -	struct xfs_mount *mp,
> -	int		attrlen)
> +	struct xfs_mount	*mp,
> +	unsigned int		attrlen)
>  {
>  	if (xfs_has_crc(mp)) {
> -		int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
> +		unsigned int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
>  		return (attrlen + buflen - 1) / buflen;
>  	}
>  	return XFS_B_TO_FSB(mp, attrlen);
> @@ -122,9 +122,9 @@ __xfs_attr3_rmt_read_verify(

fsbsize in xfs_attr3_rmt_verify()?

Otherwise, looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

