Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF5213D626;
	Thu, 18 Apr 2024 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713452434; cv=none; b=nTccACKeKdLEGn5Rjur+/1FxwBk8/4AwYakNL/S4cPaRh4veM88yyhrdcSHP58Sg4bbwlKrCpWclLA29mQOqFoBevl4tlgWV4E9zbQ3crHQjovDwxYKFRd10L1lOPWt/t7UsF8oojms+qcKpcSCQuJCNLWuL6F4KvjQXfzsGlK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713452434; c=relaxed/simple;
	bh=apEuzlbf6fQcRv0hMwP7q5M7DGojZOgZl3rScTMntro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3eElBbvkey6bKrOy/mVMYzB/SL4k0kATIxbgXFf+N6iX9loOOGIBh2pnMPORFshqB0z3/p6CTR+iYNs9dKzy27Y+2fwwSbvHgtbA/iwkW09E0NVCDNf4CSh0SkS5vR7szetV+t7UszeF0Y1lLoZrOvjGQnUcNZESLSjpmvBv5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0356568D07; Thu, 18 Apr 2024 17:00:24 +0200 (CEST)
Date: Thu, 18 Apr 2024 17:00:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs/512: split out v4 specific tests
Message-ID: <20240418150023.GA32765@lst.de>
References: <20240418074046.2326450-1-hch@lst.de> <20240418074046.2326450-4-hch@lst.de> <20240418145639.GH11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418145639.GH11948@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 18, 2024 at 07:56:39AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 18, 2024 at 09:40:44AM +0200, Christoph Hellwig wrote:
> > Split the v4-specific tests into a new xfs/613.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/xfs/513     |  13 ---
> >  tests/xfs/513.out |   9 ---
> >  tests/xfs/613     | 198 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/613.out |  15 ++++
> 
> Such numerological coincidence!

I had to skip a few numbers for that, but they'll fill up soon..

