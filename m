Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D1733ADA9;
	Thu, 26 Mar 2026 06:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774506047; cv=none; b=sVNijFV7xCF+43moX5mp6vQuK+5MogM0KGZKTwpmaneKNhxJ7UiEhF3qKx1NDEwI/2zra0mMEH5bHdv7dgzZbyettrhIkhUVmRRNfsnOEJL+siz21XHlSUSg+DqV14HMTfRrHUM5wZRf7Su5ddZUzoRPVZncb/dVQZEaaeNgcTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774506047; c=relaxed/simple;
	bh=L5mCeYEcaFRDUUDi/dw7QiG57n5VuYL+A0CHP/kf1e8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UgcLh+ElVVdmcnYEVX4Q90dSfWXIuGblH+KrxXDbdvmfksMZXVQRvEDT27nmrd7hJtJz3ZQWtFVG+L43+5iOndg4NRwP8pmKoJ5RFSV9javrBk+rMrxmMT70S65b0pwI44fkOBev337JANMs/acRaEFt7XinrZbJTgrhMVJGV/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1F63168B05; Thu, 26 Mar 2026 07:20:43 +0100 (CET)
Date: Thu, 26 Mar 2026 07:20:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: Re: [PATCH v5 01/25] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <20260326062042.GA23948@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-2-aalbersh@kernel.org> <20260325075402.GA952@lst.de> <3lllvimldwcgi7crh3kgwy3a5z2ng2ugcka52ab47o5mwx4dnu@xyzbelhykn7n>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3lllvimldwcgi7crh3kgwy3a5z2ng2ugcka52ab47o5mwx4dnu@xyzbelhykn7n>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 25, 2026 at 12:41:23PM +0100, Andrey Albershteyn wrote:
> > Btw, would it make sense to enhance the interface to tell why the
> > data vs considered lost?  i.e. checksum failure vs
> 
> > (part of) device disappeared?
> 
> isn't it something filesystem should report even before fsverity
> gets the page?

I meant the fserror lost reporting.

