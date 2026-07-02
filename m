Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D5C355F57;
	Thu,  2 Jul 2026 10:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988408; cv=none; b=N+cLY+e1XYCRE5V2duWE3uYhgy8w+X6V3RKPAjt1J0hhEbYhKpsYB7HqotSRfBIBxvtgXe1bOYzwg7du3qt2Oy8tsjhBaOGZua4dGGWYWThIVZinKsAGoExhODyigP1rI7h4qv16ozXO3ljnkYvbmECXLSZrObXILwTWS4Z0+3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988408; c=relaxed/simple;
	bh=kTdmsL0veQk8gkspfGDD5PVyi3A+Lj2c1sAQ0JgXB5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLdKebOqNCzAm9mw0QUuTQx8x9rxfjCgFS/fLSBA18LhmvffFtDBliqMUgi1WIHybL7EwkhirExK+rRtYqDqlxXD9LbEkHR1BArS1nlnfFvnxDtMzuFnMhF5JnmhakvYCoWt0tVTMBJwlbalPDNUS2KbaOOQyqxmFkFv+QfW8dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0E8FE68BEB; Thu,  2 Jul 2026 12:33:24 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:33:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] formalize and fix disabling the RT subvolume
Message-ID: <20260702103323.GA6816@lst.de>
References: <20260630113526.3601287-1-hch@lst.de> <20260630184018.GB6544@frogsfrogsfrogs> <20260701105407.GA14404@lst.de> <20260701165114.GD6517@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701165114.GD6517@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 01, 2026 at 09:51:14AM -0700, Darrick J. Wong wrote:
> Ahaha ok with this patch applied, the regressions I see in generic/441
> and xfs/656 go away.  generic/441 chokes because the scratch fs goes
> down due to writeback error, so I assume it's ok to start excluding this
> test.

There also is a dedicated patch disabling them for zoned on the list":

"common: skip data write EIO survival tests on fatal configs"

from Yao Sang.

> I'm guessing that the write failure takes down the filesystem, which is
> why the subsequent xfs_io pread can't even open the file.

Yes.

> 
> Also the comment in xfs/655 and 656 doesn't make sense:
> 
>  # Disable the scratch rt device to avoid test failures relating to the
>  # rt bitmap consuming all the free space in our small data device.
>  unset SCRATCH_RTDEV
> 
> We're creating a regular sized data device, so this shouldn't be an
> issue.

I think this has been copy and pasted with the unsetting of SCRATCH_RTDEV,
as several tests have it..

