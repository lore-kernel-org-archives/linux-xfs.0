Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53188 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754649AbdJIPOy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 11:14:54 -0400
Date: Mon, 9 Oct 2017 11:14:49 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009151449.u2j57ifaoqke3hx2@thunk.org>
References: <20171006210956.vf326sydjiphsefo@destiny>
 <20171009005137.GA3666@dastard>
 <20171009022509.rz6goq3sec5ppxrr@destiny>
 <20171009034335.pwehn4kz3cwjy6o7@thunk.org>
 <20171009125415.wrfd5rp5zlf4qsgm@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009125415.wrfd5rp5zlf4qsgm@destiny>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 09, 2017 at 08:54:16AM -0400, Josef Bacik wrote:
> I purposefully used as little as possible, just json and sqlite, and I tried to
> use as little python3 isms as possible.  Any rpm based systems should have these
> libraries already installed, I agree that using any of the PyPI stuff is a pain
> and is a non-starter for me as I want to make it as easy as possible to get
> running.
> 
> Where do you fall on the including it in xfstests question?  I expect that the
> perf stuff would be run more as maintainers put their pull requests together to
> make sure things haven't regressed.  To that end I was going to wire up
> xfstests-bld to run this as well.  Whatever you and Dave prefer is what I'll do,
> I'll use it wherever it ends up so you two are the ones that get to decide.

I'm currently using Python 2.7 mainly because the LTM subsystem in
gce-xfstests was implemented using that version of Python, and my
initial efforts to port it to Python 3 were... not smooth.  (Because
it was doing authentication, I got bit by the Python 2 vs Python 3
"bytes vs. strings vs. unicode" transition especially hard.)

So I'm going to be annoyed by needing to package Python 2.7 and Python
3.5 in my test VM's, but I can deal, and this will probably be the
forcing function for me to figure out how make that jump.  To be
honest, the bigger issue I'm going to have to figure out is how to
manage the state in the sqlite database across disposable VM's running
in parallel.  And the assumption being made with having a static
sqllite database on a test machine is that the hardware capabilities
of the are static, and that's not true with a VM, whether it's running
via Qemu or in some cloud environment.

I'm not going to care that much about Python 3 not being available on
enterprise distro's, but I could see that being annoying for some
folks.  I'll let them worry about that.

The main thing I think we'll need to worry about once we let Python
into xfstests is to be pretty careful about specifying what version of
Python the scripts need to be portable against (Python 3.3?  3.4?
3.5?) and what versions of python packages get imported.

The bottom line is that I'm personally supportive of adding Python and
fsperf to xfstests.  We just need to be careful about the portability
concerns, not just now, but any time we check in new Python code.  And
having some documented Python style guidelines, and adding unit tests
so we can notice potential portability breakages would be a good idea.

	      	   	    	     - Ted
