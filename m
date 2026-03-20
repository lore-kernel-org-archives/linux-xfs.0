Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A12E36F8
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773991174; cv=none; b=mHuTieU35RO8qUTGWq3lmPngfuWXfoW9gpI6oqB4jXFPIyjZoAP6HCyFB0Tq49keoVL6r+T6djORPqAnKc1nJxwHw+ttQwKeVpIiZ8yPAxzODqz173Y3VT+wekYSI5IYcVEnIh4xBM9qN8KRfNJXebCCwtGc7skPjaz7Dp3irBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773991174; c=relaxed/simple;
	bh=Fk0IqtG89607bEeujDFQwR3a7XjBrXNNOIpRWD4Zx+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcmPhant6vTHlPqRYWWembFfzD8Q5GeeABMxt6RsW8IZ8wkL+fRJkoNtsuqa3Pea2xmXujb00mU3oWnOO1FbSdijOtFYftxybuJaEv68YAjZHRxWy0Qq9nne44aeybJssSE7ld+yCEoPXziURWXgDonzoUjBPU8Glzg2DfeYWCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QunVHViu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QunVHViu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4PUfSfF7TGQqRRz08UDsXwKFpvOticRcjJdUsAQmUvY=; b=QunVHViulHjt6j7L48VdiNX821
	ThzQElXMLSiYzsVBhTlqzRSH57pg94PDAHrPgbP1GUZjZHH2MdWvvi4eTG+WSQWuQ887yMhfDjaFB
	tfEyO//cpKYq7wH+kBSClQ5vL3nKTnI5GxqkCMIBST9cYrtoxzy/Wu4kpSsoJunANAuVEVh8oF2Ki
	4wJ3tyOv2M+zlur5nAkrUYujdpD0JPZF3RwGNGLrBvOgory5dOXPbh90E8ekghKlVZe/OmKXjgpm5
	1rCuorSXjPxo0aCJyp/A0gDEUod4o69Ss63xC5+dNN8DORd2XuBhmAeTg56texlPgIdmUQiGpIuKh
	iUTI6mHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U8r-0000000CEXb-1D9n;
	Fri, 20 Mar 2026 07:19:33 +0000
Date: Fri, 20 Mar 2026 00:19:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 2/2] xfs: don't irele after failing to iget in
 xfs_attri_recover_work
Message-ID: <abz1BR8rDZJhbLff@infradead.org>
References: <20260319170938.GS1770774@frogsfrogsfrogs>
 <20260319171044.GT1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319171044.GT1770774@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 19, 2026 at 10:10:44AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xlog_recovery_iget* never set @ip to a valid pointer if they return
> zero, so this irele will walk off a dangling pointer.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

