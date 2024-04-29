Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83CF84E1A
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410830; cv=none; b=Dh/k2Y+uBOM6SrgUYpuWP4VwFJSJ7qdZBl7MNj0OaID0hKZn/QuSa13ZdlMVLb94/MB3vOaKrN4+Nhnvc4lIxTyfDgLLKCnD4FuIzdVUulFXonOcyEgGdOB1c5cabzSqAo73SzKEvEW1d3IkHM7iLqg8pVrKUV323AwT+9jrMvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410830; c=relaxed/simple;
	bh=WoNf6BWfURA9z1KgR7aearYdeH63wq8hYkMzqRiNlcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h1fGIjqLXNS+XzKEu5dfekAyZ+9q/pOpKdSK2zypocs6fy0dv/d/9Wejhw+AbmUCqq4obhfSbRQn6dbHLaP+rB4W2SzkujPwH0AVEG/MYG84+OriKIVS8pdXct9/kIRVk6IjgVrczD4qBhd12HtVhhtopLeyN0MtN3qdXy1zxFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E391B227A87; Mon, 29 Apr 2024 19:13:44 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:13:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix log recovery buffer allocation for the
 legacy h_size fixup
Message-ID: <20240429171343.GD31337@lst.de>
References: <20240429070200.1586537-1-hch@lst.de> <20240429070200.1586537-2-hch@lst.de> <Zi-QD8IdNCFHOyu7@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zi-QD8IdNCFHOyu7@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 08:18:23AM -0400, Brian Foster wrote:
> > Reported-by: Sam Sun <samsun1006219@gmail.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> The commit log/fixes tag are incorrect... xlog_logrec_hblks() didn't
> exist at the time a70f9fe52daa was committed. I suspect this broke later
> in commit 0c771b99d6c9 ("xfs: clean up calculation of LR header
> blocks"), but please double check.

Oh, indeed.  My (git-)blame was a little too quick.

Looking at that later commit:  can xfs_sb_version_haslogv2 and the
per-xlog_rec_header XLOG_VERSION_2 ever disagree?  Do we need to check
for that?

