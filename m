Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbeEPRZe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 13:25:34 -0400
Date: Wed, 16 May 2018 10:25:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] iomap: provide more useful errors for invalid
 swap files
Message-ID: <20180516172531.GA13464@infradead.org>
References: <cover.1526488995.git.osandov@fb.com>
 <9faf09627cfa469437b76edb73ac7cc822dc33c8.1526488995.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9faf09627cfa469437b76edb73ac7cc822dc33c8.1526488995.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

On Wed, May 16, 2018 at 09:45:50AM -0700, Omar Sandoval wrote:
> +	if ((iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN) ||
> +	    iomap->addr == IOMAP_NULL_ADDR) {
> +		pr_err("swapon: file has unallocated extents\n");
> +		return -EINVAL;
> +	}

The two are really different cases - IOMAP_NULL_ADDR shouldn't really
happen for any of the above.  Although we might have to move the
inline check before the type check above for the message to make sense.

I have a patch in the local queue that makes inline a type instead of
a flag, btw as it really isn't a flag.
