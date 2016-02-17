Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D21F7CA2
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 18:24:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E0B0304032
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 16:23:59 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2A2VGdS23651Dpg2 for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 16:23:56 -0800 (PST)
Date: Wed, 17 Feb 2016 11:23:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] xfs: fixes for XFS_DIFLAG2_DAX support
Message-ID: <20160217002353.GA19486@dastard>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
	<20160216235353.GA25419@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160216235353.GA25419@linux.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: jack@suse.cz, xfs@oss.sgi.com

On Tue, Feb 16, 2016 at 04:53:53PM -0700, Ross Zwisler wrote:
> On Mon, Feb 15, 2016 at 04:22:10PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is a series to add the correct constraints to using the on-disk
> > inode flag to enable DAX on per-file basis. The same constraints are
> > placed on setting the flag on directories for inheritance purposes.
> > 
> > These constraints are:
> > 	- the inode flag is limited to regular files or directory
> > 	  inodes.
> > 	- the S_DAX flag is only ever set on regular files
> > 	- the flag can only ever be set on filesystems which have
> > 	  blocksize == PAGE_SIZE (for now)
> > 	- When the flag is set or cleared, the current mapping
> > 	  contents are flushed and then invalidated so that the new
> > 	  access mode starts with an empty mapping.
> > 	- Setting or clearing the flag is atomic w.r.t. IO and
> > 	  page faults.
> > 
> > I've tested these manually with xfs_io (patchset for supporting
> > chattr +x/-x to be sent soon), and it all appears to work as
> > expected. I'd like to push these for 4.5-rc6 so the initial kernel
> > with support for this flag doesn't do silly things, so comments,
> > testing and review woul dbe appreciated.
> 
> I'm seeing the following errors with xfs/305 when running these four patches +
> v4.5-rc4:
> 
> ================================================
> [ BUG: lock held when returning to user space! ]
> 4.5.0-rc4+ #4 Not tainted
> ------------------------------------------------
> fsstress/2311 is leaving the kernel with locks still held!
> 2 locks held by fsstress/2311:
>  #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<     inline     >] mrupdate_nested fs/xfs/mrlock.h:48
>  #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<ffffffff8149ba82>] xfs_ilock+0x152/0x1f0 fs/xfs/xfs_inode.c:170
>  #1:  (&(&ip->i_mmaplock)->mr_lock){+.+.+.}, at: [<     inline     >] mrupdate_nested fs/xfs/mrlock.h:48
>  #1:  (&(&ip->i_mmaplock)->mr_lock){+.+.+.}, at: [<ffffffff8149baad>] xfs_ilock+0x17d/0x1f0 fs/xfs/xfs_inode.c:175

I can see an error path where this might occur on a project quota
related test (fsstress can change projid, that can fail the quota
reservation, leaks locks). I'll fix and resend later today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
