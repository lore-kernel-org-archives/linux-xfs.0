Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfGWRHD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jul 2019 13:07:03 -0400
Message-ID: <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 23 Jul 2019 13:07:00 -0400
In-Reply-To: <20190723155135.GA16481@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
         <20190723151102.GA1561054@magnolia>
         <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
         <20190723155135.GA16481@infradead.org>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>

On Tue, 2019-07-23 at 08:51 -0700, Christoph Hellwig wrote:
> On Tue, Jul 23, 2019 at 05:31:33PM +0200, Carlos Maiolino wrote:
> > CC'ing Jeff so he can maybe chime in too.
> > 
> > 
> > > Er, what problem does this solve?  Does holding on to the pag spinlock
> > > too long while memory freeing causes everything else to stall?  When is
> > > memory freeing slow enough to cause a noticeable impact?
> > 
> > Jeff detected it when using this patch:
> > 
> > https://marc.info/?l=linux-mm&m=156388753722881&w=2
> > 
> > At first I don't see any specific problem, but I don't think we are supposed to
> > use kmem_free() inside interrupt context anyway. So, even though there is no
> > visible side effect, it should be fixed IMHO. With the patch above, the side
> > effect is a bunch of warnings :P
> 
> This is going to break lots of places in xfs.  While we have separate
> allocation side wrappers for plain kmalloc vs using a vmalloc fallback we
> always use the same free side wrapper.  We could fix this by adding a
> kmem_free_large and switch all places that allocated using
> kmem_alloc_large to that, but it will require a bit of work.

(cc'ing Al)

Note that those places are already broken. AIUI, the basic issue is that
vmalloc/vfree have to fix up page tables and that requires being able to
sleep. This patch just makes this situation more evident. If that patch
gets merged, I imagine we'll have a lot of places to clean up (not just
in xfs).

Anyway, in the case of being in an interrupt, we currently queue the
freeing to a workqueue. Al mentioned that we could create a new
kvfree_atomic that we could use from atomic contexts like this. That may
be another option (though Carlos' patch looked reasonable to me and
would probably be more efficient).
-- 
Jeff Layton <jlayton@kernel.org>
