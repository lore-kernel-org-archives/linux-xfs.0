Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Sep 2008 14:52:39 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m82Lqb3U029049
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 14:52:38 -0700
Date: Tue, 2 Sep 2008 17:54:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Tweak tracing allocation sizes
Message-ID: <20080902215401.GD9204@infradead.org>
References: <48BCD3BE.5040107@sgi.com> <20080902055604.GD15962@disturbed> <48BCD93E.9040407@sgi.com> <20080902062722.GF15962@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902062722.GF15962@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 02, 2008 at 04:27:22PM +1000, Dave Chinner wrote:
> > - maybe a very large global trace buffer that is allocated at mount
> > time and shared by all inodes?
> 
> Sure, we've got that for various other trace types (e.g. the "vnode"
> trace). You'd need to add idbg stuff for filtering based on the
> inode the buffer belongs to....

That's probably the best idea.  Currently all these per-object ktrace
buffers do really large no-MAYFAIL allocation all over.  They are in
fact the remaining reason not to simply directly call vmalloc for
large allocations instead of all our current mess in the kmem_
functions.
