Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754375AbdIFN35 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 09:29:57 -0400
Date: Wed, 6 Sep 2017 09:29:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170906132955.GA55280@bfoster.bfoster>
References: <1504280365-25354-1-git-send-email-amir73il@gmail.com>
 <20170902131955.GB36492@bfoster.bfoster>
 <CAOQ4uxhLTtMV9FSr4um-dYefmpZ0NJseBiQzykxjy15kLqLsww@mail.gmail.com>
 <20170905144006.GA48515@bfoster.bfoster>
 <CAOQ4uxjigcrH0FQVjB0nD-B4wHf5o0qax8+1_3xhi6UAqMRq=w@mail.gmail.com>
 <20170906131937.GA27974@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906131937.GA27974@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, linux-block <linux-block@vger.kernel.org>

On Wed, Sep 06, 2017 at 03:19:37PM +0200, Christoph Hellwig wrote:
> > You could also say that flush sequence counting code doesn't belong
> > to xfs code at all. There is nothing xfs specific about it.
> > 
> > If we had an API:
> > 
> > flush_seq = blkdev_get_flush_seq(bdev, flush_seq);
> > blkdev_issue_flush_after(bdev, flush_seq);
> > 
> > I am sure it would have been useful to more fs.
> > 
> > In fact, block drivers that use blk_insert_flush(),
> > already have serialized flush requests, so implementing
> > the above functionality would be quite trivial for those.
> > 
> > I am not fluent enough in block layer to say if this makes sense.
> > Christoph? Should we add some block people to this discussion?
> 
> Not that the interface can't be based on blkdev_issue_flush as
> our most important flushes are submitted asynchronously.
> 
> But except for that tying into the flush state machine sounds
> very interesting.  Let me look into that as the designate
> xfs <-> block layer liaison.

That sounds like a nice idea to me, particularly if there is potential
for other users. I'll wait to look into doing anything in XFS until we
see how this turns out. Thanks.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
