Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D803BED18
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782493757; cv=none; b=eRlKnRYjNcqhrdM1zddLSg7rt+CdDn8en5lAcDlJ5onEE9tYlz9k6AOv2YzsaRaq9c02LZDvWQnNmSkwJwt3F+RmNagvVFVJ5Pz3211W7ve4tUzNVMrJQ+68+F29S+GKIpsVwOwm++Ci/dTAFReRo89RAZgUgDmEf5WgO2tPqnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782493757; c=relaxed/simple;
	bh=WXfyiQteaFoJeR0fzQflbkAo0xWhetNg5Baf+oKP5EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XTH348S+jM7VeGb2s9qFY0EOih2atTOd5os7xq6qd5V0x3IddCRYvmxtMvlFmU3yc2lAEVnOwN3XmRWYnzhjRyv+y/ndolPA1EjxViV80NwYy0y5KKtqlQaYEr3GOjEfIBVF9Dx6fH9HVcxnDLSRqpUS1F4LPmnjIwkKJyz2+ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPf55aCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPf55aCz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 82C311F000E9;
	Fri, 26 Jun 2026 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782493755;
	bh=ZImoXsky9OxflOmZYad0gCNBB0sochTLvGB3cE/kLXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZPf55aCz/Pnh4kpv+hRY5N07r3X/by6vHOs5XgfjcLE7cxZaaUgoDp50UGx4LjLVJ
	 3+rYvvEGlrtkNHlWcCMMHacAAZ3qpe/0m10VuCwl+64NCcJmwcvEU/1gN5SDiAiOzL
	 ZlwIPFOF5VVbI9ne1SxirwdDg+aqFCyv1EMNQS1uMOseWPn/7a1s8M2G31j8Qt8W3W
	 3Ll/UYhrQFlgjajsv2LH5wkmvwS3t3KPnNUNdZT7Tgw+pXQuIk3cXVg6MHuxcOGm5G
	 x41hq5e5zDpEV0UOZ4DPGGlrDPC1VY0udFlirOosR5XbtKaIGOfvFSBEPqrI/o90ON
	 szyrS7mruuG9w==
Date: Fri, 26 Jun 2026 10:09:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs_scrub: fix spacemap external log device scan dev
 key
Message-ID: <20260626170914.GZ6078@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
 <178242801378.1981574.12871573702305819173.stgit@frogsfrogsfrogs>
 <20260626050345.GD8786@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626050345.GD8786@lst.de>

On Fri, Jun 26, 2026 at 07:03:45AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 03:55:15PM -0700, Darrick J. Wong wrote:
> > --- a/scrub/spacemap.c
> > +++ b/scrub/spacemap.c
> > @@ -213,7 +213,7 @@ scan_rt_rmaps(
> >  	scan_dev_rmaps(ctx, ctx->fsinfo.fs_rtdev, arg);
> >  }
> >  
> > -/* Iterate all the reverse mappings of the log device. */
> > +/* Iterate all the reverse mappings of the external log device. */
> >  static void
> >  scan_log_rmaps(
> >  	struct workqueue	*wq,
> > @@ -222,7 +222,12 @@ scan_log_rmaps(
> >  {
> >  	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
> >  
> > -	scan_dev_rmaps(ctx, ctx->mnt.fsgeom.rtstart ? 2 : ctx->fsinfo.fs_logdev,
> > +	/*
> > +	 * Internal rt sections (rtstart != 0) means we use synthetic device
> > +	 * keys for external devices.
> > +	 */
> > +	scan_dev_rmaps(ctx, ctx->mnt.fsgeom.rtstart ? XFS_DEV_LOG :
> > +						      ctx->fsinfo.fs_logdev,
> 
> Maybe this should be using to_fsmap_dev instead?  Move the call
> to to_fsmap_dev into scan_dev_rmaps for further simplification.

Yeah.  phase7 could use from_fsmap_dev, so I'll hoist both to spacemap.h
and clean up the callsites.

> scan_rt_rmaps seems to have similar issues.

I don't agree with that since it's only used for pre-rtgroups rt volumes
which can't be internal, but it's trivial to clean it up along with the
other callsites so in it goes.

--D
