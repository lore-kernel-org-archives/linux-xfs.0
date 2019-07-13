Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfGMEHp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jul 2019 00:07:45 -0400
Date: Fri, 12 Jul 2019 21:07:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [GIT PULL] xfs: new features for 5.3
Message-ID: <20190713040728.GB5347@magnolia>
References: <20190712180205.GA5347@magnolia>
 <CAHk-=wiK8_nYEM2B8uvPELdUziFhp_+DqPN=cNSharQqpBZ6qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiK8_nYEM2B8uvPELdUziFhp_+DqPN=cNSharQqpBZ6qg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>

On Fri, Jul 12, 2019 at 05:27:15PM -0700, Linus Torvalds wrote:
> On Fri, Jul 12, 2019 at 11:02 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > The branch merges cleanly against this morning's HEAD and survived an
> > overnight run of xfstests.  The merge was completely straightforward, so
> > please let me know if you run into anything weird.
> 
> Hmm. I don't know what you merged against, but it got a (fairly
> trivial) conflict for me due to
> 
>   79d08f89bb1b ("block: fix .bi_size overflow")
> 
> from the block merge (from Tuesday) touching a line next to one changed by
> 
>   a24737359667 ("xfs: simplify xfs_chain_bio")
> 
> from this pull.
> 
> So it wasn't an entirely clean merge for me.
> 
> Was it a complex merge conflict? No. I'm just confused by the "merges
> cleanly against this morning's HEAD", which makes me wonder what you
> tried to merge against..

Doh, it turns out I was merging against the same HEAD as my last two
pull requests because I forgot to re-pull.  Sorry about that.  It's been
too long of a week. :/

--D

>             Linus
