Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751442AbdGAFkI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Jul 2017 01:40:08 -0400
Date: Sat, 1 Jul 2017 13:40:05 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: xfsprogs for-next branch build failure
Message-ID: <20170701054005.GH23360@eguan.usersys.redhat.com>
References: <20170630121913.GE23360@eguan.usersys.redhat.com>
 <20170630164537.GL5874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170630164537.GL5874@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Fri, Jun 30, 2017 at 09:45:37AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 30, 2017 at 08:19:13PM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > I'm seeing a xfsprogs for-next branch (HEAD is f77f9908851e) build
> > failure in my test.
> > 
> > This build failure only happens if I installed 4.12-rc kernel headers,
> > which has /usr/include/linux/fsmap.h installed, so that in
> > xfsprogs/include/builddefs it has "HAVE_GETFSMAP = yes" defined.
> > 
> > e.g. install Fedora rawhide kernel package and its kernel header files,
> > and re-compile xfsprogs.
> > kernel-4.12.0-0.rc6.git3.1.fc27.x86_64
> > kernel-headers-4.12.0-0.rc6.git3.1.fc27.x86_64
> > 
> > Build failure log:
> > 
> > ...
> > Building fsck
> > Building growfs
> > ...
> > Building io
> > ...
> >     [CC]     fsmap.o
> > In file included from ../include/xfs.h:68:0,
> >                  from io.h:19,   
> >                  from fsmap.c:24:
> > fsmap.c: In function ‘special_owner’:
> > ../include/xfs/xfs_fs.h:117:26: error: ‘FMR_OWN_FREE’ undeclared (first use in this function)
> >  #define XFS_FMR_OWN_FREE FMR_OWN_FREE      /* free space */
> >                           ^
> > fsmap.c:61:7: note: in expansion of macro ‘XFS_FMR_OWN_FREE’
> >   case XFS_FMR_OWN_FREE:
> >        ^
> > ../include/xfs/xfs_fs.h:117:26: note: each undeclared identifier is reported only once for each function it appears in
> >  #define XFS_FMR_OWN_FREE FMR_OWN_FREE      /* free space */
> >                           ^
> > fsmap.c:61:7: note: in expansion of macro ‘XFS_FMR_OWN_FREE’
> >   case XFS_FMR_OWN_FREE:
> >        ^
> > ../include/xfs/xfs_fs.h:118:29: error: ‘FMR_OWN_UNKNOWN’ undeclared (first use in this function)
> >  #define XFS_FMR_OWN_UNKNOWN FMR_OWN_UNKNOWN   /* unknown owner */
> >                              ^
> > fsmap.c:63:7: note: in expansion of macro ‘XFS_FMR_OWN_UNKNOWN’
> >   case XFS_FMR_OWN_UNKNOWN:
> >        ^
> > fsmap.c:65:2: warning: implicit declaration of function ‘FMR_OWNER’ [-Wimplicit-function-declaration]
> >   case XFS_FMR_OWN_FS:
> >   ^
> > ...
> 
> Drat, looks like we forgot to include linux/fsmap.h during the refactoring
> of the original fsmap support patch. :(
> 
> Does the patch below fix it for you?

Yeah, it works!

Eryu

> 
> --D
> 
> diff --git a/include/linux.h b/include/linux.h
> index 92f291d..6ce344c 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -222,7 +222,9 @@ struct fsxattr {
>  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>  #endif
>  
> -#ifndef HAVE_GETFSMAP
> +#ifdef HAVE_GETFSMAP
> +# include <linux/fsmap.h>
> +#else
>  /*
>   *	Structure for FS_IOC_GETFSMAP.
>   *
