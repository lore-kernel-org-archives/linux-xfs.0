Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hVmGpaop"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CEB170B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/L8eBK0sDfHFAPNJICWj/+NrPppfX1k25u16K9eQTN0=; b=hVmGpaopHvHDlNsnVG4e+I23EW
	Ynxy2vxJU0m20Xkv3dFNvoq+bDTkpu2D4/BtJbmzaOabITGxz7qVvwZVHczGIGCQfihbnalmumRjn
	AMzxvCLDBkgXCXW8EzDJSMJzoBX1ds+Nd0MwtLQoplceTFkb4E2gXR5qu5DfkObF/c4076b9UZnlW
	Ens7/9sMEdHaq+ARiukRiy53zO8KdsgWm0i6ayvmIfoBnvmiMUp//0ODPpJCNc+OUtqCzPcp8ee3n
	gidTxAeng+6d5No8r/uiTDO7BYlDC1LVly9aNx98lrYvdEEO0T6fPmVIRFlmLf3Tvz3vznw/rawPs
	9hMegh2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lfb-008daf-1P;
	Sat, 25 Nov 2023 05:57:35 +0000
Date: Fri, 24 Nov 2023 21:57:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: create separate structures and code for u32
 bitmaps
Message-ID: <ZWGMz5WYlUGpv7OQ@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927011.2770967.5667556103424812308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927011.2770967.5667556103424812308.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:50:02PM -0800, Darrick J. Wong wrote:
> Create a version of the xbitmap that handles 32-bit integer intervals
> and adapt the xfs_agblock_t bitmap to use it.  This reduces the size of
> the interval tree nodes from 48 to 36 bytes and enables us to use a more
> efficient slab (:0000040 instead of :0000048) which allows us to pack
> more nodes into a single slab page (102 vs 85).

The changes themsleves looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Q: should we rename the existing xbitmap to xbitmap64 for consistency?

Also why are the agb_bitmap* wrappers in bitmap.h?  Following our
usual code organization I'd expect bitmap.[ch] to just be the
library code and have users outside of that.  Maybe for later..
