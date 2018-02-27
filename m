Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58748 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbeB0Dp7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 22:45:59 -0500
Date: Mon, 26 Feb 2018 22:45:45 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] mkfs config file bikeshed now!
Message-ID: <20180227034545.GC24294@thunk.org>
References: <20180226224224.GE19312@magnolia>
 <20180227000122.GR14069@wotan.suse.de>
 <3e239e61-bc79-c594-c1fd-44fa3efe779d@sandeen.net>
 <CAB=NE6U+7hmRhrkkd1v=rEKrcY+NNf61jL9B4nm=kDbTPvy--w@mail.gmail.com>
 <20180227002550.GH19312@magnolia>
 <20180227031757.GB24294@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180227031757.GB24294@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

One other thing I'll mention is that it was really important to me
that it was very easy to look up values from the config file.  So for
me it was a lot more than just the parser.  So I can fetch a read a
config parameter from the config file like this:

	profile_get_boolean(ctx->profile, "options", "no_optimize_extents",
			    0, 0, &c);

That's because I use this for a lot more than just file system tuning
parametres, but also for changing how e2fsck / mke2fs behaves.  So
trying to parse all of the config file at startup time and having to
stash that in some global context structure is just lot of extra work
that isn't necessary with the profile library compared with other
libraries which are focused exclusively on the parsing aspect of
things (which is actually pretty trivial).

Maybe this doesn't matter for XFS, but other file system utilities may
find this issue to be something worthy of consideration when trying to
pick a config file library.

							- Ted
