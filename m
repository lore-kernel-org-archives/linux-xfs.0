Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D419B3A16B2;
	Wed, 19 Aug 2026 06:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120409; cv=none; b=f6Nwp98YUCiK/JDKGw53++iyintn9b6uKXCbPpCMDSRblWEFE24eRcIJRBLaGdiz7sSuqzA0gURzqZ94T/p+Mj+d8ZXPy/9MXGUWb6SIHzLPyZSPX2QJQGtMFSSiRodLJVSnpBiUjihbvnVPcbQ8yRb0UtG13zh8Lbe8U9s27dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120409; c=relaxed/simple;
	bh=SbMmXbUSRsywEg9qwXsm1e0Bpxb9JyX75wHwPcyol5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1oMtize+JCKCY41bq2a96qI3103BOpgH2ReLQWSRsWi3ixiJ8akeFdj/j2NiC0ko/8mUTV7Jgk4wyA8GW/VN12OFA8AlQ/4aRhZvPsq1RY0XLHorgVBFAJRZVj/XabGq2keyJvqUS/EbCQRRl/ZS7pmhKtIqU9x/dEBhoceyvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RWRMaE+s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RWRMaE+s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d+Dcv/VtkzdUPJBL1ZqeJ2e3UFSn/41pDGWiX7vf+Io=; b=RWRMaE+soAbMw93pY6pjo0Wp+/
	WOaOU2JvqrsySZ6JufJCaU6+uhgERQIUefyg+Z8e05uLxglj4IJlAAJp8pdfM27w7LVvf59eGyKhl
	QuM5Nf1vRetsldSaBnpDaJykRVDlkUiqtyTFEF8OA+FnDqYrOCUWlFXa7lJCwChYgfKI1TeLZNpvp
	bO4LJi+JWZSayye9I+ZiMxBsZ/5e5rbpZcLl+/aHGFMpUfYjY/aSTrzMK4ULT5nSV6Y3alX1jjD2Q
	+BKNaLYH3Q4dqiWbzAIA+85MTJ2m35PMVlsl8vl7gpxE6D28p58kK3sbEeXA2OS01HbJ5rua3UXC1
	iQlvsH0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZeh-000000095aQ-0MOC;
	Wed, 19 Aug 2026 06:20:07 +0000
Date: Tue, 18 Aug 2026 23:20:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't leak new_bp if xfs_btree_bload_drop_buf
 fails
Message-ID: <aoVLFy0F8Z8sDqfZ@infradead.org>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861940.833922.4172164469168951361.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178659861940.833922.4172164469168951361.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 12, 2026 at 10:26:12PM -0700, Darrick J. Wong wrote:
> xfs_btree_bload_drop_buf can hit an IO error if writing the delwri
> buffer list to disk fails.  In this case, we fail to release new_bp,
> which means we lose a locked buffer.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
