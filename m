Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE03227B85
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716181; cv=none; b=GH6zGw4v5qOxeXNAoQOgx8M/yCWvfxctWDuBIT12qIi2SAKtG05N3EEu+ZzLsLwfWsNOFqSmx9PhnaYwY4pxWH/w7j+m+s9M4T9UiCyzkRhjtl8rzqsfdvyQA20Iz5oELYyIG4y1f8POBu3HUlAGM26g3//qRJ811mhrOVYi9s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716181; c=relaxed/simple;
	bh=P33HhQ5exX3hjmIscmxenCivfShCBFK3LSbU3lC5VV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nSdPL7sfo9NwsmwyU6sT7cUx8/prEBTbUTiSLckLRFGhQxoFbCuccIBDFC20tH9P0VjDK7jwlhWE8pCaQxSd8BZ7ddqVDcCCrYGcR6geJiyKQfBIgflMzP/xlq/ElYeVJ7cFJS9tVllwwLPEMWt02PDUm4GAkUxxQMH4ZEw0Tg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gWVSL5Bb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gWVSL5Bb"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21669fd5c7cso113621115ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738716179; x=1739320979; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/5kg3H6HL8o754rBW0YOFr5SCx8c7RwYcIDPTGJAHUY=;
        b=gWVSL5BbkgBEfsNcOahET6vDJUCg0GBKRECcv+6/ZXO4q9ekMKlRvPayydDSKLdz5x
         o5TaXvQKLogOxUsxKTqXWRPIVS7oP5uQVEpqlBbR692AnvKFIRJSv8aHLo4Jj3yPBgg8
         tOazNj87409eqOzwVl+enDfiS/v1s5UM3InCPLT4D2YiT+DiUzT4962PJLzrTRVmhHj1
         DyF8ZRYLnw+Ka7BdCjl08oUhlHjq+JiOw4e3hv0evUPRQNkQ78hInFamcSsLqs/cgBDb
         ZzEznzi6pvsVCtKxAhaZo7qBZC4guHXv1y/cI7A729QCqmLyEUiul6nTDPOq8jXFuJrW
         mePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716179; x=1739320979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/5kg3H6HL8o754rBW0YOFr5SCx8c7RwYcIDPTGJAHUY=;
        b=YgShRwszzwtIgBMQNEO2UDo274lX6E6TW5zNdWWVn02QloP6Tgo6K9+MO9/PB3YSu6
         CO7oGstmQmlmYKO7ImWHj2GbAD+w/WzQ3+2YAWKX9vyE6SBLTQgZRe/z0ER5J0qTGp7q
         DL83eUxU+ChjAXybByvEtcECD5VCGZd7IcT3xv6dUIzkYa0poEWwsuSIsKytfO/fhoR/
         QE4ggQ+qG3piMocuMV+gwBd/9bZzHbBQFJbXz3gtHgG5n9l6VPt8pGfTIRP7PkZsAJFB
         4c/2LviBJ+RDFF6Tg8ijQWVyBvTneVeAA6rc7BGBFxUbMhLk0DE5LUpiLphRmBHZ/5E5
         rB/w==
X-Forwarded-Encrypted: i=1; AJvYcCX9r6sISCGG5MM/iTzpiwcdQwXxdCyB8nmD40dezo9hNfvGBWh+rgLr3FPGfl1oLnKsS2nLLlRf038=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGwRLv94VfT+L5IjchATk22kXfig/Arnhti6K666n5I0xwmL/4
	nSNMQLsF6ljPA3DziDgXglLA/3Vc4738pDruAvZrj1FHU2atn2iuOL6BeBg05/c=
X-Gm-Gg: ASbGncupPoa4jnG3BGrCF/mSL+2I8ks0yjqjk0iF1mWGkHvaA4q6QV6j1IBuDe9D0tM
	ljtJB1UrdH/opOZHo9kwYZv1oe0E9aRtHalzpwkJIdwe9yEobuFsxCRznn88GI5G0APvQuxMQg5
	UEP7hNbvbmAwdZaYThJY/SSI60KD8HDVdWG8HDXQIRA53GZ/w3qIO0+EKh/iU6AZ6DZW6FA+cbX
	OrtwpnvPcEKe0oxtLqvPLZ3abTiHfvL+++34udSbui8hBhqHScqNVyaHnXvChNziKXDPkIe08W6
	xf6HAONnDt9OPNeyFmlaqarp9mbfROTNCr4/8IhPZkBSSzfSah83SAve
X-Google-Smtp-Source: AGHT+IGxUiOieMp79uApguEYeIuDLJwOd2I8PSClu9Pv4EGVwRv3e62vJxfnZTpJXrSof2sMrWqx/A==
X-Received: by 2002:a17:902:ced2:b0:21c:15b3:e3a8 with SMTP id d9443c01a7336-21f17f031bamr11512035ad.37.1738716179570;
        Tue, 04 Feb 2025 16:42:59 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32ea5bbsm103699705ad.150.2025.02.04.16.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:42:59 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTVI-0000000EjMs-37WQ;
	Wed, 05 Feb 2025 11:42:56 +1100
Date: Wed, 5 Feb 2025 11:42:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/34] common/rc: return mount_ret in _try_scratch_mount
Message-ID: <Z6K0EF-wHqwN-68X@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406411.546134.11968180503485222405.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406411.546134.11968180503485222405.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:27:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make the _try_scratch_mount and _test_mount helpers return the exit code
> from mount, not _prepare_for_eio_shutdown.
> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: 1a49022fab9b4d ("fstests: always use fail-at-unmount semantics for XFS")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Ack, missed that. Though:

> ---
>  common/rc |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/common/rc b/common/rc
> index 03603a5198e3b6..56b4e7e018a8e0 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -440,6 +440,7 @@ _try_scratch_mount()
>  	[ $mount_ret -ne 0 ] && return $mount_ret
>  	_idmapped_mount $SCRATCH_DEV $SCRATCH_MNT
>  	_prepare_for_eio_shutdown $SCRATCH_DEV
> +	return $mount_ret

These could just be 'return 0' because we've already checked
for $mount_ret being non-zero.

Regardless, it gives the same result, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
