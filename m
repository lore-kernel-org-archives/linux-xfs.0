Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:29955 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731279AbeKTIdn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 03:33:43 -0500
Date: Tue, 20 Nov 2018 09:07:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: flush posteof zeroing before reflink truncation
Message-ID: <20181119220756.GM19305@dastard>
References: <20181116190724.GW4235@magnolia>
 <20181116203756.GF19305@dastard>
 <20181118141205.GA40476@bfoster>
 <20181119002611.GH19305@dastard>
 <20181119190513.GA2841@bfoster>
 <20181119220422.GL19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119220422.GL19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 20, 2018 at 09:04:22AM +1100, Dave Chinner wrote:
> On Mon, Nov 19, 2018 at 02:05:13PM -0500, Brian Foster wrote:
> > On Mon, Nov 19, 2018 at 11:26:11AM +1100, Dave Chinner wrote:
> > > (*) I've still got several different fsx variants that fail on either
> > > default configs and/or 1k block size with different signatures.
> > > Problem is they take between 370,000 ops and 5 million ops to
> > > trigger, and so generate tens to hundreds of GB of trace data....
> > > 
> > 
> > Have you tried 1.) further reducing the likely unrelated operations
> > (i.e., fallocs, insert/collapse range, etc.) from the test
> 
> Yes. The test cases I have cut out all the unnecessary ops.
> 
> Oh, look, I just found a new failure on a default 4k block size
> filesystem:
> 
> # src/xfstests-dev/ltp/fsx -q -p 10000  -o 128000   -l 500000 -r 4096 -t 512 -w 512 -Z -R -W -F -H -z -C -I  /mnt/scratch/foo
> 20000 clone     from 0x46000 to 0x48000, (0x2000 bytes) at 0x2c000
> 100000 clone    from 0x44000 to 0x51000, (0xd000 bytes) at 0x1e000
> 110000 clone    from 0x54000 to 0x5b000, (0x7000 bytes) at 0xf000
> READ BAD DATA: offset = 0x1000, size = 0xb000, fname = /mnt/scratch/foo
> OFFSET  GOOD    BAD     RANGE
> 0x07000 0xa2d9  0x711b  0x00000
> ....

And just to reinforce that these are unreliable failures, the second
time I ran the above command:

$ src/xfstests-dev/ltp/fsx -q -p 10000  -o 128000   -l 500000 -r 4096 -t 512 -w 512 -Z -R -W -F -H -z -C -I  /mnt/scratch/foo
20000 clone     from 0x46000 to 0x48000, (0x2000 bytes) at 0x2c000
100000 clone    from 0x44000 to 0x51000, (0xd000 bytes) at 0x1e000
110000 clone    from 0x54000 to 0x5b000, (0x7000 bytes) at 0xf000
120000 clone    from 0x3a000 to 0x3e000, (0x4000 bytes) at 0x10000
140000 trunc    from 0x62400 to 0xd800
190000 trunc    from 0x56800 to 0x78e00
READ BAD DATA: offset = 0x2c000, size = 0x1c000, fname = /mnt/scratch/foo
OFFSET  GOOD    BAD     RANGE
0x32000 0xc81d  0x9289  0x00000
.....

It failed somewhere else. That's the difficulty I'm having here -
the failures aren't reliable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
