Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA061B640
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264813; cv=none; b=KSN6XdXF1iyElaCl8oWLGVxk2NatY2k1OGObmFNvOyj+zUn4M5uc+P5e7c1C8Vs+aCCeMrGs+ldgSo9lGmnWbLQV7mXKuWLo/o98pt7DLViImnVNQIMrFw+sYm6zbQJQtCpdBWaj4DIc7hFkwnkXcbS17N73GEy5SiZOJ+EMrlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264813; c=relaxed/simple;
	bh=FLMCbFMeV6nxtQsmaSMK/auB3trSfqrjpHnXKyJcgmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hMK2J/qr7rm/cUdkh6WEAMPVsQ0x1j210o35U8aIKlY8/sc3QRc6y4osMxLj3ddMxutsFt18/+CYfTbO1RwfiZHEiU9yg9bmFWMH2gkA5jo+We5cVSdpkMWZxIHcJto6f6aZTxURVSLUnRub8fgY62rlMQaAqEwH2ROsQz5GUbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7F6FD68BFE; Thu, 10 Apr 2025 08:00:06 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:00:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/45] FIXUP: xfs: make metabtree reservations global
Message-ID: <20250410060005.GA30571@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-5-hch@lst.de> <20250409154303.GT6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409154303.GT6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 08:43:03AM -0700, Darrick J. Wong wrote:
> > +	error = -libxfs_metafile_resv_init(mp);
> > +	if (error)
> > +		prealloc_fail(mp, error, 0, _("metafile"));
> 
> Could this be _("metadata files") so that the error message becomes:
> 
> mkfs.xfs: cannot handle expansion of metadata files; need 55 free blocks, have 7
> 
> With that changed,

Sure.

