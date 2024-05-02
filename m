Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A26719470
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 04:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714623255; cv=none; b=trcIzyoGU54uUJ0iXmUrHyNK4NFbVoA4hWI2w97ha5RQfjdD2THkHHmzuFBNZEMZ4YOFo6M34XBI5RMFP9XXaXzNYkwhFWaQynAvMJcX0tIQfUwVW1zOQjrE/xiNuPrBMgeDF5sZ6IOqwkT4S9T6yEQv0CQ84oh9Dodv60mEPIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714623255; c=relaxed/simple;
	bh=qUrfpP6ymnBNFtm+q50wlcY8Og38uCVcdZ+i2mC4T5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHj+aSA69g2VrY4+gdZOevjqJGkjDsq0SkgKgA7Uv6hHqv4dLAyfI5tqouWptpxIk0xx4DtNkBRN5Hq04oiMhmL/YoRYdtLNq/0UxjF5hsOZaLN3Y3u6beIOlK92PzCguZXkiyziVVU1XpFJdiuCFVE7lnuP3VqbOiektKKw+b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C10EF227A87; Thu,  2 May 2024 06:14:10 +0200 (CEST)
Date: Thu, 2 May 2024 06:14:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/16] xfs: add xfs_dir2_block_overhead helper
Message-ID: <20240502041410.GB26601@lst.de>
References: <20240430124926.1775355-1-hch@lst.de> <20240430124926.1775355-12-hch@lst.de> <20240501212758.GZ360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501212758.GZ360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 01, 2024 at 02:27:58PM -0700, Darrick J. Wong wrote:
> I could've sworn there's a helper to compute this, but as I cannot find
> it I guess I'll let that go.

I did a fair amount of a advanced grepping (TM) and couldn't one.

