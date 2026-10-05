Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFFC48FF72;
	Mon,  5 Oct 2026 13:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206807; cv=none; b=B/vp1P/HUVmMYr6RkIlYx+CGfbo8irBlTcJVpRfO3wQIVJ0taoSyNkFeHeGYjBZcLkbf9A5BUMKyAYBUw2M4osqf/9ct9eVPjMmJc7VtW19DTAKUyTLRlx1yqjS6P9XYCDRa79RNp8W/VqU96MTtWAj1u7EIROzdRUVieRR+mnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206807; c=relaxed/simple;
	bh=lF6kWqOFuoCAAWCsILq7k5J4xhOuhJWjp1rOutnC6sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QL0m+Yn3uT/ek23jZ7TWmJ5zlIZmpauNRbN9QphYTHkgfygtQ3ugZiuk6JODHjubc0xYRsg49iDM1pjJ3Gd7ug76HPPMRJQdUt0Y9DELzveI/Pv0c+2lI2cTeRBjUaVx4gvNtlxcZlqwCFt5qjtM4QSE7IL8C77Iw5PeK5uxxqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F028D68AFE; Mon,  5 Oct 2026 15:25:22 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:25:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs/2304: version of generic/388 that run
 xfs_scrub -x for each iteration
Message-ID: <20261005132522.GN26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-10-hch@lst.de> <20260929015645.GL2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929015645.GL2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:56:45PM -0700, Darrick J. Wong wrote:
> > +	$XFS_SCRUB_PROG -x $SCRATCH_MNT >> $seqres.full 2>&1
> 
> I think we should just change generic/388 to run xfs_scrub after
> recovery, and add -x if data checksums are enabled?  That /would/ have
> the effect of catching recovery errors (or scrub bugs) earlier.

My idea was to key it off XFS_VERIFY_FILE_DATA.  But yes, generic
is probably better if no one screams.

> Though I wonder how much that reduces the number of loop iterations over
> a given SOAK_DURATION?

Good question.  Maybe adjust that if XFS_VERIFY_FILE_DATA is set?

