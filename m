Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41850 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754071AbcJZA4J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 20:56:09 -0400
Date: Wed, 26 Oct 2016 11:56:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/39] libxfs: add configure option to override system
 header fsxattr
Message-ID: <20161026005606.GF23194@dastard>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743671705.11035.1549555844450499931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743671705.11035.1549555844450499931.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:05:17PM -0700, Darrick J. Wong wrote:
> By default, libxfs will use the kernel/system headers to define struct
> fsxattr.  Unfortunately, this creates a problem for developers who are
> writing new features but building xfsprogs on a stable system, because
> the stable kernel's headers don't reflect the new feature.  In this
> case, we want to be able to use the internal fsxattr definition while
> the kernel headers catch up, so provide some configure magic to allow
> developers to force the use of the internal definition.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
>  #include <stdio.h>
>  #include <asm/types.h>
>  #include <mntent.h>
> +#ifdef OVERRIDE_SYSTEM_FSXATTR
> +# define fsxattr sys_fsxattr
> +#endif
>  #include <linux/fs.h> /* fsxattr defintion for new kernels */
> +#ifdef OVERRIDE_SYSTEM_FSXATTR
> +# undef fsxattr
> +#endif

messy, but I can't think of a cleaner way of doing this.
>  
>  static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
>  {
> @@ -175,7 +181,7 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
>   * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
>   * so this is purely for supporting builds against old kernel headers.
>   */
> -#ifndef FS_IOC_FSGETXATTR
> +#if !defined FS_IOC_FSGETXATTR || defined OVERRIDE_SYSTEM_FSXATTR
>  struct fsxattr {
>  	__u32		fsx_xflags;	/* xflags field value (get/set) */
>  	__u32		fsx_extsize;	/* extsize field value (get/set)*/
> @@ -184,7 +190,9 @@ struct fsxattr {
>  	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
>  	unsigned char	fsx_pad[8];
>  };
> +#endif
>  
> +#ifndef FS_IOC_FSGETXATTR
>  /*
>   * Flags for the fsx_xflags field
>   */

Hmmm - what happens if all we are doing is introducing new flags?
Doesn't the overide need to cover them as well?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
