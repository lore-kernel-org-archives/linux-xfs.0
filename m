Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 12:24:37 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OJORQ3027493
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 12:24:30 -0700
Date: Mon, 24 Sep 2007 20:24:26 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-ID: <20070924192425.GA6629@infradead.org>
References: <20070920195249.852667D5@kernel> <20070920195320.38C8E20D@kernel> <20070924175411.GA2314@infradead.org> <20070924121035.8d8c6ce2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924121035.8d8c6ce2.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 24, 2007 at 12:10:35PM -0700, Andrew Morton wrote:
> > As we already say in various messages the percpu counters in here
> > look rather fishy.  I'd recomment to take a look at the per-cpu
> > superblock counters in XFS as they've been debugged quite well
> > now and could probably be lifted into a generic library for this
> > kind of think.  The code is mostly in fs/xfs/xfs_mount.c can
> > can be spotted by beeing under #ifdef HAVE_PERCPU_SB.
> > 
> > It also handles cases like hotplug cpu nicely that this code
> > seems to work around by always iterating over all possible cpus
> > which might not be nice on a dual core laptop with a distro kernel
> > that also has to support big iron.
> 
> hm.  How come xfs invented a new version of percpu_counters?

This code actually predates the generic percpu_counters even if it
was merged to mainline later.  Neither Dave who wrote it nor me
who reviewed it before it was merged thought of percpu_counters
probably.  Then again this code is considerably more complex due
to features actually needed in a very hot fastpath.
