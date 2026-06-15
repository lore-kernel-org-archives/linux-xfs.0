Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC3C3ECBEA;
	Mon, 15 Jun 2026 14:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781532186; cv=none; b=gAMU1UZEud+vsQ/W8Q6yL6gaDHJpDN071r7zDkXy51EX4/dpyXQ06vtPPKRfRq2DxFxxaa3QdvQOHE+8QN3E/2dtMutsj/TVxV6vdsoQkZIDUHZZxrrNqoytY36Kwb9+TrSFoeEs1igpZctiSD+TmrIKaXh+M4D0Bl2rsyzPddQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781532186; c=relaxed/simple;
	bh=p83Ni8ccVngH4VQY0V8HKHuFEQXuG9ke6cPeVDdp7UE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWMwGS2nrEScYR+SIxzOJ4CPaPQsjKr6SU4p/XN8SdDFokfuuBXNXIzAYpvSxyEWJ5TaVv4fbDOO6RWFmB2sC7YxSkMtqhdJpX3m90ARNgXsI+HOc5BvXC8G6K64UwllFiV+crOnnhyTajrVCU9RRnAVdfUHQOnDupYWgcMHs9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CAF1568AFE; Mon, 15 Jun 2026 16:03:01 +0200 (CEST)
Date: Mon, 15 Jun 2026 16:03:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs/013: fix ENOSPC handling
Message-ID: <20260615140301.GA28378@lst.de>
References: <20260615121257.512060-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615121257.512060-1-shinichiro.kawasaki@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 15, 2026 at 09:12:57PM +0900, Shin'ichiro Kawasaki wrote:
> Commit 000813899afb ("fstests: scale some tests for high CPU count
> sanity") replaced "touch" with "echo -n >" to speed up file creation by
> using a shell builtin redirection instead of forking and execing an
> external binary. However, this broke the ENOSPC filtering the test
> relies on.
> 
> When the scratch filesystem fills up, the shell redirection "> $dir/$i"
> fails instead of the "touch" command. The shell applies redirections
> left-to-right, so "> $dir/$i" is attempted before "2>&1". Because
> opening the file fails immediately with ENOSPC, the command never runs
> and the shell writes the error message "No space left on device" to the
> stderr instead of the pipe. Then the error message is not passed to
> "filter_enospc" and leaks into the test output, causing the test case
> failure. The failure is recreated by running the test case with rather
> small size of block devices, such as 128MiB null_blk:

Ewww.  I've seen the same errors sporadically too in zoned testing,
but never got to the ground of it.  The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

