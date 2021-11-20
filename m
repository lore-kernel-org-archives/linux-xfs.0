Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC28C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Nov 2021 22:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbhKTWaZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Nov 2021 17:30:25 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:44390 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236454AbhKTWaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Nov 2021 17:30:25 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 9372B1092AC;
        Sun, 21 Nov 2021 09:27:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1moYpL-00BFrN-0x; Sun, 21 Nov 2021 09:27:19 +1100
Date:   Sun, 21 Nov 2021 09:27:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Helmut Grohne <helmut@subdivi.de>,
        Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] debian: Fix FTCBFS: Skip crc32 test (Closes: #999879)
Message-ID: <20211120222719.GC449541@dread.disaster.area>
References: <20211119171241.102173-1-bage@debian.org>
 <20211119171241.102173-3-bage@debian.org>
 <20211119231105.GA449541@dread.disaster.area>
 <YZikmB1aLZUX8FC7@alf.mars>
 <20211120171548.GB24307@magnolia>
 <20211120222009.GB449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120222009.GB449541@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61997647
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=3_uRt0xjAAAA:8 a=xNf9USuDAAAA:8
        a=7-415B0cAAAA:8 a=EnCLs0fK6DofL71tI8kA:9 a=CjuIK1q_8ugA:10
        a=z1SuboXgGPGzQ8_2mWib:22 a=SEwjQc04WA-l_NiBhQ7s:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 21, 2021 at 09:20:09AM +1100, Dave Chinner wrote:
> On Sat, Nov 20, 2021 at 09:15:48AM -0800, Darrick J. Wong wrote:
> > On Sat, Nov 20, 2021 at 08:32:40AM +0100, Helmut Grohne wrote:
> > > Hi Dave,
> > > 
> > > On Sat, Nov 20, 2021 at 10:11:05AM +1100, Dave Chinner wrote:
> > > > I don't get it. The crcselftest does not use liburcu in
> > > > any way, nor does it try to link against liburcu, so it should not
> > > > fail because other parts of xfsprogs use liburcu.
> > > > 
> > > > What's the build error that occurs?
> > > 
> > > As the build log shows, that's not technically accurate. You can find
> > > logs of test builds for various architecture combinations at
> > > http://crossqa.debian.net/src/xfsprogs. This is also available as a link
> > > called "cross" in https://tracker.debian.org/xfsprogs.
> > > 
> > > The relevant part is:
> > > |     [TEST]    CRC32
> > > | In file included from crc32.c:35:
> > > | ../include/platform_defs.h:27:10: fatal error: urcu.h: No such file or directory
> > > |    27 | #include <urcu.h>
> > > |       |          ^~~~~~~~
> > > | compilation terminated.
> > > 
> > > I failed to figure a good way of dropping either include directive.
> > > 
> > > > We need to fix the generic cross-build problem in the xfsprogs code,
> > > > not slap a distro-specific build band-aid over it.
> > > 
> > > I fully agree with this in principle. However, when I fail to find that
> > > upstreamable solution, I try to at least provide a Debian-specific
> > > solution to iterate from.
> > > 
> > > Can you propose a way to drop either #include?
> > 
> > Frankly I don't really see the value in crc32selftest when cross
> > compiling -- sure, the crc32c code works correctly on the build host,
> > but that proves nothing about the (cross-)built binaries that end up in
> > the package.
> 
> Yup, that's pretty much what I was getting at.

Though this is pretty simple and should just work, too:

--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -29,10 +29,11 @@
  * match the hardware acceleration available on Intel CPUs.
  */
 
+#include <stdio.h>
+#include <sys/types.h>
 #include <inttypes.h>
 #include <asm/types.h>
 #include <sys/time.h>
-#include "platform_defs.h"
 /* For endian conversion routines */
 #include "xfs_arch.h"
 #include "crc32defs.h"

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
