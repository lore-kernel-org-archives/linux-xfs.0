Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9E723507B;
	Tue, 25 Aug 2026 06:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787639286; cv=none; b=fn5GYZuzHmfAGK4pzM5QxlC6kBqG+8XrH95WMmc88SskEMHSX7KfFUh0cFKMykjCGEA4vHoktn3aXxBP/3eU0cFzr+SJVlo64BVlVpj9ZnmOmiCyhFqLijHcBsGo325zcBlQDKTMMEYHHnNHsCDExOgmDbBQMK1vQ93luHNqCRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787639286; c=relaxed/simple;
	bh=Tt+95E+13UsmGT1SzdaThnkA+QPh64B9pqgm4Xy8nh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2EweBmBV4YvtIeZyPX2xldX0L+kox+k/Dv4WmuGd1tkgHQ5Hvp450yJZWJo+gF3BmDvp0uYFuqV6yisvcv3EoH+kWTgG0j0Wn4JTennO0j8wJ5Qsi2ytCl1xVQGmDWJUT/kmXMB3L1CXwqtO3mupiAA+Th01ONe2XTUZ00+Lu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 497D668BFE; Tue, 25 Aug 2026 08:28:00 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:28:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: don't stash removename operations with
 unknown ftype
Message-ID: <20260825062800.GB24324@lst.de>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs> <178760940721.944084.7350116310283813250.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760940721.944084.7350116310283813250.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:34:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that the behavior of xrep_dir_replay_update changes based
> on the ftype recorded in the stashed removename information.  It also
> notices that the unlink iops sometimes set that ftype to FT_UNKNOWN
> because the regular directory tree update code paths don't need to know
> the ftype of the child.
> 
> Unfortunately, this results in incorrect link counts, which eventually
> trips link count errors in later phases of xfs_scrub, or in xfs_repair.
> Fix this.

Fix what?

> @@ -1381,9 +1381,24 @@ xrep_dir_live_update(
>  		if (p->delta > 0)
>  			error = xrep_dir_stash_createname(rd, p->name,
>  					I_INO(p->ip));
> -		else
> -			error = xrep_dir_stash_removename(rd, p->name,
> +		else {
> +			/*
> +			 * xfs_dentry_to_name in unlink or rename-exchange can
> +			 * pass us names with ftype FT_UNKNOWN, but we really
> +			 * must know the ftype of the child that is being
> +			 * removed so that we can do nlink updates correctly
> +			 * without holding inode references.
> +			 */
> +			struct xfs_name	name = {
> +				.name	= p->name->name,
> +				.len	= p->name->len,
> +				.type	= xfs_mode_to_ftype(
> +						VFS_IC(p->ip)->i_mode),
> +			};

.. fix up the xfs_name to always have the correct type is I guess what
the commit log should say.

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

