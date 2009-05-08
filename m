Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n486SF4D001290 for <xfs@oss.sgi.com>; Fri, 8 May 2009 01:28:15 -0500
Date: Fri, 8 May 2009 02:28:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix double unlock in xfs_swap_extents()
Message-ID: <20090508062819.GB1689@infradead.org>
References: <1241745202-7452-1-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1241745202-7452-1-git-send-email-felixb@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org, a.beregalov@gmail.com, xfs@oss.sgi.com

The patch looks good, but a little nitpick:

On Thu, May 07, 2009 at 08:13:22PM -0500, Felix Blyakher wrote:
>  out:
>  	kmem_free(tempifp);
>  	return error;
>  
> +out_unlock:
> +	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	goto out;
> +
>  out_trans_cancel:
>  	xfs_trans_cancel(tp, 0);
>  	goto out_unlock;

this would be more readable as:

 out_trans_cancel:
	xfs_trans_cancel(tp, 0);
 out_unlock:
	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
	goto out;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
