Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41346 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbeCXAwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 20:52:09 -0400
Date: Fri, 23 Mar 2018 17:52:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: clean up xfs_mount allocation and dynamic
 initializers
Message-ID: <20180324005203.GM4818@magnolia>
References: <20180321161325.12773-1-bfoster@redhat.com>
 <20180321172728.GF4818@magnolia>
 <20180321180738.GM11127@bfoster.bfoster>
 <20180322001945.GZ18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180322001945.GZ18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 11:19:45AM +1100, Dave Chinner wrote:
> On Wed, Mar 21, 2018 at 02:07:38PM -0400, Brian Foster wrote:
> > On Wed, Mar 21, 2018 at 10:27:28AM -0700, Darrick J. Wong wrote:
> > > On Wed, Mar 21, 2018 at 12:13:25PM -0400, Brian Foster wrote:
> > > > Most of the generic data structures embedded in xfs_mount are
> > > > dynamically initialized immediately after mp is allocated. A few
> > > > fields are left out and initialized during the xfs_mountfs()
> > > > sequence, after mp has been attached to the superblock.
> > > > 
> > > > To clean this up and help prevent premature access of associated
> > > > fields, refactor xfs_mount allocation and all dependent init calls
> > > > into a new helper. This self-documents that all low level data
> > > > structures (i.e., locks, trees, etc.) should be initialized before
> > > > xfs_mount is attached to the superblock.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > I realized after the fact that this steps on the ability to instrument
> > > > the use-before-init variant[1] of the problematic radix tree access on
> > > > failed mount issue that Dave tracked down. This is because we'd
> > > > immediately initialize the structure and thus a subsequent memset()
> > > > would ultimately require another proper initialization.
> > > 
> > > That's simply a matter of re-calling
> > > 
> > > 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> > > 
> > > after the msleep, right?
> > > 
> > 
> > I suppose that may work (I'll let Dave chime in)...
> 
> Well, to tell the truth, this whole "VFS accesses the fs during
> mount: problem is isolated to only the inode cache shrinker, and it
> while a mount is in progress it does not run inode cache scans
> (can't lock s_umount because the mount holds it locked).
> 
> IOWs, this crash can be fixed entirely by modifying the VFS code as
> I mentioned to avoid super_cache_count() doing any work during mount
> and unmount.
> 
> So, really, none of these XFS changes are necessary to fix the
> problem that was reported. I'm not opposed to it as a cleanup, but
> let's not conflate it with the VFS superblock shrinker bug that
> needs to be fixed....

Are you working on such a patch?  I guessed that one could change the
vfs to avoid register_shrinker until after fill_super returns?  Or
possibly just have super_cache_count bail out if !SB_ACTIVE, though that
could be messy given that xfs (and others) mess with that flag.

--D

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
