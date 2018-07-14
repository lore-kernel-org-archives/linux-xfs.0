Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40964 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729787AbeGNBJP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jul 2018 21:09:15 -0400
Date: Fri, 13 Jul 2018 20:52:07 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Message-ID: <20180714005207.GF28610@thunk.org>
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

On Fri, Jul 13, 2018 at 09:44:20AM -0700, Luis R. Chamberlain wrote:
> 
> We have a few options. One is share the entire results directory for
> a release / section, however this is rather big. For instance for a
> full v4.17.3 run this is about 292 MiB alone. I don't think this
> scales. IMHO lgogs should only be supplied onto bug reports, not this
> framework.

The results directory compress fairly well.  A complete ext4 run (with
the configurations defined for gce-xfstests) is 101MB uncompressed,
and 2.3 MB as a tar.xz file.  That's only 6 cents a month in Google
Cloud Storage, and for me it's worth it to keep them; it's
occasionally been interesting.

> The other option is to use -R xunit to generate the report in the
> specified unit. I have not yet run this, or tried it, however IIRC
> it does record success runs?

Yes, it does.

> Does it also keep logs? Hopefully not.

It does include some information, but not all of the information that
might be in the results directory.

    % ls /tmp/results-ltm-20180709000722/ab/ext4/results-1k/results.xml 
    108 /tmp/results-ltm-20180709000722/ab/ext4/results-1k/results.xml

    vs

    % du -sh /tmp/results-ltm-20180709000722/ab/ext4/results-1k
    3.0M	/tmp/results-ltm-20180709000722/ab/ext4/results-1k

> Having the expunge files separately helps as we can annotate bug URLs to
> them optionally. Ie, we should be able to process both expunge lists
> and xunit file to construct a nice db schema to process results
> in a more easily viewable manner in the future.

I do this.  You can see an example here with my annotations:

https://github.com/tytso/xfstests-bld/blob/master/kvm-xfstests/test-appliance/files/root/fs/ext4/exclude

> So to establish a baseline, one first manually contstructs the expunge
> files needed to run a full test. In the future hopefully we can have
> a set of scripts to do all this for us.

Yep, I do this by using a command-line option when I run gce-xfstests
or kvm-xfstests to skip using the exclude files.  It's definitely
useful.

> We'd have to then process that file to scrape out which tests were
> passed, if a user wanted that. Do we have scripts for processing
> xunit files?

I have some scripts which you may find useful.   They can be found here:

https://github.com/tytso/xfstests-bld/tree/master/kvm-xfstests/test-appliance/files/usr/local/bin
https://github.com/tytso/xfstests-bld/tree/master/kvm-xfstests/test-appliance/files/usr/lib/python2.7

This is what I use to parse through the xunit xml files to generate
summaries like this:

ext4/4k: 430 tests, 1 failures, 43 skipped, 6565 seconds
  Failures: generic/388 
ext4/1k: 441 tests, 7 failures, 55 skipped, 7985 seconds
  Failures: ext4/033 generic/018 generic/383 generic/388 generic/454 
    generic/475 generic/476 
ext4/encrypt: 495 tests, 121 skipped, 4081 seconds
ext4/nojournal: 472 tests, 1 failures, 88 skipped, 4700 seconds
  Failures: ext4/301 
ext4/ext3conv: 429 tests, 1 failures, 43 skipped, 5965 seconds
  Failures: generic/388 
ext4/adv: 434 tests, 2 failures, 49 skipped, 5142 seconds
  Failures: generic/399 generic/477 
ext4/dioread_nolock: 429 tests, 1 failures, 43 skipped, 5870 seconds
  Failures: generic/388 
ext4/data_journal: 476 tests, 2 failures, 91 skipped, 6832 seconds
  Failures: generic/388 generic/475 
ext4/bigalloc: 414 tests, 11 failures, 50 skipped, 6963 seconds
  Failures: ext4/033 generic/204 generic/219 generic/235 generic/273 
    generic/388 generic/456 generic/472 generic/494 generic/495 
    generic/496 
ext4/bigalloc_1k: 428 tests, 11 failures, 64 skipped, 5458 seconds
  Failures: ext4/033 generic/204 generic/235 generic/273 generic/383 
    generic/388 generic/454 generic/472 generic/494 generic/495 
    generic/496 
Totals: 3801 tests, 647 skipped, 37 failures, 0 errors, 59147s

> > Tested that started to notrun since baseline?
> 
> Its unclear if xunit captures this. Otherwise we have some work to do.

There are software packages that will process xunit XML files, store
them into a database and then generate reports against a defined
baseline.  They'll also do fancy graphs, and some of them will show
flakey tests, etc.  I haven't had time to investigate them, though,
but if you do find some cool tools to process the xunit files, I'd
definitely be interested.

Cheers,

						- Ted
