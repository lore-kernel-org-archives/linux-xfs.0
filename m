Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7A179F5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067434; cv=none; b=P1yIsedCWiuWPrLetTHS1WJrmDHNlXmWnmSsyaLXsDlPOkIZdBcoA3nbthYERM3Es+GgaR17DHTJmFkmSiNDt2PJb7M7xwKZHbdO26Cy0/REPNPYZUzvpf+1koFmrR4Stm3a51chzpxojISHwIxc5erYQWRvYW0yix3Nv4+MmQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067434; c=relaxed/simple;
	bh=7Jct7clYYIRbFqqeKfBk19aCO0u7Ya6sKFHzIGmEXJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hz1s49Ic1VfTnytmaoM8g9N25iixSscPMGOFLQPzPO/rcnK3xHQIg9Gkuco22+B1cNG5vx9Y6amDw/tZuhc3vw2Ea7W3lcttaFDae6S+XaEydACnlqom8EzYasmMC27hlPI3QNLK0cRMARKOJPkbGRGKZSlT9NCnKuUZnWFBl40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A9A2F68BEB; Fri, 13 Dec 2024 06:23:49 +0100 (CET)
Date: Fri, 13 Dec 2024 06:23:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/43] xfs: export zoned geometry via XFS_FSOP_GEOM
Message-ID: <20241213052349.GM5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-19-hch@lst.de> <20241212220913.GD6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212220913.GD6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 02:09:13PM -0800, Darrick J. Wong wrote:
> > +	if (xfs_has_zoned(mp)) {
> > +		geo->rtstart = XFS_FSB_TO_BB(mp, sbp->sb_rtstart);
> 
> Not sure why this is reported in units of 512b, everything else set by
> xfs_fs_geometry is in units of fsblocks.

Because I didn't update it when switching the sb field to FSBs per
a pre-review request :)  That being said the sectors actually work
pretty well for the users in xfsprogs, so this will create move code.
But I guess that's worth it to be consistent.

