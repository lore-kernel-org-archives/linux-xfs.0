Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f51.google.com ([209.85.160.51]:34804 "EHLO
        mail-pl0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbeGMSCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 14:02:01 -0400
Date: Fri, 13 Jul 2018 10:46:20 -0700
From: "Luis R. Chamberlain" <mcgrof@kernel.org>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Message-ID: <20180713174620.GA12723@garbanzo.do-not-panic.com>
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
 <20180713164420.GA3620@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713164420.GA3620@garbanzo.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Chamberlain" <mcgrof@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Jeff Mahoney <jeffm@suse.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>

The other thing I forgot to mention is annotations for failure rates.

For now I'll just indicate it as a ratio ratio as as part of the ending
comment for an expunge entry. For instance I just ran into a failure
with a set of stable patches for generic/475, however after re-running
the test it succeeded. So the test does not fail always. I'd like to
annotate this.

I now have to go and re-test with the oscheck/naggy-check.sh a few
times as follows:

./naggy-check.sh -s xfs_nocrc_512 -f generic/475

This will run the test in a loop until it fails, and I can use this
as an initial failure rate hint to the tester. If I wanted to get
more accurate I could use an average of few runs with naggy-check.sh.

In practice I typically am only sure a test succeeds if it passes at
least 1000 times (one can use -c 1000 on naggy-check.sh).

I will also then have to go back to the stable kernel without patches
and verify at least one failure was visible before. This will confirm
this is indeed not a regression. Likewise I'll have to test this also
with the other sections and see if this is also observed there.

  Luis
