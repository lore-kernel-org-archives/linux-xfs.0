Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:29032 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754098AbdJIVJ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 17:09:26 -0400
Date: Tue, 10 Oct 2017 08:09:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009210920.GO3666@dastard>
References: <20171006210956.vf326sydjiphsefo@destiny>
 <20171009005137.GA3666@dastard>
 <20171009022509.rz6goq3sec5ppxrr@destiny>
 <20171009051731.GK3666@dastard>
 <20171009130050.ufnmdhslc53bwpgc@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009130050.ufnmdhslc53bwpgc@destiny>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 09, 2017 at 09:00:51AM -0400, Josef Bacik wrote:
> On Mon, Oct 09, 2017 at 04:17:31PM +1100, Dave Chinner wrote:
> > On Sun, Oct 08, 2017 at 10:25:10PM -0400, Josef Bacik wrote:
> > > > Integrating into fstests means it will be immediately available to
> > > > all fs developers, it'll run on everything that everyone already has
> > > > setup for filesystem testing, and it will have familiar mkfs/mount
> > > > option setup behaviour so there's no new hoops for everyone to jump
> > > > through to run it...
> > > > 
> > > 
> > > TBF I specifically made it as easy as possible because I know we all hate trying
> > > to learn new shit.
> > 
> > Yeah, it's also hard to get people to change their workflows to add
> > a whole new test harness into them. It's easy if it's just a new
> > command to an existing workflow :P
> > 
> 
> Agreed, so if you probably won't run this outside of fstests then I'll add it to
> xfstests.  I envision this tool as being run by maintainers to verify their pull
> requests haven't regressed since the last set of patches, as well as by anybody
> trying to fix performance problems.  So it's way more important to me that you,
> Ted, and all the various btrfs maintainers will run it than anybody else.
> 
> > > I figured this was different enough to warrant a separate
> > > project, especially since I'm going to add block device jobs so Jens can test
> > > block layer things.  If we all agree we'd rather see this in fstests then I'm
> > > happy to do that too.  Thanks,
> > 
> > I'm not fussed either way - it's a good discussion to have, though.
> > 
> > If I want to add tests (e.g. my time-honoured fsmark tests), where
> > should I send patches?
> > 
> 
> I beat you to that!  I wanted to avoid adding fs_mark to the suite because it
> means parsing another different set of outputs, so I added a new ioengine to fio
> for this
> 
> http://www.spinics.net/lists/fio/msg06367.html
> 
> and added a fio job to do 500k files
> 
> https://github.com/josefbacik/fsperf/blob/master/tests/500kemptyfiles.fio
> 
> The test is disabled by default for now because obviously the fio support hasn't
> landed yet.

That seems .... misguided. fio is good, but it's not a universal
solution.

> I'd _like_ to expand fio for cases we come up with that aren't possible, as
> there's already a ton of measurements that are taken, especially around
> latencies.

To be properly useful it needs to support more than just fio to run
tests. Indeed, it's largely useless to me if that's all it can do or
it's a major pain to add support for different tools like fsmark.

e.g.  my typical perf regression test that you see the concurrnet
fsmark create workload is actually a lot more. It does:

	fsmark to create 50m zero length files
	umount,
	run parallel xfs_repair (excellent mmap_sem/page fault punisher)
	mount
	run parallel find -ctime (readdir + lookup traversal)
	unmount, mount
	run parallel ls -R (readdir + dtype traversal)
	unmount, mount
	parallel rm -rf of 50m files

I have variants that use small 4k files or large files rather than
empty files, taht use different fsync patterns to stress the
log, use grep -R to traverse the data as well as
the directory/inode structure instead of find, etc.

> That said I'm not opposed to throwing new stuff in there, it just
> means we have to add stuff to parse the output and store it in the database in a
> consistent way, which seems like more of a pain than just making fio do what we
> need it to.  Thanks,

fio is not going to be able to replace the sort of perf tests I run
from week to week. If that's all it's going to do then it's not
directly useful to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
