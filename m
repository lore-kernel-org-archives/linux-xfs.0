Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prvmx01.microfocus.com ([130.57.1.216]:4837 "EHLO
        prvmx01.microfocus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfDHQx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 12:53:56 -0400
Message-ID: <1554741429.3326.43.camel@suse.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
From: Davidlohr Bueso <dbueso@suse.com>
Date: Mon, 8 Apr 2019 09:37:09 -0700
In-Reply-To: <20190408103303.GA18239@quack2.suse.cz>
References: <20190404165737.30889-1-amir73il@gmail.com>
         <20190404211730.GD26298@dastard> <20190408103303.GA18239@quack2.suse.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, 2019-04-08 at 12:33 +0200, Jan Kara wrote:
> On Fri 05-04-19 08:17:30, Dave Chinner wrote:
> > FYI, I'm working on a range lock implementation that should both
> > solve the performance issue and the reader starvation issue at the
> > same time by allowing concurrent buffered reads and writes to
> > different file ranges.
> 
> Are you aware of range locks Davidlohr has implemented [1]? It didn't get
> merged because he had no in-tree user at the time (he was more aiming at
> converting mmap_sem which is rather difficult). But the generic lock
> implementation should be well usable.
> 
> Added Davidlohr to CC.
> 
> 								Honza
> 
> [1] https://lkml.org/lkml/2017/3/7/22

fyi this was the latest version (had some naming updates per peterz).

https://lkml.org/lkml/2018/2/4/232
