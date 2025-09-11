Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558AF31A057;
	Thu, 11 Sep 2025 11:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589333; cv=none; b=tJ/t0BpT8w7C8ledTtPV1kUCN0IA1k9fbLOvzcl3D3DTjdZNsRKqt6EKl34cOQ+YXkWaU1GfT+Q9TKItcQLkBgWHngmISkcSZxt8QGMls0C9AXYPWstriI93WH3wjt1govHdlHk55ydIRYjOdWXz1nZ4F5VNoo3FDxU+dwI/5so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589333; c=relaxed/simple;
	bh=ePnQIg6VLH0BpANGrW/7pchIuSQ1xQQyWDiKAniRlrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLTDOywCDFO/YKYOjyX4V6ryEgDIckrDbw03epnQTJBPx0zDJdURYiqCORI0iqMoVQu6p3NXtZ96WLuuuKypECqQj3PRqd86Y5LdGSq1wEotVRIZsq/V7rCjxc9D3owvyy6bWUoK5pt01U3T35jmdrlonYsrZBcdZA0dV3MUqNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=waLGN5tG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="waLGN5tG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LcDGpRTdcR8UCEwxbBbt9wJD5efIvWJU8lGy1UmtUh0=; b=waLGN5tG1GwJwqxTHikeJyWNa/
	lTSAYltyy9WedmSClGnWxMrAAjMFpnYN29DPcmTMSUrQRKdvio14YL7KxcBlkIX3J9Bmg3t0iR2th
	E2VD4Yyvmd2yguR6rpt0m0clFb/omtNZJA5AHLxCLVRz+DP4UtX6usWWybBVVqISxvnRPZOopV3Ip
	vMdqnneb5f+N8GWBrYQ/f1ujzC6NCozJqsMHT4LIh8GqJPhf45Ar6v6lLYPmg/e5cci86JXFFfgsB
	YyQ+NIMfHwXHd9HCuTyyLb76Iy99j059s+dpURGI+VEpu4KW5mOt/i8/WKirVTiSeHZXRJsTiXz/z
	5Y4pf4hQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwfH0-00000002bdn-1Yu9;
	Thu, 11 Sep 2025 11:15:30 +0000
Date: Thu, 11 Sep 2025 04:15:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, miklos@szeredi.hu, hch@infradead.org,
	djwong@kernel.org, hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 06/16] iomap: iterate over entire folio in
 iomap_readpage_iter()
Message-ID: <aMKvUsgJU9ySP2fb@infradead.org>
References: <20250908185122.3199171-1-joannelkoong@gmail.com>
 <20250908185122.3199171-7-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908185122.3199171-7-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 08, 2025 at 11:51:12AM -0700, Joanne Koong wrote:
> +		/*
> +		 * We should never in practice hit this case since
> +		 * the iter length matches the readahead length.
> +		 */

This can also use up all 80 characters for the comment.  Otherwise looks
fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

