Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249FD1FE455
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 13:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745846271; cv=none; b=pvi2mFUdxYWEKh4nhmvYCqa3l1OYL1uQm6APCjQX32Z5WQ3PUNQwdBXHdIbEJudmTGBHd4LahpWS5M2I60acyOefg5IbIKQuxYkfecrWCPf36Mpc7XmCRXMlWMUGTEAZiHejHnDBtkpDzWcpukcHdEeGSGPQ3qJ2BAFKKRErck4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745846271; c=relaxed/simple;
	bh=lNMmVgPBXptKOJS57ihzfryKJIjBSWf9R6mBRvH4KQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ssN1ZhhEBq/Vhfesc76YNqJMhPxeiHl5yavf47D2pwNjIzLNj2+0NTEDBzic8vfj3OlPb8JhCsusOyif5aT6q0hqNCO8T3SV4EVjdcJG65dALrkGOuSdRrRbqsdfIOy7J8sTmdIlBRpBaG1rC8EnnIvFQHcUWtXkEGJN8uEqsmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 10C2568C4E; Mon, 28 Apr 2025 15:17:46 +0200 (CEST)
Date: Mon, 28 Apr 2025 15:17:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 44/43] xfs_repair: fix libxfs abstraction mess
Message-ID: <20250428131745.GB30382@lst.de>
References: <20250414053629.360672-1-hch@lst.de> <20250425154818.GP25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425154818.GP25675@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 25, 2025 at 08:48:18AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Do some xfs -> libxfs callsite conversions to shut up xfs/437.

I'll add it to the next round.  Which afaik is just this and some minor
commit message tweaking.

Andrey: let me know when it's a good time for another xfsprogs series
round, and if you want the FIXUP patches squashed for that or not.

