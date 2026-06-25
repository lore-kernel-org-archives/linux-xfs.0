Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D84524F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782426715; cv=none; b=Vti7DwDYwKtA9/NyLQePY3fFltLKcxdwZ3TiuEgKkVbkDf0htC+nB2ZTbf03CZDrlMoiCxTCXsWq6Ojdm2sy3d1wgjMV3gtnuJyROQesVULIJQ3UDniT9fceH3yTbv4ogfizS2lPqwR1veP3EhibDF4wjpgAzE0G93a2vuc8gds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782426715; c=relaxed/simple;
	bh=axb9/p6/ORG17VHOF7Y0oqd8EJ0uVlB+xz5Gm0dBY7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FXY50Q3XF9K/BuYJ2PFtGN2GU+gewkDKdl1hMJkE4ItFquE91Nguhr/MhP4HLN+oa897GaeEtv7YtHddQkFwtSi3GLzPMUKrvBuwYMWgfdSJXLOx/wnc271rXoCQbu3gYi8ibuNAldi2o3D9RcAarpvVYMnQNxUfieHffF/sxK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4yDwKza; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4yDwKza"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2958E1F000E9;
	Thu, 25 Jun 2026 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782426714;
	bh=DjwjrIHvptxuHC/DU3mQBI6MKrSyioexDWUB3x75LMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i4yDwKzaVbCMofFSrEAkjRTp6ekOQKagDXsdfamDH8bPNb+mqN7ZJaUXGEegpLD7I
	 OonUaLlcy5X7doyT8TWU/VMMgzQFWJ8VZQWvYz6ApO2cj4pz9UL5tnCF1Vq1JSK0OI
	 mdwAT/ArfJG3Bkxm5JcWwEjuQKPhMSNhLvWU2dvGu2RDHEparRd0ptrVmUQFvwBh6V
	 2QxcFZ1gml4YNg+T6KLaZ+gVwYFKVH70rAEXnxwCUkWg54XygCS+dl7GdzXwPjOrf1
	 0ePBghS5w0YmwXNghgDHkSLMMtIhEHUuHYNkOksbSC9/R5mGvOqTh6rlmpokVaJL8L
	 BwV26Zjhwindw==
Date: Thu, 25 Jun 2026 15:31:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs_scrub: track inode scan abort state with an
 enum
Message-ID: <20260625223153.GL6078@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
 <178232484512.915780.15261436223285476643.stgit@frogsfrogsfrogs>
 <20260625120213.GE18766@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625120213.GE18766@lst.de>

On Thu, Jun 25, 2026 at 02:02:13PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 24, 2026 at 11:15:33AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Change this from a boolean to an enum so that we can handle scan
> > cancellations correctly in the next patch.
> 
> Where that means adding a new member to the enum I guess?  I'd probaby

Yep.

> merge the patches for easier understanding, but the change itself does
> look ok:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
