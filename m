Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43159 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754109AbeCVATs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 20:19:48 -0400
Date: Thu, 22 Mar 2018 11:19:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: clean up xfs_mount allocation and dynamic
 initializers
Message-ID: <20180322001945.GZ18129@dastard>
References: <20180321161325.12773-1-bfoster@redhat.com>
 <20180321172728.GF4818@magnolia>
 <20180321180738.GM11127@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321180738.GM11127@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 02:07:38PM -0400, Brian Foster wrote:
> On Wed, Mar 21, 2018 at 10:27:28AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 21, 2018 at 12:13:25PM -0400, Brian Foster wrote:
> > > Most of the generic data structures embedded in xfs_mount are
> > > dynamically initialized immediately after mp is allocated. A few
> > > fields are left out and initialized during the xfs_mountfs()
> > > sequence, after mp has been attached to the superblock.
> > > 
> > > To clean this up and help prevent premature access of associated
> > > fields, refactor xfs_mount allocation and all dependent init calls
> > > into a new helper. This self-documents that all low level data
> > > structures (i.e., locks, trees, etc.) should be initialized before
> > > xfs_mount is attached to the superblock.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > I realized after the fact that this steps on the ability to instrument
> > > the use-before-init variant[1] of the problematic radix tree access on
> > > failed mount issue that Dave tracked down. This is because we'd
> > > immediately initialize the structure and thus a subsequent memset()
> > > would ultimately require another proper initialization.
> > 
> > That's simply a matter of re-calling
> > 
> > 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> > 
> > after the msleep, right?
> > 
> 
> I suppose that may work (I'll let Dave chime in)...

Well, to tell the truth, this whole "VFS accesses the fs during
mount: problem is isolated to only the inode cache shrinker, and it
while a mount is in progress it does not run inode cache scans
(can't lock s_umount because the mount holds it locked).

IOWs, this crash can be fixed entirely by modifying the VFS code as
I mentioned to avoid super_cache_count() doing any work during mount
and unmount.

So, really, none of these XFS changes are necessary to fix the
problem that was reported. I'm not opposed to it as a cleanup, but
let's not conflate it with the VFS superblock shrinker bug that
needs to be fixed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
