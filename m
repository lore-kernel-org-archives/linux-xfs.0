Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36411 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934873AbcIHNWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 09:22:45 -0400
Received: by mail-wm0-f66.google.com with SMTP id l65so7840970wmf.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 06:22:44 -0700 (PDT)
Date: Thu, 8 Sep 2016 15:22:41 +0200
From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: Re: [BUG] xfsprogs-4.7.0: issues cross-compiling for musl
Message-ID: <20160908152241.437cf8c8@gmail.com>
In-Reply-To: <ed4c5fc0-d33d-553e-bae8-ea4e269888cc@sandeen.net>
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
        <20160907222753.GR30056@dastard>
        <e9241262-fdfa-d10c-3fa2-3c4ef752a8bc@sandeen.net>
        <20160908104131.479349ae@gmail.com>
        <ed4c5fc0-d33d-553e-bae8-ea4e269888cc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, 8 Sep 2016 07:13:40 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> On 9/8/16 3:41 AM, Ralph Sennhauser wrote:
> > Hi Eric
> > 
> > On Wed, 7 Sep 2016 17:40:01 -0500
> > Eric Sandeen <sandeen@sandeen.net> wrote:
> >   
> >> On 9/7/16 5:27 PM, Dave Chinner wrote:  
> >>> On Wed, Sep 07, 2016 at 11:42:56AM +0200, Ralph Sennhauser
> >>> wrote:    
> >>>> To get xfsprogs to cross-compile for musl some hacks were needed.
> >>>>
> >>>> 1) d_namlen isn't available with musl    
> >>>
> >>> musl problem. It needs to define _DIRENT_HAVE_D_RECLEN and friends
> >>> to tell applications what the struct dirent it defines contains.
> >>>
> >>> (Haven't we been through this before?)    
> >>
> >> (yes: http://www.openwall.com/lists/musl/2016/01/15/9)
> >>
> >> what *does* it contain?
> >>
> >> We do already have:
> >>
> >>  #ifdef _DIRENT_HAVE_D_RECLEN
> >>  		*total += dirent->d_reclen;
> >>  #else
> >> 		*total += dirent->d_namlen + sizeof(*dirent);
> >>  #endif
> >>
> >> but you'd like:
> >>
> >>  #ifdef _DIRENT_HAVE_D_RECLEN
> >>  		*total += dirent->d_reclen;
> >>  #else
> >> -		*total += dirent->d_namlen + sizeof(*dirent);
> >> +		*total += strlen(dirent->d_name) +
> >> sizeof(*dirent); #endif
> >>
> >> but musl *does* have d_reclen:
> >>
> >> http://git.musl-libc.org/cgit/musl/tree/include/dirent.h
> >>
> >> so if it simply advertised that fact we'd be good...  
> > 
> > Why not test for d_reclen in configure instead?  
> 
> Why not advertise it in headers, as the manpage tells us to expect?
> 
> In the end Dave is the final arbiter here.  I don't really care,
> but what I would not want to see is #ifdef hell resulting from
> several different ways to check.  If it can be hidden in configure,
> it doesn't bother me.
> 

It can be hidden from the sources. If musl advertises d_reclen the code
is fixed for musl. We still might want the slow-path to be more POSIX
conformant for other libcs.

> >>
> >> Whatever happened to that request from January above?  
> 
> Nobody knows? ;)
> 

It's not in master :)

> >>>> 2) crc32selftest doesn't make sense in case of cross-compilation,
> >>>> the same can be said if building for a different host with the
> >>>> native toolchain. So maybe an --disable-crc32selftest configure
> >>>> option could be used here.  
> 
> ...
> 
> > So for 2) the plan is disable if cross-compiling, run
> > unconditionally otherwise and no way to overwrite at configure
> > time.  
> 
> Seems reasonable.  I agree that it should be automatic, not a
> config-time switch.  We know if we're cross compiling, so DTRT...
> 
> -Eric
>  

Even with a configure option default would be enabled unless
cross-compiling, that would be my take.

Of course "make test" wasn't ruled out either. Guess that is still open
as well.

Cross-compiling crc32selftest instead of compiling native is probably
more meaningful as well. So that remark earlier certainly has some
merit.

Cheers
Ralph
