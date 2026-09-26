Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D1C2E762C
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403335; cv=none; b=qR2S94glOwrgxiG5N4yraKEYGxEXxme0UNKUqboZbet6Hk/A70SKlnmKiLLUHNajHkErj7jcka5CBeGEaXP/gHSGiGtfZGHmCuxXxcoAgW4qm4mFHEsqM3f6XOCbhuD997cI7gWxpk4uO3NA8GZqQZ6xpCJwa0okm1DsAl+cSXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403335; c=relaxed/simple;
	bh=CHard53DOE+H2jeL2NpUuaPu0FhDVSavUop89XJnxOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cw858nD03P4MKi61W2Rhi2Y8CfHwUWZ2FyOMpZHyVRKa5FI+imdO5AMcxLNrdiz6XfQqtRFJObtEh5WkgbdXFkLXnmiZqw6etKl5a2Iph66eWIfolfnQnDHxJ86KfPhbgAgO8ceTnWkQ9Z/kjomiXPXwrObkdswz9/3nzCMH7Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3FE9368C4E; Sat, 26 Sep 2026 08:15:31 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:15:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/32] man: fix alignment of the rtstart field in
 ioctl_xfs_fsgeometry.2
Message-ID: <20260926061530.GG20636@lst.de>
References: <20260924100512.2733748-1-hch@lst.de> <20260924100512.2733748-2-hch@lst.de> <20260924203029.GA2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924203029.GA2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 01:30:29PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 12:03:51PM +0200, Christoph Hellwig wrote:
> > Using tabs for indentation messes up man page rendering, so use spaces
> > for rtstart to match the other fields.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This could go into 7.3.

Andrey, can you pick this up directly, or should I resend it standalone?

