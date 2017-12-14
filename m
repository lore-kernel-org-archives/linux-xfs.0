Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754425AbdLNRsz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Dec 2017 12:48:55 -0500
Date: Thu, 14 Dec 2017 18:48:53 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 5/9] tests/xfs/group: add group for tests which require a
 logdev
Message-ID: <20171214174853.GK16026@wotan.suse.de>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-6-mcgrof@kernel.org>
 <20171213215013.GW4094@dastard>
 <20171213230052.GJ16026@wotan.suse.de>
 <20171213233914.GD5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213233914.GD5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 14, 2017 at 10:39:14AM +1100, Dave Chinner wrote:
> You can't just run an internal log test then add couple of extra
> external log tests and say "external logs work fine".
> 
> > Automatic detection if the requirements are met is fine, but this doesn't 
> > let me easily use say:
> > 
> > 	./check -s logdev_xfs -g logdev
> 
> You can do that if we ignore the fact that a large number of tests
> need to be run on both internal and external log devices to cover
> the differences in behaviour between them.
> 
> > > And, FWIW, we already have a "log" group to indicate tests that
> > > exercise the log, and that mostly includes all the tests that use
> > > external logs. It would be better to tag all the tests that exercise
> > > the log with "log" rather than create some new group that doesn't
> > > really provide any added benefit....
> > 
> > So for my case would one better goal be to just run check without the external
> > one and one with the external log?
> 
> See above. Your test coverage assumptions are wrong, so what you are
> trying to do really doesn't tell you whether external logs work
> correctly or not. It's worse that not testing external logs at all,
> because it gives the false impression that they have been
> exhaustively tested and work just fine when that really isn't the
> case.

Makes sense, thanks.

  Luis
