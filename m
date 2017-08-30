Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38400 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750851AbdH3EQh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 00:16:37 -0400
Date: Wed, 30 Aug 2017 06:16:35 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Message-ID: <20170830041635.GK27873@wotan.suse.de>
References: <20170829235052.21050-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 09:50:10AM +1000, Dave Chinner wrote:
> Everyone who tries to modify mkfs quickly learns that it is a pile
> of spaghetti, the only difference in opinion is whether it is a
> steaming, cold or rotten pile. This patchset attempts to untangle
> the ball of pasta and turn it into a set of clear, obvious
> operations that lead to a filesystem being formatted correctly.

Yay.

> The patch series is really in three parts, splitting the code up
> into roughly three modules.

Any reason you ended up with 3 instead of 4 as originally envisioned?

> The first part introduces a mkfs
> parameters structure and factors the on-disk formatting code to use
> only information in that structure.

Is there no validation on defaults prior to moving on to a next step?
I ask as config changes will modify defaults.

> The second part introduces a
> command line input structure and factors the input parsing to use
> it. This requires a bunch of temporary code to keep the rest of
> the code working. The third part is factoring the input validation
> and geometry calculation code to use the input structure and put
> the output into the mkfs parameter structure and to remove all the
> temporary support code.
> 
> The result is three modules - input parsing, validation+calculations
> and formatting - with well defined data flow between them. This also
> paves the way to supporting config files to set defaults via a
> separate (new) module. The overall data flow now looks like this:
> 
> Build defaults --\
>                   ---> mkfs_default_params -> CLI -> mkfs_params
> config file -----/
> 
> It is not worth spending a lot of time reviewing the temporary code
> that is added - it gets removed before the end of the series. No
> attempt has been made to ensure that mkfs works 100% correctly after
> each patch is applied - the only guarantee is that it will build
> cleanly. It /should/ work if a bisect lands in the middle of the
> series, but trying to exhaustively test each patch is OK would take
> more effort than it is worth. As such, testing has only been
> performed on the whole series.

Amen.

However this still begs the question of what tests we should run
prior and after the full set, and if we had any missing test what
we should add, or if we've considered that.

> The new output from mkfs to indicate where it has sourced the
> defaults from causes xfstests to have conniptions. This requires
> some updates to the mkfs output filters that are already in place
> but it is a fairly trivial update. Test xfs/191 has a couple of new
> failures, but that is because the new code now correctly parses
> things like agsize so that block and sector size based
> specifications work with default mkfs values. This will require test
> updates.
> 
> Future work will be to split the xfs_mkfs.c file into a file per
> module (i.e. seperate files for CLI parsing, mkfs formating,
> validation+calculation and, 

Great! I was hoping for this!

> finally, one for config file support),
> but otherwise the majority of the factoring work is now complete.
> 
> Comments, flames, etc all welcome.

Just one thing, got a git tree I can use? I honestly can't be bothered
reviewing the delta in between, I just want to move on with life. Thanks
for cleaning up the manure pile buttress.

  Luis
