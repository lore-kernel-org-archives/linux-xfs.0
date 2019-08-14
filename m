Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34054 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726692AbfHNDoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 23:44:09 -0400
Date: Wed, 14 Aug 2019 13:42:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190814034257.GH6129@dread.disaster.area>
References: <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
 <20190812214449.GC6129@dread.disaster.area>
 <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
 <20190813010447.GE6129@dread.disaster.area>
 <93adbd5c-1231-a94e-f44c-33bd79e26cdf@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93adbd5c-1231-a94e-f44c-33bd79e26cdf@gentoo.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Deutschmann <whissi@gentoo.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Tue, Aug 13, 2019 at 03:52:31PM +0200, Thomas Deutschmann wrote:
> On 2019-08-13 03:04, Dave Chinner wrote:
> >> Normally, configure will get the value and the Makefiles will use the
> >> value _from_ configure... but using configure _and_ reading _and adding_
> >> values from environment _in addition_ seems to be wrong.
> > 
> > <sigh>
> > 
> > xfsprogs-2.7.18 (16 May 2006)
> >         - Fixed a case where xfs_repair was reporting a valid used
> >           block as a duplicate during phase 4.
> >         - Fixed a case where xfs_repair could incorrectly flag extent
> >           b+tree nodes as corrupt.
> >         - Portability changes, get xfs_repair compiling on IRIX.
> >         - Parent pointer updates in xfs_io checker command.
> >         - Allow LDFLAGS to be overridden, for Gentoo punters.
> > 	  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Back in 2006 we added the ability for LDFLAGS to be overriden
> > specifically because Gentoo users wanted it.
> 
> Well, you got us :-)
> 
> Sorry, I wasn't around 2006 and don't know all details. Looks
> like commit https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=4d32d744f07ce74abac7029c3ee7c6f5e4238d25 caused that
> changelog entry.

I was hoping you'd look at the change and then notice and
understand that the override provided was for LDFLAGS passed by
configure, not the make environment.

And that, having looked at this hunk of the patch:

-LDFLAGS = $(LLDFLAGS)
+LDFLAGS += $(LOADERFLAGS) $(LLDFLAGS)

then, perhaps, you'd see the obvious bug introduced by that change
that resulted in LDFLAGS no longer being initialised correctly and
so could be accidentally initialised from the external
environment....

> Back to xfsprogs: When you pass your default CFLAGS/LDFLAGS
> to configure and different to make, i.e.
>
> CFLAGS="-O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt -frecord-gcc-switches" \
> LDFLAGS="-Wl,-O1 -Wl,--as-needed" \
> ./configure
> 
> and 
> 
> CFLAGS="-O2 -pipe -march=native" \
> LDFAGS="-Wl,-fno-lto" \
> make V=1
>
> you will see
> 
> > /bin/bash ../libtool --quiet --tag=CC --mode=link gcc -o mkfs.xfs -Wl,-fno-lto  -Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed -static-libtool-libs  proto.o xfs_mkfs.o   ../libxfs/libxfs.la ../libxcmd/libxcmd.la ../libfrog/libfrog.la -lrt -lpthread -lblkid -luuid

I also note that you haven't observed that CFLAGS did not get
overridden in this test, despite it being specified in the
environment like LDFLAGS.

So we correctly initialise CFLAGS so it can't be overriden from
make, but we don't initialise LDFLAGS. Yeah, I noticed this a couple
of days ago, and I've been waiting for you to send the "you forgot
to initialise a varaible 13 years ago" patch after I pointed you
right at it...

Really, I should have just sent this patch when I wrote it couple of
days ago, rather than thinking that with enough information you'd
find it yourself and get credit and cudos for fixing it for us.

Gesta non verba.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfsprogs: LDFLAGS comes from configure, not the make environment

From: Dave Chinner <dchinner@redhat.com>

When doing:

$ LDFLAGS=foo make

bad things happen because we don't initialise LDFLAGS to an empty
string in include/builddefs.in and hence make takes wahtever is in
the environment and runs with it. This causes problems even when the
correct linker options are specified correctly through configure.

We don't support overriding build flags (like CFLAGS) though the
make environment, so it was an oversight 13 years ago to allow
LDFLAGS to be overridden when adding support to custom LDFLAGS being
passed from the the configure script. This ensures we only ever use
linker flags from configure, not the make environment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/builddefs.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/builddefs.in b/include/builddefs.in
index c5b38b073e1f..e0f0ad94976e 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -16,6 +16,10 @@ LTLDFLAGS = @LDFLAGS@
 CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
 BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
 
+# make sure we don't pick up whacky LDFLAGS from the make environment and
+# only use what we calculate from the configured options above.
+LDFLAGS =
+
 LIBRT = @librt@
 LIBUUID = @libuuid@
 LIBPTHREAD = @libpthread@
