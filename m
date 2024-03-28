Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F56B1C288
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 08:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711614322; cv=none; b=cpJQxlNrI1n2EpvbHwQnrUkdki6dnaDDSBQlSYJZxbaQ7rxGBPlFXnBZruIEGDcsrSbEpp74GyTGYpZZvQ6Uugwz7jGRGqPLeeYWd04xprZpSpukZMZkrC/3kVVeoq98N1g3e1FACqmpUdffW0GumO6kWwoaPfy5xi47ROjb1oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711614322; c=relaxed/simple;
	bh=50WdDq4/vKbkqQ8q5GWy6nhkboO8241GUGNq6fC+Ljk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2MECbCRGxMxDchvc28mtInxb4H47E1HodIsZF8t4kRBqc9tBxSJtl7EQp45qO9NV3+3wePNO03OgbBiHYd/MFgP677usyWyD+5QN6tx+Gm1dE9mQfRr8Bc94dKz6iCQUIqzNq7aCmCu7MMo+Q1uuNRjvs7jTxvQIVldTyobh5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5E5268B05; Thu, 28 Mar 2024 09:25:16 +0100 (CET)
Date: Thu, 28 Mar 2024 09:25:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240328082516.GA19416@lst.de>
References: <20240327110318.2776850-1-hch@lst.de> <20240327110318.2776850-10-hch@lst.de> <ZgTxuNgPIy6/PujI@dread.disaster.area> <20240328043411.GA13860@lst.de> <ZgT1K2OH/ojXqcu2@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgT1K2OH/ojXqcu2@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 03:42:19PM +1100, Dave Chinner wrote:
> > Unfortunately there are different.  For data device blocks we use the
> > lazy sb counters and thus never updated the sb version for any file
> > system new enough to support scrub.  For RT extents lazy sb counters
> > only appear half way down Darrick's giant stack and aren't even
> > upstream yet.
> 
> Can you add a comment to either the code or commit message to that
> effect? Otherwise I'm going to forget about that and not be able to
> discover it from looking at the code and/or commit messages...

Does this look good?

http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=91bbe4c2d5518a1f991d7f19aad350d636e42d32

