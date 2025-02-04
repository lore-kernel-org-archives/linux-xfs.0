Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF24204589
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738700290; cv=none; b=VOqsGr1t26a9tDYQq8JIXKAh8xlDjTjxt13T53WLyPVoDIi9jdXSIQKOLy60pK9xOLOIn/MRV+36x8LvJ3eI/kpYTuGz6fsSTrqcQr4tz53p16YxtnJPtDxA62THBZ2nuWv00LUzRfaawQI8NzoXFDo160gzEt6pPzjZdVVYvwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738700290; c=relaxed/simple;
	bh=2jLtBenL7WlBxHovSeDK7T58wmEFnClnl2AVWMk6G18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1qFyJdgZa1wFxdbmfMze7K3NqrEGXee8kFJZf3hWrf03eOFyKyEoY/t2A6mept/4L7TBAh9s3eQIGgiAAS3QhNDZ+GJSLWsMr8Ri97OrzQwwc23JJkpq6UI0+A+RDyjhBSNRmfkjHCyLzROl7YejuimPrm8w/GeS1LvZbqDpgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=TkbpX6s7; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="TkbpX6s7"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2167141dfa1so2780685ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 12:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738700288; x=1739305088; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GU5zB96qYN+FRV6k4yCrX41hpPxDKTLz+R7SItDxUlM=;
        b=TkbpX6s7SUBT1DHYN61kXiZ1Sv7newXvM7ykSDQQwksfjESyu9Xo1oceTAKm3T1ZiG
         QtGxMDgS7ggkkOz/pE+Ep41qD8h91sW8X3WGcruidpB2eXZBLnh5EO2koGIBXRlDTDta
         N6nZItjENRYM/yrUmqM4AQkZJs9A+rA3DjYj9tDqlQU1IFXSRjtBkS1lOO9FtFozCetX
         bDxDf+4wWwpN3G1+r8vyprlhBVY0fXpvwuurvnDRJCdNelKhJGFxP5rFNJ8rDCEweo6a
         +8ph6t4zEmIHsZtf8CCm28upr8NDTU1QHOTGTgV+cAJSVQnm8dX6DMzasLInchrGl5yt
         5zRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738700288; x=1739305088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GU5zB96qYN+FRV6k4yCrX41hpPxDKTLz+R7SItDxUlM=;
        b=NlIedudvmTzgIGT0EZJVywDDdrPwq0m6rzMlbr20KvKEuacB/6qBMgJSlQVIAj5/U/
         2G7QKaKmNVK4vU9uUSVoIi/p04NrbjysI3XHEpPh4Q5cVpOtPbj9VNPsvgpxttGAVS/B
         hpc2eme4H4QDobdLtbeH91nnsWoasDQ8TdLfqPLAW+QydbbiBbK3DTSRXJLXWgEjdDod
         j/3ijeKmF2qCu/QF9ghdSfQeqeTonMfLi1/LI8YI8HTJuILg/9FaQQ0HU+H06VBtll6A
         lvMpYlAJmF1EF3I8SBCzM9KLN1xbKnEWiob8wWktyqjEVSCgnF/f+yqqy0u5KsJM6Ffc
         rVfw==
X-Forwarded-Encrypted: i=1; AJvYcCVLQxPhlisekhz2E474jJhqBx/VWxNdYmQ1Ch2hJwlti08Nd4ailFLaj5mA5wfQYzKqdmU/zUh2T0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQBe8wlGAPCdjSBA/TDJ5fI9tRgEe3IdZUoLhS7gbAvuaU0gyF
	tZ9rIFWf/krAZrxMhzNzPJP6VVS/2imCxyOU3lIePP1NsNNckx6QMONuYNnE1H+G/PaIxncnzHN
	1
X-Gm-Gg: ASbGncvi+1mHlfU2a6xqdebciwxpaTE1bz4KfTAsPI8XRLr6IQrb67v7hm/BvVY2s3L
	NmakX1LajgO3BazP9BMKQAOUs9F6mk1aDpILnRGTrbvLHcZRvVSzoIkdYqmXzkOXi3rMh8Nldmu
	H7VXF6HiQtk42BYqPO4Xhog+dAufreXKUL+Tz10G3sSlVZoWRF2AQQr7R6kjgXh6Nx+/eucHFrl
	BFDkfwrNjm2nIrbczt60HOrwFbvP56oFsUbHVaCra5vRuoP1nfzJAGX1eerkp6kvfwE39QA0HLR
	IYDapFH4PigQv7PaB2ucsZtHCF3KRJvKgDTHS9CKV+hEuvCp+7rTTxxbZ2+fQtq3pLk=
X-Google-Smtp-Source: AGHT+IEMgSD9trnuioVinMvhHC3ES+FE9T8T3czMXt9iSS8JbaTH/Nw8tHIrrnD7TJrUQ4TRc/19BA==
X-Received: by 2002:a05:6a20:6f88:b0:1e1:9e9f:ae4 with SMTP id adf61e73a8af0-1ede8302a6cmr424782637.13.1738700288392;
        Tue, 04 Feb 2025 12:18:08 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe69cdd20sm11337032b3a.135.2025.02.04.12.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 12:18:07 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfPMy-0000000EePH-3iu2;
	Wed, 05 Feb 2025 07:18:04 +1100
Date: Wed, 5 Feb 2025 07:18:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: do not check NEEDSREPAIR if ro,norecovery mount.
Message-ID: <Z6J1_MVxHbTW3v1B@dread.disaster.area>
References: <20250203085513.79335-1-lukas@herbolt.com>
 <20250203085513.79335-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203085513.79335-2-lukas@herbolt.com>

On Mon, Feb 03, 2025 at 09:55:13AM +0100, Lukas Herbolt wrote:
> If there is corrutpion on the filesystem andxfs_repair
> fails to repair it. The last resort of getting the data
> is to use norecovery,ro mount. But if the NEEDSREPAIR is
> set the filesystem cannot be mounted. The flag must be
> cleared out manually using xfs_db, to get access to what
> left over of the corrupted fs.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_super.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 394fdf3bb535..c2566dcc4f88 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1635,8 +1635,12 @@ xfs_fs_fill_super(
>  #endif
>  	}
>  
> -	/* Filesystem claims it needs repair, so refuse the mount. */
> -	if (xfs_has_needsrepair(mp)) {
> +	/*
> +	 * Filesystem claims it needs repair, so refuse the mount unless
> +	 * norecovery is also specified, in which case the filesystem can
> +	 * be mounted with no risk of further damage.
> +	 */
> +	if (xfs_has_needsrepair(mp) && !xfs_has_norecovery(mp)) {
>  		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
>  		error = -EFSCORRUPTED;
>  		goto out_free_sb;

Look fine. I've had to hack around this with xfs_db when testing
(broken) xfs_repair mods a couple of times myself...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
