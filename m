Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33410 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJRBPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 21:15:06 -0400
Date: Wed, 17 Oct 2018 10:18:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: don't include all xfs headers just for crc32
Message-ID: <20181017171812.GQ28243@magnolia>
References: <e1259a8b-b5aa-cfa2-aeab-13d63757d7a5@redhat.com>
 <20181011195859.GA114854@rodete-desktop-imager.corp.google.com>
 <b6ee7861-3bf0-7192-d26e-5d57bcb10d19@sandeen.net>
 <20181011224536.GC28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011224536.GC28243@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Norris <briannorris@chromium.org>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 03:45:36PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 11, 2018 at 05:36:36PM -0500, Eric Sandeen wrote:
> > 
> > 
> > On 10/11/18 2:59 PM, Brian Norris wrote:
> > > On Wed, Oct 10, 2018 at 03:55:32PM -0500, Eric Sandeen wrote:
> > >> Brian Norris reported that "The $BUILD_CC toolchain might have an
> > >> older set of Linux headers than the $CC toolchain. It's generally
> > >> unsafe to try to build both with the same definitions, but in
> > >> particular, this one can cause compilation failures in the local
> > >> crc32selftest build: [failure to find fsmap.h]"
> > >>
> > >> It seems like the most straightforward thing to do here is include
> > >> a specific set of system headers, instead of pulling in the whole
> > >> xfs.h header chain which has multiple tests and definitions in
> > >> place for headers that may or may not be there during the build.
> > >>
> > >> Reported-by: Brian Norris <briannorris@chromium.org>
> > >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > >> ---
> > >>
> > >> Brian, here's try #3, does this also work for you?
> > > 
> > > Tested-by: Brian Norris <briannorris@chromium.org>
> > > 
> > > This still leaves $BUILD_CFLAGS with bad entries, but as long as they
> > > don't get used anywhere that matters, it'll be OK.
> > 
> > Thanks.  At this point I think you have a better grasp of what all the
> > $FOO_FLAGS do than I do ;)  It may be  to keep things sorted
> > and separate, but it also seemed useful to get a giant tangle of
> > xfs header out of a non-xfs library file.
> > 
> > I'm also on the fence about whether cross-compiling the self-check
> > really even gains us much, given that it may be built or optimized
> > completely differently from the code on the target arch ...
> 
> So long as it's a software algorithm with a big lookup table I guess
> it's a serviceable sanity check that nobody totally goobered up the
> source code, but I don't know if it adds much value in the cross
> compilation case either.  If you ever wanted to add a faster
> implementation in the built libxfs <cough> that would be more of an
> issue.
> 
> (Granted, I've been running a patched xfsprogs with hw accelerated
> crc32c for a year now and haven't noticed any difference in runtime.
> Maybe now that I've finished upgrading everything to flash...)
> 

Looks ok, I guess...

(...and by "I guess" what I really mean is that given a lot of people
cross-compiling things these days I think I want a similar test of the
libxfs builtin crc32c algorithm that we can call from xfstests... but
that's not what's under review here. :))

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> --D
> 
> > -Eric
