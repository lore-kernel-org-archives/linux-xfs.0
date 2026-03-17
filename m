Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033E73C661E
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 12:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773752176; cv=none; b=YwJyGu1XIV7EuXGpVua3r1dOFPoOY2lhL7T0lHcFyInnCKRienhh0t4HWIWWQdgWdOXJbCyhKxauq+xorFxs+65Ze5LftgC/Am4WDtW3ltR1dvM58i5s8IPrWhK5KCDh1NWZk+xKOdPERS6fNxJmdvKR9zHO95T8WWMXsZtPByI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773752176; c=relaxed/simple;
	bh=wzBatzntpf5UFL2haH5NzDpo5Ppx2iTqwRiXK/nYvHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwj670q57CBSUVGwytyHPGF0XjUxhi2bdmj6NHcUd1c+lmBz63xhurVyk+z4wedMTwDtR5u5jzEk34K5AWR1EpFDPM24HfdFVaeSHZgrdaCOczrXDNkk0XAy3F3UWR/gRaN9MBWmsdMMxz0JTrL7y9oGwbk7XFXtzAgIiaG+AOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DBB0B68BEB; Tue, 17 Mar 2026 13:56:04 +0100 (CET)
Date: Tue, 17 Mar 2026 13:56:04 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: buffer cache simplification v4
Message-ID: <20260317125604.GA29925@lst.de>
References: <20260316154216.1598410-1-hch@lst.de> <ablFUL_cBSJBJHgp@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ablFUL_cBSJBJHgp@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 17, 2026 at 08:13:04AM -0400, Brian Foster wrote:
> On Mon, Mar 16, 2026 at 04:41:32PM +0100, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series has a few old patches that simplify the LRU handling, and
> > moves back to only having a per-buftarg hash now that the buffer hash
> > is using the scalable rhashtable.  While some of this looks like
> > performance work, performance and scalability is unchanged even on the
> > 80 core dual socket system I test this on.  Besides cleaning up the
> > code nice, it also happens to fix a syzcaller reported use after free
> > during buffer shutdown, which happened incidentally because of how the
> > tear down of the buftarg vs the perag structures is handled.
> > 
> > Changes since v3:
> >  - split the change to handling how referenced buffers on the LRU
> >    are handled into a separate patch
> > 
> 
> It looks like there's a patch ordering problem or something here. It
> doesn't apply to master, and looks like patch 1 is trying to modify
> hunks that don't yet exist. A local rebase issue related to reordering
> the change in patch 3 perhaps..?

This is against the xfs for-next tree (commit
f8544b654f22b1138ba12bc0971a96963b20311d)

