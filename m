Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF4A202F99
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268039; cv=none; b=PSSuVo6LULwxDdIL3f+IfRSD+WBRKVPKDQRxr2J2pVGku4lPTO42D59S5LHgDnerosRXASHv49Yu1cOhMpfjbAmIFna6B8zS5sHiuvL0rpUN2k2lJpRQSCDX2lZfwA/xKDDeCcQmsGCnaiNMziV3XexqbK1hPpvplBhnSXJcRWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268039; c=relaxed/simple;
	bh=H/28jjP5fJfXegxW2x+EsLq+rtmH2malj3rDTq+IXbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jtl0IVFlTArilEDBqzexOLa5RUQ5wT6FlS4xRVEYkN1CHjjmfhfWBdRdNkBJXtNWn+v9PT75GBD/DZvaIbMxZw5X5Kk4ocuBObqEumHehQ/Ve38WsAkRrG3O17/zFCuuXBKdTJr+qG6tmR38PA7GAjdNIWm2YvdufXWEDfg7agw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6EF5368BFE; Thu, 10 Apr 2025 08:53:52 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:53:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/45] man: document XFS_FSOP_GEOM_FLAGS_ZONED
Message-ID: <20250410065351.GA31858@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-37-hch@lst.de> <20250409191340.GL6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409191340.GL6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 12:13:40PM -0700, Darrick J. Wong wrote:
> > +Start of the internal RT device in fsblocks.  0 if an external log device
> 
> external RT device?

instead of the log device?  Yes.

