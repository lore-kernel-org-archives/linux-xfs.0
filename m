Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52408 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754377AbdIFNTi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 09:19:38 -0400
Date: Wed, 6 Sep 2017 15:19:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170906131937.GA27974@lst.de>
References: <1504280365-25354-1-git-send-email-amir73il@gmail.com> <20170902131955.GB36492@bfoster.bfoster> <CAOQ4uxhLTtMV9FSr4um-dYefmpZ0NJseBiQzykxjy15kLqLsww@mail.gmail.com> <20170905144006.GA48515@bfoster.bfoster> <CAOQ4uxjigcrH0FQVjB0nD-B4wHf5o0qax8+1_3xhi6UAqMRq=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjigcrH0FQVjB0nD-B4wHf5o0qax8+1_3xhi6UAqMRq=w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, linux-block <linux-block@vger.kernel.org>

> You could also say that flush sequence counting code doesn't belong
> to xfs code at all. There is nothing xfs specific about it.
> 
> If we had an API:
> 
> flush_seq = blkdev_get_flush_seq(bdev, flush_seq);
> blkdev_issue_flush_after(bdev, flush_seq);
> 
> I am sure it would have been useful to more fs.
> 
> In fact, block drivers that use blk_insert_flush(),
> already have serialized flush requests, so implementing
> the above functionality would be quite trivial for those.
> 
> I am not fluent enough in block layer to say if this makes sense.
> Christoph? Should we add some block people to this discussion?

Not that the interface can't be based on blkdev_issue_flush as
our most important flushes are submitted asynchronously.

But except for that tying into the flush state machine sounds
very interesting.  Let me look into that as the designate
xfs <-> block layer liaison.
