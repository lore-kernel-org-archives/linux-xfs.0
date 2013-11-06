Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E8AC229E2B
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 17:17:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0E118F8092
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 15:17:34 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OuscKO9rMKEwzGQY for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 15:17:33 -0800 (PST)
Date: Thu, 7 Nov 2013 10:17:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20131106231713.GK6188@dastard>
References: <20131106213635.GC24712@redacted.bos.redhat.com>
	<20131106224844.GI6188@dastard>
	<20131106225620.GC29593@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106225620.GC29593@redacted.bos.redhat.com>
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
To: Kyle McMartin <kmcmarti@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 05:56:20PM -0500, Kyle McMartin wrote:
> On Thu, Nov 07, 2013 at 09:48:44AM +1100, Dave Chinner wrote:
> > > +++ b/common/getdents.c
> > 
> > Oh, how that code makes my eyes bleed. :/
> > 
> 
> Me too :\
> 
> > > @@ -70,6 +70,9 @@ extern int __have_no_getdents64;
> > >  # ifndef SYS_getdents64
> > >  #  define SYS_getdents64 __NR_getdents64
> > >  # endif
> > > +# ifndef __NR_getdents
> > > +#  define __ONLY_GETDENTS64_SYSCALL     1
> > > +# endif
> > >  #endif
> > >  
> > >  
> > > @@ -207,6 +210,13 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
> > >  # endif
> > >      }
> > >  #endif
> > > +/* Newer Linux ports are not adding deprecated syscalls, so to avoid compile
> > > + * failures since SYS_getdents will be undefined, we check for that and only
> > > + * build the fall-back case if SYS_getdents is defined. We know that
> > > + * __ASSUME_GETDENTS64_SYSCALL is set, since __NR_getdents64 must exist on
> > > + * those platforms.
> > > + */
> > > +#ifndef __ONLY_GETDENTS64_SYSCALL
> > >    {
> > >      size_t red_nbytes;
> > >      struct kernel_dirent *skdp, *kdp;
> > > @@ -265,4 +275,5 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
> > >      }
> > >  
> > >    return (char *) dp - buf;
> > > +#endif
> > >  }
> > 
> > It's not pretty - but that code has already broken the ugly stick so
> > it isn't making the situation any worse.
> > 
> > Acked-by: Dave Chinner <dchinner@redhat.com>
> 
> I'll try to clean it up and send a patch for that, using getdents64
> wherever possible, and handling the fallback at runtime instead of
> making things all ifdeffy... Just wanted to get things building in the
> mean time. (Oh man the coding style there is janky...)

I'd factor and reformat the code using the normal kernel style. :)

And to avoid ifdef hackery and runtime fallbacks, I'd add an
autoconf macro to determine which getdents call is supported, and
then only compile in the relevant function and not have to care
about runtime fallbacks.

But that may end up more complex and more work than you had in mind,
so feel free to ignore my suggestions ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
