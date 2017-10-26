Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:12174 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932428AbdJZVTh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 17:19:37 -0400
Date: Thu, 26 Oct 2017 15:24:15 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH] xfsprogs: Issue smaller discards at mkfs
Message-ID: <20171026212414.GA30535@localhost.localdomain>
References: <20171026144131.26885-1-keith.busch@intel.com>
 <20171026162518.GW5483@magnolia>
 <3ad1751a-a4df-b0ee-d2c5-d1ac4deb5b46@sandeen.net>
 <0d50ca3b-0b27-8ac1-c102-9ea656f3f926@sandeen.net>
 <20171026183216.GA27317@localhost.localdomain>
 <20171026195923.GB5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026195923.GB5483@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 12:59:23PM -0700, Darrick J. Wong wrote:
> 
> Sure, but now you have to go fix mke2fs and everything /else/ that
> issues BLKDISCARD (or FALLOC_FL_PUNCH) on a large file / device, and
> until you fix every program to work around this weird thing in the
> kernel there'll still be someone somewhere with this timeout problem...

e2progs already splits large discards in a loop. ;)

> ...so I started digging into what the kernel does with a BLKDISCARD
> request, which is to say that I looked at blkdev_issue_discard.  That
> function uses blk_*_plug() to wrap __blkdev_issue_discard, which in turn
> splits the request into a chain of UINT_MAX-sized struct bios.
> 
> 128G's worth of 4G ios == 32 chained bios.
> 
> 2T worth of 4G ios == 512 chained bios.
> 
> So now I'm wondering, is the problem more that the first bio in the
> chain times out because the last one hasn't finished yet, so the whole
> thing gets aborted because we chained too much work together?

You're sort of on the right track. The timeouts are set on an individual
request in the chain rather than one timeout for the entire chain.

All the bios in the chain get turned into 'struct request' and sent
to the low-level driver. The driver calls blk_mq_start_request before
sending to hardware. That starts the timer on _that_ request,
independent of the other requests in the chain.

NVMe supports very large queues. A 4TB discard becomes 1024 individual
requests started at nearly the same time. The last ones in the queue are
the ones that risk timeout.

When we're doing read/write, latencies at the same depth are well within
tolerance, and high queue depths are good for throughput. When doing
discard, though, tail latencies fall outside the timeout tolerance at
the same queue depth.
 
> Would it make sense to fix __blkdev_issue_discard to chain fewer bios
> together?  Or just issue the bios independently and track the
> completions individually?
>
> > > I'm not wise in the ways of queueing and throttling, but from my naiive
> > > perspective, it seems like something to be fixed in the kernel, or if it
> > > can't, export some new "maximum discard request size" which can be trusted?
> 
> I would've thought that's what max_discard_sectors was for, but... eh.
> 
> How big is the device you were trying to mkfs, anyway?

The largest single SSD I have is 6.4TB. Other folks I know have larger.
