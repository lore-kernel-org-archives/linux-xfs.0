Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:51908 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932403AbeCDXBZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Mar 2018 18:01:25 -0500
Date: Mon, 5 Mar 2018 10:00:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180304230049.GA18129@dastard>
References: <20180301014144.28892-1-david@fromorbit.com>
 <20180302222031.GA30818@lst.de>
 <20180302222641.GA30953@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302222641.GA30953@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Mar 02, 2018 at 11:26:41PM +0100, Christoph Hellwig wrote:
> While we're at it we should probably
> also skil the generic_write_sync call for DAX pure overwrites while
> we're at it.

Now that I've looked at it, DAX is a friggin' mess.

We can't push the generic_write_sync() call into dax_iomap_rw()
because dax_iomap_rw is called with the inode_lock() held, and both
ext2's and ext4's ->fsync implementation can call
__generic_file_fsync() which takes the inode_lock(). Deadlock
central right there - someone is going to have to screw with ext4's
indoe sync code to before we can do this.

Further, XFS has post-write metadata updates to do in the case of
extending writes, and hence we'd still need the call to
generic_write_sync() after we have returned from dax_iomap_rw(). I'm
thinking we'd really need a dax write IO completion callback (say in
the struct iomap_ops) to run the filesystem specific IO completions
(like the DIO path) before we can start to think about optimisations
like this for DAX for XFS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
