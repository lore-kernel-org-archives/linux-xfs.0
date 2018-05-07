Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43128 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752800AbeEGX2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 19:28:39 -0400
Date: Tue, 8 May 2018 09:28:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: check and repair quota metadata
Message-ID: <20180507232837.GH23861@dastard>
References: <9e494d70-53bd-db81-c118-73ef7eaad667@redhat.com>
 <20180507163242.GZ26569@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507163242.GZ26569@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 07, 2018 at 09:32:42AM -0700, Darrick J. Wong wrote:
> On Mon, May 07, 2018 at 09:20:28AM -0500, Eric Sandeen wrote:
> > Today, quota inodes are not checked at all in xfs_repair.  (This is
> > a little odd, because xfs_check used to do it in process_quota()).
> > 
> > The kernel has quota inode validation and repair routines, but it is
> > out of the ordinary for the kernel to be doing metadata repair.  And
> > now that we have metadata verifiers, this also yields a surprisingly
> > noisy mount if quota inodes are corrupted, even immediately after an
> > xfs_repair.
> > 
> > So this patch allows xfs_repair to fix the quota inode metadata.
> > 
> > Quotacheck is still left for the kernel.  After a few more releases,
> > I'll propose removing the repair calls from the kernel, and move the
> > repair functions from libxfs/ into the repair code.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > This will need a bit of adjustment when my other quota patches land
> > in 4.18, but that should be no big deal.
> > 
> > diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> > index ab195f5f..e5eb3de1 100644
> > --- a/libxfs/libxfs_priv.h
> > +++ b/libxfs/libxfs_priv.h
> > @@ -196,8 +196,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
> >  # define barrier() __memory_barrier()
> >  #endif
> >  
> > -#define XFS_DQUOT_CLUSTER_SIZE_FSB (xfs_filblks_t)1
> > -
> >  /* miscellaneous kernel routines not in user space */
> >  #define down_read(a)		((void) 0)
> >  #define up_read(a)		((void) 0)
> > diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
> > index bb1b13a9..067475e2 100644
> > --- a/libxfs/xfs_quota_defs.h
> > +++ b/libxfs/xfs_quota_defs.h
> > @@ -30,6 +30,8 @@
> >  typedef uint64_t	xfs_qcnt_t;
> >  typedef uint16_t	xfs_qwarncnt_t;
> >  
> > +#define XFS_DQUOT_CLUSTER_SIZE_FSB (xfs_filblks_t)1
> 
> Requires a kernel patch, right? :)

It's already defined in the kernel in fs/xfs/xfs_qm.h.

And userspace also defines it as a private define to allow libxfs to
build:

$ git grep XFS_DQUOT_CLUSTER_SIZE_FSB
libxfs/libxfs_priv.h:#define XFS_DQUOT_CLUSTER_SIZE_FSB (xfs_filblks_t)1
libxfs/xfs_trans_resv.c:                        XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
libxfs/xfs_trans_space.h:        XFS_DQUOT_CLUSTER_SIZE_FSB)
$

If it's going to be used outside libxfs in userspace, then it should
be lifted to a libxfs header file both in the kernel and userspace,
such as fs/xfs/xfs_quota_defs.h....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
