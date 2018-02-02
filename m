Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44619 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbeBBJsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 04:48:04 -0500
Date: Fri, 2 Feb 2018 01:48:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_extent_busy_flush vs. aio
Message-ID: <20180202094802.GA17952@infradead.org>
References: <dde543cc-6641-c5ee-3385-520ef4ca821e@scylladb.com>
 <20180123152852.GA32478@bfoster.bfoster>
 <509e33df-4f76-2937-0425-98c26b3a1207@scylladb.com>
 <20180123161120.GC32478@bfoster.bfoster>
 <5f67219e-e48b-a954-69d4-318268645377@scylladb.com>
 <20180123164718.GE32478@bfoster.bfoster>
 <e1229a02-33ea-e5d5-d66f-36fa553a3393@scylladb.com>
 <20180123173902.GF32478@bfoster.bfoster>
 <f4751375-0710-cec8-ac6d-1f9546bba1ce@scylladb.com>
 <20180125130830.GD43198@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125130830.GD43198@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 08:08:31AM -0500, Brian Foster wrote:
> I suppose it's possible that this was some kind of transient state, or
> perhaps only a small set of AGs are affected, etc. It's also possible
> this may have been improved in more recent kernels by Christoph's rework
> of some of that code. In any event, this would probably require a bit
> more runtime analysis to figure out where/why allocations are getting
> stalled as such. I'd probably start by looking at the xfs_extent_busy_*
> tracepoints (also note that if there's potentially something to be
> improved on here, it's more useful to do so against current upstream).
> 
> Or you could just move to something that supports RWF_NOWAIT.. ;)

The way the XFS allocator works has always had a fundamental flaw
since we intorduced the ocncept of busy extents, and that is we need
to lock ourselves into an AG or sometimes even range without taking
said busy extents into account.

The proper fix is to separate the in-core and in-memory data structures
for free space tracking, and only release the busy extents to the
in-memory one once they aren't busy anymore.

Looking into this has been on my todo list for a long time, but I
never go to it.
