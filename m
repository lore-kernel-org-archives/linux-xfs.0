Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 19:44:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3B2iTnu030350
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 19:44:33 -0700
Date: Fri, 11 Apr 2008 12:44:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: iget behaviour in xlog_recover_process_iunlinks
Message-ID: <20080411024457.GL103491721@sgi.com>
References: <20080410190453.GA8083@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410190453.GA8083@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2008 at 09:04:53PM +0200, Christoph Hellwig wrote:
> shouldn't we call xfs_iget with the XFS_IGET_CREATE flag here?
> 
> the code seems to be perfectly happy with zero-ed out inodes as long as
> di_next_unlinked is valid.

Don't think so - di_mode is not zero'd until the inode is removed
from the unlinked list. Hence if it requires recovery from the unlinked list,
then INACTIVE transaction that removes it from the unlinked list and sets
di_mode to zero has not been replayed at all. XFS_IGET_CREATE is only
needed for inodes with a zero di_mode....

IOWs, I'm not sure how you'd get an inode with a zero mode on the unlinked
list at all, and certainly the current xfs_iget() call should not return
any inodes with a zero di_mode. So why is there special code to handle
this in recovery?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
