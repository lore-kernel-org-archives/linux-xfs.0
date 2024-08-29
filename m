Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC804084E
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 02:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724897595; cv=none; b=JnE9SWCr/My2iX+n3nVuz6VJpVMVeGQjeJNDNmamm+2ECkJeo7egCYq3VZLhsO+0v2YeFQgR8SnGmvXyl2MBejwRMipjX1YEITV3c8/NEdTRTJ3LGB+klyRBpXvtx1oSSkysRzDEOmlrvKJGMIXsZf6ORNWjhlZXt57tvQggd0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724897595; c=relaxed/simple;
	bh=Xbe0tx+3OMdJXJ5Es2Ujzn9J+L1DIndwSf8fnwVAmws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9s/2pH1xD8Rzrl5uN/BVx6GU5bKDNKJ+zCTVIS5QHMgm43FR2QLFawEq4G4cxiY3C4t/Zh67RddgBUFy336bX1MAl4u15aig1sqbaCXFCaRAwWRwvJLMklZfwIDTXKlBaNWLOD+lsJo6bUgxP3gNledTLB3dRTj/9DZa01L6rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=esMMb9Fu; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="esMMb9Fu"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-71423704ef3so131154b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 19:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724897593; x=1725502393; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=67bQvZoVNsdiTCpVWzO1I4vyAmPSqzAo+fncMEZqvlY=;
        b=esMMb9FuRRrs1UaoZ/2PU1utM8wBAOsHvLIXTmmaGgT0fxAn6ezkjyAsEJYdfFOjhj
         xEc+ODVosV4gy/FC+Tg+K0h4ZW2M+LVKdsyoWG1evZ+s5M9N6yliszOVRYcxvo2VTi5J
         tT3QADxBJn8tDuuOyJUvmxDmWzv4eG6XSkxXgo8HPi3APoMteS3AwxtgPzMRtWf7i7sY
         Jyxrjyel0bAb67Op2XyayBCghumk3obwvM2+qVdoyPLzlE6ItcCtCRKIS56641E6t6qg
         6z+Kdz+75LR8AkFqyrppBaAi5Cj/b2okCbNHzysiBZ7zNa6Sfq71vQEmHRji/C2lLRfn
         PKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724897593; x=1725502393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67bQvZoVNsdiTCpVWzO1I4vyAmPSqzAo+fncMEZqvlY=;
        b=p0vbb9oLZfdVz5ghr/Do8goaPi9oVPCR8I1L4TqZ+uZEyncZzzJ48zayIMn7QBPI62
         fRtA4cI6glk7CWYrV0GeXfsHB/LexX7s5kiKBlwqCVtcog1JyX4xZ3Yn+vSvhMFiSkd3
         OffMCvc2Jg3kwJ5TpZ4kXkSiUZ7G9qlCtRNyYr45OIna4UPiIW5E58RVZlWAtZMCr4ID
         tT2+CAmAxiKTPLonuB+Nx0Wc+iMoZp8S8RtIDA2YecFVf5sNnbCrSx6H05mxt0DXkGpk
         dqZpI8k4EJiDmS0QjMnJbiMdKPWR4aUMZqhqhTW1g2MbPgtLGR/bPJOV0vcptYX5VbiT
         ngxg==
X-Gm-Message-State: AOJu0YyDKATIf5GbYfrfeJcq+IjshFQmGrwLDgf1BfyQmB5YcUlepsd4
	LzDPVKOChxfQcm/XYgrnyk8jno1SydTprKJd3/WT/BTRYW9FRTPGXZLPVBcxbrY=
X-Google-Smtp-Source: AGHT+IFQFtkzkAEQ+crF6b8M4KBdBpQITpjdpTNL9SZqJTSCxxDv5X7wDlnFF7o3sFmSphVbR41YBw==
X-Received: by 2002:a05:6a21:a4c2:b0:1c1:92f8:d3c6 with SMTP id adf61e73a8af0-1cce1046489mr1181119637.27.1724897592669;
        Wed, 28 Aug 2024 19:13:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-205155342dcsm1318835ad.151.2024.08.28.19.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 19:13:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjUer-00GPUk-1f;
	Thu, 29 Aug 2024 12:13:09 +1000
Date: Thu, 29 Aug 2024 12:13:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/10] xfs: refactor creation of bmap btree roots
Message-ID: <Zs/ZNSQ74BOefzUm@dread.disaster.area>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131627.2291268.8798821424165754100.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131627.2291268.8798821424165754100.stgit@frogsfrogsfrogs>

On Tue, Aug 27, 2024 at 04:35:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've created inode fork helpers to allocate and free btree
> roots, create a new bmap btree helper to create a new bmbt root, and
> refactor the extents <-> btree conversion functions to use our new
> helpers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |   20 ++++++--------------
>  fs/xfs/libxfs/xfs_bmap_btree.c |   13 +++++++++++++
>  fs/xfs/libxfs/xfs_bmap_btree.h |    2 ++
>  3 files changed, 21 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 00cac756c9566..e3922cf75381c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -614,7 +614,7 @@ xfs_bmap_btree_to_extents(
>  	xfs_trans_binval(tp, cbp);
>  	if (cur->bc_levels[0].bp == cbp)
>  		cur->bc_levels[0].bp = NULL;
> -	xfs_iroot_realloc(ip, -1, whichfork);
> +	xfs_iroot_free(ip, whichfork);

I feel like the "whichfork" interface is unnecessary here. We
already have the ifp in all cases here, and so

	xfs_iroot_free(ifp);

avoids the need to look up the ifp again in xfs_iroot_free().

The same happens with xfs_iroot_alloc() - the callers already have
the ifp in a local variable, so...

>  	ASSERT(ifp->if_broot == NULL);
>  	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
>  	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> @@ -655,19 +655,10 @@ xfs_bmap_extents_to_btree(
>  	ASSERT(ifp->if_format == XFS_DINODE_FMT_EXTENTS);
>  
>  	/*
> -	 * Make space in the inode incore. This needs to be undone if we fail
> -	 * to expand the root.
> -	 */
> -	xfs_iroot_realloc(ip, 1, whichfork);
> -
> -	/*
> -	 * Fill in the root.
> -	 */
> -	block = ifp->if_broot;
> -	xfs_bmbt_init_block(ip, block, NULL, 1, 1);
> -	/*
> -	 * Need a cursor.  Can't allocate until bb_level is filled in.
> +	 * Fill in the root, create a cursor.  Can't allocate until bb_level is
> +	 * filled in.
>  	 */
> +	xfs_bmbt_iroot_alloc(ip, whichfork);

.... this becomes xfs_bmbt_iroot_alloc(ip, ifp);

i.e. once we already have an ifp resolved for the fork, it makes no
sense to pass whichfork down the stack instead of the ifp...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
