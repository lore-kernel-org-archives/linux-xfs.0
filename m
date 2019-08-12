Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40436 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbfHLVqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 17:46:01 -0400
Date: Tue, 13 Aug 2019 07:44:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190812214449.GC6129@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Deutschmann <whissi@gentoo.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Aug 12, 2019 at 12:57:32PM +0200, Thomas Deutschmann wrote:
> Hi,
> 
> On 2019-08-12 06:30, Dave Chinner wrote:
> >>> In a clear environment, do:
> >>>
> >>>> tar -xaf xfsprogs-5.2.0.tar.xz
> >>>> cd xfsprogs-5.2.0
> >>>> export CFLAGS="-O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt"
> >>>> export LDFLAGS="-Wl,-O1 -Wl,--as-needed"
> >>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >> Don't do this.
> >>
> >> "--as-needed" is the default linker behaviour since gcc 4.x. You do
> >> not need this. As for passing "-O1" to the linker, that's not going
> >> to do anything measurable for you. Use --enable-lto to turn on link
> >> time optimisations if they are supported by the compiler.
> > 
> > Ok, I could reproduce your link time failure for a while with
> > --enable-lto, but I ran 'make distclean' and the problem went away
> > completely. And I can build with your options successfully, too:
> > 
> > $ make realclean
> > $ make configure
> > <builds new configure script>
> > $ LDFLAGS="-Wl,-O1 -Wl,--as-needed" ./configure
> 
> That's not the correct way to reproduce. It's really important to
> _export_ the variable to trigger the problem and _this_ is a problem in
> xfsprogs' build system.

Which means you are overriding the LDFLAGS set by configure when
you _run make_, not just telling configure to use those LDFLAGS.

That's why _make_ is getting screwed up - it is doing exactly what
you are telling it to do, and that is to overrides every occurrence
of LDFLAGS with your exported options rather than using the correct
set configure calculated and specified.

Exporting your CFLAGS and LDFLAGS is the wrong thing to doing
- they should only ever be passed to the configure invocation and
not remain to pollute the build environment after you've run
configure.

> But keep in mind that 3x "-Wl,-O1 -Wl,--as-needed" don't cause a failure
> without "--disable-static" for me... that's just the answer for your
> question where this is coming from.

As I've already explained, --disable-static should never have worked
in the first place, because the internal XFS libraries are
statically linked and need to be build statically, which
--disable-static turns off. 

Indeed:

$ git reset --hard v5.1.0; make realclean; make configure ; ./configure --disable-static ; make -j 32
......
    [LD]     xfs_estimate
    [LD]     xfs_mdrestore
    [LD]     xfs_rtcp
    [LD]     libhandle.la
    [LD]     libxcmd.la
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_new_probe_from_filename'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_alignment_offset'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_probe_get_topology'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_do_fullprobe'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_logical_sector_size'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_optimal_io_size'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_probe_lookup_value'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_free_probe'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_physical_sector_size'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_probe_enable_partitions'
/usr/bin/ld: ../libfrog/.libs/libfrog.so: undefined reference to `blkid_topology_get_minimum_io_size'
$

Yup, --disable-static is broken in v5.1.0, too. I'm guessing it
hasn't worked for a long time....

So, please remove --disable-static from your build, and everything
will be fine. I'll write up a patch to remove --disable-static from
the configure script so this broken option can't be specified any
more.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
