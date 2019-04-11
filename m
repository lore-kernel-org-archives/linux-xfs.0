Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48983 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbfDKBbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 21:31:15 -0400
Date: Thu, 11 Apr 2019 11:11:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190411011117.GC29573@dread.disaster.area>
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
 <20190408103303.GA18239@quack2.suse.cz>
 <1554741429.3326.43.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554741429.3326.43.camel@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Davidlohr Bueso <dbueso@suse.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Apr 08, 2019 at 09:37:09AM -0700, Davidlohr Bueso wrote:
> On Mon, 2019-04-08 at 12:33 +0200, Jan Kara wrote:
> > On Fri 05-04-19 08:17:30, Dave Chinner wrote:
> > > FYI, I'm working on a range lock implementation that should both
> > > solve the performance issue and the reader starvation issue at the
> > > same time by allowing concurrent buffered reads and writes to
> > > different file ranges.
> > 
> > Are you aware of range locks Davidlohr has implemented [1]? It didn't get
> > merged because he had no in-tree user at the time (he was more aiming at
> > converting mmap_sem which is rather difficult). But the generic lock
> > implementation should be well usable.
> > 
> > Added Davidlohr to CC.
> > 
> > 								Honza
> > 
> > [1] https://lkml.org/lkml/2017/3/7/22
> 
> fyi this was the latest version (had some naming updates per peterz).
> 
> https://lkml.org/lkml/2018/2/4/232

No, I wasn't aware of these because they haven't ever been posted to
a list I subscribe to and they haven't been merged. I'll go have a
look at them over the next few days.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
