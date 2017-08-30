Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45953 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750761AbdH3WK5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 18:10:57 -0400
Date: Thu, 31 Aug 2017 00:10:56 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Message-ID: <20170830221056.GU27873@wotan.suse.de>
References: <20170829235052.21050-1-david@fromorbit.com>
 <20170830041635.GK27873@wotan.suse.de>
 <20170830054420.GI10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830054420.GI10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 03:44:20PM +1000, Dave Chinner wrote:
> On Wed, Aug 30, 2017 at 06:16:35AM +0200, Luis R. Rodriguez wrote:
> > On Wed, Aug 30, 2017 at 09:50:10AM +1000, Dave Chinner wrote:
> > > Everyone who tries to modify mkfs quickly learns that it is a pile
> > > of spaghetti, the only difference in opinion is whether it is a
> > > steaming, cold or rotten pile. This patchset attempts to untangle
> > > the ball of pasta and turn it into a set of clear, obvious
> > > operations that lead to a filesystem being formatted correctly.
> > 
> > Yay.
> > 
> > > The patch series is really in three parts, splitting the code up
> > > into roughly three modules.
> > 
> > Any reason you ended up with 3 instead of 4 as originally envisioned?
> 
> Because the 4th module - config file support - doesn't exist yet.

To be fair you had itemized before:

  1) Settings default - struct mkfs_default_params
  2) CLI parsing - struct cli_params
  3) Validation + calculation - struct mkfs_params
  4) On disk formatting

> > > The result is three modules - input parsing, validation+calculations
> > > and formatting - with well defined data flow between them.

And you instead ended up with:

  1) Input parsing - struct mkfs_default_params and I guess struct cli_params
  2) Validation + calculation - struct mkfs_params
  3) On disk formatting

Hence my question.

> Maybe you can come up with a way of automating this, but for a
> one-off piece of work that affects a point-in-time snapshot of mkfs
> functionality, I'm not sure it's worth the effort to try to make a
> generic test to do this sort of thing.

In Dave we trust!

> > > finally, one for config file support),
> > > but otherwise the majority of the factoring work is now complete.
> > > 
> > > Comments, flames, etc all welcome.
> > 
> > Just one thing, got a git tree I can use? I honestly can't be bothered
> > reviewing the delta in between, I just want to move on with life. Thanks
> > for cleaning up the manure pile buttress.
> 
> Nope, not right now. Tag all the patches, save them to an mbox
> file, run 'git-am <mbox-file>' to apply them all. Takes all of 20s
> to do with mutt....

Turns out mutt re-orders tagged messages in what I think may be the order you
got them in so the order on the input output filename may differ from the patch
order intent. Even when I manually sort them and apply them, the patches failed
on both origin/master and origin/for-next, so I must be doing something wrong
or using an incorrect branch or commit ID. What branch and commit ID should I
use?

It also seems I didn't get patch #20 in my inbox, could you resend?

On the latest origin/for-next applying your patches fails at patch #3, you need
git am -3, but then after that it fails at patch #9 even with git am -3.

  Luis
