Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E8E3839A1;
	Tue, 15 Sep 2026 06:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454006; cv=none; b=ocXPDTCHa+K2HG5zFo9Qxx7am6+bMzT2KBnZj5Lo4o5bD7VLwLLup/1I9U2FcYAq2pRzPPtvXHld7TZyHpPq8paEEgw7dAt2Z51P+F9mFWC8zqP2nfDVuVPw8IiHGVzqZt8NagaEO+AwJYU2rDp1VGbDvlyJqXF9zcUnc0mXkoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454006; c=relaxed/simple;
	bh=wmbkmz5elqXH+Ee6bCo5UGfkcslESAKS3yI1/cEiXho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYuQevQOudwEVnUhlkFwyMTRBXOjlB0znVDujQ6ZgIWKaZDs5TxM3w9ZzNPtyVbMxM5vUd5Vwzz1efWat5TpEoDS2z66BHUjU25sh3YEbD+8ptqzdoE+W/cL4ncttMVXhY9lVuAfBkOWBKgLHSiM4322ajdk2BYQrSlYBQdWVSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T8M1b4Oh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T8M1b4Oh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CgzcBpZknaxw2d108gJra5McxdciI70P9szsLpVMkVY=; b=T8M1b4OhQUKhMSHljz37VAv5t3
	Cfvivc06wP0B8kJPXlgQgk1DyBM7cLBF5mcChLpKkixq7l+HNHWb9crtD5r4gd4Zvk5tilmsEcAWT
	7MY/YM+lJ+7UNVYFlpeniBPN/umIDyAJhjrNZeSmkzoVvNFRnrqGLaypcCIYWtdd7I9A5s1Cqi/Xv
	4AMx5+NmAy5gY+4LtWD219AQJXdWN6qrRIgimbhOCPOBOofRcGPEKANLsTZawTQGZ9mvvVVxfYosk
	BeVsCc6CUAfPV1p82uenkIu42ahvMGtIoedVRtCkSJENIJLMptcBF/uFbNGbfWwCYRcqko3HlKICw
	kwHfcyaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6MjN-00000005M0q-00Y3;
	Tue, 15 Sep 2026 06:33:25 +0000
Date: Mon, 14 Sep 2026 23:33:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: fix wild memcpy access when formatting ondisk
 rtrefcount btree roots
Message-ID: <aqjmtJCMRkYfpbZ9@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048731.3061055.2062919508652373941.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048731.3061055.2062919508652373941.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 14, 2026 at 10:39:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that the inode btree root formatting methods copy too many
> bytes -- there's only one set of keys in node blocks, not two.  This
> causes memory corruption of whatever's beyond the buffers.

Eeek.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

