Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbdIFRei (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 13:34:38 -0400
Date: Wed, 6 Sep 2017 13:34:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: revert "xfs: factor rmap btree size into the indlen
 calculations"
Message-ID: <20170906173436.GH55280@bfoster.bfoster>
References: <20170902170626.GC4073@magnolia>
 <20170903074358.GB8351@infradead.org>
 <20170903154050.GG4073@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903154050.GG4073@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Sun, Sep 03, 2017 at 08:40:50AM -0700, Darrick J. Wong wrote:
> On Sun, Sep 03, 2017 at 12:43:58AM -0700, Christoph Hellwig wrote:
> > On Sat, Sep 02, 2017 at 10:06:26AM -0700, Darrick J. Wong wrote:
> > > In commit fd26a88093ba we added a worst case estimate for rmapbt blocks
> > > needed to satisfy the block mapping request.  Since then, we added the
> > > ability to reserve enough space in each AG such that we should never run
> > > out of blocks to grow the rmapbt, which makes this calculation
> > > unnecessary.  Revert the commit because it makes the extra delalloc
> > > indlen accounting unnecessary and incorrect.
> > 
> > Do you remember any details of why we added it and what is supposed
> > to fix it?  I have memories of various issues in this area, but I
> > can't remember the details.
> 
> We'd fill the fs up with delalloc reservations until there wasn't any
> space, and once the fs fragmented badly then we suddenly needed more
> than just the indlen to satisfy bmbt + rmapbt expansion.  This indlen
> patch was a hack to try to ENOSPC out of write_begin/page_mkwrite before
> we ran the fs totally out of blocks back when we were still trying to
> cram the bmbt and rmap updates into a single huge transaction.  Deferred
> ops broke that, and perag reservations made it unnecesary, so now we can
> rip it out.
> 

It's not totally clear to me what the original patch would have done,
since we technically could return all of the indlen on delay -> real
extent conversion before the rmap operation would have even run. Perhaps
it could hide a problem by reserving blocks only to release them just
before we'd actually need to allocate rmapbt blocks..?

Anyways, the patch seems fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> --D
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
