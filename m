Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48485 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754969AbcJEUwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 16:52:22 -0400
Date: Thu, 6 Oct 2016 07:52:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: clear di_forkoff on ialloc
Message-ID: <20161005205219.GQ27872@dastard>
References: <bb3e00eb-7334-1ac5-509f-89804583e9ff@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb3e00eb-7334-1ac5-509f-89804583e9ff@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 05, 2016 at 01:04:04PM -0400, Jeff Mahoney wrote:
> Commit 6dfe5a049f2 (xfs: xfs_attr_inactive leaves inconsistent
> attr fork state behind) fixed an issue where an inconsistent
> attr fork count persisted on disk if there was concurrent inode
> writeback happening after the inode was evicted from the VFS layer.
> 
> If one of those inodes landed on disk and was reused, it may have
> an invalid di_forkoff, which can cause problems when trying to add
> new extended attributes.  Since we clear the rest of the attribute
> fork values on ialloc, let's clear di_forkoff as well and ensure the
> invalid value won't be encountered.

The problem with this theory is that xfs_attr_inactive() isn't the
last time di_forkoff is modified when freeing an inode. The
attribute fork is cleaned up when the inode is evicted and put on
the unlinked list (orphan list, in ext4 speak).

The inode is not yet free when xfs_attr_inactive() is called -
freeing happens when the last reference goes away (typically in the
syscall return path when fput() is called) - this is where we call
xfs_ifree() to remove the inode from the unlinked list and mark it
free. And there we do:

        VFS_I(ip)->i_mode = 0;          /* mark incore inode as free */
        ip->i_d.di_flags = 0;
        ip->i_d.di_dmevmask = 0;
        ip->i_d.di_forkoff = 0;         /* mark the attr fork not in use */
        ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
        ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;

And so there is no stage where we have a free inode on disk or
in memory available for allocation with a non-zero di_forkoff.

If there is a di_forkoff value set on a freed inode indexed in the
AG inode btree, then a corruption of some kind has occurred. I'd
suggest that xfs_dinode_verify() needs this added to it:

	/* unlinked inodes should always have an empty attr fork */
	if (!dip->di_mode && dip->di_forkoff)
		return false;

So we catch such issues coming off disk on old format filesystems.

For CRC enabled filesystems, we don't read inodes off disk on
allocation (except when the ikeep mount option is set), so this problem
simply doesn't exist for those filesystems (see xfs_iread(): /*
shortcut IO on inode allocation if possible */).

So while I don't see any harm in zeroing the di_forkoff on
allocation, I don't see how the situation you describe would occur
or lead to the problem you are seeing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
