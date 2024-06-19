Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD536BB58;
	Wed, 19 Jun 2024 06:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777319; cv=none; b=N+kbxDMgS4hivEdMDeZxSG/iNfXnjbOo0dYoiFlkFgz0HUZEK8Gqwv/ypHPifa2hQYokq5GiVfTwN1445DL1DzwW9956CDaSCgy6WvLSEjKsMZ++eiDZEtY0kWYcJgTpD0az+oo5w24yYt+JKcMWdbRhzN56JtxCs/52GOHTU0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777319; c=relaxed/simple;
	bh=t7pdGxTusvTOxv6XvrJXgddeisefDsJ6Pf3emM7ztxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZjQwpCzdi8/ciQrvrgEeWODdKtEwLNbXv+gcYALyHaLu98kCfBwccUgMaMACPSJHdbVEnimVsBZFGC2VvvrraMOC3kCudxSPyHO6V33ApBJR/yDW0rYVq66xwF0k8vRuo8+iLvXeQT2/IUoA3FVwF0xRVnUBugwLwqcv9ZYi+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=APmfoAvv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="APmfoAvv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J+W/3m9cxrKf3lsNTvsVpZh2XdPb7UCopi9wgCPhLEg=; b=APmfoAvvWRI9DFv40NlXRZxM64
	VZRUns8dJpij/KGaBbWw4W81qa3+WJq8CVIgA2NMAY94RyIbyEEAfL6/js/PSbgubnZahM/lz/btb
	qryvzhT1Q8aN7BgTXP06u3bsvvIOgRsUP+ozqWOWK4VdEz5nNvWzmmzc/KH417s/NeT1yr/fKtgxh
	iSWszUcjm5FpMsz8sAwk2HrVW47IV/npssTTsYLzE2+C5dNr32m3YUq5oed9pTixpsijf/tI2SqkS
	pxVATsGhSpkdUywv95EGLuWMm9bTMO10+sgjhPU4dgqZLZFzIqYOetLwuYsDrDANDsdaEXz3oZPCG
	TjCJY9Xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoUn-000000000yU-16Tb;
	Wed, 19 Jun 2024 06:08:37 +0000
Date: Tue, 18 Jun 2024 23:08:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] generic/710: repurpose this for exchangerange vs.
 quota testing
Message-ID: <ZnJ15ZG1nWsCkxiG@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145344.793463.2045134533110555641.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145344.793463.2045134533110555641.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 17, 2024 at 05:47:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The exchange-range implementation is now completely separate from the
> old swapext ioctl.  We're deprecating the old swapext ioctl, so let's
> move this test to use exchangerange.

Do we really want to lost the swapext test coverage?  Even if it is
deprecated, it will be with us for a long time.  My vote for copy and
pasting this into a new test for exchrange.

