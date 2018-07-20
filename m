Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56870 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731746AbeGTQyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 12:54:46 -0400
Date: Fri, 20 Jul 2018 09:05:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/14] xfs: support embedded dfops in transaction
Message-ID: <20180720160550.GC12054@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-9-bfoster@redhat.com>
 <20180719161825.GE29404@bfoster>
 <20180719194759.GA6558@infradead.org>
 <20180719203120.GF29404@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719203120.GF29404@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 04:31:20PM -0400, Brian Foster wrote:
> On Thu, Jul 19, 2018 at 12:47:59PM -0700, Christoph Hellwig wrote:
> > On Thu, Jul 19, 2018 at 12:18:26PM -0400, Brian Foster wrote:
> > > FYI, this accidentally leaves off libxfs/xfs_rtbitmap.c, which also
> > > requires the xfs_defer.h include treatment.
> > 
> > I wonder if we shouldn't just move struct xfs_defer_ops to xfs_trans.h
> > instead.
> 
> I thought about doing that, was curious how many files I'd have to
> modify and ended up just plowing through them all. :P I'm happy to move
> the struct def over if nobody objects.

To me moving it feels like the right thing.  In the end xfs_trans will be
the prime user of xfs_defer_ops, assuming we even keep it as a separate
structure at all.
