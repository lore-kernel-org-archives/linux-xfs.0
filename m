Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 483FE7CA6
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 16:56:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36C588F8049
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 14:56:58 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id eGUG2w7wPiMGUy0H for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 14:56:57 -0800 (PST)
Date: Wed, 17 Feb 2016 15:56:45 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/4] xfs: fixes for XFS_DIFLAG2_DAX support
Message-ID: <20160217225645.GD30126@linux.intel.com>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455513734-15192-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Feb 15, 2016 at 04:22:10PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is a series to add the correct constraints to using the on-disk
> inode flag to enable DAX on per-file basis. The same constraints are
> placed on setting the flag on directories for inheritance purposes.
> 
> These constraints are:
> 	- the inode flag is limited to regular files or directory
> 	  inodes.
> 	- the S_DAX flag is only ever set on regular files
> 	- the flag can only ever be set on filesystems which have
> 	  blocksize == PAGE_SIZE (for now)
> 	- When the flag is set or cleared, the current mapping
> 	  contents are flushed and then invalidated so that the new
> 	  access mode starts with an empty mapping.
> 	- Setting or clearing the flag is atomic w.r.t. IO and
> 	  page faults.
> 
> I've tested these manually with xfs_io (patchset for supporting
> chattr +x/-x to be sent soon), and it all appears to work as
> expected. I'd like to push these for 4.5-rc6 so the initial kernel
> with support for this flag doesn't do silly things, so comments,
> testing and review woul dbe appreciated.
> 
> Cheers,
> 
> Dave.

This seems like what we want to be doing for raw block devices, when we add
back in support.  Default to DAX off so we have to opt-in, and when we get an
IOCTL to enable them block I/O and page faults, clear out all mappings and
radix tree entries, and then change the flag and turn back on I/O and page
faults.  We'll also need to add a check to prevent mounts on raw block devices
with S_DAX set.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
