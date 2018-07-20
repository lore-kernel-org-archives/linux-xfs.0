Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733198AbeGTRRB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 13:17:01 -0400
Date: Fri, 20 Jul 2018 09:27:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/14] xfs: support embedded dfops in transaction
Message-ID: <20180720162731.GP4813@magnolia>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-9-bfoster@redhat.com>
 <20180719161825.GE29404@bfoster>
 <20180719194759.GA6558@infradead.org>
 <20180719203120.GF29404@bfoster>
 <20180720160550.GC12054@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180720160550.GC12054@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Jul 20, 2018 at 09:05:50AM -0700, Christoph Hellwig wrote:
> On Thu, Jul 19, 2018 at 04:31:20PM -0400, Brian Foster wrote:
> > On Thu, Jul 19, 2018 at 12:47:59PM -0700, Christoph Hellwig wrote:
> > > On Thu, Jul 19, 2018 at 12:18:26PM -0400, Brian Foster wrote:
> > > > FYI, this accidentally leaves off libxfs/xfs_rtbitmap.c, which also
> > > > requires the xfs_defer.h include treatment.
> > > 
> > > I wonder if we shouldn't just move struct xfs_defer_ops to xfs_trans.h
> > > instead.
> > 
> > I thought about doing that, was curious how many files I'd have to
> > modify and ended up just plowing through them all. :P I'm happy to move
> > the struct def over if nobody objects.
> 
> To me moving it feels like the right thing.  In the end xfs_trans will be
> the prime user of xfs_defer_ops, assuming we even keep it as a separate
> structure at all.

I don't have a problem with moving it either, but if you do please make
sure it ports to xfsprogs (it probably will without much fuss).

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
