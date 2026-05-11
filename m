Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C934A3BAD90
	for <linux-xfs@vger.kernel.org>; Mon, 11 May 2026 08:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489811; cv=none; b=Iqi+zzPs7xiaZ1w9UP+7XUKax9r+vwzSHxdIo1cco6HfgkFUipiunSXLqjlyhyxD7WCSVldrfJsjk3WUGpo4/Vr8AIb+PwQKdGOfUdiah/JKxamAqUuhquIk2qn+EeXtSzgCGR0Lu/n71OIP7SmQrtp3Hra1N/Z/hsvWfASC1Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489811; c=relaxed/simple;
	bh=izop3LthyGEenI5lWqcHlst2Lx6srKFIBx4MiTJ2IlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tr+D7mXNSCx7YvueOi9gLPUS9ahcUWK2ZgGbe4K5ybS/UdIEsjOf8yw8bW25rp4HS2+Sv9VsNZDxP0a9QHrLDkkfdJy7ncgM4gO98gKw7s4RDGvxGoWJ0fyHitukVAHRBnr18q9jHhkoXlWusjL75GRZu9/MnXWSNA8VaSbM0iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CF7A468BEB; Mon, 11 May 2026 10:56:45 +0200 (CEST)
Date: Mon, 11 May 2026 10:56:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Jeff Layton <jlayton@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Andres Freund <andres@anarazel.de>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>, gost.dev@samsung.com,
	p.raghav@samsung.com
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
Message-ID: <20260511085645.GA1186@lst.de>
References: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r> <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6> <20260508081047.GA19748@lst.de> <610346dc-ba8d-471f-be38-2429c5646416@linux.dev> <20260508084346.GA19951@lst.de> <08a84b78e83a61b7dd661df32ac31d87b98ccc9c.camel@kernel.org> <334a4d92-887d-4572-b153-25906148601e@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <334a4d92-887d-4572-b153-25906148601e@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 08, 2026 at 01:47:58PM +0200, Pankaj Raghav wrote:
> -                       if (inode_maybe_inc_iversion(inode, !!dirty))
> +                       /*
> +                        * Don't force iversion increment for pure lazytime
> +                        * updates (I_DIRTY_TIME only), let I_VERSION_QUERIED
> +                        * dictate whether the increment is needed.
> +                        */
> +                       if (inode_maybe_inc_iversion(inode,
> +                                                    dirty != I_DIRTY_TIME))

Looks good, thanks!

