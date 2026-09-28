Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB9C37DEA3
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 05:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572538; cv=none; b=HPQPMQs1R4wYvERmD10HXaJNszJGWgjhA7F+u/NxuDmfSMunu5I1VlnGsundT7KbjLN1Z4m+R9Sa0a6Ka3SD5uLVY9sDF5L3IJo8DWS7FWswtYazFD3cKxz66n2RCdDxv2PW4UYdAiQZP47Z5bME5bfSLSV2XvbAUnVS9sQG9Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572538; c=relaxed/simple;
	bh=PMtSsiTxPK+YxJNYik9MSdJZmnF6eC0AW1VpuK6hl64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPkOCMDmQXtDx+/q//6nLFMez2Sfx235xs9/IL387l4vXImQUKjmgiJriQ+i+4aEQL9eOFXN+Rl9GN1hihOqgXvGRlXR1aywZRPStRvLNCM5YqNvSo3ESDRUVJfrRW7sherifcEE5Y6NdduZuVS+JZrBUsNpm1sXxY+308Sixxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EC07868BFE; Mon, 28 Sep 2026 07:15:30 +0200 (CEST)
Date: Mon, 28 Sep 2026 07:15:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't let racing writers consume the free zones
 reserved for GC
Message-ID: <20260928051530.GA18833@lst.de>
References: <20260927124841.31314-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927124841.31314-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Sep 27, 2026 at 02:48:41PM +0200, Hans Holmberg wrote:
> xfs_try_open_zone() checks the free zone count to avoid grabbing zones
> required for GC forward progress, but does so without decreasing the
> counter, letting multiple user writers through to call xfs_open_zone()
> and collectivly gobble up all free zones, stalling gc and eventually
> leading to user threads getting stuck waiting for free space.
> 
> Fold the check and the accounting into a single atomic claim in
> xfs_open_zone() instead.  The free zone count is decremented before the
> zone is looked up and given back if none could be grabbed, so the reserve
> can no longer be raced away.  User allocations only claim a zone if that
> leaves the reserve behind, while GC just needs one free zone and thus can
> still use the zones that are kept for it.

Ouch.   Yes, this looks good.  One nit:

> @@ -460,11 +483,12 @@ xfs_open_zone(
>  		if (atomic_inc_not_zero(&xg->xg_active_ref))
>  			goto found;
>  	xas_unlock(&xas);
> +
> +	atomic_inc(&zi->zi_nr_free_zones);
>  	return NULL;

This NULL return case now is a bug as the earlier atomic decrement
of zi_nr_free_zones should protect against it ever happening.

So this should have a comment and some kind of warning (WARN_ON maybe,
the usual XFS_IS_CORRUPT doesn't really fit for a pure in-core issue).

