Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AD9192B9D;
	Wed,  4 Dec 2024 08:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733300695; cv=none; b=ET1uk6u2r8HKm/17gT60t60Na2eXllZ5kRJrUIqrhs6YBvrXCnTGjLiV4cKEbKUCQjBvqSy2yM9DY6UcJDHBEQAHKjd+RmoV3pWebiBGUqbHcU5dX+i/D2307OQMvn68nLI8FPaM/MKGtcrNVH3hOIrJoeBnahieElC1X7sgXD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733300695; c=relaxed/simple;
	bh=+WwrL96zyhhT+uWzyi8AD22JLJysFvdpQAKPX9fG8bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3kev85qdbp2kwZEzS1WXkdRtkC82kpzYJ2VHYL3TxzDQm7Y0ORUngG1uFq3HubNWh1eMF+fPRD97Wss1FqOb1ijhlX+JYe3OOBuBVsVYynXZZg8O9Cm4GNdJM0hdhLiMuePN89y0F7J2H8ON7vsd90VxNQPvV55nCxHWV0P2X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OrXJmNTI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OrXJmNTI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cTbUyETKrnSqJgjpW9nfyDk19qizjzKtAL3+RCzGI+U=; b=OrXJmNTIamt6Gbk19dtIPpfqFI
	bkF4lEiKA0IPDOdytAip60bMOSjlK5dJIztEMEhviSjxn+qDnJtJzbqvQHLjKBqj+6yGnT6H9n1my
	cJqJ8M7fU0c9YSGjlr+vVCr8eMlkJPoGCZU8S4TO8Eoq+sEror5kyGvxvTPuwLHHYhFPHNaD7kcyV
	CFbvQl1dRU+4WzAwyAW1kM27E5XvxBbF1YaM05AFxRz6vSpPbXuauXL2tKD5zkIEO3+ky6Ibw9GbG
	wHzh3uLIKChdfSSLFU5OiTT4GybpgAGiU6s1SckMJMyIri8lW62+XEzdoFvPHV3xYCznnybg5eBai
	YEJFOP1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tIkgn-0000000BsJ0-2JsI;
	Wed, 04 Dec 2024 08:24:53 +0000
Date: Wed, 4 Dec 2024 00:24:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 2/6] xfs: don't crash on corrupt /quotas dirent
Message-ID: <Z1AR1dKAA9SbHcgZ@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106618.1145623.18381388947501707203.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328106618.1145623.18381388947501707203.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 03, 2024 at 07:02:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the /quotas dirent points to an inode but the inode isn't loadable
> (and hence mkdir returns -EEXIST), don't crash, just bail out.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

