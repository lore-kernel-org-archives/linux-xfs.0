Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:35245 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754011AbcK2WVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 17:21:39 -0500
Received: by mail-pg0-f43.google.com with SMTP id p66so74012761pga.2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2016 14:21:38 -0800 (PST)
Date: Tue, 29 Nov 2016 14:21:35 -0800
From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] Fix building xfsprogs on 32-bit platforms
Message-ID: <20161129222135.GA107713@google.com>
References: <1480372955-41315-1-git-send-email-ebiggers@google.com>
 <20161129214456.GE31101@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161129214456.GE31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2016 at 08:44:56AM +1100, Dave Chinner wrote:
> On Mon, Nov 28, 2016 at 02:42:35PM -0800, Eric Biggers wrote:
> > Since commit 7fda99a0c297 ("xfs.h: require transparent LFS for all
> > users"), building xfsprogs fails on a 32-bit platform because it does
> > not define _FILE_OFFSET_BITS=64 itself.  Fix it by adding this to CFLAGS
> > in builddefs.in.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  include/builddefs.in | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index aeb2905..5219071 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -25,7 +25,7 @@ OPTIMIZER = @opt_build@
> >  MALLOCLIB = @malloc_lib@
> >  LOADERFLAGS = @LDFLAGS@
> >  LTLDFLAGS = @LDFLAGS@
> > -CFLAGS = @CFLAGS@
> > +CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
> 
> So, umm, why aren't these lines in configure.ac setting this already
> on your system?
> 
> AC_SYS_LARGEFILE
> AC_NEED_LFS
> 
> Cheers,
> 

AC_SYS_LARGEFILE puts the _FILE_OFFSET_BITS definition in the generated config
header, not in CFLAGS.  Normally projects use a config.h.in template that's
generated from configure.ac using autoheader.  xfsprogs doesn't do this but
rather uses a non-generated file include/platform_defs.h.in.  Since there is no
"#undef _FILE_OFFSET_BITS" in platform_defs.h.in, '#define _FILE_OFFSET_BITS 64'
doesn't gets included in platform_defs.h.  Also, even if it was, then I think it
wouldn't always work because not all .c files in xfsprogs have platform_defs.h
as their first #include.

The reason AC_NEED_LFS still passes is that 'configure' includes a temporary
header confdefs.h rather than the final generated header, and the temporary
header includes the _FILE_OFFSET_BITS definition.

Eric
