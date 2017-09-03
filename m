Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28136 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752907AbdICPlR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 11:41:17 -0400
Date: Sun, 3 Sep 2017 08:40:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: revert "xfs: factor rmap btree size into the indlen
 calculations"
Message-ID: <20170903154050.GG4073@magnolia>
References: <20170902170626.GC4073@magnolia>
 <20170903074358.GB8351@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903074358.GB8351@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Sun, Sep 03, 2017 at 12:43:58AM -0700, Christoph Hellwig wrote:
> On Sat, Sep 02, 2017 at 10:06:26AM -0700, Darrick J. Wong wrote:
> > In commit fd26a88093ba we added a worst case estimate for rmapbt blocks
> > needed to satisfy the block mapping request.  Since then, we added the
> > ability to reserve enough space in each AG such that we should never run
> > out of blocks to grow the rmapbt, which makes this calculation
> > unnecessary.  Revert the commit because it makes the extra delalloc
> > indlen accounting unnecessary and incorrect.
> 
> Do you remember any details of why we added it and what is supposed
> to fix it?  I have memories of various issues in this area, but I
> can't remember the details.

We'd fill the fs up with delalloc reservations until there wasn't any
space, and once the fs fragmented badly then we suddenly needed more
than just the indlen to satisfy bmbt + rmapbt expansion.  This indlen
patch was a hack to try to ENOSPC out of write_begin/page_mkwrite before
we ran the fs totally out of blocks back when we were still trying to
cram the bmbt and rmap updates into a single huge transaction.  Deferred
ops broke that, and perag reservations made it unnecesary, so now we can
rip it out.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
