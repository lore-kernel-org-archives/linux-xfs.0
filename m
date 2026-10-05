Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7322A481FA1;
	Mon,  5 Oct 2026 13:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206313; cv=none; b=ZDzDf61PCQjsct83s+91kHr5FlGXITdplu4FQ9b5O9JFmVSFBN99DytSeKK4Nnz/xoO6mMlCWnFJsPug9DnMf2Q+A6kb0H+dCahagW9IXQbDYx1F+hQsY0Em6+0cnwbwC+gjzsJn62b2wtYHioTfMEJjwQAUzweTs+n+1hJEUu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206313; c=relaxed/simple;
	bh=rYV5CVQiVEQuIkbHTas3FqBA5YPkGLBzA5YLx5wDT58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gS4ryasgVs8/9COiaLOflkJJwXOwukPIwabrHEcHQvkKVcVR1Mt8MM7JrhzNljViVuiyKpyPmDSXxDgvIWQW4riAvL6vGIEj1oaf1YMdbw3l4tO743L3JiIz56mc67ibMP1j/Olrkojfddso8oFd2sZSKkLwtIkEpYvzCXmEOoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8AB7C68AFE; Mon,  5 Oct 2026 15:18:27 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:18:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] common: add a SCRATCH_MKFS_OPTIONS variable
Message-ID: <20261005131827.GI26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-3-hch@lst.de> <20260929013238.GE2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929013238.GE2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:32:38PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 12:07:43PM +0200, Christoph Hellwig wrote:
> > Add a new SCRATCH_MKFS_OPTIONS variable, which contains options that are
> > only applied to the actualy scratch device, but not to various other
> > devices like scsi_debug or loop devices created by various test.
> > 
> > This is important to support mkfs options that do not work on arbitrary
> > devices, like the extended LBA based data checksum support.
> 
> Er... what is "extended LBA based data checskum support"?  T10PI?

NVMe support non-PI metadata.  I had an implementation to support
for XFS data and RT volumes, but it ran into too many issue.  None
unfixable, but given that there is basically no hardware that supports
those but not PI I'm not spending more effort on it.

