Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2H2dYDo233176 for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 21:39:34 -0500
Date: Wed, 17 Mar 2010 13:41:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix integer overflow in fs/xfs/linux-2.6/xfs_ioctl*.c
Message-ID: <20100317024101.GH12369@dastard>
References: <20100316155350.GB18579@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100316155350.GB18579@localhost.localdomain>
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
To: wzt.wzt@gmail.com
Cc: xfs-masters@oss.sgi.com, aelder@sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Mar 16, 2010 at 11:53:50PM +0800, wzt.wzt@gmail.com wrote:
> STATIC int
> xfs_compat_attrmulti_by_handle(
>         struct file                             *parfilp,
>         void                                    __user *arg)
> {
> ...
>         if (copy_from_user(&am_hreq, arg,
>                            sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
>                 return -XFS_ERROR(EFAULT);
> ...
>         error = E2BIG;
>         /* Not check the am_hreq.opcount max value from userspace, 
>         m_hreq.opcount * sizeof(compat_xfs_attr_multiop_t) can make
>         integer overflow, and the if condition can be bypass. Though,
>         it can not make security problem, but fix it maybe better. */
>         size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
>         if (!size || size > 16 * PAGE_SIZE)
>                 goto out_dput;
> ...
> }

This description could use a little work. ;)

Perhaps something like:

The am_hreq.opcount field in the xfs_attrmulti_by_handle() interface
is not bounded correctly. The opcount is used to determine the size
of the buffer required. The size is bounded, but can overflow and so
the size checks may not be sufficient to catch invalid opcounts.
Fix it by catching opcount values that would cause overflows before
calculating the size.


> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 
> ---
>  fs/xfs/linux-2.6/xfs_ioctl.c   |    4 ++++
>  fs/xfs/linux-2.6/xfs_ioctl32.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index 4ea1ee1..b05b3b7 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -526,6 +526,10 @@ xfs_attrmulti_by_handle(
>  	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
>  		return -XFS_ERROR(EFAULT);
>  
> +	/* overflow check */
> +	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
> +		return -ENOMEM;
> +

The code currently return E2BIG for an opcount that is too large.
I think this should also return E2BIG rather then ENOMEM. Does that
seem reasonable?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
