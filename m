Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14ED44C6A
	for <linux-xfs@vger.kernel.org>; Sun,  7 Apr 2024 23:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712530818; cv=none; b=cUZiXVJ/KpDzDTYz75maMbc1lmrDF397Ca5LawOWbGEL0CUh4WB+pDOXz0U9/4pH12CCylxDojV9KOblmK8qv1yZa7pm7LM7IUE8/fWOME/lZF+HVtH4D5axdXHTKBn30EFCy6Xmat38XyR6dZ8uf3rKEt+wUcPJGfwGJrMc+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712530818; c=relaxed/simple;
	bh=egf4Q6TA6eAFLR0qY5mzyXMG6sRpTjIvtX2zz7oSUZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMyRl13oa/cZCsZY0iL8RIFkf2zlFSM6l2x7J2TQWWFNHeNs9Yl4RGo/n8uSTHDX0KTC91ngMlJaDJM6pfyGzSL5NGXb9rjnCul8NLvML2AemWXapS3Dq2zAVFIDltHWVUBBH8YEnTP4Jfn2wM1S4JsGC0a/BqD1YU5t0ijLjvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=k+aD9BLs; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="k+aD9BLs"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2a2f6da024eso2118055a91.3
        for <linux-xfs@vger.kernel.org>; Sun, 07 Apr 2024 16:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712530816; x=1713135616; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3k4XLP0YRoXO1ZdGc3iBxpC7LytmibKPyNnlCcvTZyw=;
        b=k+aD9BLssIIGavsrT6T3vvM5dEJTwy50MnQlmq6pRtOaSc3k2DiYD2F3vvBxk2Wl46
         LdNy4/IhiMC4Sjwn0YwXeXCYXSPJpEw6vc56Tu2nx1zcRBINh/7JdYG4T7VBSf4bSW1G
         +64HiggVRYBreD02xJlRc5Yb8OvX426NDi8dE3ln/xEaOMIQXnUYwIeEZ3UqkJMKdQS9
         UPFPTMj6H4j/lO4JuUq0a65MzlfLFsi17ahGeN8ZP4ArkVMhASKNBMaDBbhmIhUClcOR
         vXvCKdQ8twdXXUEjc9dFLU70j1rsuWSPcD8B10FMVm0LeMGxLPKETqFvIzGKK3IXFDAz
         EQ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712530816; x=1713135616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3k4XLP0YRoXO1ZdGc3iBxpC7LytmibKPyNnlCcvTZyw=;
        b=M0wKZlX/jaf+cJMJbLrMZR1msPHY23xyCLfIkMo3YTQjnClbBeqhkknqZIgogo9Kti
         a5u9yx/F1pgATFwRTAMxXIXt1LgHdNU93W18HJmKBRxypFybvc9XvMG6Gr+iFKtu14Jy
         hYaGI/dc9b+8bVJu94kIk5RN3uQMmxpL9Db8RNvVoKBfdn82iBth1gbfDRGdEvAfYYGg
         S50ELd8EpAwQXwp+o5u/hnR5gKJKB/VXMHzw/Brs/1UROmJ4uldUD47TJfBd/kaBSaE6
         9WJzqLIwx1oHMhzhVV/5TgtsXVY7FbgA5VMaWb89o/f+sTeRfvCRpclwObG/txIp6gNS
         T/fw==
X-Forwarded-Encrypted: i=1; AJvYcCUsBoDp8wVdKjX/cGOZx9tGJRDGmc7LRJxBGy4YZDyPGxftoqA1j5WL/Chj7Y2MhAwp50+1reDo7o/EIBggAIDKsgWfCbAzpzQY
X-Gm-Message-State: AOJu0YwRXGPP4wjJBbN8LzDCvohAk2jg/fgSlazfqn7wwFVCuS+LXYEc
	zboYiQoaON828OB3UMqo5g1Hl0GnFEODtMmeeFuB2Uhtqy2dtsGEcrCNvVz0rrQ=
X-Google-Smtp-Source: AGHT+IF5h7DpKdorEt3LEeBENwbG4Ib/LtcofEu8+Ao5a/BFtFo00RS4ATJWfx38fsP/NhCCOl2QiQ==
X-Received: by 2002:a05:6a21:1509:b0:1a3:495e:3f17 with SMTP id nq9-20020a056a21150900b001a3495e3f17mr7817294pzb.24.1712530815775;
        Sun, 07 Apr 2024 16:00:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b001e0a61cb886sm5464232plh.120.2024.04.07.16.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 16:00:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rtbUh-007irg-2W;
	Mon, 08 Apr 2024 09:00:11 +1000
Date: Mon, 8 Apr 2024 09:00:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: only add log incompat features with explicit
 permission
Message-ID: <ZhMle4U4mwUnqoNZ@dread.disaster.area>
References: <171150379721.3216346.4387266050277204544.stgit@frogsfrogsfrogs>
 <171150379761.3216346.9053282853553134545.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150379761.3216346.9053282853553134545.stgit@frogsfrogsfrogs>

On Tue, Mar 26, 2024 at 06:51:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Only allow the addition of new log incompat features to the primary
> superblock if the sysadmin provides explicit consent via a mount option
> or if the process has administrative privileges.  This should prevent
> surprises when trying to recover dirty logs on old kernels.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

As I said originally when this was proposed, the logic needs to
default to allow log incompat features to be added rather than
disallow.

Essentially, having the default as "not allowed" means in future
every single XFS mount on every single system is going to have to
add this mount option to allow new log format features to used.

This "default = disallow" means our regression test systems will not
be exercising features based on this code without explicitly
expanding every independent test configuration matrix by another
dimension. This essentially means there will be almost no test
coverage for these dynamic features..

So, yeah, I think this needs to default to "allow", not "disallow".


> ---
>  Documentation/admin-guide/xfs.rst |    7 +++++++
>  fs/xfs/xfs_mount.c                |   26 ++++++++++++++++++++++++++
>  fs/xfs/xfs_mount.h                |    3 +++
>  fs/xfs/xfs_super.c                |   12 +++++++++++-
>  4 files changed, 47 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index b67772cf36d6d..52acd95b2b754 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -21,6 +21,13 @@ Mount Options
>  
>  When mounting an XFS filesystem, the following options are accepted.
>  
> +  add_log_feat/noadd_log_feat
> +        Permit unprivileged userspace to use functionality that requires
> +        the addition of log incompat feature bits to the superblock.
> +        The feature bits will be cleared during a clean unmount.
> +        Old kernels cannot recover dirty logs if they do not recognize
> +        all log incompat feature bits.
> +
>    allocsize=size
>  	Sets the buffered I/O end-of-file preallocation size when
>  	doing delayed allocation writeout (default size is 64KiB).
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d37ba10f5fa33..a0b271758f910 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1281,6 +1281,27 @@ xfs_force_summary_recalc(
>  	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
>  }
>  
> +/*
> + * Allow the log feature upgrade only if the sysadmin permits it via mount
> + * option; or the caller is the administrator.  If the @want_audit parameter
> + * is true, then a denial due to insufficient privileges will be logged.
> + */
> +bool
> +xfs_can_add_incompat_log_features(
> +	struct xfs_mount	*mp,
> +	bool			want_audit)
> +{
> +	/* Always allowed if the mount option is set */
> +	if (mp->m_features & XFS_FEAT_ADD_LOG_FEAT)
> +		return true;

Please define a __XFS_HAS_FEAT() macro for this feature bit and
use xfs_has_log_features_enabled() wrapper for it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
