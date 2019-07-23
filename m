Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388606AbfGWRlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 13:41:53 -0400
Date: Tue, 23 Jul 2019 10:41:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723174152.GA19405@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
 <20190723151102.GA1561054@magnolia>
 <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
 <20190723155135.GA16481@infradead.org>
 <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
 <20190723170843.GA1952@infradead.org>
 <70ea7252bc0cbfc99da7fde1ce58ddb92550885a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70ea7252bc0cbfc99da7fde1ce58ddb92550885a.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Tue, Jul 23, 2019 at 01:38:08PM -0400, Jeff Layton wrote:
> Ahh ok, I get it now. You're using it as a generic "free this, no matter
> what it is" wrapper, and relying on the caller to ensure that it will
> never try to free a vmalloc'ed addr from an atomic context.
> 
> I wonder how many other places are doing that? I count 858 call sites
> for kvfree. If significant portion of those are doing this, then we may
> have to re-think my patch. It seems like the right thing to do, but we
> there may be more fallout than I expected.

For xfs we only have 4 direct callers of kmem_alloc_large, and 8 callers
of kmem_zalloc_large, so it they aren't too many, even assuming that due
to error handling we usually have a few more sites that free the
buffers.
