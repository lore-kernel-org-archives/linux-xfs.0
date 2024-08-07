Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD267E0E9
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723041492; cv=none; b=r9aHbHC41m1w96i7gcNW5vpgVuqtJrH5wAy6Ofz8U0YVJYV63DUaqfoEA8yCV8N1A9f2oPti6g7TjVxiCp+4+cuV2G+41IMCIBfQmp8hyiYxVH+eGG8zqtkLUf7VpozLx8cVtmvjPsFkkF6eSXT3uomkEmRDQpUE77WCzv29nC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723041492; c=relaxed/simple;
	bh=k0Pc16e32nVgTdSf4HJK7Bt+9hKgL3zlReuj1Hk+bZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VawBq5HH9nRqvMn8frezh7nQRzYD4kx1cDRffVsr0a6WdtbvH7mya9upNouucSwBBCRzyxXT5V5xNh7xtalOnSZj2Zlvg0iimby8RknQVivObwujv2MHh3EqkaguSC5y6ZN0QgrmLAmCCHjXVGHk0RKHGR+AhgZ4JIiZquZAZXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D0DE968C4E; Wed,  7 Aug 2024 16:37:59 +0200 (CEST)
Date: Wed, 7 Aug 2024 16:37:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: xfs_release lock contention
Message-ID: <20240807143759.GA3175@lst.de>
References: <ejy4ska7orznl75364ehskucg7ibo3j3biwkui6q6mv42im6o5@pzl7pwwxjrg3> <ZrMJmfYfaT4fxSNM@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrMJmfYfaT4fxSNM@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 07, 2024 at 03:43:53PM +1000, Dave Chinner wrote:
> Hmmm, I thought I saw these patches go past on the list again
> recently.  Yeah, that was a coupl eof months ago:
> 
> https://lore.kernel.org/linux-xfs/20240623053532.857496-1-hch@lst.de/
> 
> Christoph, any progress on merging that patchset?

I expected them to go into 6.11 but they didn't.  I'll resend them
after retesting them as there weren't any actionable items except for
a few typo fixes.

