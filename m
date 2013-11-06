Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBFD029E23
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 16:56:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C0AD58F8084
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 14:56:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id e6WkJM6fGNLxA3AR for
	<xfs@oss.sgi.com>; Wed, 06 Nov 2013 14:56:25 -0800 (PST)
Date: Wed, 6 Nov 2013 17:56:20 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20131106225620.GC29593@redacted.bos.redhat.com>
References: <20131106213635.GC24712@redacted.bos.redhat.com>
	<20131106224844.GI6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106224844.GI6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 09:48:44AM +1100, Dave Chinner wrote:
> > +++ b/common/getdents.c
> 
> Oh, how that code makes my eyes bleed. :/
> 

Me too :\

> > @@ -70,6 +70,9 @@ extern int __have_no_getdents64;
> >  # ifndef SYS_getdents64
> >  #  define SYS_getdents64 __NR_getdents64
> >  # endif
> > +# ifndef __NR_getdents
> > +#  define __ONLY_GETDENTS64_SYSCALL     1
> > +# endif
> >  #endif
> >  
> >  
> > @@ -207,6 +210,13 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
> >  # endif
> >      }
> >  #endif
> > +/* Newer Linux ports are not adding deprecated syscalls, so to avoid compile
> > + * failures since SYS_getdents will be undefined, we check for that and only
> > + * build the fall-back case if SYS_getdents is defined. We know that
> > + * __ASSUME_GETDENTS64_SYSCALL is set, since __NR_getdents64 must exist on
> > + * those platforms.
> > + */
> > +#ifndef __ONLY_GETDENTS64_SYSCALL
> >    {
> >      size_t red_nbytes;
> >      struct kernel_dirent *skdp, *kdp;
> > @@ -265,4 +275,5 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
> >      }
> >  
> >    return (char *) dp - buf;
> > +#endif
> >  }
> 
> It's not pretty - but that code has already broken the ugly stick so
> it isn't making the situation any worse.
> 
> Acked-by: Dave Chinner <dchinner@redhat.com>

I'll try to clean it up and send a patch for that, using getdents64
wherever possible, and handling the fallback at runtime instead of
making things all ifdeffy... Just wanted to get things building in the
mean time. (Oh man the coding style there is janky...)

--Kyle

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
