Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:39188 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752555AbeC2SRP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Mar 2018 14:17:15 -0400
Received: by mail-qk0-f179.google.com with SMTP id j73so6907735qke.6
        for <linux-xfs@vger.kernel.org>; Thu, 29 Mar 2018 11:17:15 -0700 (PDT)
Date: Thu, 29 Mar 2018 14:17:13 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180329181712.ijbruc7rl2i3nh35@destiny>
References: <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180328033228.GA18129@dastard>
 <20180328193004.GB7561@sasha-vm>
 <20180328230535.GE18129@dastard>
 <20180329181223.GK30543@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180329181223.GK30543@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, Josef Bacik <josef@toxicpanda.com>, Tso Ted <tytso@mit.edu>

On Thu, Mar 29, 2018 at 06:12:23PM +0000, Luis R. Rodriguez wrote:
> On Thu, Mar 29, 2018 at 10:05:35AM +1100, Dave Chinner wrote:
> > On Wed, Mar 28, 2018 at 07:30:06PM +0000, Sasha Levin wrote:
> > > 
> > > This is actually something I want maintainers to dictate. What sort of
> > > testing would make the XFS folks happy here? Right now I'm doing
> > > "./check 'xfs/*'" with xfstests. Is it sufficient? Anything else you'd like to see?
> > 
> > ... and you're doing it wrong. This is precisely why being able
> > to discover /exactly/ what you are testing and being able to browse
> > the test results so we can find out if tests passed when a user
> > reports a bug on a stable kernel.
> > 
> > The way you are running fstests skips more than half the test suite
> > It also runs tests that are considered dangerous because they are
> > likely to cause the test run to fail in some way (i.e. trigger an
> > oops, hang the machine, leave a filesystem in an unmountable state,
> > etc) and hence not complete a full pass.
> > 
> > "./check -g auto" runs the full "expected to pass" regression test
> > suite for all configured test configurations. (i.e. all config
> > sections listed in the configs/<host>.config file)
> 
> ie, it would be safer to expect that an algorithmic auto-selection process for
> fixes for stable kernels should have direct input and involvement from
> subsystems for run-time testing and simply guessing or assuming won't suffice.
> 
> The days of just compile testing should be way over by now, and we should
> expect no less for stable kernels, *specially* if we start involving
> automation.
> 
> Would a way to *start* to address this long term for XFS or other filesystems
> for auto-selection long-term be a topic worth covering / addressing at LSF/MM?
> 

It would be cool to tie tests to commit numbers for things where we're making
sure a oops/hang doesn't happen again, but honestly I'm not sure it's worth the
effort.  Maybe this is my upstream bias showing, but I only ever run xfstests
against something relatively close to linus, so I'm not super worried about
./check -g auto eating my box.  I expect that if I run auto that everything
minus the few flakey tests are going to pass.

Also TIL about configs/<host>.config, that's pretty fucking cool.  Thanks,

Josef
