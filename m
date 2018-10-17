Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbeJRG2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 02:28:39 -0400
Date: Wed, 17 Oct 2018 15:30:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: reject per-inode dax flag on reflink filesystems
Message-ID: <20181017223047.GR28243@magnolia>
References: <c1ad993d-5330-88c3-b859-06e33dcd75d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1ad993d-5330-88c3-b859-06e33dcd75d8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>

On Wed, Oct 17, 2018 at 05:20:56PM -0500, Eric Sandeen wrote:
> Today we reject this flag on an already-reflinked inode, but we really
> need to reject it for any inode on a reflink-capable filesystem until
> reflink+dax is supported.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (um, do we need to catch this when reading from disk as well?  If we
> found a dax-flagged inode on a reflinked fs, then what would we do with it?)

Ignore the DAX flag.  See xfs_inode_supports_dax.

> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0ef5ece5634c..63d579c652f2 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1031,8 +1031,9 @@ xfs_ioctl_setattr_xflags(
>  	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
>  		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
>  
> -	/* Don't allow us to set DAX mode for a reflinked file for now. */
> -	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
> +	/* Don't allow us to set DAX mode on a reflink filesystem for now. */
> +	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
> +	    xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
>  		return -EINVAL;

Not sure we need this, since DAX always loses to REFLINK, whether it's
at inode loading time or if someone's trying to set it in the ioctl.
Ofc it's hard to say what the behavior should be since the dax iflag
semantics are poorly defined (it's been more or less advisory this whole
time)...

...but I gather you're sending this patch because you don't like this
wishy washy "ok you change this flag but it doesn't tell you if that had
any effect and there's no way to find out either" behavior? :)

--D

>  
>  	/*
> 
