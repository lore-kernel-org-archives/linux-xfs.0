Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:64024 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750756AbdH3FsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 01:48:10 -0400
Date: Wed, 30 Aug 2017 15:44:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Message-ID: <20170830054420.GI10621@dastard>
References: <20170829235052.21050-1-david@fromorbit.com>
 <20170830041635.GK27873@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830041635.GK27873@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 06:16:35AM +0200, Luis R. Rodriguez wrote:
> On Wed, Aug 30, 2017 at 09:50:10AM +1000, Dave Chinner wrote:
> > Everyone who tries to modify mkfs quickly learns that it is a pile
> > of spaghetti, the only difference in opinion is whether it is a
> > steaming, cold or rotten pile. This patchset attempts to untangle
> > the ball of pasta and turn it into a set of clear, obvious
> > operations that lead to a filesystem being formatted correctly.
> 
> Yay.
> 
> > The patch series is really in three parts, splitting the code up
> > into roughly three modules.
> 
> Any reason you ended up with 3 instead of 4 as originally envisioned?

Because the 4th module - config file support - doesn't exist yet.
This patchset only supplies the hook point for that module to be
interface with the existing code.

> > The first part introduces a mkfs
> > parameters structure and factors the on-disk formatting code to use
> > only information in that structure.
> 
> Is there no validation on defaults prior to moving on to a next step?
> I ask as config changes will modify defaults.

Never has been - it's been assumed that the built in defaults are
sane and valid because they've been set by the XFS developers. This
patchset is not changing functionality, defaults, or how defaults
are used, anything config files might require is outside the scope
of this work.

> > The second part introduces a
> > command line input structure and factors the input parsing to use
> > it. This requires a bunch of temporary code to keep the rest of
> > the code working. The third part is factoring the input validation
> > and geometry calculation code to use the input structure and put
> > the output into the mkfs parameter structure and to remove all the
> > temporary support code.
> > 
> > The result is three modules - input parsing, validation+calculations
> > and formatting - with well defined data flow between them. This also
> > paves the way to supporting config files to set defaults via a
> > separate (new) module. The overall data flow now looks like this:
> > 
> > Build defaults --\
> >                   ---> mkfs_default_params -> CLI -> mkfs_params
> > config file -----/
> > 
> > It is not worth spending a lot of time reviewing the temporary code
> > that is added - it gets removed before the end of the series. No
> > attempt has been made to ensure that mkfs works 100% correctly after
> > each patch is applied - the only guarantee is that it will build
> > cleanly. It /should/ work if a bisect lands in the middle of the
> > series, but trying to exhaustively test each patch is OK would take
> > more effort than it is worth. As such, testing has only been
> > performed on the whole series.
> 
> Amen.
> 
> However this still begs the question of what tests we should run
> prior and after the full set, and if we had any missing test what
> we should add, or if we've considered that.

We have nothing that actually tests that the on-disk filesystem
format values match what is specified on the command line, so
testing/validation has all been completely manual. I'm not sure we
can automate it, given the math needed to check that all the fields
in the superblock are correct and sane for arbitrary mkfs
configurations on arbitrary block devices.

In the end I basically ran some configs with an old mkfs, dumped the
superblock with xfs_db for each config, then did the same with the
new mkfs. I then diffed the output to see if anything came out
differently. I fixed all the things I found that were different.  I
ran the checks on 4k and 512 byte sector devices, just to make sure
nothing went wrong with using probed device sector sizes by default.
Then I diffed logprint output for different log options (e.g. sector
size, lsunit, etc) to make sure everything was correct, etc. I
mounted each filesystem, ran repair on them, etc so that both the
kernel and repair code could validate the format, too (the kernel
found the first log formatting bug via CRC errors).  And, of course,
I ran xfstests over a variety of configs - different block sizes,
rmap, DAX, etc.

Maybe you can come up with a way of automating this, but for a
one-off piece of work that affects a point-in-time snapshot of mkfs
functionality, I'm not sure it's worth the effort to try to make a
generic test to do this sort of thing.

> > finally, one for config file support),
> > but otherwise the majority of the factoring work is now complete.
> > 
> > Comments, flames, etc all welcome.
> 
> Just one thing, got a git tree I can use? I honestly can't be bothered
> reviewing the delta in between, I just want to move on with life. Thanks
> for cleaning up the manure pile buttress.

Nope, not right now. Tag all the patches, save them to an mbox
file, run 'git-am <mbox-file>' to apply them all. Takes all of 20s
to do with mutt....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
