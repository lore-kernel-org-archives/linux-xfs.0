Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27D413ACC
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600487; cv=none; b=rzg3IxjXGUY3pb7pa5YOhlX+2OgLU+EVUwrX0bZRwtKhxZnDVQCQ8WQ27yLpjOM/I1cwfjZGHcODJDG7GCw2wSJKP279vWc1xDmewYZRIPvReo3Sz8APa7epcNAhApKIn/E6m5i5KuDeaVTLdLH3yBtzw37hsMC1nuBMLqwmGCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600487; c=relaxed/simple;
	bh=hZLFIqiREFFFtA+YsjY86sh+QG/rzu0g4crB8mYc0AU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbD19YhPZXQEmZ39sokKxsYQZhqKNOCIPPTbrMC5HhRCzkyx7PenRxA/BDDMV6ju55ggkXou7GFkyYH9cCbUgXhlzorGla7XfLkD6KFD2X7yTSISTjZw8spEZTntpajGdjOKfMusJtXwcTVnvE5G4IrT4dVBUVr5UnKSoVSPJi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 555BB68B05; Thu, 28 Mar 2024 05:34:42 +0100 (CET)
Date: Thu, 28 Mar 2024 05:34:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs: look at m_frextents in
 xfs_iomap_prealloc_size for RT allocations
Message-ID: <20240328043442.GB13860@lst.de>
References: <20240327110318.2776850-1-hch@lst.de> <20240327110318.2776850-11-hch@lst.de> <ZgTy8iQgXeCK841G@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgTy8iQgXeCK841G@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 03:32:50PM +1100, Dave Chinner wrote:
> It took me extra brain cells to realise that this had nested
> function calls because of the way the long line is split. Can we
> change it to look like this:
> 
> 		freesp = xfs_rtx_to_rtb(mp,
> 				xfs_iomap_freesp(&mp->m_frextents,
> 						mp->m_low_rtexts, &shift));
> 
> Just to make it a little easier to spot the nested function and
> which parameters belong to which function?

Sure.  Or maybe even add a local variable.

