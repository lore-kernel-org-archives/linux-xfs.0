Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50874 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757703AbcJZBQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 21:16:12 -0400
Date: Tue, 25 Oct 2016 18:16:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/39] libxfs: add configure option to override system
 header fsxattr
Message-ID: <20161026011605.GE23568@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743671705.11035.1549555844450499931.stgit@birch.djwong.org>
 <20161026005606.GF23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026005606.GF23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 11:56:07AM +1100, Dave Chinner wrote:
> On Tue, Oct 25, 2016 at 04:05:17PM -0700, Darrick J. Wong wrote:
> > By default, libxfs will use the kernel/system headers to define struct
> > fsxattr.  Unfortunately, this creates a problem for developers who are
> > writing new features but building xfsprogs on a stable system, because
> > the stable kernel's headers don't reflect the new feature.  In this
> > case, we want to be able to use the internal fsxattr definition while
> > the kernel headers catch up, so provide some configure magic to allow
> > developers to force the use of the internal definition.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> >  #include <stdio.h>
> >  #include <asm/types.h>
> >  #include <mntent.h>
> > +#ifdef OVERRIDE_SYSTEM_FSXATTR
> > +# define fsxattr sys_fsxattr
> > +#endif
> >  #include <linux/fs.h> /* fsxattr defintion for new kernels */
> > +#ifdef OVERRIDE_SYSTEM_FSXATTR
> > +# undef fsxattr
> > +#endif
> 
> messy, but I can't think of a cleaner way of doing this.
> >  
> >  static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
> >  {
> > @@ -175,7 +181,7 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
> >   * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
> >   * so this is purely for supporting builds against old kernel headers.
> >   */
> > -#ifndef FS_IOC_FSGETXATTR
> > +#if !defined FS_IOC_FSGETXATTR || defined OVERRIDE_SYSTEM_FSXATTR
> >  struct fsxattr {
> >  	__u32		fsx_xflags;	/* xflags field value (get/set) */
> >  	__u32		fsx_extsize;	/* extsize field value (get/set)*/
> > @@ -184,7 +190,9 @@ struct fsxattr {
> >  	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
> >  	unsigned char	fsx_pad[8];
> >  };
> > +#endif
> >  
> > +#ifndef FS_IOC_FSGETXATTR
> >  /*
> >   * Flags for the fsx_xflags field
> >   */
> 
> Hmmm - what happens if all we are doing is introducing new flags?
> Doesn't the overide need to cover them as well?

As I did in the next patch, my intent is for the include/ header files to
define any flag that isn't picked up by the system headers.  IOWs, the
OVERRIDE_SYSTEM_FSXATTR only helps us pick up changes to the struct
fsxattr definition.

#ifndef FS_XFLAG_MOOCOW
# define FS_XFLAG_MOOCOW   0xBEEF
#endif

(Inelegant, but oh well.)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
