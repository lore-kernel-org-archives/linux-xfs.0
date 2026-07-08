Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264223FCB33
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 08:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783498421; cv=none; b=XY5xz8Ab72dD22adwch5mXn+e/OikhY2Z3Be+Fqva6x0BbTmO+/YjuNospxr6nt55f/O2d1uGYzOtgOO8CYYHBF+wosR+c+CJDffSrxo2Chz7NpFWBlrT6HEOM1jMDH5pokaXMapyD1RUrjXPQRGrQQODZ+VAaCO9VQrdJ2ad14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783498421; c=relaxed/simple;
	bh=mYdNyVEWwcAkraH5yD2lt74s5q887QxOthr8aEdS73w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j55dIUGoXIyUnxNm/MUd05yND5QrKlAYRb3U0mSdCTzCtEIvYnMEkE6KhxthhSfYRhEpxhs3fhC+hEHbzH6AMIGnQURDPJQy+y8ORj2KdDJpU2ffJxq3lysQop2n0muo6x1TnjUOp1V4XbXX1sHreYcPMsqpoKyG28kcoJ8krKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E02DC68BFE; Wed,  8 Jul 2026 10:13:34 +0200 (CEST)
Date: Wed, 8 Jul 2026 10:13:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: fix spacemap scan for internal rt devices
Message-ID: <20260708081334.GB1198@lst.de>
References: <20260701145124.GE6526@frogsfrogsfrogs> <20260706065035.GA25419@lst.de> <20260707164202.GD9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707164202.GD9392@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 09:42:02AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 06, 2026 at 08:50:35AM +0200, Christoph Hellwig wrote:
> > Btw, the current xfsprogs for-next fails a lot of xfstests without
> > this.  So it would be great to get it in ASAP.
> 
> I'm assuming Andrey saw my most recent PRs:

Note that the failures are without any of the series, and none of
the series seems to include this patch.

