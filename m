Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4EF945A
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 01:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724636485; cv=none; b=NXBAJQwyPdrW709cGgjBTqsVf3nuiEfMQuEw2ZJYJ5VU+hiR/089nxcjFp/BJFwSHSZ91xXdcETs9HQZzpJRxo1F3IiWFOqePYeenqbxE53tUa7d8C3pPJbEAimPy3oRWEJNsoK289VzaPEJrW3Yyl5XnZXoEGjx1I0Ptm0QqYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724636485; c=relaxed/simple;
	bh=jjv0sc8dys8ljzYBE80fSqzOcPmMkZOiGqGr9jNy95o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bsf0MnD2kDsqxry79vwvbHTF2eY9yAMmMZZU91uiuyIFGJxc+/whA5XU3QL9ELROZSuk8oeyseg8f745l081J9qCCmYOw7+kD+6c70OxCyXWkAez+53avcy2nMxMYP3V3Hgtv1JmwMLBKX4C4sy1wUNyntj/4Dj+yhRWPqqIImM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=seTqtB0l; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="seTqtB0l"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71433cba1b7so2693134b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 18:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724636483; x=1725241283; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OLDjvBjvYu3c/7QrDqsoIoHNuQsgk+yqwF2fajz7vAk=;
        b=seTqtB0lorOnaVr54feriblrfVQuqxvJu2Fw9Gux2/ccpsfSMBOcytRAw1aB3WWABx
         FpJ5S/4UnjfWLuG4UubpEorRbdbNFn87gJ86SslBnLBBboAFppxLxeKC/fe31Y2rG0BD
         0IY45JvRsJbZOdVeLBZ7bQ7vpaei5yW83FB1PknGsaPFMtJluS/ZegFEOh6IpusNmNyJ
         PD+ZGlLou62ocnebvz6rLZx444G/DgOLW7/4Ya5w7EUWb/tt8z/b4hdRGLfm1/ILwOcN
         afI9VKAbQk+kKCIEhPeVEqwH53TxMx7ml4dlE6prVHCBRPaxCbCYTVw83PIjHBOCEufb
         R4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724636483; x=1725241283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLDjvBjvYu3c/7QrDqsoIoHNuQsgk+yqwF2fajz7vAk=;
        b=kji/S9hytt2JjaSdxcAaMrahdQlreVWaygrrthk1iuhSNNOj/7MZe3DsnwTb/eLWkQ
         3+xdRfeQxAakTh/XODsvMMgwLgSDLBRPvdCRV4J7YHsmmD82rDtTU9JmGPJqVg9Ox3W9
         LPS7YkmUmvJdYXfaRbrnpP5W8HELOjJOqOsCqlgvI74CgNW1SN6s708YqSImJb39KpVw
         6CFw/1pY5DSuIlXYBDfZVzDh3eEOpC7bA3QlqPE7XqmTCif/EFkyPqRfF6/PDRqtmoiV
         7LkPH+VwAV09RF5CBRaQ5D87XCuwUQlOt+0Zykt/el5jWQPzHU2yQ1Lh3MLUkVlddQoB
         4DsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtvTZD0HD/s0oLkGycjDGZytDkJ3oH0H+Z5EZ+p3nknVZFQvamXzVxskFXpTDn5HzHt5hyvy5qx5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPRWTyS5QEN4t63YO49nq0cINYsaZ1PKj313GvlZZnX/wYQ92y
	2rAqv/bi+mIcHmIOleS6EBjYgp51MOYrFQVUOpUALWBY2AhGV3gZ2bHJ3NzL8KRYfbXKiXjtpZC
	h
X-Google-Smtp-Source: AGHT+IEcULRMc+lVgI2BQL+JNHxVtG14QHYHDuhD9og53htUeCQynSDCNfhyypi5VbL1OQ4XyHMeRg==
X-Received: by 2002:a05:6a00:841:b0:70d:2956:61d9 with SMTP id d2e1a72fcca58-714458c75afmr8886805b3a.25.1724636482534;
        Sun, 25 Aug 2024 18:41:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7143422ed7esm6168521b3a.6.2024.08.25.18.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 18:41:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siOjP-00CpIy-2H;
	Mon, 26 Aug 2024 11:41:19 +1000
Date: Mon, 26 Aug 2024 11:41:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: support caching rtgroup metadata inodes
Message-ID: <ZsvdP4IaRNpJcavt@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087487.59588.6672080001636292983.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087487.59588.6672080001636292983.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:18:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create the necessary per-rtgroup infrastructure that we need to load
> metadata inodes into memory.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_rtgroup.c |  182 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_rtgroup.h |   28 +++++++
>  fs/xfs/xfs_mount.h          |    1 
>  fs/xfs/xfs_rtalloc.c        |   48 +++++++++++
>  4 files changed, 258 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index ae6d67c673b1a..50e4a56d749f0 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -30,6 +30,8 @@
>  #include "xfs_icache.h"
>  #include "xfs_rtgroup.h"
>  #include "xfs_rtbitmap.h"
> +#include "xfs_metafile.h"
> +#include "xfs_metadir.h"
>  
>  /*
>   * Passive reference counting access wrappers to the rtgroup structures.  If
> @@ -295,3 +297,183 @@ xfs_rtginode_lockdep_setup(
>  #else
>  #define xfs_rtginode_lockdep_setup(ip, rgno, type)	do { } while (0)
>  #endif /* CONFIG_PROVE_LOCKING */
> +
> +struct xfs_rtginode_ops {
> +	const char		*name;	/* short name */
> +
> +	enum xfs_metafile_type	metafile_type;
> +
> +	/* Does the fs have this feature? */
> +	bool			(*enabled)(struct xfs_mount *mp);
> +
> +	/* Create this rtgroup metadata inode and initialize it. */
> +	int			(*create)(struct xfs_rtgroup *rtg,
> +					  struct xfs_inode *ip,
> +					  struct xfs_trans *tp,
> +					  bool init);
> +};

What's all this for?

AFAICT, loading the inodes into the rtgs requires a call to
xfs_metadir_load() when initialising the rtg (either at mount or
lazily on the first access to the rtg). Hence I'm not really sure
what this complexity is needed for, and the commit message is not
very informative....


> +static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
> +};
> +
> +/* Return the shortname of this rtgroup inode. */
> +const char *
> +xfs_rtginode_name(
> +	enum xfs_rtg_inodes	type)
> +{
> +	return xfs_rtginode_ops[type].name;
> +}
> +
> +/* Should this rtgroup inode be present? */
> +bool
> +xfs_rtginode_enabled(
> +	struct xfs_rtgroup	*rtg,
> +	enum xfs_rtg_inodes	type)
> +{
> +	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
> +
> +	if (!ops->enabled)
> +		return true;
> +	return ops->enabled(rtg->rtg_mount);
> +}
> +
> +/* Load and existing rtgroup inode into the rtgroup structure. */
> +int
> +xfs_rtginode_load(
> +	struct xfs_rtgroup	*rtg,
> +	enum xfs_rtg_inodes	type,
> +	struct xfs_trans	*tp)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	const char		*path;
> +	struct xfs_inode	*ip;
> +	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
> +	int			error;
> +
> +	if (!xfs_rtginode_enabled(rtg, type))
> +		return 0;
> +
> +	if (!mp->m_rtdirip)
> +		return -EFSCORRUPTED;
> +
> +	path = xfs_rtginode_path(rtg->rtg_rgno, type);
> +	if (!path)
> +		return -ENOMEM;
> +	error = xfs_metadir_load(tp, mp->m_rtdirip, path, ops->metafile_type,
> +			&ip);
> +	kfree(path);
> +
> +	if (error)
> +		return error;
> +
> +	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
> +			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
> +		xfs_irele(ip);
> +		return -EFSCORRUPTED;
> +	}

We don't support LOCAL format for any type of regular file inodes,
so I'm a little confiused as to why this wouldn't be caught by the
verifier on inode read? i.e.  What problem is this trying to catch,
and why doesn't the inode verifier catch it for us?

> +	if (XFS_IS_CORRUPT(mp, ip->i_projid != rtg->rtg_rgno)) {
> +		xfs_irele(ip);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	xfs_rtginode_lockdep_setup(ip, rtg->rtg_rgno, type);
> +	rtg->rtg_inodes[type] = ip;
> +	return 0;
> +}
> +
> +/* Release an rtgroup metadata inode. */
> +void
> +xfs_rtginode_irele(
> +	struct xfs_inode	**ipp)
> +{
> +	if (*ipp)
> +		xfs_irele(*ipp);
> +	*ipp = NULL;
> +}
> +
> +/* Add a metadata inode for a realtime rmap btree. */
> +int
> +xfs_rtginode_create(
> +	struct xfs_rtgroup		*rtg,
> +	enum xfs_rtg_inodes		type,
> +	bool				init)

This doesn't seem to belong in this patchset...

....

> +/* Create the parent directory for all rtgroup inodes and load it. */
> +int
> +xfs_rtginode_mkdir_parent(
> +	struct xfs_mount	*mp)

Or this...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
