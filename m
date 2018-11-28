Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbeK1SPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 13:15:53 -0500
Date: Tue, 27 Nov 2018 23:15:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH v1 0/7] Block/XFS: Support alternative mirror device
 retry
Message-ID: <20181128071510.GG8125@magnolia>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <20181128053303.GL6311@dastard>
 <20181128054923.GF8125@magnolia>
 <20181128063046.GO6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128063046.GO6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Wed, Nov 28, 2018 at 05:30:46PM +1100, Dave Chinner wrote:
> On Tue, Nov 27, 2018 at 09:49:23PM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 28, 2018 at 04:33:03PM +1100, Dave Chinner wrote:
> > > On Tue, Nov 27, 2018 at 08:49:44PM -0700, Allison Henderson wrote:
> > > > Motivation:
> > > > When fs data/metadata checksum mismatch, lower block devices may have other
> > > > correct copies. e.g. If XFS successfully reads a metadata buffer off a raid1 but
> > > > decides that the metadata is garbage, today it will shut down the entire
> > > > filesystem without trying any of the other mirrors.  This is a severe
> > > > loss of service, and we propose these patches to have XFS try harder to
> > > > avoid failure.
> > > > 
> > > > This patch prototype this mirror retry idea by:
> > > > * Adding @nr_mirrors to struct request_queue which is similar as
> > > >   blk_queue_nonrot(), filesystem can grab device request queue and check max
> > > >   mirrors this block device has.
> > > >   Helper functions were also added to get/set the nr_mirrors.
> > > > 
> > > > * Expanding bi_write_hint to bi_rw_hint, now @bi_rw_hint has three meanings.
> > > >  1.Original write_hint.
> > > >  2.end_io() will update @bi_rw_hint to reflect which mirror this i/o really happened.
> > > >  3.Fs set @bi_rw_hint to force driver e.g raid1 read from a specific mirror.
> > > > 
> > > > * Modify md/raid1 to support this retry feature.
> > > > 
> > > > * Add b_rw_hint to xfs_buf
> > > >   This patch adds a new field b_rw_hint to xfs_buf.  We will use this to set the
> > > >   new bio->bi_rw_hint when submitting the read request, and also to store the
> > > >   returned mirror when the read compleates
> > > 
> > > One thing that is going to make this more complex at the XFS layer
> > > is discontiguous buffers. They require multiple IOs (and therefore
> > > bios) and so we are going to need to ensure that all the bios use
> > > the same bi_rw_hint.
> > 
> > Hmm, we hadn't thought about that.  What happens if we have a
> > discontiguous buffer mapped to multiple blocks, and there's only one
> > good copy of each block on separate disks in the whole array?
> > 
> > e.g. we have 8k directory blocks on a 4k block filesystem, only disk 0
> > has a good copy of block 0 and only disk 1 has a good copy of block 1?
> 
> Then the user has a disaster on their hands because they have
> multiple failing disks. 

Or lives in the crazy modern age, where we have rapidly autodegrading
flash storage and hard disks whose heads pop off with no warning. :D

(But seriously, ugh.)

> > I think we're just stuck with failing the whole thing because we can't
> > check the halves of the 8k block independently and there's too much of a
> > combinatoric explosion potential to try to mix and match.
> 
> Yup, user needs to fix their storage before the filesystem can
> attempt recovery.
> 
> > > > We're not planning to take over all 16 bits of the read hint field; just looking for
> > > > feedback about the sanity of the overall approach.
> > > 
> > > It seems conceptually simple enough - the biggest questions I have
> > > are:
> > > 
> > > 	- how does propagation through stacked layers work?
> > 
> > Right now it doesn't, though once we work out how to make stacking work
> > through device mapper (my guess is that simple dm targets like linear
> > and crypt can set the mirror count to min(all underlying devices).
> > 
> > > 	- is it generic/abstract enough to be able to work with
> > > 	  RAID5/6 to trigger verification/recovery from the parity
> > > 	  information in the stripe?
> > 
> > In theory we could supply a raid5 implementation, wherein rw_hint == 0
> > lets the raid do as it pleases; rw_hint == 1 reads from the stripe; and
> > rw_hint == 2 forces stripe recovery for the given block.
> 
> So more magic numbers to define complex behaviours? :P

Yes!!!

I mean... you /could/ allow devices more expansive reporting of their
redundancy capabilities so that xfs could look at its read-retry-time
budget and try mirrors in decreasing order of likelihood of a good
response:

struct blkdev_redundancy_level {
	unsigned		latency;		/* ms */
	unsigned		chance_of_success;	/* 0 to 100 */
} redundancy_levels[blk_queue_get_mirrors()] = {
	{ 10,	    90 }, /* tries another mirror */
	{ 300,      85 }, /* erasure decoding */
	{ 7000,	    30 }, /* long slow disk scraping via SCT ERC */
	{ 1000000,   5 }, /* boils the oceans looking for data */
};

So at least the indices wouldn't be *completely* magic.  But now we have
the question of how do you populate this table?  And how many callers
are going to do something smarter than the dumb loop that it's worth the
extra code?

(Anyone?  Now would be a great time to pipe up.)

> > A trickier scenario that I have no idea how to solve is the question of
> > how to handle dynamic redundancy levels.  We don't have a standard bio
> > error value that means "this mirror is temporarily offline", so if you
> 
> We can get ETIMEDOUT, ENOLINK, EBUSY and EAGAIN from the block layer
> which all indicate temporary errors (see blk_errors[]). Whether the
> specific storage layers are actually using them is another matter...

<nod>

> > have a raid1 of two disks and disk 0 goes offline, the retry loop in xfs
> > will hit the EIO and abort without even asking disk 1.  It's also
> > unclear if we need to designate a second bio error value to mean "this
> > mirror is permanently gone".
> 
> If we have a mirror based retries, we should probably consider EIO
> as "try next mirror", not as a hard failure.

Yeah.

> > [Also insert handwaving about whether or not online fsck will want to
> > control retries and automatic rewrite; I suspect the answer is that it
> > doesn't care.]
> 
> Don't care - have the storage fix itself, then check what comes
> back and fix it from there.

<nod> Admittedly, the auto retry and rewrite are dependent solely on the
lack of EIO and the verifiers giving their blessing, and for the most
part online fsck doesn't go digging through buffers that don't pass the
verifiers, so it'll likely never see any of this anyway.

> > [[Also insert severe handwaving about do we expose this to userspace so
> > that xfs_repair can use it?]]
> 
> I suspect the answer there is through the AIO interfaces....

Y{ay,uck}...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
