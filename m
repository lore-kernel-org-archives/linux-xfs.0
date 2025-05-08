Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067E778F37;
	Thu,  8 May 2025 04:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746677964; cv=none; b=Wmfw76WX0s3s0pq/lJK31urQCb434sUhadM7a1eSN5NwpWsR4kx39kvDHy8pLy9iRVGwZ8sOWF7SwwBG6vjkRLJHOZ7xvZ8OwK5SdX87aiNnY/EQt53zVizB2k4kMogLissgGe7oYfAFtpOcpqn5PUSfQE3KS5sFsav3jnIVF4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746677964; c=relaxed/simple;
	bh=SHYmoMiH/tDcEeEr3FDheswgZZ4C/dn+2QghPF1XOPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQfcw9u7edIG5er2oFpxU/zbg7BNPkszfqCxOtnU9aukh48XpdQiIvPmj7mSveBLZnJtgTpGkjMQoZKu0Xxd27iG4J0ysIyoLQM9sBwkVdAQEwKpNrlrar0Oezmti3RPuPqKhh0xOThOVUzEJCGsZMLv/GIjrPGavh1t4V3WZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FrD2QJR2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FrD2QJR2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rWMqtnGLrbtnDgEZgXncbKFThDZXKtwzGSyoV0fIRJY=; b=FrD2QJR2yvaHD8Nco3d8Hepl51
	3He2tXjrKlo7J105vZErpjmIZAh4mP4yrfypW5EM6IUGpx8KkOtDiXhtYa13CCY+HvOwMESjg4183
	TFVijH4v1uPveAMgrq84Wxkj+dNEHTq2LgG6/owmxP0v8104IeLopkLksLsqxdFOPri6ly949PFXi
	vG7LVk2i43lr3C2sgmoCf5M6hVD7eM8d1w6puEbKJ4ywaf68z7LeOacaA8kISOTTZ8BOs+bavkJb6
	atDOdaBbkkB6nMoxAzZv48z9EDa6KywYi2SP3qKHJXgDDMHRy/oApO+vlMcT+qXFVZ29lAuiA/0nV
	woPzfEog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCsjC-0000000HHCN-2fhl;
	Thu, 08 May 2025 04:19:22 +0000
Date: Wed, 7 May 2025 21:19:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fsstress: fix attr_set naming
Message-ID: <aBwwykf7xaGXHnVD@infradead.org>
References: <174665480800.2706436.6161696852401894870.stgit@frogsfrogsfrogs>
 <174665480825.2706436.15433477670941336936.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174665480825.2706436.15433477670941336936.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 07, 2025 at 02:54:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in 2020 I converted attr_set to lsetxattr, but neglected to notice
> that the attr name now has to have the prefix "user." which attr_set
> used to append for us.  Unfortunately nobody runs fsstress in verbose
> mode so I didn't notice until now, and even then only because fuse2fs
> stupidly accepts any name, even if that corrupts the filesystem.

Looks good

Reviewed-by: Christoph Hellwig <hch@lst.de>

I wonde if this creates a fallout somewhere else now that we actually
do xattr ops that don't fail..

