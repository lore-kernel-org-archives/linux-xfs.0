Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B5F4B270F;
	Mon,  5 Oct 2026 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212184; cv=none; b=NWhNgQJJqG91+hRnr4phu9M0Cnt9gputvKVVgmi9HRLcXSMf4mRuAxNzuEYqcPUKc28jH+fNXtrnuqeRXDsWa5hNyoDpUkGUU++kulcPGVrAptaBKBI40bemv8jKXPNVpdRZXYEUjVg7i3MoKs6pRlh39Yke/pDSadxWYFZafhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212184; c=relaxed/simple;
	bh=f6M8maBSI2NdZJ9giH259dDbC529zfb2lTJV8qd4odk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kYrbT3j8gSatfrrPt75wcjENBw0y9MgGkrjoNFiJPfTQZCMl7OJjM0mLaOHZwOaI4Jx5a5lYoqlvUVkxDlk/RZ+sR2Wm+mSqklPzjZGwm65Cm+Kn3JU5gO/uK6SAbJQhE9T/T3DjM0Ng1jl7JC3/UF0QsbcNhfX7rLmVEZWa5Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DDD6168AFE; Mon,  5 Oct 2026 16:56:15 +0200 (CEST)
Date: Mon, 5 Oct 2026 16:56:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs/2304: version of generic/388 that run
 xfs_scrub -x for each iteration
Message-ID: <20261005145615.GB2082@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-10-hch@lst.de> <20260929015645.GL2705364@frogsfrogsfrogs> <20261005132522.GN26805@lst.de> <20261005145123.GB2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005145123.GB2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 05, 2026 at 07:51:23AM -0700, Darrick J. Wong wrote:
> I'm ok with g388 running more slowly if it'll catch data checksum bugs
> and whatnot.  I'm a little surprised that it doesn't already run
> _check_filesystems every loop iteration.

Maybe we should patch that in first, and then XFS_VERIFY_FILE_DATA
magically does the right thing?

