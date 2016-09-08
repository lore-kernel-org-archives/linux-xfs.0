Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35841 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752532AbcIHIle (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 04:41:34 -0400
Received: by mail-wm0-f65.google.com with SMTP id l65so6719153wmf.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 01:41:34 -0700 (PDT)
Date: Thu, 8 Sep 2016 10:41:31 +0200
From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: Re: [BUG] xfsprogs-4.7.0: issues cross-compiling for musl
Message-ID: <20160908104131.479349ae@gmail.com>
In-Reply-To: <e9241262-fdfa-d10c-3fa2-3c4ef752a8bc@sandeen.net>
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
        <20160907222753.GR30056@dastard>
        <e9241262-fdfa-d10c-3fa2-3c4ef752a8bc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

Hi Eric

On Wed, 7 Sep 2016 17:40:01 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> On 9/7/16 5:27 PM, Dave Chinner wrote:
> > On Wed, Sep 07, 2016 at 11:42:56AM +0200, Ralph Sennhauser wrote:  
> >> To get xfsprogs to cross-compile for musl some hacks were needed.
> >>
> >> 1) d_namlen isn't available with musl  
> > 
> > musl problem. It needs to define _DIRENT_HAVE_D_RECLEN and friends
> > to tell applications what the struct dirent it defines contains.
> > 
> > (Haven't we been through this before?)  
> 
> (yes: http://www.openwall.com/lists/musl/2016/01/15/9)
> 
> what *does* it contain?
> 
> We do already have:
> 
>  #ifdef _DIRENT_HAVE_D_RECLEN
>  		*total += dirent->d_reclen;
>  #else
> 		*total += dirent->d_namlen + sizeof(*dirent);
>  #endif
> 
> but you'd like:
> 
>  #ifdef _DIRENT_HAVE_D_RECLEN
>  		*total += dirent->d_reclen;
>  #else
> -		*total += dirent->d_namlen + sizeof(*dirent);
> +		*total += strlen(dirent->d_name) + sizeof(*dirent);
>  #endif
> 
> but musl *does* have d_reclen:
> 
> http://git.musl-libc.org/cgit/musl/tree/include/dirent.h
> 
> so if it simply advertised that fact we'd be good...

Why not test for d_reclen in configure instead?

> 
> Whatever happened to that request from January above?
> 
> That said, I suppose strlen is fine to use here, so I guess I don't
> see a strong reason to object to this change.
> 

Guessing uClibc would benefit as well.

So how does testing for d_reclen and making the slow-path more portable
by using strlen sound for a plan?

> >> 2) crc32selftest doesn't make sense in case of cross-compilation,
> >> the same can be said if building for a different host with the
> >> native toolchain. So maybe an --disable-crc32selftest configure
> >> option could be used here.
> >>
> >> 3) The CFLAGS passed to BUILD_CC weren't understood by the native
> >> compiler. Set BUILD_CFLAGS to CFLAGS if not cross-compiling or let
> >> it blank anyway?  
> > 
> > Ah, yes, we've definitely been through this before. Last time I said
> > "send patches" and they never appeared.

Well this is a case of easy to write the code but hard to figure out
what the upstream preferred way of handling it is. I'd just put it
behind a test target. Distribution developers are conditioned to run
make test.

> > 
> > As it is, I'm really hesitant to remove the crc32c sanity check,
> > mainly because we've just been through a XFS corruption drill where
> > one in 10^6 crc calculations would end up wrong because of a bug in
> > a compiler.
> > 
> > Can we "auto detect" cross compilation in the makefile and avoid the
> > check only in that situation? configure options are really only a
> > last resort...  
> 
> That sounds like the right path to me.

So for 2) the plan is disable if cross-compiling, run unconditionally
otherwise and no way to overwrite at configure time.

As for 3) is there a point in having BUILD_CFLAGS introduced?

> 
> Or cross-compile it but don't run it, and let package managers run
> it at install time?  ;)

Of course I can implement it but I doubt we would see many packagers go
that length. :)

Cheers
Ralph


> 
> >> 4) sys/ustat.h is missing in musl.  
> > 
> > Yup, been reported before. I'm about to commit a fix for that,
> > mainly because certain new arches don't even implement the ustat
> > system call, and glibc completely fucks up the handling of that.
> > i.e. programs that call ustat don't fail at build time, the syscall
> > is stubbed to print "not supported, will fail" at runtime. Hence
> > nobody noticed that the xfsprogs code calling ustat was actually
> > broken until a week ago...  
> 
> Partly because we only checked for success, not failure, but nobody
> rationally expected -ENOSYS any more than they expected the
> Spanish Inquisition...
> 
> -Eric
> 
> > Cheers,
> > 
> > Dave.
> >   

