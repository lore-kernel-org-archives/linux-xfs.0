Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0651617583
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 14:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097506; cv=none; b=QllKgWFiJ6KW8OHKoHZSRSwdUYJdPAhSUDT+RfPAOQzGz+IaOjzFZ0FpZraLxMUoc2lCL/p9cHjM7HQPRNN1xZfJgaaJ/dxI4jzKqEtahzbCGnXECiy5CszNoKfwc80M69FMZh+2u6W8KLh+wwpWGJoDf9yH50VzDoFUckGMiEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097506; c=relaxed/simple;
	bh=jze28RAnhXMbJoAiaRTtPrHmuzq3iWYRSmIJZUy/xTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCAm8CcYMk5Laa5hE6JFx7GGtHP6q5rFYxI9trFk+v6zKbmvbx/TVM01yFMvj3sLMnEetd2suOW96oyBDmtmYl+bmRi999rLGb5/dGf6D73EdUv8/g6EB3kfJauyQYiHeBPypgOKF3fB6C2DlxW9aUyS6pNyh7OTbnITUu84668=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3735A68D05; Tue,  4 Mar 2025 15:11:41 +0100 (CET)
Date: Tue, 4 Mar 2025 15:11:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: cleanup mapping tmpfs folios into the
 buffer cache
Message-ID: <20250304141140.GD15778@lst.de>
References: <20250226155245.513494-1-hch@lst.de> <20250226155245.513494-12-hch@lst.de> <20250226173931.GS6242@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226173931.GS6242@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 26, 2025 at 09:39:31AM -0800, Darrick J. Wong wrote:
> > +int xmbuf_map_backing_mem(struct xfs_buf *bp);
> 
> Does this actually work if CONFIG_XFS_MEMORY_BUFS=n ?  I guess the
> compiler will see:
> 
> 	if (false)
> 		return xmbuf_map_backing_mem(bp);
> 
> and optimize it out, right?

Exactly.

