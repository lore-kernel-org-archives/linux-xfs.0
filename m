Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FD818026
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 00:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712534724; cv=none; b=thUHKVZ4EgjFhNJxZK+7JSXDC/25T7sbf3zBrXNvQtrVGTC1qeNfYGhASiaFih4aZpuSVeo6gFh4CicH02Naa6/kRKhKwA+q+Bu7UuD61F/XGMRR2I6c5UM66H67obHagLwx3qmTAGzOhaIH4q7Uk5wu9kstbrR9j6wVV+VKn8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712534724; c=relaxed/simple;
	bh=FIffYrDSn/nKZVQPW+Kcaw76wRhmkF1hByCKMHiITOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzLD0ejGKMTfEpiq9vjYL2mbnzj+//gSRxpGGpL+cexxpDhStJ6SXlN2dRZCqHi3zKo0OjgUvJbvbebiRfrIZgIMKNwCwW4XEXXR259ThBbXdBx0jbEoVFs6zyIobIIhGmtRENDW+tIOm3MWufsblBWTj85NvAMtxkzXDoZCmPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Q4NTn4bT; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Q4NTn4bT"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6ed01c63657so1900398b3a.2
        for <linux-xfs@vger.kernel.org>; Sun, 07 Apr 2024 17:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712534722; x=1713139522; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KGy2q+eNB4gw6zY5jgPbbCEaa0lUtLkIc4Pq7otvsWg=;
        b=Q4NTn4bTCH1f2qsNnBrxpHfOKg8Mf918/TPCIVXAf59Fs4TLk3s+rsA28HpGyhJwzT
         UUgWqWYps3LmRfd0P+zVOZ0o6P1jm8BEEpF/qf1Y8ZsTCHs0yBemZwriiiRM1ZuJjd0Z
         0DhYkgKUC6WXw2Dt5AykpS9rSItHu7CSB1b58SZXgGOaoUFEBZi/IpemDv8qeP8YCSrQ
         lsu5EgNC92qFdwQ/0Ru5PB4H4nKfwtwXF/eFbEPwzo5+2kBVsnwyi54DgL0XIz49NLA1
         LAjVRFG7ZDTbJc9mO8wvfRI7baTphshhOglwzNFT0UpAwHzbqc9+euTt14EfQHFuezPt
         1h6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712534722; x=1713139522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGy2q+eNB4gw6zY5jgPbbCEaa0lUtLkIc4Pq7otvsWg=;
        b=DK92ORX8uvnqaRmJclpon2mTkKs//LC91Ex4dB4RCD4zlUA9qXBmSqdoT93vfrV86i
         TspRWn7EDzU0UbRIlPU6Lbz3iekdCf08c8Tia7Dwx2nauStJ+JOeiQLryxangXdYJA8h
         1j6XjSvNRlGLewmku/NwW6x4eq/Z67/cgoBjHl+B+dyGrr/syKqBkNXnNdkkxAFB8Zuf
         p/3XgAW7NSkS0xSZEkbX4CJ/+U97t3Xx67dlFCRIEdIUaadcB9MZPi6JvJMr5wkg9vOe
         EKl8I4b4feG6EOqyScqjVXzl3M8tsd4VZvXRZabdX6QItOmxUmhGnNIAgpRQgl0FiuXW
         J1jw==
X-Forwarded-Encrypted: i=1; AJvYcCXDphKBgpRtIVN+uWsMxX2jJhzzoopX2dHZavc4QvuT94R0eb89bTykuT1F8UJAu6xhvllF9BWpR8m4Q/utQ8pVk+DBJYzK3zVm
X-Gm-Message-State: AOJu0Yw7+uF0zVkQqdag1WrxZE9+DtrqOvbijcB6Z+Eu9e4vGyb4M/4/
	nGbHWaEjHxVNRuGXqN7aBenUavviucVj6NFOghx0Szz7yG3VMDSfz876OlKgIYdLoNM6F25acn+
	C
X-Google-Smtp-Source: AGHT+IFVpNlmHET2UYDv1GKkxb00PRRA9D5i66h/HUQ3YtIojz9z9x48weJQvoriLoGwiSFVHZZ3+Q==
X-Received: by 2002:a05:6a00:3d06:b0:6ec:faef:dd28 with SMTP id lo6-20020a056a003d0600b006ecfaefdd28mr7518351pfb.23.1712534721699;
        Sun, 07 Apr 2024 17:05:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id j25-20020aa78019000000b006e69cb93585sm5229439pfi.83.2024.04.07.17.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 17:05:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rtcVi-007m47-2t;
	Mon, 08 Apr 2024 10:05:18 +1000
Date: Mon, 8 Apr 2024 10:05:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/15] xfs: bind together the front and back ends of the
 file range exchange code
Message-ID: <ZhM0vg/ZoDxCiX2F@dread.disaster.area>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
 <171150380767.3216674.8194914191250132008.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150380767.3216674.8194914191250132008.stgit@frogsfrogsfrogs>

On Tue, Mar 26, 2024 at 06:54:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> So far, we've constructed the front end of the file range exchange code
> that does all the checking; and the back end of the file mapping
> exchange code that actually does the work.  Glue these two pieces
> together so that we can turn on the functionality.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_exchrange.c |  364 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_exchrange.h |    1 
>  fs/xfs/xfs_mount.h     |    5 +
>  fs/xfs/xfs_trace.c     |    1 
>  fs/xfs/xfs_trace.h     |  163 +++++++++++++++++++++
>  5 files changed, 532 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> index ff8a2712f657c..1642ea1bd7b30 100644
> --- a/fs/xfs/xfs_exchrange.c
> +++ b/fs/xfs/xfs_exchrange.c
> @@ -12,8 +12,15 @@
>  #include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> +#include "xfs_quota.h"
> +#include "xfs_bmap_util.h"
> +#include "xfs_reflink.h"
> +#include "xfs_trace.h"
>  #include "xfs_exchrange.h"
>  #include "xfs_exchmaps.h"
> +#include "xfs_sb.h"
> +#include "xfs_icache.h"
> +#include "xfs_log.h"
>  #include <linux/fsnotify.h>
>  
>  /*
> @@ -47,6 +54,34 @@ xfs_exchrange_possible(
>  	       xfs_can_add_incompat_log_features(mp, false);
>  }
>  
> +/*
> + * Get permission to use log-assisted atomic exchange of file mappings.
> + * Callers must not be running any transactions or hold any ILOCKs.
> + */
> +int
> +xfs_exchrange_enable(
> +	struct xfs_mount	*mp)
> +{
> +	int			error = 0;
> +
> +	/* Mapping exchange log intent items are already enabled */
> +	if (xfs_sb_version_haslogexchmaps(&mp->m_sb))
> +		return 0;

I must have missed this earlier. We don't do "sb_version" checks on
the superblock anymore - that wrapper should be removed from
whatever patch introduced it. Enabled features set a feature bit on
the xfs_mount when the feature is set/detected and the code runs
xfs_has_foo(mp) against the mount, not the superblock.

i.e. Please define a XFS_FEAT_EXCHMAPS field and set that appropriately
when enabling the feature and check it here...

> +
> +	if (!xfs_exchrange_upgradeable(mp))
> +		return -EOPNOTSUPP;
> +
> +	error = xfs_add_incompat_log_feature(mp,
> +			XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS);
> +	if (error)
> +		return error;
> +
> +	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_EXCHMAPS,
> + "EXPERIMENTAL atomic file range exchange feature in use. Use at your own risk!");

This doesn't need to use xfs_warn_mount() because we can only turn
the feature on once per mount now. Hence the opstate bit can go away
and it can just use xfs_warn()....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
