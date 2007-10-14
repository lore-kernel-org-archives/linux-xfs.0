Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Oct 2007 16:10:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9EN9xPp021249
	for <xfs@oss.sgi.com>; Sun, 14 Oct 2007 16:10:02 -0700
Date: Mon, 15 Oct 2007 09:09:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS regression?
Message-ID: <20071014230949.GO23367404@sgi.com>
References: <20071010152742.1b2a7bce@zeus.pccl.info> <20071011010139.GT995458@sgi.com> <20071011151512.69f19419@zeus.pccl.info> <20071011215352.GX995458@sgi.com> <20071012002613.GL23367404@sgi.com> <20071012123601.291fee8a@zeus.pccl.info> <cc7060690710130635u2a85bc28we36b344c0987b691@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7060690710130635u2a85bc28we36b344c0987b691@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: Andrew Clayton <andrew@digital-domain.net>, David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Oct 13, 2007 at 07:05:17PM +0530, Bhagi rathi wrote:
> David, Can you let me know the use after free problem? I want to understand
> how the life cycle of linux inode
> and xfs inode are related to log flush.

Log I/O completion:

  -> xfs_trans_commited
       -> xfs_iunpin(xfs inode)
         get linux inode from xfs inode
          -> mark_inode_dirty_sync(linux inode)

Freeing the linux inode:

clear_inode(linux_inode)
 -> xfs_inactive()
    -> xfs_trans_commit() (e.g. freeing data associated with unlinked inode)
       -> xfs_ipin()
    (link between xfs and linux inode broken)
  linux inode freed 
 
So, in log I/O completion, we can be completing a previous
transaction at the same time clear_inode() is running, and
hence in xfs_iunpin() we can race with the freeing of the
linux inode as xfs_iunpin does not hold any locks.

> Any pointer is also of great help.

/me points at the code.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
