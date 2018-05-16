Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeEPQXa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 12:23:30 -0400
Date: Wed, 16 May 2018 09:23:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iomap: don't allow holes in swapfiles
Message-ID: <20180516162329.GA21071@infradead.org>
References: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>

>  
> -	/* Skip holes. */
> +	/* No holes. */
>  	if (iomap->type == IOMAP_HOLE)
> -		goto out;
> +		goto err;

If we end up not allowing holes this check can just be removed
entirely.  We already check for the allow types below.  I have to
admit I would move that type check above the bdev check, though.
