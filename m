Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13990 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751185AbdCPXoR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 19:44:17 -0400
Date: Fri, 17 Mar 2017 10:42:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 V2] xfs: toggle readonly state around
 xfs_log_mount_finish
Message-ID: <20170316234249.GW17542@dastard>
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
 <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
 <74f6a009-211c-617a-2d6f-0a115ceb366b@sandeen.net>
 <20170315113629.GA23221@bfoster.bfoster>
 <20170316191500.GL5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170316191500.GL5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 16, 2017 at 12:15:00PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 15, 2017 at 07:36:29AM -0400, Brian Foster wrote:
> > On Tue, Mar 14, 2017 at 06:23:57PM -0500, Eric Sandeen wrote:
> > > When we do log recovery on a readonly mount, unlinked inode
> > > processing does not happen due to the readonly checks in
> > > xfs_inactive(), which are trying to prevent any I/O on a
> > > readonly mount.
> > > 
> > > This is misguided - we do I/O on readonly mounts all the time,
> > > for consistency; for example, log recovery.  So do the same
> > > RDONLY flag twiddling around xfs_log_mount_finish() as we
> > > do around xfs_log_mount(), for the same reason.
> > > 
> > > This all cries out for a big rework but for now this is a
> > > simple fix to an obvious problem.
> > > 
> > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > ---
> > > 
> 
> Both patches look ok, so I'll put them on the test queue for -rc4.
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

FWIW, I don't think this is a -rc candidate. Making log recovery
process unlinked inode transactions on read-only mounts is a pretty
major change in behaviour. Who knows exactly what dragons are
lurking at lower layers that have never been run in this context
until now.

Also, it's not urgent - we've lived with this behaviour for years -
so waiting a month for the next merge window is not going to hurt
anyone and it gives us a chance to test it - XFS developers are the
people who should be burnt by the lurking dragons, not users who
updated to a late -rcX kernel....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
