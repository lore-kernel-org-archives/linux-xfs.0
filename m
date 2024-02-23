Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ED082D74
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708706265; cv=none; b=hHglvu/+9s48z/PnbfFPwm7HAjXPohBjkYsEMspdVEDEQci+yjwVbWuISBA9wFlyVc/iQcBC9YPyYdzsi7P5OH5pby+VJrCvAp5/3BfosJ2gOAF7hkM1j5apJOQa1CBPV07UQ8JEafimroSXI+AF+sZyLgbdSFGEKKCVv8TpgL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708706265; c=relaxed/simple;
	bh=4i5emWT0APjWLlJYhFfgioJFVD9dNBTKJEJHUXKyetg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NEWiv6nqWO0QofKPu1VXyTInvWrJZG4fOZE/1G9BXHaPjsO325nynKa7QaGFJ6IXt8IdL9BUqVbnaCSOjfjtmvv1Za9B7edf6VQQOLo7ePLnsfFNzTOkoSrK+wQdJV8gq22MBYR4V7YL7MpLTrq7ZQ8aj00B02m7bt0kv9oaZSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC31C68D09; Fri, 23 Feb 2024 17:37:37 +0100 (CET)
Date: Fri, 23 Feb 2024 17:37:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240223163737.GA3410@lst.de>
References: <20240223071506.3968029-1-hch@lst.de> <20240223071506.3968029-3-hch@lst.de> <20240223163448.GN616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223163448.GN616564@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 08:34:48AM -0800, Darrick J. Wong wrote:
> I don't really like using transaction flags to record lock state.
> 
> Would this be cleaner if we tracked this in struct xfs_rtalloc_args, and
> had an xfs_rtalloc_acquire(mp, &args, XFS_ILOCK_{SHARED,EXCL}) method
> that would set that up for us?

Urgg, that would be pretty ugly, and not work for the new locking in the
extfree item once you add that, which has the same weird layering
violation.

The only "sane" way out would be to always use a deferred item, which we
should be doing for anything using new RT features, but we can't really
do that for legacy file systems without forcing a log incompat flag.
So while I don't particularly like the transaction flag it seems like
the least evil solution.

