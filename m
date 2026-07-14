Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C902FFF8D;
	Tue, 14 Jul 2026 06:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009817; cv=none; b=SiQnp+sUvGJHSfgrl91a1kmfK9adC127fsgIiyFqunVYjwrMEHNTjXH0ofwdJE8dLu0Uax1zGjJc4MLq/sXx+s8qYelXYM/0Gtw4TYvj8jdWSseHrTS3Lv2ojh20qr0u/r6tdiEEiYe5/Ktbj/Z1T/YpPxq4FmN8ttQSW8OHPDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009817; c=relaxed/simple;
	bh=ptivHWiJrUy+fIVmhzObpUMawV9QrSkHPd+g2Cap4VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+mPVcX4kM2VSD+V5UZ7jmZ68/OVHEziXbbIq4h3QeJJeukWzV9tcEpEarF1t/R4TMo/a0z9OGxt7sZRpG1H2Yvq6dBpg+w9/Zwoj63QRZ/HZCSbraRcaf+6gfS4JyqpMHrT5MG0QkOjLpAPyVXFAfZZV3HteirlchzsXVQrQrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 49AA868C4E; Tue, 14 Jul 2026 08:16:52 +0200 (CEST)
Date: Tue, 14 Jul 2026 08:16:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't zap bmbt forks if they are MAXLEVELS
 tall
Message-ID: <20260714061652.GG1072@lst.de>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs> <178400716946.268162.18317924649043454437.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178400716946.268162.18317924649043454437.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 13, 2026 at 11:07:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed a discrepancy between the bmbt level checks in the libxfs
> bmbt code vs. the inode repair code.  We do actually allow a bmbt root
> that proclaims to have a height of XFS_BM_MAXLEVELS.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I guess we need a test that actually creates such a deep tree.  But
we'll probably run out space / extents before..

