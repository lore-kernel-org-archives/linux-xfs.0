Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56386 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbeG3R6h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 13:58:37 -0400
Date: Mon, 30 Jul 2018 09:22:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] xfs: fix cow_seq locking behavior
Message-ID: <20180730162252.GA19254@infradead.org>
References: <20180730055539.GT30972@magnolia>
 <20180730081456.GA25004@infradead.org>
 <20180730155207.GV30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730155207.GV30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 30, 2018 at 08:52:07AM -0700, Darrick J. Wong wrote:
> /*
>  * COW fork blocks can overlap data fork blocks even if the blocks
>  * aren't shared.  COW I/O always takes precedent, so we must always
>  * check for overlap on reflink inodes unless the mapping is already a
>  * COW one.
>  *
>  * It's safe to check the COW fork if_seq here without the ILOCK because
>  * we've indirectly protected against concurrent updates: writeback has
>  * the page locked, which prevents concurrent invalidations by reflink
>  * and directio and prevents concurrent buffered writes to the same
>  * page.  Concurrent changes to other parts of the COW fork will drop
>  * the i_lock on their way out, which provides the necessary memory
>  * barrier to ensure that we see the updated if_seq.
>  */
> 
> I'm not actually sure about the last sentence anymore -- that's what I
> was thinking the first time I looked at this patch, before Dave spoke
> up.

Yeah, that last sentence looks odd.  I'd replace it with:

Changes to if_seq always happen under i_lock, which protects against
concurrent updates and provides a memory barrier on the way out that
ensures that we always see the current value.
