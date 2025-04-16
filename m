Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4064A1A
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 04:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744778148; cv=none; b=T4eGTqxdyul7ScS95YGjlTvS9ES3dARwHmIeZh6qCqAzpRbC7f15Oj8YSUImrKkhDbdQ9lvDllDpxFJQYoYmz9lPYQc0vRqL3kzjr5nBP+JkLoE2d6BPxYybg2GN76+1uZp1qSNLuM5O5l9N5Y+vVhWyMDhLeVevgAMrNh4PGXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744778148; c=relaxed/simple;
	bh=thjeOqVDdA7ZBfGvbdi9ihrqRNXivXwQI+1584Ldzic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZaU4uasSqWIMI0LRuIzmfQe9J1+biaLHj+bUreHv1qMAvnLXVVAqRmPanV0kHVMT4yXQmdGQkl1REjGkWD2RlPaqgxPXfhMwW6a5KhzR6NGaowvL8YRR2n0TwcRV3Cf2gPqNzZicmk4ZCKUbMaHjo3Jl/AR6nEcpjCEBZzBcYEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QU9OWWqR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QU9OWWqR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B0WEbKQV4nC8vGcVBrnV61mUJmr28y9fYball3n6QXU=; b=QU9OWWqROwZ/XqeRX9NJxW9BCB
	T25+Cy78e3Rs92eEo+Vmq9CQNLED+GNXkE/tz6OYekUJv5fNLmAn+xE7SDEF27U7afQmoM3Wpv4Fg
	qm5kLELXkX2ltdHR4ZCcwiS+SG53gpquiaqbHcDIxNbAinitY4l5Xj+Jo6WBl7bbY27uO/tQHo0rf
	HcquTuuy6QuwCcRXWCQJeHIJZzJLx1YZTmXXa60GgvyMZcJOcDZ37l+ulYLJQHsPuEjJCyHZEyQXb
	Yr75hOwqCq56O8hZCjtT3MGrv+wa8vDJ9XKyiZCI1MLbfQzI9GKVJh3YgoGlCGkA9x3EsSDKdJg8J
	rGP6UR+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4uV0-00000008ADx-31pu;
	Wed, 16 Apr 2025 04:35:46 +0000
Date: Tue, 15 Apr 2025 21:35:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: fix blkid probe API violations causing weird output
Message-ID: <Z_8zojbPUQ69-hH7@infradead.org>
References: <20250416012837.GW25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416012837.GW25675@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 15, 2025 at 06:28:37PM -0700, Darrick J. Wong wrote:
> +	/* libblkid 2.38.1 lies and can return -EIO */

Can you expand this comment be less terse using the wording in the
commit message?  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Did you also report the bug to util-linux so that it gets fixed there?

