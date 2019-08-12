Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46485 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbfHLDMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Aug 2019 23:12:32 -0400
Date: Mon, 12 Aug 2019 13:11:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190812031123.GA6129@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Deutschmann <whissi@gentoo.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Aug 12, 2019 at 03:21:28AM +0200, Thomas Deutschmann wrote:
> On 2019-08-12 02:23, Dave Chinner wrote:
> > That still doesn't explain where all the whacky gcc options are
> > coming from - that's got to be something specific to your build or
> > distro environment.
> 
> Mh, at the moment it looks like xfsprogs' build system is adding
> $LDFLAGS multiple times when LDFLAGS is set in environment.
> 
> In a clear environment, do:
> 
> > tar -xaf xfsprogs-5.2.0.tar.xz
> > cd xfsprogs-5.2.0
> > export CFLAGS="-O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt"
> > export LDFLAGS="-Wl,-O1 -Wl,--as-needed"
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Don't do this.

"--as-needed" is the default linker behaviour since gcc 4.x. You do
not need this. As for passing "-O1" to the linker, that's not going
to do anything measurable for you. Use --enable-lto to turn on link
time optimisations if they are supported by the compiler.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
