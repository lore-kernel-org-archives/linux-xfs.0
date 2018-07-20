Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57158 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732141AbeGTQ6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 12:58:22 -0400
Date: Fri, 20 Jul 2018 09:09:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/14] xfs: embed dfops in the transaction
Message-ID: <20180720160923.GF12054@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719200557.GK6558@infradead.org>
 <20180719203643.GJ29404@bfoster>
 <20180719213634.GN4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719213634.GN4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 02:36:34PM -0700, Darrick J. Wong wrote:
> > That sounds reasonable to me. We can always change behavior in a
> > subsequent patch. IIRC the only issue is that intent recovery code has
> > no way to carry dop_low mode around without a transaction. It currently
> > passes around a dfops for each intent. Hmm, perhaps we can have the
> > caller just allocate a transaction, pass it to the recovery helpers for
> > reservation and then just keep rolling it rather than have each helper
> > allocate a transaction anew. I'll look into it, or let me know if you
> > have any other thoughts/ideas.
> 
> That could get tricky, since each log intent item type allocates its own
> transaction with some context-dependent reservation and resblks. Rolling
> our way through the intent items would require us to calculate the max
> reservation size and resblks for all the items beforehand for the
> initial _trans_alloc, which would be kinda messy to avoid having a flags
> field.

For now we can just keep that state in a separate variable, e.g.:

	bool low_space_mode = (tp->t_flags & XFS_TRANS_LOW_SPACE);

	...

	if (low_space_mode)
		other_tp->t_flags |= XFS_TRANS_LOW_SPACE;

Not too pretty but I wouldn't spend to much time on this low space
mode, which fundamentally is a horribly band aid and should eventually
go away once we've fixed up our space reservations for real.
