Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:54172 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754018AbdJIMyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 08:54:18 -0400
Received: by mail-qk0-f172.google.com with SMTP id w63so23440355qkd.10
        for <linux-xfs@vger.kernel.org>; Mon, 09 Oct 2017 05:54:18 -0700 (PDT)
Date: Mon, 9 Oct 2017 08:54:16 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009125415.wrfd5rp5zlf4qsgm@destiny>
References: <20171006210956.vf326sydjiphsefo@destiny>
 <20171009005137.GA3666@dastard>
 <20171009022509.rz6goq3sec5ppxrr@destiny>
 <20171009034335.pwehn4kz3cwjy6o7@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009034335.pwehn4kz3cwjy6o7@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Josef Bacik <josef@toxicpanda.com>, Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Oct 08, 2017 at 11:43:35PM -0400, Theodore Ts'o wrote:
> On Sun, Oct 08, 2017 at 10:25:10PM -0400, Josef Bacik wrote:
> > 
> > Probably should have led with that shouldn't I have?  There's nothing keeping me
> > from doing it, but I didn't want to try and shoehorn in a python thing into
> > fstests.  I need python to do the sqlite and the json parsing to dump into the
> > sqlite database.
> 
> What version of python are you using?  From inspection it looks like
> some variant of python 3.x (you're using print as a function w/o using
> "from __future import print_function") but it's not immediately
> obvious from the top-level fsperf shell script what version of python
> your scripts are dependant upon.
> 
> This could potentially be a bit of a portability issue across various
> distributions --- RHEL doesn't ship with Python 3.x at all, and on
> Debian you need to use python3 to get python 3.x, since
> /usr/bin/python still points at Python 2.7 by default.  So I could see
> this as a potential issue for xfstests.
> 
> I'm currently using Python 2.7 in my wrapper scripts for, among other
> things, to parse xUnit XML format and create nice summaries like this:
> 
> ext4/4k: 337 tests, 6 failures, 21 skipped, 3814 seconds
>   Failures: generic/232 generic/233 generic/361 generic/388
>     generic/451 generic/459
> 
> So I'm not opposed to python, but I will note that if you are using
> modules from the Python Package Index, and they are modules which are
> not packaged by your distribution (so you're using pip or easy_install
> to pull them off the network), it does make doing hermetic builds from
> trusted sources to be a bit trickier.
> 
> If you have a secops team who wants to know the provenance of software
> which get thrown in production data centers (and automated downloading
> from random external sources w/o any code review makes them break out
> in hives), use of PyPI adds a new wrinkle.  It's not impossible to
> solve, by any means, but it's something to consider.
>

I purposefully used as little as possible, just json and sqlite, and I tried to
use as little python3 isms as possible.  Any rpm based systems should have these
libraries already installed, I agree that using any of the PyPI stuff is a pain
and is a non-starter for me as I want to make it as easy as possible to get
running.

Where do you fall on the including it in xfstests question?  I expect that the
perf stuff would be run more as maintainers put their pull requests together to
make sure things haven't regressed.  To that end I was going to wire up
xfstests-bld to run this as well.  Whatever you and Dave prefer is what I'll do,
I'll use it wherever it ends up so you two are the ones that get to decide.
Thanks,

Josef
