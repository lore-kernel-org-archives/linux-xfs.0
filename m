Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A47226AD0
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734286238; cv=none; b=ISKOR5r7idW3ZwyGVsQRfxSVfNoFLIhcT5O5RRLhuzRivE1TwFdm8NhiSJKL2BJa5MLNRn864HscHIFmEbLNDWuamA2xaqQPXT2+rQ6s9wpKADVQldDsDOtlgWvQ03pzN7ZlwflbmbrxuiSPmvdUx6/M6c1JjHUmEDjQLdGP+r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734286238; c=relaxed/simple;
	bh=MNzjAmpfUOWIF17TpFhtxdSwPpG1b/94vZJcso4VjtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJzqHetJVBcupUqGiE3Ea5Y6xqFHckAp1OBgnfH79k9tNo/+7AYDpeouuglFBDZ607NNeNHwWb4uvc28kFM7Jl6sTs30o5Gti6RPHKDOceiJVBFWIfrM36/0JjW0T2ikUkF/Am99v4FzLyQRQJk05uCwffmR9RCDzhIJX52R7jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZgSsWDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZgSsWDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA908C4CECE;
	Sun, 15 Dec 2024 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734286237;
	bh=MNzjAmpfUOWIF17TpFhtxdSwPpG1b/94vZJcso4VjtE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dZgSsWDrzjs28nVltvmnFgMkohNUTXZrwwc1a5eJdq/MO8dsDvTMnS7pf36wlYciZ
	 zYqOVopv57UIczPTk7SC0HJ/dYHqxxEcz0jt73ELIytYX9g1gw6a20K3kBhVWNFOMX
	 i/4mTeTRbdmWf0BmZFkDhN1fJFeJpnUJKIlRE1ulLONwHJ6V02B29adrgqCm0O0gh7
	 +HGUhV602cDpLTK0/efuj8nLaQpRXRYrDxJykL/yUq5B2ejc1ZaBxaVGQwFPQvIxvs
	 u2TSP259WDxnDTcOCdSk5GJC28kr7L3Goxo4Z0azN3Z9mJ6HMC5om+WRBjs0mvg5aL
	 0AkxXAN49XXMQ==
Date: Sun, 15 Dec 2024 10:10:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/43] xfs: add a rtg_blocks helper
Message-ID: <20241215181037.GA6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-4-hch@lst.de>
 <20241212211225.GP6678@frogsfrogsfrogs>
 <20241213050045.GA5630@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213050045.GA5630@lst.de>

On Fri, Dec 13, 2024 at 06:00:46AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 01:12:25PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 11, 2024 at 09:54:28AM +0100, Christoph Hellwig wrote:
> > > Shortcut dereferencing the xg_block_count field in the generic group
> > > structure.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks good, though I imagine there are a few more places where you could
> > use this helper?
> 
> While the zoned code uses it a lot, there are surprisingly few uses
> in your baseline.  But when reassuring me I noticed your recently added
> RT-aware failure notifier could use it, so at least one more.

<nod> Well at least it's an easy enough cleanup after all the dust
settles. :)

--D
