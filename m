Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E0616A930
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 20:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734467121; cv=none; b=a6E81XoMuGgOCdxTatMgNj3h8m583ZbTq/P3j3WdlqsKybgE881I8Q8n44vz3X9CKVR1dPdZJQHRqnVGO2XhS/qLm1PJg3U0UMdQJFSwEBkMh56OQtw+6kRbdEi1scAwu9OFwvyHcCUR3k/Ro/G9NjPVH4R32bDfdCPKJR0MTa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734467121; c=relaxed/simple;
	bh=38MTR0ZF6kIOxN3SyDMyj5uxK9/xWPtntxuEpcldfYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHBDmKJkJiHSq5zhCZfT1T6/o2sLZlXVeLaY6UYaiqK7F8Ti1WGKWwi3nArhlVYtEgY7C9Z+IDs2ZkBXPh6DA7e09Nwn8nzLw2a5Y1beybKew+pxSFzM3cn1bwAArvLmEA8tFtlHMY8NRiCivCCB4GeIeyzyV51NtKrptpfxbLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTqqzrBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTqqzrBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C364C4CED3;
	Tue, 17 Dec 2024 20:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734467121;
	bh=38MTR0ZF6kIOxN3SyDMyj5uxK9/xWPtntxuEpcldfYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XTqqzrBt2rg39lTbk8HSUA2ZufuuDwBqrNSsvfi4zyUFrci6M6ev/57QHWkZ2uvzX
	 pSCp97qRVpK/gkBd2Yh2lSNvdzWwGHY2+3HUdnQcq32n7kkl9PrRomj4Nf0Xr4OvLS
	 60Ve5S4GZVS60FkDfszF0pzK+j/lKHMN3JhCkSwB4Ne57eQnFQUx5SU6jrZBfPYVdD
	 TwzWcweqRS+r71ZRy03bYMwqv0ubv9ssbcKbX7ee7Z4f3ftzbNBhhYSanhb706Pgta
	 mPb/ms3ocdy/CCtm8/atIb7OzIRWzrnNtzf1o94uvgT/oZ/KOSKfrBACF18g53FTAs
	 uJwTYXHbIlOJg==
Date: Tue, 17 Dec 2024 12:25:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/37] xfs: online repair of realtime file bmaps
Message-ID: <20241217202520.GS6174@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123778.1181370.13816707119197050202.stgit@frogsfrogsfrogs>
 <Z1vf6PiDFJBekXYU@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1vf6PiDFJBekXYU@infradead.org>

On Thu, Dec 12, 2024 at 11:19:04PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 05:07:37PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Repair the block mappings of realtime files.
> 
> A non-stub commit log would be nice here.

How about:

"Now that we have a reverse-mapping index of the realtime device, we can
rebuild the data fork forward-mappings of any realtime file.  Enhance
the existing bmbt repair code to walk the rtrmap btrees to gather this
information."

--D
