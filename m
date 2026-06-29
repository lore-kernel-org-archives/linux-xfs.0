Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D97406802
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735920; cv=none; b=p6Btet7lF95/MUoak305yZAp1lhQ+VCMarcESDls886+EqWdqbiLbWdYWRL8a/GJCp5LqK0+8i8smM6GEU0wqx42+QpVDv4WTUQU1K7d2TB5ZF7YNb3kB/D2PKaOu9cMEJW0UqRTmkMn1A+RgfWEAizEDqLoWyY12sarr+yf4s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735920; c=relaxed/simple;
	bh=pwIYlHq98cwhkc50twIYoD7ZuVkFCi0EL4y3W0B8+Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZXH3bxIZ9HIAGkY/wonqs5UVM9LsGKRGXAnRzVmOGyPeejQQzMC9kxPlt+mLuq4EueWLEwlIPejo3pmLia5Vy4v+xbExuWDKONeUZaSvDhvCS+kIQ6M7wdknOQbDxl4tz0dkkn8Z/K9P2aLPabmJZiK3G+gBWnqkiFBZ5ZqSPXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9603B68B05; Mon, 29 Jun 2026 14:25:15 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:25:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_scrub: fix estimate of work items for phase 4
Message-ID: <20260629122515.GB21344@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801396.1981574.2199805727145890150.stgit@frogsfrogsfrogs> <20260626050426.GE8786@lst.de> <20260626165525.GY6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626165525.GY6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 09:55:25AM -0700, Darrick J. Wong wrote:
> They're run explicitly by phase4_func so that repairs don't fail with
> ENOSPC or EDQUOT if the summary counters (or quota usage numbers) are
> wrong.  How about I expand on this in the comments?

That would be very useful, thanks!

