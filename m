Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33356 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfHMBF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 21:05:58 -0400
Date: Tue, 13 Aug 2019 11:04:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190813010447.GE6129@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
 <20190812214449.GC6129@dread.disaster.area>
 <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Deutschmann <whissi@gentoo.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Tue, Aug 13, 2019 at 12:18:04AM +0200, Thomas Deutschmann wrote:
> On 2019-08-12 23:44, Dave Chinner wrote:
> >> That's not the correct way to reproduce. It's really important to
> >> _export_ the variable to trigger the problem and _this_ is a problem in
> >> xfsprogs' build system.
> > Which means you are overriding the LDFLAGS set by configure when
> > you _run make_, not just telling configure to use those LDFLAGS.
> > 
> > That's why _make_ is getting screwed up - it is doing exactly what
> > you are telling it to do, and that is to overrides every occurrence
> > of LDFLAGS with your exported options rather than using the correct
> > set configure calculated and specified.
> > 
> > Exporting your CFLAGS and LDFLAGS is the wrong thing to doing
> > - they should only ever be passed to the configure invocation and
> > not remain to pollute the build environment after you've run
> > configure.
> 
> I disagree with the conclusion. LDFLAGS in build environment shouldn't
> cause any problems, especially when you are using a build system:
>
> Normally, configure will get the value and the Makefiles will use the
> value _from_ configure... but using configure _and_ reading _and adding_
> values from environment _in addition_ seems to be wrong.

<sigh>

xfsprogs-2.7.18 (16 May 2006)
        - Fixed a case where xfs_repair was reporting a valid used
          block as a duplicate during phase 4.
        - Fixed a case where xfs_repair could incorrectly flag extent
          b+tree nodes as corrupt.
        - Portability changes, get xfs_repair compiling on IRIX.
        - Parent pointer updates in xfs_io checker command.
        - Allow LDFLAGS to be overridden, for Gentoo punters.
	  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Back in 2006 we added the ability for LDFLAGS to be overriden
specifically because Gentoo users wanted it.

> So you either use a build system or you don't.

Yup, but Gentoo wanted it both ways, and so we gave them that
capability.  And now you're complaining that Gentoo users can shoot
themselves in the foot with it.... :/

Just pass your special CFLAGS/LDFLAGS to configure like the rest of
the world does and everything will work correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
