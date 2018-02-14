Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4286 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031536AbeBNWGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 17:06:08 -0500
Date: Thu, 15 Feb 2018 09:05:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180214220532.GJ7000@dastard>
References: <20180205003415.dn6elcqb4kae3xle@destitution>
 <20180206162141.GA3862@bfoster.bfoster>
 <20180212024138.GB6778@dastard>
 <20180212142619.GA33694@bfoster.bfoster>
 <20180212211824.GC6778@dastard>
 <20180213131525.GA38210@bfoster.bfoster>
 <20180213220220.GF6778@dastard>
 <20180214130939.GA42785@bfoster.bfoster>
 <20180214164912.GI5217@magnolia>
 <20180214180807.GA43414@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214180807.GA43414@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Feb 14, 2018 at 01:08:07PM -0500, Brian Foster wrote:
> On Wed, Feb 14, 2018 at 08:49:12AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 14, 2018 at 08:09:39AM -0500, Brian Foster wrote:
> > > On Wed, Feb 14, 2018 at 09:02:20AM +1100, Dave Chinner wrote:
> > > Yep. It's a specially crafted symlink creation on a small FSB, v4
> > > filesystem with fragmented free space. We log symlink buffers on v4
> > > filesystems without any header, so the buffer content is not dictated by
> > > any internal fs metadata format. If the link target is large enough to
> > > span multiple blocks and free space is fragmented such that those blocks
> > > are discontiguous, we can end up logging (solely) the first byte of the
> > > last buffer of the link target.

I'd completely forgotten about that whacky corner case in the v4
format. :(

> > > This is actually reproducible on demand so I'll just append a basic
> > > recipe rather than collect the debug data and whatnot..
> > > 
> > > Brian
> > > 
> > > --- 8< ---
> > > 
> > > dev=<dev>
> > > mnt=/mnt
> > > 
> > > sym=`for i in $(seq 0 512); do echo -n a; done`
> > > 
> > > mkfs.xfs -f -mcrc=0 -bsize=512 -dsize=25m $dev
> > > mount $dev $mnt
> > > 
> > > dd if=/dev/zero of=$mnt/spc1
> > > ~/xfstests-dev/src/punch-alternating $mnt/spc1
> > > dd if=/dev/zero of=$mnt/spc2
> > > xfs_io -c "fpunch 5m 25m" $mnt/spc2
> > > 
> > > for i in $(seq 0 2); do
> > >         ln -s $sym $mnt/link.$i
> > >         xfs_io -c fsync $mnt
> > > done
> > > 
> > > umount $mnt
> > 
> > Did one of the "fragment free space, do stuff" xfstests hit this?  If
> > not, would it be worth turning into a test?
> > 
> 
> This was just an experiment on this patch. I haven't run xfstests so I
> can't say for sure whether some existing test would have caught it
> (though I suspect Dave would have hit the problem by now, if so). I'm

Nope, a v4 512 byte block size filesystem is so far outside my
normal test config matrix it's not funny. In fact, I almost never
test on v4 filesystems anymore, and I rarely think of them when
developing new code as it's essentially a legacy format now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
