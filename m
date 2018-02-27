Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52551 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751117AbeB0SLq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Feb 2018 13:11:46 -0500
Date: Tue, 27 Feb 2018 18:11:42 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC] mkfs config file bikeshed now!
Message-ID: <20180227181142.GT14069@wotan.suse.de>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 10:17:57PM -0500, Theodore Ts'o wrote:
> So number one, unlike everyone else, I didn't reinvent the wheel.  I
> grabbed the same wheel I wrote for MIT Kerberos years before.  :-)

Yes thank you for not re-inventing the wheel.

> But hey, to be clear, I'm not the one trying to claim everyone should
> use my library (even though it's the best looking and above-average,
> ala Lake Wobegon. :-)

I started out with libconfig. Clearly that's crap. As I waited for the facelift
of mkfs/xfs_mkfs.c I found libini_config and was supportive of it as the best
in the community given community traction and good code. As I poked further and
extracted e2fsprogs profile library into its own repo and sized it up against
libini_config, I'll let it be on me to say:

I think its *very* sensible for us to consider using it *provided* we're up to
co-maintain a future small shared library in the hopes others will stop also
re-inventing the wheel further.

Unless I hear otherwise I'll give e2fsprogs profile library a shot for my
next iteration under the assumption we can share the library long term.

  Luis
