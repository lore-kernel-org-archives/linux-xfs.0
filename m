Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729291AbfB0UpZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 15:45:25 -0500
Date: Wed, 27 Feb 2019 15:45:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
Message-ID: <20190227204521.GB50261@bfoster>
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190227131838.GA49593@bfoster>
 <20190227141732.GA49946@bfoster>
 <20190227155419.qmjzfbviolg6cwht@MacBook-Pro-91.local>
 <20190227171337.GA50261@bfoster>
 <CAOQ4uxgZruCPAgk0-GP8=Ngecn=Yjv+6KKLmkUuDjh+QDqTWUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgZruCPAgk0-GP8=Ngecn=Yjv+6KKLmkUuDjh+QDqTWUg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>

On Wed, Feb 27, 2019 at 08:46:42PM +0200, Amir Goldstein wrote:
> > > > FYI, I gave this a try and it didn't ultimately work because mkfs didn't
> > > > clear the device either. I ended up reproducing the problem, physically
> > > > zeroing the device, replaying the associated FUA and observing the
> > > > problem go away. From there, if I replay to the final FUA mark and go
> > > > back to the (originally) problematic FUA, the problem is reintroduced.
> > > >
> > >
> > > Sorry guys, whenever I run log-writes on xfs I use my helper script here
> > >
> > > https://github.com/josefbacik/log-writes
> > >
> > > specifically replay-individual-faster.sh.  This creates a snapshot at every
> > > replay point, mounts and checks the fs, and then destroys the snapshot and keeps
> > > going.  This way you don't end up with the "new" data still being on the device.
> > > It's not super fast, but this is usually a fire and forget sort of thing.  I
> > > could probably integrate this into xfstests for our log-writes tests, those tend
> > > to not generate large logs so wouldn't take super long.  Does this fix the
> > > problem for you Brian?
> > >
> >
> > Thanks Josef. At a glance at that script I'm not quite following how
> > this fits together. Are you taking a snapshot of the original device
> > before the workload being tested is run against dm-log-writes, then
> > replaying on top of that? In general, anything that puts the device back
> > into the state from before the workload ran and replays from there
> > should be enough to fix the problem I think. As long as a replay
> > sequence runs in order, I don't think snapshots of each replay point
> > should technically be necessary (vs a single replay snapshot, for e.g.).
> >
> > Note that I ended up testing generic/482 with a loop device for a
> > scratch device and that also worked around the problem, I suspect
> > because that allowed the aforementioned discards to actually reset the
> > underlying the device via loop discard->hole punch (which doesn't occur
> > with my original, non-loop scratch dev). So it seems that another option
> 
> Urrgh! take a look at src/log-writes/log-writes.c:log_discard()->zero_range().
> I remembered correctly the replay log falls back to zeroing device with no
> discard support, but wasn't aware that it drops large discard requests
> (> 128MB), so there we have it.
> 

Heh, Ok.

> > for more deterministic behavior in fstests could be to just enforce the
> > use of a loop device as the underlying target in these particular tests.
> > For example, have the log-writes init create a file on the test device
> > and loop mount that rather than using the scratch device. Just a thought
> > though, it's not clear to me that's any more simple than what you have
> > already implemented here..
> >
> 
> Seems like a pretty good idea to me, but in doing that we may loose
> diversity in the tested block devices. On different test machines mkfs
> and later fsstress ops will result in slightly different io patterns.
> Since generic/482 is not a deterministic test (random fsstress seed)
> than we cannot argue that reproducible results are better than
> deterministic results.
> 
> Another option is to relax the  log->max_zero_size limit of
> log_discard() and allow it to zero out devices that don't support
> discard, but that is likely going to cost much more runtime.
> Note that this simple patch could also work for you:
> 
> --- a/src/log-writes/log-writes.c
> +++ b/src/log-writes/log-writes.c
> @@ -95,7 +95,7 @@ int log_discard(struct log *log, struct
> log_write_entry *entry)
>  {
>         u64 start = le64_to_cpu(entry->sector) * log->sectorsize;
>         u64 size = le64_to_cpu(entry->nr_sectors) * log->sectorsize;
> -       u64 max_chunk = 1 * 1024 * 1024 * 1024;
> +       u64 max_chunk = log->max_zero_size;
> 
> ---
> 
> Brian,
> 
> Can you try this patch on you test machine and say how much
> worse the runtime is compared to the loop device setup?
> 
> In general, I am in favor of the simplest possible fix
> and in keeping runtime shortest, so if the above fix
> results in longer runtime, I would prefer to make the test always
> run on loopdev as you suggested.
> 

Note that this is a low resource VM with a spinning disk. The scratch
device is a 15G LVM volume. My last run of generic/482 was 139s (which I
think was using loop for a scratch device). With this change and back to
using the LVM volume, I ended up stopping it because I started seeing a
~160s or so delay between XFS mount cycles in the syslog (i.e., per
replay iteration). ;P

Brian

> Thanks,
> Amir.
