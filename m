Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D5A18990D;
	Thu, 24 Oct 2024 06:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729751091; cv=none; b=MTeSOfvH5M4ZTF6sixBoqaIQfAkmpLqvC8tRPVnfrIc2sMI9Jec7Wbg4ZL27WijocFTCTN76Ch/zTUcD0yTN+CeHnYr+gFDR/Sy+39ruXvQtA892bO+TLxpYs1gGiAEhSp2acemz5/UknUdWVOGHdDAHcrt+jaZI2bovQFIp5mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729751091; c=relaxed/simple;
	bh=s8eN85HcmLW/r6O26hwWWNE6UzeE2XN+kpeQ5VquBHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWyHCpK0bhOXxYGiJXGqSr539zx+aLu+PiwxSPq+isuGUNr+2r6YbUxMb+J9Ojzv0q6QcQ3Q8Ik8z+QCUcIDZIhrBIYK5Sp7N7rrgCAhn9Q/F/mL7Xrq7xHCcDB04MLDTpq4EIhRC4sH7tF5ysFpOwaZKsDbMSCIw+gH5G4+t04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 555A6227A87; Thu, 24 Oct 2024 08:24:40 +0200 (CEST)
Date: Thu, 24 Oct 2024 08:24:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	zlang@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the post-EOF prealloc tests from the auto
 and quick groups
Message-ID: <20241024062439.GA32468@lst.de>
References: <20241023103930.432190-1-hch@lst.de> <20241023172351.GG21853@frogsfrogsfrogs> <ZxltWrUxkeuRq2I8@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxltWrUxkeuRq2I8@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 24, 2024 at 08:40:42AM +1100, Dave Chinner wrote:
> On Wed, Oct 23, 2024 at 10:23:51AM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 23, 2024 at 12:39:30PM +0200, Christoph Hellwig wrote:
> > > These fail for various non-default configs like DAX, alwayscow and
> > > small block sizes.
> > 
> > Shouldn't we selectively _notrun these tests for configurations where
> > speculative/delayed allocations don't work?
> 
> Perhaps turning off speculative delalloc by adding the mount
> option "-o allocsize=<1 fsb>" to these tests would result in them
> always have the same behaviour?

But it also kinda defeats what they are trying to test?  At least
that's my understanding, but your wrote them, though..

