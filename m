Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9059B7F51
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 16:35:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DE398F8068
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 14:35:07 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qcRwb8GOjsZc065R for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 14:35:02 -0700 (PDT)
Date: Fri, 1 Nov 2013 08:34:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfs: underflow bug in xfs_attrlist_by_handle()
Message-ID: <20131031213456.GM4446@dastard>
References: <20131025144452.GA28451@ngolde.de>
	<20131031180010.GA24839@longonot.mountain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031180010.GA24839@longonot.mountain>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Fabian Yamaguchi <fabs@goesec.de>, security@kernel.org, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Nico Golde <nico@ngolde.de>

On Thu, Oct 31, 2013 at 09:00:10PM +0300, Dan Carpenter wrote:
> If we allocate less than sizeof(struct attrlist) then we end up
> corrupting memory or doing a ZERO_PTR_SIZE dereference.
> 
> This can only be triggered with CAP_SYS_ADMIN.
> 
> Reported-by: Nico Golde <nico@ngolde.de>
> Reported-by: Fabian Yamaguchi <fabs@goesec.de>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 4d61340..33ad9a7 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -442,7 +442,8 @@ xfs_attrlist_by_handle(
>  		return -XFS_ERROR(EPERM);
>  	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
>  		return -XFS_ERROR(EFAULT);
> -	if (al_hreq.buflen > XATTR_LIST_MAX)
> +	if (al_hreq.buflen < sizeof(struct attrlist) ||
> +	    al_hreq.buflen > XATTR_LIST_MAX)
>  		return -XFS_ERROR(EINVAL);

Yup, that's not checked in xfs_attr_list(). Looks like these are the
only direct callers of xfs_attr_list(), and the other callers of
xfs_attr_list_int() don't appear to have the same issue. Good find!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
