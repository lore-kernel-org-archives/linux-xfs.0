Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730008AbfGWPvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 11:51:36 -0400
Date: Tue, 23 Jul 2019 08:51:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723155135.GA16481@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
 <20190723151102.GA1561054@magnolia>
 <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, jlayton@kernel.org

On Tue, Jul 23, 2019 at 05:31:33PM +0200, Carlos Maiolino wrote:
> CC'ing Jeff so he can maybe chime in too.
> 
> 
> > Er, what problem does this solve?  Does holding on to the pag spinlock
> > too long while memory freeing causes everything else to stall?  When is
> > memory freeing slow enough to cause a noticeable impact?
> 
> Jeff detected it when using this patch:
> 
> https://marc.info/?l=linux-mm&m=156388753722881&w=2
> 
> At first I don't see any specific problem, but I don't think we are supposed to
> use kmem_free() inside interrupt context anyway. So, even though there is no
> visible side effect, it should be fixed IMHO. With the patch above, the side
> effect is a bunch of warnings :P

This is going to break lots of places in xfs.  While we have separate
allocation side wrappers for plain kmalloc vs using a vmalloc fallback we
always use the same free side wrapper.  We could fix this by adding a
kmem_free_large and switch all places that allocated using
kmem_alloc_large to that, but it will require a bit of work.
