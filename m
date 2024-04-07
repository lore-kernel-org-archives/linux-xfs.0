Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF133C082
	for <linux-xfs@vger.kernel.org>; Sun,  7 Apr 2024 23:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712531833; cv=none; b=VhK3Q4WT78Alucf8uENql0+0gkuu6VblaYQ5DzuS7mzy+xvF00WDpTTc4rM+vdZVAxKmk0gDgIVzs4T9Zdb8GVFYonisM+FwozABvrovi03TdtMUYDxMdl2gDpNJ4jvykmhNNj6VJSfQ6EVect1hvJWlGZEwYCO4Z6hRGr7IYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712531833; c=relaxed/simple;
	bh=pr4Q/C6Xf0R8fBp3csI7kr6Gq8u2CRZXQ7tvNLUFumI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sO9oObmn72anNj1TYO7bvmuj0ztNMF+b5XE7ij1CQJjFnnJEYKRz24uFJ51WYaBpJybpZfec0nHQMXmsTG5yb9Z0x65IwRL0NHEzuSoK3EPxGuP+/X0MZO+NHF6QdlQ/D+GreSd4nvV76C1TCTHbVnserEiNbswcE3hWApKj9Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=CnSsDO55; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CnSsDO55"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ed2170d89fso398414b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 07 Apr 2024 16:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712531831; x=1713136631; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0bYRg/l1GD52a9vnArKAmMdPQTp+H0DY3ahkf5b0bw=;
        b=CnSsDO558mv8D3Bbzn1JDFwvfN8ATTOpUrdHKatCy4s4Q5JOU7Ju3FACReIFvNN5fd
         BWfoGU2fMZmrbYG7YFwDmxhlXw7D8972aBGX+Xl6LEODJkVTk8INw3OYWxZGQSL0E/Fg
         6jYImaC39GVv98V9Ib+xMu5woYkt+RwVLHipCSOBZ9hj15/PwidrueyJxBUiruJFCSYd
         0ZlDp/mnHfTuUwMXQDRuxiy0W6ukSwJP/0a34+f6aF3h8hABr/q/z9k8qkqKnUZtYqAe
         0Pj3XrMFMJR4fiPKb9dnaL9TvP13zi+jJ2ju5yfP+2+Rub8TUyMObAR5R1CwXhFbrIXQ
         71jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712531831; x=1713136631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0bYRg/l1GD52a9vnArKAmMdPQTp+H0DY3ahkf5b0bw=;
        b=i9anM2gapwFjZI8Sr+1MqpMd7U0g+yc2lADAuo29luwVTzEwzOBwLRb4KDQ6zdJs6W
         +kWUoL10awp17Ymg2Of+h0GdhRziSOILOTrIDQeWwU4MwpvGhV89ILZ+ewuR1j/otbFY
         KtY/t4uv5+J3OdNARNhEmpd807dr430cs9Atk7hdwXZOTk1jm8BY8z5USvFR7MjmZ0vX
         u1HxSJxU4lHQf+iQeOT1OWGB0It429FOzKz/bnYVGRHjoOh5VbL8AxtGAAOgH5NQ/7iU
         ngM21iWzirOtyCNoePDxxPj7t2IJa1GTVlOpEMRtFgfCy+hA0npzHyCfSZeYeygfOoXK
         Sbcg==
X-Forwarded-Encrypted: i=1; AJvYcCV/7b0d4ljZeYlh7CC+c/pF55v/3xbUpmr5NRMeoofHQ1mERJ9qTwrT9j7I8cDMubCEu+YYIvujocVe4egzkBmsbUWLqJATK9Zh
X-Gm-Message-State: AOJu0YwzStTZmc40x724jd4f7pmcXDl813TTnSNPvcu+96XLV8unPzEO
	deiYwxo+XBF1coAj6wXv9sZE3hqZLV2vUYbMHXQsLg+ocRealmvZNfA/VYDw5ex87iioDVFpVDe
	c
X-Google-Smtp-Source: AGHT+IHS3UCEiiXgC4BYACNX1Fi1X271VS20zI2dzR763qP9wJI/HaLjviwi40StwKGORE2iinqRqQ==
X-Received: by 2002:a17:902:f548:b0:1e2:bb09:6270 with SMTP id h8-20020a170902f54800b001e2bb096270mr9997511plf.28.1712531830984;
        Sun, 07 Apr 2024 16:17:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b001e3c972c83bsm4810188plg.76.2024.04.07.16.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 16:17:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rtbl5-007jaO-3A;
	Mon, 08 Apr 2024 09:17:08 +1000
Date: Mon, 8 Apr 2024 09:17:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/15] xfs: create a log incompat flag for atomic file
 mapping exchanges
Message-ID: <ZhMpc58ZiQOPWBQE@dread.disaster.area>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
 <171150380715.3216674.13307875397061790548.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150380715.3216674.13307875397061790548.stgit@frogsfrogsfrogs>

On Tue, Mar 26, 2024 at 06:53:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a log incompat flag so that we only attempt to process file
> mapping exchange log items if the filesystem supports it, and a geometry
> flag to advertise support if it's present or could be present.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h |   13 +++++++++++++
>  fs/xfs/libxfs/xfs_fs.h     |    3 +++
>  fs/xfs/libxfs/xfs_sb.c     |    3 +++
>  fs/xfs/xfs_exchrange.c     |   31 +++++++++++++++++++++++++++++++
>  fs/xfs/xfs_exchrange.h     |    2 ++
>  5 files changed, 52 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 2b2f9050fbfbb..753adde56a2d0 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -391,6 +391,12 @@ xfs_sb_has_incompat_feature(
>  }
>  
>  #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
> +
> +/*
> + * Log contains file mapping exchange log intent items which are not otherwise
> + * protected by an INCOMPAT/RO_COMPAT feature flag.
> + */
> +#define XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS (1 << 1)
>  #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>  	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
>  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
> @@ -423,6 +429,13 @@ static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
>  		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
>  }
>  
> +static inline bool xfs_sb_version_haslogexchmaps(struct xfs_sb *sbp)
> +{
> +	return xfs_sb_is_v5(sbp) &&
> +		(sbp->sb_features_log_incompat &
> +		 XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS);
> +}
> +
>  static inline bool
>  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>  {
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 8a1e30cf4dc88..ea07fb7b89722 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -240,6 +240,9 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
>  #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
>  
> +/* file range exchange available to userspace */
> +#define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE	(1 << 24)
> +
>  /*
>   * Minimum and maximum sizes need for growth checks.
>   *
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index d991eec054368..c2d86faeee61b 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -26,6 +26,7 @@
>  #include "xfs_health.h"
>  #include "xfs_ag.h"
>  #include "xfs_rtbitmap.h"
> +#include "xfs_exchrange.h"
>  
>  /*
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> @@ -1258,6 +1259,8 @@ xfs_fs_geometry(
>  	}
>  	if (xfs_has_large_extent_counts(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
> +	if (xfs_exchrange_possible(mp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
>  	geo->rtsectsize = sbp->sb_blocksize;
>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>  
> diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> index a575e26ae1a58..620cf1eb7464b 100644
> --- a/fs/xfs/xfs_exchrange.c
> +++ b/fs/xfs/xfs_exchrange.c
> @@ -15,6 +15,37 @@
>  #include "xfs_exchrange.h"
>  #include <linux/fsnotify.h>
>  
> +/*
> + * If the filesystem has relatively new features enabled, we're willing to
> + * upgrade the filesystem to have the EXCHMAPS log incompat feature.
> + * Technically we could do this with any V5 filesystem, but let's not deal
> + * with really old kernels.
> + */

Please document tnis in the commit message - this decision needs to
be seen by anyone reading the commit history rather than the code...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
