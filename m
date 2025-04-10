Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FED5202F8F
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 07:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268547; cv=none; b=toFt3JPYIaz7jwgtcM1XEJKSj+EtYh6N3Qv8OePC4lw+umcbDelrZYf9RdT0SoXRYAwDhig5Xs5RG5PndBtC1ScKhiYdOIX9YSgTlSjHBZfrtzB140ne8ZpjsKDuVKdSixlw3GpzlPiVDCn4elRoDqbOFUkqNoabvLWgUttihgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268547; c=relaxed/simple;
	bh=aW7dTGjjYlAeoGXkvX4RS0mrqiOzFicixcHC1QfLOxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQ7Xf7p/JQwoMwK/hjp8wLp8IXB+cFr6sAkbgxEBZ1RYYnKLb2d/mu93s5HY0Q+sERZnYdceZ1lpKqxZlvfMNHjhs/q4fOwVYQsGu77zTfCE6LWY/k+TC9Lcttaq3ch8gmM5omvFz859xy87mXVVQMAXlZVFqi/ecx0uYFdRZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9D5A068BFE; Thu, 10 Apr 2025 09:02:20 +0200 (CEST)
Date: Thu, 10 Apr 2025 09:02:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/45] libfrog: report the zoned geometry
Message-ID: <20250410070220.GD31858@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-36-hch@lst.de> <20250409190144.GJ6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409190144.GJ6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 12:01:44PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 09, 2025 at 09:55:38AM +0200, Christoph Hellwig wrote:
> > Also fix up to report all the zoned information in a separate line,
> > which also helps with alignment.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Could all these xfs_report_geom should be a single patch?

Yes, that works much better.

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Although between all the changes I won't add the Reviewed-by tag for now.

