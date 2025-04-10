Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130041FC8
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264900; cv=none; b=YWeZEahGyy1DxQFm3Pb8j0fScjEa6Y82CujVkpiljZlEuVQcB9csVmPSHAUivQjP1HULDVhZsm9D5r+MLv0wI6pf44rdeW50muB+Aiuux0tsXQgpSgoAqOpM/Q0phuJZ6UebEeM5rgoDJYCiIX3wYhAhtrWfq1/o8BmbHeenVWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264900; c=relaxed/simple;
	bh=RPziyDYbC9PVicfXPDuLh8rCyhIopHCOJxAh9vEWX84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTHh31tsp3cePJs5L2SXwxydd1HKqykjLJcTf+x3j+d54ORaUaGJax209rKiVgRObt4KXLnEDaT7g5tCdBP3D1dcH4zUP1hbu2tGIVr2UaYJCeZAClCUSqOi6vhPZWAc8EOQxbMIVY5t6lFrdj3H++B4nIoep4f0x4ym1h2z0Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 20DBA68D0A; Thu, 10 Apr 2025 08:01:35 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:01:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/45] FIXUP: xfs: define the zoned on-disk format
Message-ID: <20250410060132.GB30571@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-12-hch@lst.de> <20250409154715.GU6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409154715.GU6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 08:47:15AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 09, 2025 at 09:55:14AM +0200, Christoph Hellwig wrote:
> 
> No SoB?

The FIXUPs don't really have a clear process yet.  I'll add them where
missing, but I'd also be interested if these fixups are a generally
useful process we should follow.

