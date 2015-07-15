Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6B817F86
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 18:53:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54555AC006
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 16:53:24 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BNJ3or32698Lq7Pw for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 16:53:20 -0700 (PDT)
Date: Thu, 16 Jul 2015 09:53:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] Prefix LIST_... macros to XFS_LIST_...
Message-ID: <20150715235306.GT3902@dastard>
References: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
	<1436964412-12093-2-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1436964412-12093-2-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 15, 2015 at 02:46:51PM +0200, Jan Tulak wrote:
> OS X has some conflicting LIST_ macros, so prefix the XFS ones.

What are the macros that conflict and where do they come from?

> --- a/include/irix.h
> +++ b/include/irix.h
> @@ -230,7 +230,7 @@ static __inline__ int xfsctl(const char *path, int fd, int cmd, void *arg)
>  					((xfs_fsop_handlereq_t*)arg)->ihandlen,
>  					((xfs_fsop_handlereq_t*)arg)->ohandle,
>  					((xfs_fsop_handlereq_t*)arg)->ohandlen);
> -		case SGI_ATTR_LIST_BY_HANDLE:
> +		case SGI_ATTR_XFS_LIST_BY_HANDLE:

This is wrong - that's an Irix ioctl name and should not be renamed.
It won' compile on Irix with this change...

> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 89689c6..8c37e08 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -403,7 +403,7 @@ typedef struct xfs_fsop_handlereq {
>  /*
>   * Compound structures for passing args through Handle Request interfaces
>   * xfs_fssetdm_by_handle, xfs_attrlist_by_handle, xfs_attrmulti_by_handle
> - * - ioctls: XFS_IOC_FSSETDM_BY_HANDLE, XFS_IOC_ATTRLIST_BY_HANDLE, and
> + * - ioctls: XFS_IOC_FSSETDM_BY_HANDLE, XFS_IOC_ATTRXFS_LIST_BY_HANDLE, and
>   *	     XFS_IOC_ATTRMULTI_BY_HANDLE
>   */
>  
> @@ -553,7 +553,7 @@ typedef struct xfs_swapext
>  #endif
>  
>  #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
> -#define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
> +#define XFS_IOC_ATTRXFS_LIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
>  #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
>  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
>  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)

Renaming Linux ioctls is wrong, too, as that will break all source
code outside xfsprogs that uses this ioctl.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
