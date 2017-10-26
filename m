Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37940 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932309AbdJZRzf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:55:35 -0400
Date: Thu, 26 Oct 2017 12:00:14 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH] xfsprogs: Issue smaller discards at mkfs
Message-ID: <20171026180014.GA27102@localhost.localdomain>
References: <20171026144131.26885-1-keith.busch@intel.com>
 <20171026162518.GW5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026162518.GW5483@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 09:25:18AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 26, 2017 at 08:41:31AM -0600, Keith Busch wrote:
> > Running mkfs.xfs was discarding the entire capacity in a single range. The
> > block layer would split these into potentially many smaller requests
> > and dispatch all of them to the device at roughly the same time.
> > 
> > SSD capacities are getting so large that full capacity discards will
> > take some time to complete. When discards are deeply queued, the block
> > layer may trigger timeout handling and IO failure, though the device is
> > operating normally.
> > 
> > This patch uses smaller discard ranges in a loop for mkfs to avoid
> > risking such timeouts. The max discard range is arbitrarilly set to
> > 128GB in this patch.
> 
> I'd have thought devices would set sane blk_queue_max_discard_sectors
> so that the block layer doesn't send such a huge command that the kernel
> times out...

The block limit only specifies the maximum size of a *single* discard
request as seen by the end device. This single request is not a problem
for timeouts, as far as I know.

The timeouts occur when queueing many of them at the same time: the last
one in the queue will have very high latency compared to ones ahead of
it in the queue if the device processes discards serially (many do).

There's no such limit to say the maximum outstanding number discard
requests that can be dispatched at the same time; the max number of
dispatched commands are shard with read and write.
 
> ...but then I actually went and grepped that in the kernel and
> discovered that nbd, zram, raid0, mtd, and nvme all pass in UINT_MAX,
> which is 2T.  Frighteningly xen-blkfront passes in get_capacity() (which
> overflows the unsigned int parameter on big virtual disks, I guess?).

The block layer will limit a single discard range to 4GB. If the IOCTL
specifies a larger range, the block layer will split it into multiple
requests.

> (I still think this is the kernel's problem, not userspace's, but now
> with an extra layer of OMGWTF sprayed on.)
> 
> I dunno.  What kind of device produces these timeouts, and does it go
> away if max_discards is lowered?

We observe timeouts on capacities above 4TB: a single BLKDISCARD for that
capacity has the block layer send 1024 discard requests at 4GB each.

Could the drivers do something else to mitigate this? We could set queue
depths lower to throttle dispatched commands and the problem would go
away. The depth, though, is set to optimize read and write, and we don't
want to harm that path to mitigate discard latency spikes.
