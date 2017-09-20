Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34476 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751509AbdITAuH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 20:50:07 -0400
Date: Tue, 19 Sep 2017 17:49:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs: Uninitialized memory read at xlog_write
Message-ID: <20170920004959.GE7112@magnolia>
References: <20170911150157.GA13400@bfoster.bfoster>
 <201709131614.FAG69217.MSHFFVOFLJtQOO@I-love.SAKURA.ne.jp>
 <20170913094335.GV17782@dastard>
 <201709131859.AHB43227.SOFFOHJVMLFtOQ@I-love.SAKURA.ne.jp>
 <20170913214028.GX17782@dastard>
 <201709141915.HAD04123.FQOSHJtVOLFMFO@I-love.SAKURA.ne.jp>
 <20170914224431.GA10621@dastard>
 <20170918182121.GI6540@magnolia>
 <20170920004639.GO10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920004639.GO10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, bfoster@redhat.com, sandeen@redhat.com, dchinner@redhat.com, linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 10:46:39AM +1000, Dave Chinner wrote:
> On Mon, Sep 18, 2017 at 11:21:21AM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 15, 2017 at 08:44:31AM +1000, Dave Chinner wrote:
> > > xfs: Don't log uninitialised fields in inode structures
> > > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Prevent kmemcheck from throwing warnings about reading uninitialised
> > > memory when formatting inodes into the incore log buffer. There are
> > > several issues here - we don't always log all the fields in the
> > > inode log format item, and we never log the inode the
> > > di_next_unlinked field.
> > > 
> > > In the case of the inode log format item, this is aused b cerbated
> > 
> > "is aused b cerbated" ?
> 
> vi fail when replacing the word "used" with "exacerbated". :)
> 
> > > by the old xfs_inode_log_format structure padding issue. Hence make
> > > the padded, 64 bit aligned version of the structure the one we always
> > > use for formatting the log and get rid of the 64 bit variant. This
> > > means we'll always log the 64-bit version and so recovery only needs
> > > to convert from the unpadded 32 bit version from older 32 bit
> > > kernels.
> > 
> > And those old 32-bit kernels can read the xfs_inode_log_format{,_64}
> > structures, right?
> 
> Yes. With the in-memory format now being the same as the old
> xfs_inode_log_format_64 structure in the log, we only need a
> conversion from "32 bit in log to 64 bit in memory" on all
> platforms.

Ok, that's what I thought.  Will await a positive test result + proper
patch submission. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
