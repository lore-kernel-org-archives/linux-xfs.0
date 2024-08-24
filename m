Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E1D182B4
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 04:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724475009; cv=none; b=kM+POymwCKL7K5QzZo1PD45UkEYq9goJa9LQ39I/9DwtPv7sVUoyltSxTDOjrRmvkpbmq1bWO/DsWm5vsbVI/eOMB/VT1vK51Tld5mxNqfiLGuELwYsXBBMXlKzsTB9LpIAr16ekJeNijmK7Cv26DDSBrDlGc+eVze5xrQvdOIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724475009; c=relaxed/simple;
	bh=Hp+VpGrqvfjLO1oCslPXVEz81mb5xyC9kgsyZA5+iKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZRgREqCdTlHnAB0WrsttQK27ybLDTVIedN+sraslz5c+ZbYL8tuacJrOXzSw4Tj225PzAQNo1JmyCC95TJiPDTXfY9ZQB9Sde2nbXtzks7TJjgzwslrsAu9pAvbue9glbUoYVmv2szySlsGRHIpRFKzyTA7uNWuPZj4LDfxmnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 540F0227A87; Sat, 24 Aug 2024 06:50:04 +0200 (CEST)
Date: Sat, 24 Aug 2024 06:50:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: ensure st_blocks never goes to zero during COW
 writes
Message-ID: <20240824045004.GB4813@lst.de>
References: <20240824033814.1162964-1-hch@lst.de> <20240824044718.GT865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240824044718.GT865349@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 23, 2024 at 09:47:18PM -0700, Darrick J. Wong wrote:
> > +	 * data when the entire mapping is in the process of being overwritten
> > +	 * using the out of place write path. This is undone in after
> 
> Nit: "...undone after xfs_bmapi_remap..."

It's actually undone inside xfs_bmapi_remap, and has to because that
clears the blockcount to zero.

