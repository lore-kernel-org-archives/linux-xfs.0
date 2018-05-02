Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbeEBOig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 10:38:36 -0400
Date: Wed, 2 May 2018 07:38:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5 V2] xfs: implement online get/set fs label
Message-ID: <20180502143832.GP4127@magnolia>
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <698bd41a-9281-83a2-ff51-64547025442a@sandeen.net>
 <2a638f02-ea72-0d5e-30a4-1d95cfe6ff69@sandeen.net>
 <20180502142420.GL4127@magnolia>
 <d364f3c8-110a-fb69-f2a5-c3b5716f556e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d364f3c8-110a-fb69-f2a5-c3b5716f556e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, May 02, 2018 at 09:28:35AM -0500, Eric Sandeen wrote:
> On 5/2/18 9:24 AM, Darrick J. Wong wrote:
> > On Tue, May 01, 2018 at 06:04:09PM -0500, Eric Sandeen wrote:
> >> The GET ioctl is trivial, just return the current label.
> >>
> >> The SET ioctl is more involved:
> >> It transactionally modifies the superblock to write a new filesystem
> >> label to the primary super.
> >>
> >> A new variant of xfs_sync_sb then writes the superblock buffer
> >> immediately to disk so that the change is visible from userspace.
> >>
> >> It then invalidates any page cache that userspace might have previously
> >> read on the block device so that i.e. blkid can see the change
> >> immediately, and updates all secondary superblocks as userspace relable
> >> does.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> V2: rework the force-sb-to-disk approach, invalidate the whole block
> >> device, and block waiting for the growfs lock.  Also remove too-long-label
> >> printk.
> >>
> >> Thanks to dchinner for the xfs_sync_sb_buf suggestion & framework.
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> >> index d9b94bd..54992e8 100644
> >> --- a/fs/xfs/libxfs/xfs_sb.c
> >> +++ b/fs/xfs/libxfs/xfs_sb.c
> >> @@ -888,6 +888,37 @@ struct xfs_perag *
> >>  	return xfs_trans_commit(tp);
> >>  }
> >>  
> >> +/*
> >> + * Same behavior as xfs_sync_sb, except that it is always synchronous and it
> >> + * also writes the superblock buffer to disk sector 0 immediately.
> >> + */
> >> +int
> >> +xfs_sync_sb_buf(
> >> +	struct xfs_mount	*mp)
> >> +{
> >> +	struct xfs_trans	*tp;
> >> +	int			error;
> >> +
> >> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0,
> >> +			XFS_TRANS_NO_WRITECOUNT, &tp);
> > 
> > I suppose this is a straight clone of xfs_sync_sb, but do we need
> > NO_WRITECOUNT here?  Will this get called while the fs is frozen?
> 
> No, I should remove that, thanks.  I might see how ugly it'd be to just
> convert xfs_sync_sb() to take flags for wait, no_writecount, and flush_sb
> or something. 
> ...
>  
> >> +static int
> >> +xfs_ioc_getlabel(
> >> +	struct xfs_mount	*mp,
> >> +	char			__user *label)
> >> +{
> >> +	struct xfs_sb		*sbp = &mp->m_sb;
> >> +
> >> +	/* Paranoia */
> >> +	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
> >> +
> >> +	if (copy_to_user(label, sbp->sb_fname, sizeof(sbp->sb_fname)))
> > 
> > Needs to ensure that a null is set at the end of the (userspace) buffer
> > just in case the label is "123456789012".
> 
> Oh, yup!
> 
> > There's nothing in the documentation for this ioctl <cough> that says
> > the passed in buffer must already be zeroed.
> 
> where /do/ we document ioctls like this, anyway?
> 
> Documentation/ioctl/* I guess, though of course we don't.

In the man-pages project, of course:
https://www.kernel.org/doc/man-pages/contributing.html

See example of previous efforts:
http://man7.org/linux/man-pages/man2/ioctl_getfsmap.2.html

--D

> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
