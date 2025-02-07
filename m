Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9822A1D8
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903817; cv=none; b=sqvSs8+gN+Yv4BkKUawmC5UaZhyyiPpwxjCthMVncmOIL8Rm0iaJZaNDyOtNXfOwY1zqmoz9qD9XD1WpRl71N/JTxWBGbSInScG61YtrzEt16v4wVM3yZfX+U0lnOKKatOo08e7l5r4VqJY7287xzKdDC1PAxBO6PUYMXSvFsAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903817; c=relaxed/simple;
	bh=3XXjkubCARJxbm2Zx5IINSAGU13V3CpT03lKmclP8W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJV5x5ybw+isaV6EtatuxEKHf9+i4Uw/XfA4EVqSk2q4chmRIMNaU/MipDUxWR3aHCCv64bzHIZ3IGWsmFYJNnVXAc2FwqHGtoewrQ9cxBDbnTEg5TKjEPUnfKlv9hk+VEdhn6m2WgwUgsgj9xqJ8v5aa7Z+ZnZSc2ubAUSKE+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mwGNGEWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mwGNGEWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84147C4CED1;
	Fri,  7 Feb 2025 04:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738903816;
	bh=3XXjkubCARJxbm2Zx5IINSAGU13V3CpT03lKmclP8W0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mwGNGEWo1g6CEAaJw52l0rG/Bwl2yD00ZasJM8DKrcf+MK5qqyf2JQzeiVOOP/aWi
	 H2DKqRyenXPBqld2hdIRzgI8XzvoomL5JibpXu/ftjbOych27wqfVLRVmSZyCKnwA5
	 N1Ui9CVpGRvj40i0Pey5jAWaKb+ve1LDJGa8r6ogBrg9ItewwZCQXm6SKHg/yN+p/L
	 2Kib16ZwpBBkFE/5OKji+utJNO+iD64rr+XGr5gnXdAwwjoiw/CcjQlrwz/n9ktz0S
	 8jE6+sQMKgeb1UP187kOMTpFkmeDqtVRayWD8hxBh2D1ISWrzYHaAqFFoMvV6nOjby
	 sU4oj8v0JlZkA==
Date: Thu, 6 Feb 2025 20:50:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs_scrub: don't blow away new inodes in
 bulkstat_single_step
Message-ID: <20250207045016.GS21808@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086274.2738568.5398591109789938783.stgit@frogsfrogsfrogs>
 <Z6WQKi1Df-YlODzi@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6WQKi1Df-YlODzi@infradead.org>

On Thu, Feb 06, 2025 at 08:46:34PM -0800, Christoph Hellwig wrote:
> I think this commit is the best indication the inumbers + bulkstat
> game was a really bad idea from the start, and we should have instead
> added a bulkstat flag to return records for corrupted inodes instead.

Yeah, I wish I'd thought of that sooner. :/

> I'll cook up a patch for that, but in the meantime we'll need
> workarounds like this one.

But I'm looking forward to this.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
