Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oOI7Pqcz"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E741707
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 20:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+gMKdG/dzw9l1myYDziwK4UqkzVGycb12Iwo5jesFr8=; b=oOI7Pqcz9YK5I6s7NUVfYjPjlq
	gU+jyQ0S6bd4x4THeM71tuaQcmWktgtg20C4zmPieGyzAKqz/J8XOeeaCdQrKiyhxQc7tqPqAaxQj
	YWvCwb9wvn35fWbHSVajZGEbBvFUAqvyXQtYUjtu/+1x/L4BLt6OmYZ5m81FKDRyy/4IfliuXxwHA
	Ht1NTKIJeHtWrTs3C+7pG2dTJauTi1rKyvaza6leaBNGVp3vEXwSWHhZOIiiqFLD4EwX8GY+LTEmi
	qJZuVmXZHY2KXkM70zY9NGEPdIfvMJTN2n9PSJD15GwCjZelvNmAGTCksPj/9LCPvK/uLpLEtIBn/
	edeoQG+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6kjt-008ZOv-0m;
	Sat, 25 Nov 2023 04:57:57 +0000
Date: Fri, 24 Nov 2023 20:57:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: make xchk_iget safer in the presence of corrupt
 inode btrees
Message-ID: <ZWF+1Qz7p7SwdqWB@infradead.org>
References: <170086925757.2768713.18061984370448871279.stgit@frogsfrogsfrogs>
 <170086925774.2768713.17299783083709212096.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086925774.2768713.17299783083709212096.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:46:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When scrub is trying to iget an inode, ensure that it won't end up
> deadlocked on a cycle in the inode btree by using an empty transaction
> to store all the buffers.

My only concern here is how I'm suppsed to know when to use the _safe
version or not.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
