Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87676207217
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 07:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633260; cv=none; b=LrYGZsBK62RUbylMvDhdccAthgoWxR3/98XurbTFC9dGv0dxXkn1XzjvpbYbmQv7k5KrvtRRTcl0pA1fCd+wXCarfkQ5bbsgbmrhwIGb78Ki4/heMr9l5HpiK9iu2rJgLAUcnAKHtsh2DWlyoFmixcEWdNa1iKlH55ubIyt3w8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633260; c=relaxed/simple;
	bh=lSDiw/HVpQL64ZF2N5Y4OZGPATWyX8GMjgAkpABxDmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAtb7770CnxdldPCdwLJRbHeigDmOik/UTpQ8tsNhx4Do5+Z3sBuHPX1J+i6jA1RNF5RRMsf6llzfguwoLsRF9PkVrTaZWm9MeAHa6PVuy7NQrogRwR+I4SX73MgmqyUqA1P/w+p9atBpyLJn2P1UJAqJriTyoUoW7wDQLKwhks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D173E227AB3; Fri, 11 Oct 2024 09:54:08 +0200 (CEST)
Date: Fri, 11 Oct 2024 09:54:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: split xfs_trans_mod_sb
Message-ID: <20241011075408.GB2749@lst.de>
References: <20240930164211.2357358-1-hch@lst.de> <20240930164211.2357358-8-hch@lst.de> <ZwffV8BDDJjr5xvV@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwffV8BDDJjr5xvV@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 10, 2024 at 10:06:15AM -0400, Brian Foster wrote:
> Seems Ok, but not sure I see the point personally. Rather than a single
> helper with flags, we have multiple helpers, some of which still mix
> deltas via an incrementally harder to read boolean param. This seems
> sort of arbitrary to me. Is this to support some future work?

I just find these multiplexers that have no common logic very confusing.

And yes, I also have some changes to share more logic between the
delalloc vs non-delalloc block accounting.

