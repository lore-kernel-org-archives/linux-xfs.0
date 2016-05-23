Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 282857CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 17:36:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A63A7AC004
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 15:36:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wE1zDdXh2MMEwIvu for <xfs@oss.sgi.com>;
	Mon, 23 May 2016 15:36:39 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 59A4CB55
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 17:36:39 -0500 (CDT)
Subject: Re: [PATCH 1/2] xfs.h: define XFS_IOC_FREEZE even if FIFREEZE is
	defined
References: <1464015836-25127-1-git-send-email-hch@lst.de>
	<1464015836-25127-2-git-send-email-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9b47e358-b106-1fe2-251a-c317a6a914dd@sandeen.net>
Date: Mon, 23 May 2016 17:36:39 -0500
MIME-Version: 1.0
In-Reply-To: <1464015836-25127-2-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com



On 5/23/16 10:03 AM, Christoph Hellwig wrote:
> And the same for XFS_IOC_THAW.  Just because we now have a common
> version of the ioctl we still need to provide the old name for it
> for anyone using those.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/xfs_fs.h | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index b9622ba..1f17e1c 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -542,12 +542,8 @@ typedef struct xfs_swapext
>  #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
>  /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
>  
> -/*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
> -/*	XFS_IOC_THAW		  -- FITHAW     120	 */
> -#ifndef FIFREEZE
> -#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
> -#define XFS_IOC_THAW		     _IOWR('X', 120, int)
> -#endif
> +#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)	/* aka FIFREEZE */
> +#define XFS_IOC_THAW		     _IOWR('X', 120, int)	/* aka FITHAW */
>  
>  #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
>  #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
