Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:50888 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750965AbeC0VRb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 17:17:31 -0400
Date: Wed, 28 Mar 2018 08:17:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
Message-ID: <20180327211728.GP18129@dastard>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <896a0202-aac8-e43f-7ea6-3718591e32aa@sandeen.net>
 <20180324162049.GP4818@magnolia>
 <20180326124649.GD34912@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326124649.GD34912@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 26, 2018 at 08:46:49AM -0400, Brian Foster wrote:
> On Sat, Mar 24, 2018 at 09:20:49AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 07, 2018 at 05:33:48PM -0600, Eric Sandeen wrote:
> > > Now that unlinked inode recovery is done outside of
> > > log recovery, there is no need to dirty the log on
> > > snapshots just to handle unlinked inodes.  This means
> > > that readonly snapshots can be mounted without requiring
> > > -o ro,norecovery to avoid the log replay that can't happen
> > > on a readonly block device.
> > > 
> > > (unlinked inodes will just hang out in the agi buckets until
> > > the next writable mount)
> > 
> > FWIW I put these two in a test kernel to see what would happen and
> > generic/311 failures popped up.  It looked like the _check_scratch_fs
> > found incorrect block counts on the snapshot(?)
> > 
> 
> Interesting. Just a wild guess, but perhaps it has something to do with
> lazy sb accounting..? I see we call xfs_initialize_perag_data() when
> mounting an unclean fs.

The freeze is calls xfs_log_sbcount() which should update the
superblock counters from the in-memory counters and write them to
disk.

If they are out, I'm guessing it's because the in-memory per-ag
reservations are not being returned to the global pool before the
in-memory counters are summed during a freeze....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
