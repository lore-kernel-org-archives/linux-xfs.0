Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D622D9EDB
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778229832; cv=none; b=X7HO0g1KUiumRCy3UG/7FCc00P0v4KmMf8qjdfJa1hL6tQZgYqWK2OZgwUT2YashdP1W249OxNugQfyixwdkifcpdaTtokZ5d1Y5Vp9vnQAHjK9dHC3FjRalPGtLI6V80IL4OAwh8Bfn++rTQib6L4OgQ260vkLArHCwvDKFKZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778229832; c=relaxed/simple;
	bh=oGsDnEblRNI63O4t2Kw7j/vjC/XnxHsgJpcRlWw7qmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GgFbSmAaILpazbzfJHOIEdRPRdapIBzPoREZIu1SSVE20FLBZfItXLmurMcdfPG+7jWjbXJF+jzggGDp/+7hLX0si4Otsshgy+0WftSyxDXIWEs/cJTpScx7HBg+jPXIOfXsF6KZ3hC4TzlXQbwVqIdH5RRdwd1ecApmBlHn2io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 17DA568BEB; Fri,  8 May 2026 10:43:47 +0200 (CEST)
Date: Fri, 8 May 2026 10:43:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Andres Freund <andres@anarazel.de>,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>, gost.dev@samsung.com,
	p.raghav@samsung.com, Jeff Layton <jlayton@kernel.org>
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
Message-ID: <20260508084346.GA19951@lst.de>
References: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r> <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6> <20260508081047.GA19748@lst.de> <610346dc-ba8d-471f-be38-2429c5646416@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <610346dc-ba8d-471f-be38-2429c5646416@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 08, 2026 at 10:29:38AM +0200, Pankaj Raghav wrote:
>                 } else {
> -                       if (inode_maybe_inc_iversion(inode, !!dirty))
> +                       /*
> +                        * Don't force iversion increment for pure lazytime
> +                        * updates (when dirty is set to I_DIRTY_TIME only).
> +                        */
> +                       if (inode_maybe_inc_iversion(inode,
> +                                                    dirty != I_DIRTY_TIME))
>                                 dirty |= I_DIRTY_SYNC;
>                 }
>         }
> 
> If you are tests are passing, then I can send a fix as a separate patch.

The comment needs to explain the why and not the how.   AFAICS the
why is that lazytime is not propagated to the disk at this mount,
so incrementing i_version should not happen, but I'm adding Jeff
for insights.

> 
> --
> Pankaj
> 
---end quoted text---
