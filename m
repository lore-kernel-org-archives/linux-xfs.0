Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:12551 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756213AbcK2XZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 18:25:54 -0500
Date: Wed, 30 Nov 2016 10:25:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix building xfsprogs on 32-bit platforms
Message-ID: <20161129232548.GF31101@dastard>
References: <1480372955-41315-1-git-send-email-ebiggers@google.com>
 <20161129214456.GE31101@dastard>
 <20161129222135.GA107713@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161129222135.GA107713@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers@google.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2016 at 02:21:35PM -0800, Eric Biggers wrote:
> On Wed, Nov 30, 2016 at 08:44:56AM +1100, Dave Chinner wrote:
> > On Mon, Nov 28, 2016 at 02:42:35PM -0800, Eric Biggers wrote:
> > > Since commit 7fda99a0c297 ("xfs.h: require transparent LFS for all
> > > users"), building xfsprogs fails on a 32-bit platform because it does
> > > not define _FILE_OFFSET_BITS=64 itself.  Fix it by adding this to CFLAGS
> > > in builddefs.in.
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  include/builddefs.in | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/include/builddefs.in b/include/builddefs.in
> > > index aeb2905..5219071 100644
> > > --- a/include/builddefs.in
> > > +++ b/include/builddefs.in
> > > @@ -25,7 +25,7 @@ OPTIMIZER = @opt_build@
> > >  MALLOCLIB = @malloc_lib@
> > >  LOADERFLAGS = @LDFLAGS@
> > >  LTLDFLAGS = @LDFLAGS@
> > > -CFLAGS = @CFLAGS@
> > > +CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
> > 
> > So, umm, why aren't these lines in configure.ac setting this already
> > on your system?
> > 
> > AC_SYS_LARGEFILE
> > AC_NEED_LFS
> > 
> > Cheers,
> > 
> 
> AC_SYS_LARGEFILE puts the _FILE_OFFSET_BITS definition in the generated config
> header, not in CFLAGS. 

<sigh> It's times like this that I really hate software.

This is not what the documentation implies occurs:

https://www.gnu.org/software/autoconf/manual/autoconf-2.65/html_node/System-Services.html

	Macro: AC_SYS_LARGEFILE

	Arrange for 64-bit file offsets, known as large-file
	support. On some hosts, one must use special compiler
	options to build programs that can access large files.
	Append any such options to the output variable CC. Define
	_FILE_OFFSET_BITS and _LARGE_FILES if necessary.


i.e. it implies that the required LFS options are automatically
appended to CC variable.

> Normally projects use a config.h.in template that's generated from
> configure.ac using autoheader.  xfsprogs doesn't do this but
> rather uses a non-generated file include/platform_defs.h.in.

We didn't add any hoop jumping, because the autoconf documentation
implies it is not necessary. I trusted that the patch submitter
actually tested it on 32 bit systems and that it all worked.

> Since there is no "#undef _FILE_OFFSET_BITS" in
> platform_defs.h.in, '#define _FILE_OFFSET_BITS 64' doesn't gets
> included in platform_defs.h.

platform_defs.h should not need to do this - we handle build
environment specific defines in builddefs.h....

> Also, even if it was, then I think
> it wouldn't always work because not all .c files in xfsprogs have
> platform_defs.h as their first #include.

.... precisely for this reason.

So, builddefs.in should really detect if autoconf set a "large file
required" flag, and in that case add the _FILE_OFFSET_BITS value
that autoconf has generated to the PCFLAGS variable, right? (PCFLAGS
are "Platform CFLAGS")

Or, if we are just going to unconditionally define
-D_FILE_OFFSET_BITS=64 in CFLAGS, then the autoconf checks are
completely useless and should be removed?

> The reason AC_NEED_LFS still passes is that 'configure' includes a
> temporary header confdefs.h rather than the final generated
> header, and the temporary header includes the _FILE_OFFSET_BITS
> definition.

IOWs, stupid code backed by ambiguous documentation means that
developers that try to do the right thing still end up with broken
builds.

Eric, to speed things up a bit next time, can you try to explain how
something is broken in the commit message, not just say "it's
broken, fix it". This avoids the need to go back and forth multiple
times just so we can understand what the problem is that you are
fixing....

Cheers,

-Dave.
-- 
Dave Chinner
david@fromorbit.com
