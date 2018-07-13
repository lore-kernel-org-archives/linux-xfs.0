Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:41514 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731342AbeGMVG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 17:06:59 -0400
Date: Fri, 13 Jul 2018 13:50:38 -0700
From: "Luis R. Chamberlain" <mcgrof@kernel.org>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Message-ID: <20180713205038.GB3620@garbanzo.do-not-panic.com>
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
 <20180713164420.GA3620@garbanzo.do-not-panic.com>
 <e4485816-9c42-c798-0a80-ece79948ae0c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4485816-9c42-c798-0a80-ece79948ae0c@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: "Luis R. Chamberlain" <mcgrof@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>

On Fri, Jul 13, 2018 at 04:40:39PM -0400, Jeff Mahoney wrote:
> On 7/13/18 12:44 PM, Luis R. Chamberlain wrote:
> > On Fri, Jul 13, 2018 at 11:39:55AM +0300, Amir Goldstein wrote:
> >> On Fri, Jul 13, 2018 at 5:43 AM, Luis R. Chamberlain <mcgrof@kernel.org> wrote:
> >>> I had volunteered at the last LSF/MM to help with the stable work for
> >>> XFS. To help with this, as part of this year's SUSE Hackweek, I've
> >>> first generalized my own set of scripts to help track a baseline of
> >>> results from fstests [0], and extended it to be able to easily ramp up
> >>> with fstests on different distributions, and I've also created a
> >>> respective baseline of results against these distributions as a
> >>> further example of how these scripts and wrapper framework can be used
> >>
> >> Hi Luis!
> >>
> >> Thanks a lot for doing this work!
> >>
> >> Will take me some time to try it out, but see some questions below...
> >>
> >>> [1]. The distributions currently supported are:
> >>>
> >>>   * Debian testing
> >>>   * OpenSUSE Leap 15.0
> >>>   * Fedora 28
> >>>
> >>> The stable work starts with creating a baseline for v4.17.3. The
> >>> results are visible as a result of expunge files which categorize the
> >>> failures for the different sections tested.
> >>
> >> So the only "bad" indication is a test failure?
> > 
> > That is correct to a certain degree, ie, if xfsprogs / the kernel
> > config could run it we can assume it passed.
> > 
> >> How about indication about a test that started to pass since baseline?
> > 
> > Indeed, that is desirable.
> > 
> > We have a few options. One is share the entire results directory for
> > a release / section, however this is rather big. For instance for a
> > full v4.17.3 run this is about 292 MiB alone. I don't think this
> > scales. IMHO lgogs should only be supplied onto bug reports, not this
> > framework.
> > 
> > The other option is to use -R xunit to generate the report in the
> > specified unit. I have not yet run this, or tried it, however IIRC
> > it does record success runs? Does it also keep logs? Hopefully not.  I'm
> > assuming it does not as of yet. I should note if one hits CTRL-C in the
> > middle one does not get the results. An alternative was being worked on
> > by Jeff which would sprinkle IIRC .ok files for tests which succeed,
> > then you could just scrape the results directory to determine which
> > tests did pass -- but you run into the same size problem as above.
> 
> Eryu didn't like that idea, so I abandoned it.  What I have now is a -R
> files mode that creates a bunch of files with the goal of just archiving
> the results for later comparison or import into a results db.
> 
> For each test, there are:
> $seq.result.start.txt - start timestamp
> $seq.result.stop.txt - stop timestamp
> $seq.result.result.txt - simple result: pass/fail/expunged/notrun
> $seq.result.detail.txt - contains the contents of $seq.notrun/$seq.expunged
> $seq.result.{dmesg,kmemleak,full,check}.txt - contains the contents of
> the corresponding files

This is sexy, it also gives the person interpretting the results to
opt-in or not for the actuall full log of the output. You pick and
choose what info you want.

This is indeed nice.

> As an aside, IIRC, -R xunit doesn't catch all kinds of failures.  Also,
> as you mentioned, if it's interrupted, all results are lost.  This makes
> it difficult to identify test failures that crashed or hung the test system.

OK so indeed not my preference.

> I have some basic scripts that parse the output and generate an HTML
> report/table (and it does do what Amir asks WRT tests that started passing).

These scripts, are they for parsing your new -R files output?

I take it the patches are still being worked on?

  Luis
