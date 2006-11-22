Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 20:50:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAM4oYaG032562
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 20:50:37 -0800
Date: Wed, 22 Nov 2006 15:51:59 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Review: Fix inverted quiet mount logic
Message-ID: <7013720DE121BA0C2CA1A09D@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20061122044656.GS37654165@melbourne.sgi.com>
References: <20061122044656.GS37654165@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

Add me to the reviewer list :)
--Tim

--On 22 November 2006 3:46:56 PM +1100 David Chinner <dgc@sgi.com> wrote:

>
> Simple problem Noticed by Eric Sandeen at about the same time I did
> - we are not getting error messages in dmesg when certain checks
> fail during mount.  Turns out the XFS_MFSI_QUIET flag usage is
> inverted, so we suppress messages when we should be noisy and
> shout when we should be silent....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
> ---
>  fs/xfs/xfs_error.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: 2.6.x-xfs-new/fs/xfs/xfs_error.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_error.h	2006-10-17 12:17:25.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_error.h	2006-11-16 09:45:03.444451972 +1100
> @@ -180,6 +180,6 @@ extern void xfs_fs_cmn_err(int level, st
>  	xfs_fs_cmn_err(level, mp, fmt "  Unmount and run xfs_repair.", ## args)
>
>  #define xfs_fs_mount_cmn_err(f, fmt, args...) \
> -	((f & XFS_MFSI_QUIET)? cmn_err(CE_WARN, "XFS: " fmt, ## args) : (void)0)
> +	((f & XFS_MFSI_QUIET)? (void)0 : cmn_err(CE_WARN, "XFS: " fmt, ## args))
>
>  #endif	/* __XFS_ERROR_H__ */
