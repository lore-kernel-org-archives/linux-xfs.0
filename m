Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ED22771B
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 04:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213675; cv=none; b=T6EeoFi2lIK38uz7OUgSNNjshzki9IEUKxzage9gCQVUvEj24UIshrGLIno0NZSMDHNW1GLlSsEBg1EZX0Hfdsxh+NBMFfOGCpjNhLqU0IhlFOMswaT/0lv5dVegBjJu6Y1j2CIJvCbV0whZcasGqi6QnUWFn4Ey45lKfX8spcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213675; c=relaxed/simple;
	bh=RQJtIR+E5wE8TONnI4kS4nTnXp+v9/gYF8DgF9hLGeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRe9P6UyWD/oQnDXPPjpHcfcafGj5Y9d0hQvRlzaHallCOaNzKoYCmOS849m33BVlmC0Gabnr1XBCG7gw9bVc11R+p4LMIm73kfDT02j0qxNOCT2FoLYJW6RI7xJnc5mxUuVoDs6eCymqW6lVJ0GFNAiZj8kAI7K3myEXYwy5M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CCAD468AFE; Tue, 28 Jul 2026 06:41:11 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:41:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: add lockless xfs_buf_readahead_map fast path
Message-ID: <20260728044111.GE20064@lst.de>
References: <20260715145147.95654-1-hch@lst.de> <20260715145147.95654-13-hch@lst.de> <20260724170316.GZ2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724170316.GZ2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 10:03:16AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 15, 2026 at 04:51:05PM +0200, Christoph Hellwig wrote:
> > Readahead currently always locks the buffer, which can cause contention
> > with actual users of the buffer.  Add a fast path without taking any
> > locks if the buffer is uptodate and not stale.
> 
> So we're trying to cut down on b_sema contention for detecting the case
> where the buffer is already uptodate?  And I guess the idea here is that
> if you had per-fsblock filesystem metadata, you'd want to be able to
> readahead that metadata into memory during setup for file IO without
> so much locking?

Yes.

