Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58838 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbeGRV07 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 17:26:59 -0400
Date: Wed, 18 Jul 2018 13:47:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: filefrag and reflink
Message-ID: <20180718204715.GB4813@magnolia>
References: <CAJCQCtSJUV-0LYCTS2mfeZWA812aqc5oQagsWZ5fi3xuXQ9ncA@mail.gmail.com>
 <20180718195940.GA4813@magnolia>
 <165c936c-7dc4-7336-3d7e-268ec6746b56@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165c936c-7dc4-7336-3d7e-268ec6746b56@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Jul 18, 2018 at 01:27:40PM -0700, Eric Sandeen wrote:
> 
> 
> On 7/18/18 12:59 PM, Darrick J. Wong wrote:
> > On Wed, Jul 18, 2018 at 12:41:27PM -0600, Chris Murphy wrote:
> >> xfsprogs 4.17.0 mkfs with reflink=1
> >> kernel 4.17.6
> >>
> >> $ fallocate -l 1g tmp2
> >> $ cp --reflink tmp2 tmp3
> >> $ filefrag -v *
> >> Filesystem type is: 58465342
> >> File size of tmp2 is 1073741824 (262144 blocks of 4096 bytes)
> >>  ext:     logical_offset:        physical_offset: length:   expected: flags:
> >>    0:        0..  130136:         24..    130160: 130137:             unwritten
> >>    1:   130137..  260280:     131082..    261225: 130144:     130161: unwritten
> >>    2:   260281..  262143:     264714..    266576:   1863:     261226:
> >> last,unwritten,eof
> >> tmp2: 3 extents found
> >> File size of tmp3 is 1073741824 (262144 blocks of 4096 bytes)
> >> tmp3: 0 extents found
> >> [chris@f28s xfs]$
> >>
> >>
> >> Is this expected? When I do it on Btrfs, I see identical information
> >> for the two files after reflink copy, with flags "unwritten,shared".
> > 
> > Yes.  xfs doesn't share unwritten extents; what would be the point?
> > 
> > --D
> 
> <materializes somewhere on a US western interstate>
> 
> Seems a little weird that bare cp will create a written file full of
> zeros, while a cp --reflink will create a sparse file, though?

Well see therein lies the problem.  The documentation for cp states:

"When --reflink[=always] is specified, perform a lightweight copy, where
the data blocks are copied only when modified."

The lightest weight copy for a bunch of zeroes is a hole.  That's the
interpretation I went with. :)

OTOH the "copied only when modified" language does sort of imply that
you'd share the unwritten extents and then COW them, but that involves
adding more machinery to _iomap_begin to copy-write over zeroes,
which seems pointless and would involve a format change since old
kernels wouldn't know to check for shared unwritten extents...

...and if your worry is about being able to write to tmp3 without
hitting ENOSPC then you'll have to fallocate + funshare the file
separately anyway.

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
