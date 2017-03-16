Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38143 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752808AbdCPTPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 15:15:06 -0400
Date: Thu, 16 Mar 2017 12:15:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2 V2] xfs: toggle readonly state around
 xfs_log_mount_finish
Message-ID: <20170316191500.GL5280@birch.djwong.org>
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
 <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
 <74f6a009-211c-617a-2d6f-0a115ceb366b@sandeen.net>
 <20170315113629.GA23221@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170315113629.GA23221@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 15, 2017 at 07:36:29AM -0400, Brian Foster wrote:
> On Tue, Mar 14, 2017 at 06:23:57PM -0500, Eric Sandeen wrote:
> > When we do log recovery on a readonly mount, unlinked inode
> > processing does not happen due to the readonly checks in
> > xfs_inactive(), which are trying to prevent any I/O on a
> > readonly mount.
> > 
> > This is misguided - we do I/O on readonly mounts all the time,
> > for consistency; for example, log recovery.  So do the same
> > RDONLY flag twiddling around xfs_log_mount_finish() as we
> > do around xfs_log_mount(), for the same reason.
> > 
> > This all cries out for a big rework but for now this is a
> > simple fix to an obvious problem.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 

Both patches look ok, so I'll put them on the test queue for -rc4.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > V2: And now for something completely different...
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 62176b8..374edc1 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -743,16 +743,23 @@
> >  	struct xfs_mount	*mp)
> >  {
> >  	int	error = 0;
> > +	int	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> >  
> >  	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> >  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> >  		return 0;
> > +	} else if (readonly) {
> > +		/* Allow unlinked processing to proceed */
> > +		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> >  	}
> >  
> >  	error = xlog_recover_finish(mp->m_log);
> >  	if (!error)
> >  		xfs_log_work_queue(mp);
> >  
> > +	if (readonly)
> > +		mp->m_flags |= XFS_MOUNT_RDONLY;
> > +
> >  	return error;
> >  }
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
