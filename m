Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB58194A67
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902230; cv=none; b=mUTgM4NMgKwRJ3QJ1+MNjtetjMvIvKEzNj0oxqq+uPqi3oWyb3Uc1A/6pjTm56bvaJZ9mOnTQzTMSpvC9gDHO0QocKaW+GTTUu2PrbNidc/yjgjCDMMKee6MYjOUH/gdM9+BvUtuQd9RIZN99XvYVi7f7QgNcWO07jDFhDrGhX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902230; c=relaxed/simple;
	bh=CTRzq8FnFoYC3Q3T0aF35IwDCcbOG6Ik4JjgjEO3E3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ea11aGZfxnQC2KfdCzRRGa+TsTdRGsdehyDZcWR4NxdyxLZTMRmk1b666IBE7oTRo+jbD7CpAeyY99ld1KeqWmnN729ISThddfb5kWqNtjPcPmznz7JP62cGnlXtJQpsP13URNdtP7IyidL6yDRs76T1JOFiIRccduCdl8vO+3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A59F768D0D; Fri,  7 Feb 2025 05:23:45 +0100 (CET)
Date: Fri, 7 Feb 2025 05:23:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/43] xfs: export max_open_zones in sysfs
Message-ID: <20250207042345.GG5467@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-44-hch@lst.de> <20250207005259.GD21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207005259.GD21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 04:52:59PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 07:44:59AM +0100, Christoph Hellwig wrote:
> > Add a zoned group with an attribute for the maximum number of open zones.
> > This allows querying the open zones for data placement tests, or also
> > for placement aware applications that are in control of the entire
> > file system.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> It occurs to me -- what happens to all this zoned code if you build
> without RT support?

Where this code is all of it, or the sysfs support here?

In general the code is keyed off IS_ENABLED(CONFIG_XFS_RT) wherever
possible.  But the sysfs code here is missing that, so it should
be added.

