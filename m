Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50410 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753711AbdJIDnl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Oct 2017 23:43:41 -0400
Date: Sun, 8 Oct 2017 23:43:35 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009034335.pwehn4kz3cwjy6o7@thunk.org>
References: <20171006210956.vf326sydjiphsefo@destiny>
 <20171009005137.GA3666@dastard>
 <20171009022509.rz6goq3sec5ppxrr@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009022509.rz6goq3sec5ppxrr@destiny>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Oct 08, 2017 at 10:25:10PM -0400, Josef Bacik wrote:
> 
> Probably should have led with that shouldn't I have?  There's nothing keeping me
> from doing it, but I didn't want to try and shoehorn in a python thing into
> fstests.  I need python to do the sqlite and the json parsing to dump into the
> sqlite database.

What version of python are you using?  From inspection it looks like
some variant of python 3.x (you're using print as a function w/o using
"from __future import print_function") but it's not immediately
obvious from the top-level fsperf shell script what version of python
your scripts are dependant upon.

This could potentially be a bit of a portability issue across various
distributions --- RHEL doesn't ship with Python 3.x at all, and on
Debian you need to use python3 to get python 3.x, since
/usr/bin/python still points at Python 2.7 by default.  So I could see
this as a potential issue for xfstests.

I'm currently using Python 2.7 in my wrapper scripts for, among other
things, to parse xUnit XML format and create nice summaries like this:

ext4/4k: 337 tests, 6 failures, 21 skipped, 3814 seconds
  Failures: generic/232 generic/233 generic/361 generic/388
    generic/451 generic/459

So I'm not opposed to python, but I will note that if you are using
modules from the Python Package Index, and they are modules which are
not packaged by your distribution (so you're using pip or easy_install
to pull them off the network), it does make doing hermetic builds from
trusted sources to be a bit trickier.

If you have a secops team who wants to know the provenance of software
which get thrown in production data centers (and automated downloading
from random external sources w/o any code review makes them break out
in hives), use of PyPI adds a new wrinkle.  It's not impossible to
solve, by any means, but it's something to consider.

       	      	       		    - Ted
