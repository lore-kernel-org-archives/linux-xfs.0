Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36357 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726649AbfHMVe5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 17:34:57 -0400
Date: Wed, 14 Aug 2019 07:33:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfsprogs: Fix --disable-static option build
Message-ID: <20190813213348.GG6129@dread.disaster.area>
References: <20190813051421.21137-1-david@fromorbit.com>
 <20190813051421.21137-3-david@fromorbit.com>
 <20190813142801.GP7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813142801.GP7138@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 07:28:01AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 13, 2019 at 03:14:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Internal xfsprogs libraries are linked statically to binaries as
> > they are not shipped libraries. Using --disable-static prevents the
> > internal static libraries from being built and this breaks dead code
> > elimination and results in linker failures from link dependencies
> > introduced by dead code.
> > 
> > We can't remove the --disable-static option that causes this as it
> > is part of the libtool/autoconf generated infrastructure. We can,
> > however, reliably detect whether static library building has been
> > disabled after the libtool infrastructure has been configured.
> > Therefore, add a check to determine the static build status and
> > abort the configure script with an error if we have been configured
> > not to build static libraries.
> 
> Uh... is this missing from the patch?  I don't see anything that aborts
> configure.  Though I sense this might be your v2 solution that works
> around --disable-static via the ld command line and leaves configure
> alone...? :)

Ugh, forgot to refresh the patch after updating the comment. That
paragraph should read:

	We can't remove the --disable-static option that causes this as it
	is part of the libtool/autoconf generated infrastructure. We can,
	however, override --disable-static on a per-library basis inside the
	build by passing -static to the libtool link command. Therefore, add
	-static to all the internal libraries we build and link statically
	to the shipping binaries.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
