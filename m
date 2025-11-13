Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9571932ED2F
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 08:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763021256; cv=none; b=lNXipqvGYCT39vnwRlpEHfKtkuUbBqlKcMabHq4nGEdy9wqOgdxa21Ksxuyi5FMitsmjuw8rXADYT7g4IXDpBlc9ieCXttmPhSPUFALaCDKNW0yzjiljdFOPJoe7dP94nq9l+fPuZl7nl2nqdRvP1D6SLXQELDwjE5aPnz+WtCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763021256; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFJoCoImp5s2BdQZbmBuQPH1X9MRgIVLwl0GKyGGl0TaHsMUcCk7qBuCNpXhfQIHhAbA9t/31ts7D4eGlRVMiDl9Zb/nhN9cLw6pI0KhKOaUkzNxfYywihx+4OW7b9fXNpVUOL0qdYl5whFh/Kbbgam8DCuKV8AuHmgHVfIBy5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JzqNDw64; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JzqNDw64"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JzqNDw64im1e3DLyRs/tez9M5A
	xbGDQcm/p5C42FWmlJsTYhxWKy9TxbTsV4kbv8qFx6XPUdobviS7He3Hj/5OsFt1zsAxIqXydRszR
	iRPPtqGc07Lan5YfE6sO4jA7Kmrc+v8PXgbIbVcxurHiem9zvF+Cbe2EFNI1cjJ41BmZ3eYba3w+o
	4UTh6299FL9Hda073LXlxzkpRhSUKlLcC9wmvQXe0Ktn+8TbwqbHt84MKw1pVTJXy7yPbEUDN13lf
	x4xd6pc9GycbZmhfyqSdBgcBzAWJmqEPhy6sRZ/iE2/dRYUXYzAhyGQjHF23PHm7uyKCKB5vbFt8S
	Y6J1sW+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJSMf-0000000A3N0-0Co9;
	Thu, 13 Nov 2025 08:07:33 +0000
Date: Thu, 13 Nov 2025 00:07:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Wu Guanghao <wuguanghao3@huawei.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	yangyun50@huawei.com
Subject: Re: [PATCH] libxfs: remove the duplicate allocation of
 xfs_extfree_item_cache
Message-ID: <aRWRxTyuX9PHpRpx@infradead.org>
References: <7ae57ed5-75bd-277b-8cb7-970e65761dcd@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ae57ed5-75bd-277b-8cb7-970e65761dcd@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

