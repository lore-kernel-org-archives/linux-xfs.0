Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609FA364049;
	Tue, 14 Jul 2026 06:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009700; cv=none; b=bVVetccCT2atIdBVxxFsKimixjq8Ur/c28Z1dRGofQYs1AC7Va75QQQAxDoVb/7uVJ0q10hmI82gPihh4zMtYNJ8uSdLO9Xmzp/C3LO8DxNyyPa5JdM0juSRbUCQKAIF7fBu7d54Y4K/8lnkX8UMxNpIt+78DHljdHtXbofAR3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009700; c=relaxed/simple;
	bh=WKt7qoSABRdFGNTGJQ47+rSoGC3pWsQ3j5tR4p/1u7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkZeeAAIamLwWO0rFtKOGE5Tfu2OdZhwGGb/LV6t8k3Z/J9Pw26oDfT7MhxwByukGfcimv6LPPd8WU99K6XMi2dMIHbjQCQUMIEKe322G2vaAjTDCbrHIZiMevTGCKyuMPA+Eosyoy4efIbycjxem+Dm2ULMm+jtw/1/c/vMFxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DF69868BFE; Tue, 14 Jul 2026 08:14:56 +0200 (CEST)
Date: Tue, 14 Jul 2026 08:14:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fully check the parent handle when it points
 to the rootdir
Message-ID: <20260714061456.GE1072@lst.de>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs> <178400716902.268162.497307588168425150.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178400716902.268162.497307588168425150.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 13, 2026 at 11:06:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that the directory tree path checking declares the path to
> be ok if the inumber in the parent pointer reaches the root directory.
> Unfortunately, it neglects to check that the generation is correct.  Fix
> that by moving the generation check up.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

