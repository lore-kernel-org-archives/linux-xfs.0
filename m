Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B483264D8;
	Thu,  7 May 2026 05:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778133141; cv=none; b=j4uUlczTm4MAlVyU16ZF3OfawQqtylQDhi4A2RLCplLUE2Yx1Wib8WIWe1t4h0BDZCPvjCi3UNoJ4TP8zoH8sseM0l6WQ1J/xIeUcyDmp1orr+P0Ty+87MQKzhm2p62oB+qDX1DqXBsSds8ds8baEuQRN7l8zChAVRF5vtLbd1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778133141; c=relaxed/simple;
	bh=kgPalJv7veT0KOeNATxyzEZn/BLemJspD2/UygeoTGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AH5r+BmuH289LtNNUuYE5KJ0DeJqCxQj3wJjCqSy4I3PAUjGjxLHi+OTse95QTrHEnMHdWUXAmeYrkg1cAgQjdbBZ3AwZqo+s0bir/u8HVL97TKTxgIyF8jCUEsSe478pkSi/P1z4hm4Ojq5XfQY1Z2tzJ/G1c24PQRjPIFOcqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6C60468BEB; Thu,  7 May 2026 07:52:17 +0200 (CEST)
Date: Thu, 7 May 2026 07:52:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v9 00/22] fs-verity support for XFS with post EOF
 merkle tree
Message-ID: <20260507055217.GA19888@lst.de>
References: <20260428083332.768693-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428083332.768693-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 28, 2026 at 10:33:06AM +0200, Andrey Albershteyn wrote:
> This series based on v7.0 with Christoph's read ioends patchset [1].

That's not a good baseline.  We'll need it on the -rc that has everything
from the current merge window at least.  It might also interact with
the fsverity fix that just went in.

This might also be time to come up with a merge plan to figure out through
what tree(s) to merge it as there don't seem to be any maintainer
objections.

