Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B61032AAAB
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785253652; cv=none; b=MKPdRsj3ikhXwHBf7PssscTVtbRVuKF4SIErBogUFSIUNRA85CRX9hk2RT2+rTKaRsTm/Fpvr6lMDQDGzdJNEAbnQrB3XB8P0b19Vvvt672yBaQOXqW43Vi7g2iazhe+TLxrRpfoPuN4wdlQ0lCJ/tUQNjDa0nORZv10xModUKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785253652; c=relaxed/simple;
	bh=rqc2VA8SAASTkN6SsDCbItMaEr7gk9vTjz4Rka8sNT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e4MEnZsCRltkAzcFswEn2IKonHdKZ6yz+dHI263yvJicC/upnHZdOrPWiPxRUb0V5ohm+HHGFxPDfH2Qyr1Oi6R7tAkKtAnIPVxWuUUTnGn78POzPh4E9gqUo9pSMl7RZrBI9dwfydzPc+g0gVIAThVuSNCZ5K/MDgaWBQdcIkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxScvnjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxScvnjp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ACB2F1F00A3A;
	Tue, 28 Jul 2026 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785253650;
	bh=5lDhj9UPkpfynvE949VHuhs1/Ze+fr2ItKpOMxwlNCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IxScvnjpLWliSDNtZvz8twe1GoDOWiMy4aeylnuhZkBRDBDPdJBrlFxl+A921pSnx
	 t1kH0JNZR4qCh62DNKSFfcGpT48egj0IEU4KAAUUOgFVvDNDvU2dhtqq3J6imjqHAa
	 St/Qseum0DB3Tf00UpeWIttS8UO7A+S/4wwTJHO5oIF/ZJUytb5rC8CsKdInE9yxXx
	 DRM2dRMqRFAb7PUXFy2ihpFbRTpphVn3rlyjxCx+TlkUN4mPNmEb0WdLD15fzIuVH/
	 78j0DVCYgiBvGestFwFjfUgznXh2kD2SIcGLH0LEpBswcAv6bNp0Z/40/R6KpdGEce
	 yvga+rRiVJyyg==
Date: Tue, 28 Jul 2026 08:47:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check v5 superblock features early
Message-ID: <20260728154730.GS2901224@frogsfrogsfrogs>
References: <20260728080435.1777362-1-hch@lst.de>
 <20260728152628.GN2901224@frogsfrogsfrogs>
 <20260728154207.GA10775@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728154207.GA10775@lst.de>

On Tue, Jul 28, 2026 at 05:42:07PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 28, 2026 at 08:26:28AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 28, 2026 at 10:04:35AM +0200, Christoph Hellwig wrote:
> > > When working on a new features that reuses the existing pad in the
> > > superblock, I noticed that mounting such a file system on an old kernel
> > > logs a rather confusing warning:
> > > 
> > >     XFS (vdc): Metadir superblock padding fields must be zero.
> > > 
> > > This is because we only validate the various feature fields in v5
> > > superblocks after the common superblock validation helper is called.
> > > 
> > > Fix this by calling the feature validation first.  To make this more
> > > obvious, rename xfs_validate_sb_read to xfs_validate_sb_features and only
> > > call it for v5 file systems.
> > 
> > Shouldn't it be called xfs_validate_v5_sb_features then?
> > 
> > Oh.  There's already a xfs_sb_validate_v5_features function that checks
> > that the v4 feature bits are set correctly for a v5 filesystem, and it
> > would be confusing to have both.
> 
> Or just stick to the old name :)
> 
> > Could we move the code in
> > xfs_validate_sb_read into xfs_sb_validate_v5_features instead?
> 
> But yes, that does look sensible as well.
> 
> > If you do that, then xfs_sb_good_version will validate the feature bit
> > recognition, which it doesn't do now.  I'm not sure what weird side
> > effects might result from that though.
> 
> None in the kernel, but userspace has a lot more callers that need a
> careful look.

I /think/ the only visible change to userspace is that the code in
repair that checks v5 feature flag recognition now becomes defunct
because libxfs_sb_good_version will catch it first.  But the
xfs_validate_sb_read code will already log (more or less) the same
complaint so I don't think it will have any real effect.

--D
