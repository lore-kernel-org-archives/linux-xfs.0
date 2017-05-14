Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:21804 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751123AbdENW0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 May 2017 18:26:20 -0400
Date: Mon, 15 May 2017 08:26:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: use crc32c slice-by-8 variant by default
Message-ID: <20170514222616.GM17542@dastard>
References: <20170513193344.GK4519@birch.djwong.org>
 <20170513234545.GL17542@dastard>
 <20170514012522.GL4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170514012522.GL4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Sat, May 13, 2017 at 06:25:22PM -0700, Darrick J. Wong wrote:
> On Sun, May 14, 2017 at 09:45:45AM +1000, Dave Chinner wrote:
> > On Sat, May 13, 2017 at 12:33:44PM -0700, Darrick J. Wong wrote:
> > > The crc32c code used in xfsprogs was copied directly from the Linux
> > > kernel.  However, that code selects slice-by-4 by default, which isn't
> > > the fastest -- that's slice-by-8, which trades table size for speed.
> > > Fix some makefile dependency problems and explicitly select the
> > > algorithm we want.  With this patch applied, I see about a 10% drop in
> > > CPU time running xfs_repair.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  libxfs/Makefile    |    4 ++--
> > >  libxfs/crc32defs.h |    3 +++
> > >  2 files changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/libxfs/Makefile b/libxfs/Makefile
> > > index 0f3759e..c5dc382 100644
> > > --- a/libxfs/Makefile
> > > +++ b/libxfs/Makefile
> > > @@ -124,7 +124,7 @@ LDIRT = gen_crc32table crc32table.h crc32selftest
> > >  
> > >  default: crc32selftest ltdepend $(LTLIBRARY)
> > >  
> > > -crc32table.h: gen_crc32table.c
> > > +crc32table.h: gen_crc32table.c crc32defs.h
> > >  	@echo "    [CC]     gen_crc32table"
> > >  	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32table $<
> > >  	@echo "    [GENERATE] $@"
> > > @@ -135,7 +135,7 @@ crc32table.h: gen_crc32table.c
> > >  # systems/architectures. Hence we make sure that xfsprogs will never use a
> > >  # busted CRC calculation at build time and hence avoid putting bad CRCs down on
> > >  # disk.
> > > -crc32selftest: gen_crc32table.c crc32table.h crc32.c
> > > +crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h
> > >  	@echo "    [TEST]    CRC32"
> > >  	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
> > >  	$(Q) ./$@
> > > diff --git a/libxfs/crc32defs.h b/libxfs/crc32defs.h
> > > index 64cba2c..153f44c 100644
> > > --- a/libxfs/crc32defs.h
> > > +++ b/libxfs/crc32defs.h
> > > @@ -1,3 +1,6 @@
> > > +/* Use slice-by-8, which is the fastest variant. */
> > > +# define CRC_LE_BITS 64
> > 
> > I'm not sure this works on all platforms and builds, whereas the
> > existing slice-by-4 default should work for them all
> 
> That's why we have a selftest to ensure that the implementation isn't
> busted no matter which method we pick.

<snip long explanation>

> For nearly all of XFS' perceived
> userbase (which I assume are 32 and 64-bit machines with sufficiently
> large CPU cache and largeish storage devices) I think slice by 8 is the
> right choice.

If it takes you that much text to explain why it's a) safe and b)
desirable for all xfsprogs users, then short commit message that
effectively only says "slice-by-8 is 10% faster" is not
sufficient....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
