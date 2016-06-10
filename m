Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E3A07CA1
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2016 07:19:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F3F52304053
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2016 05:19:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yAlffDgrxOH5VFUF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2016 05:19:34 -0700 (PDT)
Date: Fri, 10 Jun 2016 08:19:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: implement online get/set fs label
Message-ID: <20160610121931.GB21568@bfoster.bfoster>
References: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
	<67255993-9730-2872-675f-ac5cb518a338@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <67255993-9730-2872-675f-ac5cb518a338@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Jun 09, 2016 at 11:41:07AM -0500, Eric Sandeen wrote:
> Wire up label ioctls for XFS.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This is where the implementation questions come in;
> is using growlock an abomination?  How can I make the
> primary super change immediately visible?
> 
>  fs/xfs/xfs_ioctl.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 62 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index dbca737..ab59213 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -41,6 +41,8 @@
>  #include "xfs_trans.h"
>  #include "xfs_pnfs.h"
>  #include "xfs_acl.h"
> +#include "xfs_log.h"
> +#include "xfs_sb.h"
>  
>  #include <linux/capability.h>
>  #include <linux/dcache.h>
> @@ -1603,6 +1605,62 @@ xfs_ioc_swapext(
>  	return error;
>  }
>  
> +static int
> +xfs_ioc_getlabel(
> +	struct xfs_mount	*mp,
> +	char			__user *label)
> +{
> +	int			error = 0;
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +
> +	if (!mutex_trylock(&mp->m_growlock))
> +		return -EWOULDBLOCK;
> +	if (copy_to_user(label, sbp->sb_fname, sizeof(sbp->sb_fname)))
> +		error = -EFAULT;
> +	mutex_unlock(&mp->m_growlock);
> +	return error;
> +}
> +
> +static int
> +xfs_ioc_setlabel(
> +	struct file		*filp,
> +	struct xfs_mount	*mp,
> +	char			__user *newlabel)
> +{
> +	int			error;
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	char			sb_fname[12];
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (copy_from_user(sb_fname, newlabel, sizeof(sb_fname)))
> +		return -EFAULT;
> +
> +	error = mnt_want_write_file(filp);
> +	if (error)
> +		return error;
> +
> +	/* growfs & label both muck w/ the super directly... */
> +	if (!mutex_trylock(&mp->m_growlock))
> +		return -EWOULDBLOCK;

Why the trylock here? It seems like we can still block in other places
(e.g., mnt_want_write_file() above).

> +	memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));
> +	strncpy(sbp->sb_fname, sb_fname, sizeof(sbp->sb_fname));
> +

So m_growlock excludes grow and nothing else looks like it mucks with
sb_fname, but what about any other invocations of xfs_log_sb()? For
example, is there a risk here of somebody else logging the superblock
buffer based on a transiently zeroed mp->m_sb.sb_fname? (In fact,
xfs_log_sb() looks kind of racy to me, but maybe I'm missing something.)

Perhaps we need an xfs_trans_getsb() somewhere in here..?

Brian

> +	error = xfs_sync_sb(mp, true);
> +	if (error)
> +		goto out;
> +	/*
> +	 * Most kernelspace superblock updates only update sb 0.
> +	 * Userspace relabel has always updated all, though, so:
> +	 */
> +	error = xfs_update_secondary_supers(mp, sbp->sb_agcount, 0);
> +out:
> +	mutex_unlock(&mp->m_growlock);
> +	mnt_drop_write_file(filp);
> +	return error;
> +}
> +
>  /*
>   * Note: some of the ioctl's return positive numbers as a
>   * byte count indicating success, such as readlink_by_handle.
> @@ -1630,6 +1688,10 @@ xfs_file_ioctl(
>  	switch (cmd) {
>  	case FITRIM:
>  		return xfs_ioc_trim(mp, arg);
> +	case FS_IOC_GET_FSLABEL:
> +		return xfs_ioc_getlabel(mp, arg);
> +	case FS_IOC_SET_FSLABEL:
> +		return xfs_ioc_setlabel(filp, mp, arg);
>  	case XFS_IOC_ALLOCSP:
>  	case XFS_IOC_FREESP:
>  	case XFS_IOC_RESVSP:
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
