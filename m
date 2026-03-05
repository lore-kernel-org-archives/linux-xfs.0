Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44728396584
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 14:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719594; cv=none; b=ItjmGIBBP4ncWUQnm/jtbml/TDSoJMcRegGHD88H+KWceAnJhesg76dV8MGCQk5unLOiqxXK1t5J+O1iN6yWC5W9+LAZRpGHUb2CiBCu5hzC6iVak4DDneVgOLCrq/9C3K7Hj4VPCGqnoN7tuDuS1/NweUf0KJwzOhmvGBiPpz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719594; c=relaxed/simple;
	bh=ji4Jq+Dz4RM3sKG5tc+tfCPD7VP0NcI4ZdHZ1C3dmp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFCzJHJnIrqEQmlmBijCWlitYkKGXH+z66KIcDreEocY/vYjN4GZFMZ1MXVD9SrxJZ59Dh9SjRG0oIKbO4doq2hYqUbnlXW0jj3Clf38nbw7YUwqfaOqsU3pt3oA3rshKjpYXWYsrX5FOGKJ24cMXtnhzgazsqEtCCw8p+bW+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2vJo+V/r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2vJo+V/r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ji4Jq+Dz4RM3sKG5tc+tfCPD7VP0NcI4ZdHZ1C3dmp8=; b=2vJo+V/rUgPPME8olNAg0sRQRW
	jQJxKanOjzXMCMsnVV8wtClyfvDHfiLWJRVxSJ8vTtu4rWGOAZ6cGo2jSma1OLw+PDpEGNt4tpjG9
	Op+G+jB/4l2PfQHHk2YbLpuJu6kQpRrl5G4AQ9cTmFcgRh+e2rqEtIxknhh38bMMjS1aEP/1X/XjS
	kE1/VOkMTOqtsP9B7lJkI7T8qosnDj4oH1fqPK+no9LnVY/oSNTXW7B7FtOD+MWusnWzBMz9NUQut
	8o/R9V0KoK1AkXNUJDEQdL8pbQX8I6LSwxT3oSoOXkjf7ca3cZ4vSXDuY0drw7s24+/408EbE6TgC
	mrpvBDUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9LT-00000001vJx-0Wz0;
	Thu, 05 Mar 2026 14:06:31 +0000
Date: Thu, 5 Mar 2026 06:06:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: remove redundant set null for ip->i_itemp
Message-ID: <aamN57CqiAXJQH39@infradead.org>
References: <20260305084922.800699-1-leo.lilong@huawei.com>
 <20260305084922.800699-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305084922.800699-2-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 05, 2026 at 04:49:21PM +0800, Long Li wrote:
> ip->i_itemp has been set null in xfs_inode_item_destroy(), so there is
> no need set it null again in xfs_inode_free_callback().

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

