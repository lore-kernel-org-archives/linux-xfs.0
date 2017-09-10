Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:29154 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751661AbdIJWIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Sep 2017 18:08:17 -0400
Date: Mon, 11 Sep 2017 08:08:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170910220814.GN17782@dastard>
References: <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170910211907.GF5426@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Sun, Sep 10, 2017 at 10:19:07PM +0100, Al Viro wrote:
> On Mon, Sep 11, 2017 at 07:11:10AM +1000, Dave Chinner wrote:
> > On Sun, Sep 10, 2017 at 03:57:21AM +0100, Al Viro wrote:
> > > On Sat, Sep 09, 2017 at 09:07:56PM -0400, Dave Jones wrote:
> > > 
> > > > With this in place, I'm still seeing -EBUSY from invalidate_inode_pages2_range
> > > > which doesn't end well...
> > > 
> > > Different issue, and I'm not sure why that WARN_ON() is there in the
> > > first place.  Note that in a similar situation generic_file_direct_write()
> > > simply buggers off and lets the caller do buffered write...
> > 
> > XFS does not fall back to buffered IO when direct IO fails.  A
> > direct IO failure is indicative of a problem that needs to be fixed,
> > not use a "let's hope we can hide this" fallback path. Especially in
> > this case - EBUSY usually comes from the app is doing something we
> > /know/ is dangerous and it's occurrence to completely timing
> > dependent - if the timing is slightly different, we miss detection
> > and that can lead to silent data corruption.
> 
> In this case app is a fuzzer, which is bloody well supposed to poke
> into all kinds of odd usage patterns, though...

Yup, and we have quite a few tests in xfstests that specifically
exercise this same dark corner. We filter out these warnings from
the xfstests that exercise this case, though, because we know they
are going to be emitted and so aren't a sign of test failures...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
