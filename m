Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732677AbeGTRAg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 13:00:36 -0400
Date: Fri, 20 Jul 2018 09:11:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/14] xfs: embed dfops in the transaction
Message-ID: <20180720161137.GG12054@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719200557.GK6558@infradead.org>
 <20180719203643.GJ29404@bfoster>
 <20180719213634.GN4813@magnolia>
 <20180720144106.GB34727@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180720144106.GB34727@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Jul 20, 2018 at 10:41:07AM -0400, Brian Foster wrote:
> Ok.. on this one, running some tests shows that pretty much all dfops
> joined bufs/inodes are essentially held in the transaction (which would
> probably be a bug if that were not the case).

That's what I'd expect.

> The opposite is also true
> for buffers, because a held buffers must also be held in subsequent
> transactions to ensure the caller still has a reference after dfops
> completion. OTOH, there are some places where inodes are joined to a
> transaction with lock_flags == 0 and dfops are run without the inode
> joined to the dfops. I don't necessarily think this is a bug for the
> inode case because the caller still owns the inode lock, we just don't
> relog it across the series of transactions required for dfops
> completion.

I suspect many of those are a bug.  Yes, we could have deferred ops
that don't need the inode, but in general we'd want the same objects
for the deferred inode.

That being said we could always have an indicator for that case, but
I'd rather make it opt-in than opt-out.
