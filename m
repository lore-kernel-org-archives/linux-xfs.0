Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:65463 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755419AbcISALs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Sep 2016 20:11:48 -0400
Date: Mon, 19 Sep 2016 10:11:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] fs: add iomap_file_dirty
Message-ID: <20160919001143.GU30497@dastard>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
 <147216786712.525.5901639662288553230.stgit@birch.djwong.org>
 <20160905145751.GC7662@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160905145751.GC7662@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, viro@ZenIV.linux.org.uk, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-api@vger.kernel.org

On Mon, Sep 05, 2016 at 07:57:51AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 04:31:07PM -0700, Christoph Hellwig wrote:
> > Originally-from: Christoph Hellwig <hch@lst.de>
> 
> This should be a
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> so that git picks up authorship information correctly.
> 
> > XXX: might want a bigger name, and possible a better implementation
> > that doesn't require two lookups in the radix tree.
> 
> And these need to be looked into.  I can take a stab at it, but I need
> to get a few other things off my plate first.

Seeing as it works and isn't too ugly to live, I think I'm going to
merge this as is. When a better implementation comes along we
can replace it with that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
