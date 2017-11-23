Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50770 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753028AbdKWNgl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 08:36:41 -0500
Date: Thu, 23 Nov 2017 14:36:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: log recovery should replay deferred ops in order
Message-ID: <20171123133640.GA27935@lst.de>
References: <20171122182949.GH2135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171122182949.GH2135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Hou Tao <houtao1@huawei.com>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>

Hi Darrick,

this looks generally good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I have a few nitpicks below:

> +	/*
> +	 * We're finishing the defer_ops that accumulated as a result of
> +	 * recovering unfinished intent items during log recovery.  We
> +	 * reserve an itruncate transaction because it is the largest
> +	 * permanent transaction type.  Since we're the only user of the
> +	 * fs right now, take 93% of the available free blocks.  Use
> +	 * weird math to avoid a 64-bit division.
> +	 */

Those magic 93% are 15/16th, maybe better to write it that way :)
That being said / 16 still is a 64-bit division, and I'm pretty sure
we'll run into an old gcc on some weird architecture that will not
turn it into a shift, so better write it as a shift to start with.

> +	freeblks = percpu_counter_sum(&mp->m_fdblocks);
> +	resblks = min_t(s64, UINT_MAX, freeblks);

Didn't I just got called out for using u* types?  The same applies
to s*, so use int64_t here to be consistent.

> +		/*
> +		 * NOTE: If your intent processing routine can create
> +		 * more deferred ops, you /must/ attach them to the
> +		 * dfops in this routine or else those subsequent
> +		 * intents will get replayed in the wrong order!
> +		 */

Please use up all available 80 characters for your comments.
