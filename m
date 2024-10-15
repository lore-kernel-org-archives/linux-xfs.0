Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534C118A6DB
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 06:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728975330; cv=none; b=PInnFZ8GVLVXmDQESQezo8iVFkKG1DjymlOvJtuM/X+DDIl+DyCjiXezgqzkQC7qvSZUHwD13hsTdorNiYHSh/R4b3UK69XQENrUIlpOm6J/uqbddxm+PySn0inKNeVkbFMfkiCW17n/iEIq9wiINQzd0l97vJFdD0Mu0TROcKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728975330; c=relaxed/simple;
	bh=6hc9EaNWhk2Lm/5k1y2G1AjqCGGHi7Vsj5ifZgigTW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCfc93MeoZ3boOTvLz7IG+j6KJ7G04MQhDXdXMb4DYDLxk6tVa3f/rGpv1/ragAO7n+XPt+LAkL/5Agn+Gkuy6YAAHfRN1dRjLoMU+nlEmu5sW8p+uiwpWi9NlUUV4sSGlQ9QQlkB+bgkGa6lrc3RMZ6EKVms4rs7n/rkQuVnCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=M9zf/xfu; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="M9zf/xfu"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a3bd42955bso11505575ab.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 23:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728975327; x=1729580127; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lS4+bcNhwYRbFej5iucSbbwTBwgk6HKxWb3zx8GI3ns=;
        b=M9zf/xfuygxRKznTiVqsbfchbDsgKGaTUAz4/ryUnl2b1ZBvmI1jhJWW2PLMSV0a8U
         CuLmKo+y1sLQbEg/eBW6Dp4AQK2rPFw8WkBIKP3cW0ncRTKdztDvj2fH2Y6+2JXI5WmC
         qUTIEsXekgmclPPvpFvofXWCgeYeXrScj4ua1/UXX7yvPUUYLuVaiMAxlus7Q4YpLla7
         TqiLYeBSgVI0r45ph4LNirJ5+k9qIsroZNBcnnCGEqPSGbQUUJFt8HcCJaGSL3Hlro8o
         IvRPhvSe1K6E/NzLHaXD5wF3nDUqnFTRXtcPy540qi/Oi2YNf4Gh5Ayb85Meyxt/y5ta
         Pdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728975327; x=1729580127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lS4+bcNhwYRbFej5iucSbbwTBwgk6HKxWb3zx8GI3ns=;
        b=rwhSND2oeNaiE2Id4iOV6qeEqSVEMlxnPQwlbIKji7hKU6wwlB5YBpFW/Ms8F5rKn/
         Y8zC5INdG+rJs2QxDOC0IuhfuHTl6GaIuSWtBCran1DQOYTGX7Xybdgg6Inpr+Mu6S+L
         /0kfnVGdgx/miv0moe0ZJhB91y9F8bZ9STZO0PRoAAhHze0qBw2NWgz24HORD4pCoQB4
         u377GcYfr5rjBti2hK/Nr+FZxCzLZrCVbmGuXN10u4nBGJvstO+tJp9rvAYZhI0k02bF
         su2De0xG5tOuHrIpMn6fC9YA9Z5+5ExyUVy9AcLDP92qmXh0D1eWPhymTNg5auwOXs5m
         kenA==
X-Gm-Message-State: AOJu0Ywh06HLWUvSv1Cc0QkBbqNwn3ysa/sKVWN9Iitgu5H3Hl4xFQoE
	jMcULOdgKngqaDJzIM0uH9p2uP8Denm2lA9vMB6WBRHSPxAUNNpbmTXx4lHCfbheu41x4LKgYt8
	s
X-Google-Smtp-Source: AGHT+IGjTTUyq3N9FHrOyuo2uNZ+V40NaTmqGkOs2Iu+XkDxGaYYLrPOLD7dZCvpO9E9OjGKFju/8g==
X-Received: by 2002:a05:6e02:160e:b0:396:e8b8:88d with SMTP id e9e14a558f8ab-3a3b5f61a5emr126322655ab.11.1728975327255;
        Mon, 14 Oct 2024 23:55:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea9c6d43f8sm640728a12.54.2024.10.14.23.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 23:55:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0bSl-0011u9-2n;
	Tue, 15 Oct 2024 17:55:23 +1100
Date: Tue, 15 Oct 2024 17:55:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/28] xfs: iget for metadata inodes
Message-ID: <Zw4R2zxI6XwOHrIC@dread.disaster.area>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642100.4176876.17733066608512712993.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860642100.4176876.17733066608512712993.stgit@frogsfrogsfrogs>

On Thu, Oct 10, 2024 at 05:49:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a xfs_metafile_iget function for metadata inodes to ensure that
> when we try to iget a metadata file, the inobt thinks a metadata inode
> is in use and that the metadata type matches what we are expecting.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
.....

> +/*
> + * Get a metadata inode.  The metafile @type must match the inode exactly.
> + * Caller must supply a transaction (even if empty) to avoid livelocking if the
> + * inobt has a cycle.

Is this something we have to be concerned with for normal operation?
We don't care about needing to detect inobt cycles this when doing
lookups from the VFS during normal operation, so why is this an
issue we have to be explicitly concerned about during metadir
traversals?

Additionally, I can see how a corrupt btree ptr loop could cause a
*deadlock* without a transaction context (i.e. end up waiting on a
lock we already hold) but I don't see what livelock the transaction
context prevents. It appears to me that it would only turn the
deadlock into a livelock because the second buffer lookup will find
the locked buffer already linked to the transaction and simply take
another reference to it.  Hence it will just run around the loop of
buffers taking references forever (i.e. a livelock) instead of
deadlocking.

Another question: why are we only concerned cycles in the inobt? If
we've got a cycle in any other btree the metadir code might interact
with (e.g. directories, free space, etc), we're going to have the
same problems with deadlocks and/or livelocks on tree traversal. 

> + */
> +int
> +xfs_trans_metafile_iget(
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		ino,
> +	enum xfs_metafile_type	metafile_type,
> +	struct xfs_inode	**ipp)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_inode	*ip;
> +	umode_t			mode;
> +	int			error;
> +
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &ip);

Along a similar line: why don't we trust our own internal inode
references to be correct and valid? These aren't structures that are
externally visible or accessible, so the only thing that should be
interacting with metadir inodes is trusted kernel code.

At minimum, this needs a big comment explaining why we can't trust
our metadir structure and why this is different to normal inode
lookup done for inodes accessed by path traversal from the root
dir.

Also, doing a trusted lookup means we don't have to walk the inobt
during the inode lookup, and so the deadlock/livelock problem goes
away....

> @@ -1133,45 +1130,54 @@ xfs_rtmount_iread_extents(
>   * Get the bitmap and summary inodes and the summary cache into the mount
>   * structure at mount time.
>   */
> -int					/* error */
> +int
>  xfs_rtmount_inodes(
> -	xfs_mount_t	*mp)		/* file system mount structure */
> +	struct xfs_mount	*mp)
>  {
> -	int		error;		/* error return value */
> -	xfs_sb_t	*sbp;
> +	struct xfs_trans	*tp;
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	int			error;
>  
> -	sbp = &mp->m_sb;
> -	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);

.... and it's clear that we currently treat the superblock inodes as
trusted inode numbers. We don't validate that they are allocated
when we look them up, we trust that they have been correctly
allocated and properly referenced on disk.

It's not clear to me why there's an undocumented change of
trust for internal, trusted access only on-disk metadata being made
here...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
