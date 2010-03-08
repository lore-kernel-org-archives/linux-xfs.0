Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o281QvBX249309 for <xfs@oss.sgi.com>; Sun, 7 Mar 2010 19:26:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7334622212A
	for <xfs@oss.sgi.com>; Sun,  7 Mar 2010 17:28:27 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	hM4xi3aWEMztLTQA for <xfs@oss.sgi.com>;
	Sun, 07 Mar 2010 17:28:27 -0800 (PST)
Date: Mon, 8 Mar 2010 12:28:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: add fs name to kthreads
Message-ID: <20100308012824.GH28189@discord.disaster>
References: <alpine.LSU.2.01.1003062033100.16438@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1003062033100.16438@obet.zrqbmnf.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

On Sat, Mar 06, 2010 at 08:34:39PM +0100, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Looks ok, but a couple of things. First, it would be good if you
supplied a reason/justification for the patch so the commit message
will tell us why this change was made.

> Index: linux-2.6.33/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.33.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6.33/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1527,7 +1527,8 @@ xfs_mapping_buftarg(
>  
>  STATIC int
>  xfs_alloc_delwrite_queue(
> -	xfs_buftarg_t		*btp)
> +	xfs_buftarg_t		*btp,
> +	const char *fsname)

Please keep the same indent style as the rest of the functions. i.e

	const char		*fsname)

> @@ -1548,7 +1549,8 @@ out_error:
>  xfs_buftarg_t *
>  xfs_alloc_buftarg(
>  	struct block_device	*bdev,
> -	int			external)
> +	int			external,
> +	const char *fsname)

Same again.

> @@ -899,10 +899,11 @@ xfsaild(
>  
>  int
>  xfsaild_start(
> -	struct xfs_ail	*ailp)
> +	struct xfs_ail	*ailp,
> +	const char *fsname)
>  {
>  	ailp->xa_target = 0;
> -	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild");
> +	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s", fsname);

No need to pass the name into this function. It can be retrieved
from ailp->xa_mount->m_fsname.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
