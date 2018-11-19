Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:60562 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730469AbeKTIaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 03:30:09 -0500
Date: Tue, 20 Nov 2018 09:04:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: flush posteof zeroing before reflink truncation
Message-ID: <20181119220422.GL19305@dastard>
References: <20181116190724.GW4235@magnolia>
 <20181116203756.GF19305@dastard>
 <20181118141205.GA40476@bfoster>
 <20181119002611.GH19305@dastard>
 <20181119190513.GA2841@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119190513.GA2841@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 19, 2018 at 02:05:13PM -0500, Brian Foster wrote:
> On Mon, Nov 19, 2018 at 11:26:11AM +1100, Dave Chinner wrote:
> > (*) I've still got several different fsx variants that fail on either
> > default configs and/or 1k block size with different signatures.
> > Problem is they take between 370,000 ops and 5 million ops to
> > trigger, and so generate tens to hundreds of GB of trace data....
> > 
> 
> Have you tried 1.) further reducing the likely unrelated operations
> (i.e., fallocs, insert/collapse range, etc.) from the test

Yes. The test cases I have cut out all the unnecessary ops.

Oh, look, I just found a new failure on a default 4k block size
filesystem:

# src/xfstests-dev/ltp/fsx -q -p 10000  -o 128000   -l 500000 -r 4096 -t 512 -w 512 -Z -R -W -F -H -z -C -I  /mnt/scratch/foo
20000 clone     from 0x46000 to 0x48000, (0x2000 bytes) at 0x2c000
100000 clone    from 0x44000 to 0x51000, (0xd000 bytes) at 0x1e000
110000 clone    from 0x54000 to 0x5b000, (0x7000 bytes) at 0xf000
READ BAD DATA: offset = 0x1000, size = 0xb000, fname = /mnt/scratch/foo
OFFSET  GOOD    BAD     RANGE
0x07000 0xa2d9  0x711b  0x00000
....


> and 2.)
> manually trimming down and replaying the op record file fsx dumps out on
> failure?

I've mostly been unable to get that to reliably reproduce the
problems. The failures I'm getting smell like race conditions -
turning on tracing makes a couple of them go away - and I haven't
found a reliable set of cut-down ops to reproduce them.

> I usually don't bother with fs level tracing for this kind of
> thing until I get a repeatable and somewhat manageable set of operations
> to work with.

Neither do I, but there's little choice when the failures aren't
reliable.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
