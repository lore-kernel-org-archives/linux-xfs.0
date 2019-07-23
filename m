Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58088 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfGWRIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 13:08:44 -0400
Date: Tue, 23 Jul 2019 10:08:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723170843.GA1952@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
 <20190723151102.GA1561054@magnolia>
 <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
 <20190723155135.GA16481@infradead.org>
 <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Tue, Jul 23, 2019 at 01:07:00PM -0400, Jeff Layton wrote:
> Note that those places are already broken. AIUI, the basic issue is that
> vmalloc/vfree have to fix up page tables and that requires being able to
> sleep. This patch just makes this situation more evident. If that patch
> gets merged, I imagine we'll have a lot of places to clean up (not just
> in xfs).
> 
> Anyway, in the case of being in an interrupt, we currently queue the
> freeing to a workqueue. Al mentioned that we could create a new
> kvfree_atomic that we could use from atomic contexts like this. That may
> be another option (though Carlos' patch looked reasonable to me and
> would probably be more efficient).

The point is for XFS we generally only use kmem_free for pure kmalloc
allocations under spinlocks.  But yes, the interfac is a little
suboptimal and a kmem_free_large would be nicer and then warnings like
this that might be pretty useful could be added.
