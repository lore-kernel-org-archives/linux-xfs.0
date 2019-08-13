Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40700 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbfHMPkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 11:40:13 -0400
Date: Tue, 13 Aug 2019 08:40:10 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3] vfs: fix page locking deadlocks when deduping files
Message-ID: <20190813154010.GD5307@bombadil.infradead.org>
References: <20190813151434.GQ7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813151434.GQ7138@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Aug 13, 2019 at 08:14:34AM -0700, Darrick J. Wong wrote:
> +		/*
> +		 * Now that we've locked both pages, make sure they still
> +		 * represent the data we're interested in.  If not, someone
> +		 * is invalidating pages on us and we lose.
> +		 */
> +		if (src_page->mapping != src->i_mapping ||
> +		    src_page->index != srcoff >> PAGE_SHIFT ||
> +		    dest_page->mapping != dest->i_mapping ||
> +		    dest_page->index != destoff >> PAGE_SHIFT) {
> +			same = false;
> +			goto unlock;
> +		}

It is my understanding that you don't need to check the ->index here.
If I'm wrong about that, I'd really appreciate being corrected, because
the page cache locking is subtle.

You call read_mapping_page() which returns the page with an elevated
refcount.  That means the page can't go back to the page allocator and
be allocated again.  It can, because it's unlocked, still be truncated,
so the check for ->mapping after locking it is needed.  But the check
for ->index being correct was done by find_get_entry().

See pagecache_get_page() -- if we specify FGP_LOCK, then it will lock
the page, check the ->mapping but not check ->index.  OK, it does check
->index, but in a VM_BUG_ON(), so it's not something that ought to be
able to be wrong.
