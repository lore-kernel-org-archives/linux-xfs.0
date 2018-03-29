Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57907 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752548AbeC2SM0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 14:12:26 -0400
Date: Thu, 29 Mar 2018 18:12:23 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180329181223.GK30543@wotan.suse.de>
References: <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180328033228.GA18129@dastard>
 <20180328193004.GB7561@sasha-vm>
 <20180328230535.GE18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328230535.GE18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, Josef Bacik <josef@toxicpanda.com>, Tso Ted <tytso@mit.edu>

On Thu, Mar 29, 2018 at 10:05:35AM +1100, Dave Chinner wrote:
> On Wed, Mar 28, 2018 at 07:30:06PM +0000, Sasha Levin wrote:
> > 
> > This is actually something I want maintainers to dictate. What sort of
> > testing would make the XFS folks happy here? Right now I'm doing
> > "./check 'xfs/*'" with xfstests. Is it sufficient? Anything else you'd like to see?
> 
> ... and you're doing it wrong. This is precisely why being able
> to discover /exactly/ what you are testing and being able to browse
> the test results so we can find out if tests passed when a user
> reports a bug on a stable kernel.
> 
> The way you are running fstests skips more than half the test suite
> It also runs tests that are considered dangerous because they are
> likely to cause the test run to fail in some way (i.e. trigger an
> oops, hang the machine, leave a filesystem in an unmountable state,
> etc) and hence not complete a full pass.
> 
> "./check -g auto" runs the full "expected to pass" regression test
> suite for all configured test configurations. (i.e. all config
> sections listed in the configs/<host>.config file)

ie, it would be safer to expect that an algorithmic auto-selection process for
fixes for stable kernels should have direct input and involvement from
subsystems for run-time testing and simply guessing or assuming won't suffice.

The days of just compile testing should be way over by now, and we should
expect no less for stable kernels, *specially* if we start involving
automation.

Would a way to *start* to address this long term for XFS or other filesystems
for auto-selection long-term be a topic worth covering / addressing at LSF/MM?

  Luis
