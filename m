Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Aug 2008 20:41:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7B3fZgQ023031
	for <xfs@oss.sgi.com>; Sun, 10 Aug 2008 20:41:36 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id NAA07132; Mon, 11 Aug 2008 13:42:47 +1000
Message-ID: <489FB537.70001@sgi.com>
Date: Mon, 11 Aug 2008 13:42:47 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] stop rejecting options in remount
References: <20080809195159.GA8562@lst.de>
In-Reply-To: <20080809195159.GA8562@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, jasper@amiton.co.nz

Christoph Hellwig wrote:
> Thanks to some not so nice code in mount(8) we can't blindly reject moun
> options we don't support to be changed in remount.  See the comment in
> the code for more details.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-08-09 16:34:33.000000000 -0300
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-08-09 16:36:55.000000000 -0300
> @@ -1349,9 +1349,28 @@ xfs_fs_remount(
>  			mp->m_flags &= ~XFS_MOUNT_BARRIER;
>  			break;
>  		default:
> +			/*
> +			 * Logically we would return an error here to prevent
> +			 * users from believing they might have changed
> +			 * mount options using remount which can't be changed.
> +			 *
> +			 * But unfortunately mount(8) adds all options from
> +			 * mtab and fstab to the mount arguments in some
> +			 * cases so we can't blindly reject options.
> +			 *
> +			 * The workaround for that behaviour will be to
> +			 * check for each specified option whether it actually
> +			 * is a change compared to the status quo and if yes
> +			 * silently ignore it or otherwise reject the remount
> +			 * and tell the user about the reason.
> +			 */
> +#if 0
>  			printk(KERN_INFO
>  	"XFS: mount option \"%s\" not supported for remount\n", p);
>  			return -EINVAL;
> +#else
> +			return 0;
> +#endif
>  		}
>  	}
>  

We should sill issue a warning that the option was ignored. It's not as
obvious as refusing the mount but will allow some kind of triage if
strange behavior results.

Don
