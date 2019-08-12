Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51858 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbfHLWEw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:04:52 -0400
Date: Tue, 13 Aug 2019 08:03:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190812220342.GD6129@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
 <5aff83b5-2ff3-4c2c-e0ef-c04bc506fe4f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aff83b5-2ff3-4c2c-e0ef-c04bc506fe4f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Thomas Deutschmann <whissi@gentoo.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Aug 12, 2019 at 11:34:56AM -0500, Eric Sandeen wrote:
> 
> 
> On 8/12/19 5:57 AM, Thomas Deutschmann wrote:
> > Hi,
> > 
> > On 2019-08-12 06:30, Dave Chinner wrote:
> >>>> In a clear environment, do:
> >>>>
> >>>>> tar -xaf xfsprogs-5.2.0.tar.xz
> >>>>> cd xfsprogs-5.2.0
> >>>>> export CFLAGS="-O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt"
> >>>>> export LDFLAGS="-Wl,-O1 -Wl,--as-needed"
> >>>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>> Don't do this.
> >>>
> >>> "--as-needed" is the default linker behaviour since gcc 4.x. You do
> >>> not need this. As for passing "-O1" to the linker, that's not going
> >>> to do anything measurable for you. Use --enable-lto to turn on link
> >>> time optimisations if they are supported by the compiler.
> >>
> >> Ok, I could reproduce your link time failure for a while with
> >> --enable-lto, but I ran 'make distclean' and the problem went away
> >> completely. And I can build with your options successfully, too:
> >>
> >> $ make realclean
> >> $ make configure
> >> <builds new configure script>
> >> $ LDFLAGS="-Wl,-O1 -Wl,--as-needed" ./configure
> > 
> > That's not the correct way to reproduce. It's really important to
> > _export_ the variable to trigger the problem and _this_ is a problem in
> > xfsprogs' build system.
> > 
> > But keep in mind that 3x "-Wl,-O1 -Wl,--as-needed" don't cause a failure
> > without "--disable-static" for me... that's just the answer for your
> > question where this is coming from.
> 
> My takeaway here is that I should probably stub out some things to make
> this issue go away altogether,

The linker should be taking care of eliding dead code from
statically linked libraries.

The issue here is that a shared library can't have undefined symbols
elided at link time because the linker has no idea if they will be
used or not.  Hence it fails to link against binaries that don't
specify all possible external library dependencies, even when the
library dependency is brought in by another library.

> but that it can also be remedied by adjusting
> compiler/linker flags.  Correct?  I'm not sure if this warrants a 5.2.1 release.

If you don't use the non-default --disable-static configure option
then there is no problem. That option appears to have been broken
for a while now, so lets just get rid of it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
