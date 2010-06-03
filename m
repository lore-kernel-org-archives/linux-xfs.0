Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o536oQOE140151 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 01:50:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB9CE391DD7
	for <xfs@oss.sgi.com>; Wed,  2 Jun 2010 23:52:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BZ1KeKLHdLOrmcCe for
	<xfs@oss.sgi.com>; Wed, 02 Jun 2010 23:52:54 -0700 (PDT)
Date: Thu, 3 Jun 2010 02:52:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/17] xfs: skip writeback from reclaim context
Message-ID: <20100603065252.GA28592@infradead.org>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160859.184576507@bombadil.infradead.org>
	<20100602043957.GB7011@dastard>
	<20100602100812.GA25035@infradead.org>
	<20100602230209.GA27325@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100602230209.GA27325@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

On Thu, Jun 03, 2010 at 09:02:09AM +1000, Dave Chinner wrote:
> Did you skip it unconditionally, or only when a transaction was
> required?

xfs_vm_releasepage is mostly a no-op if no transaction is required.
If we have neither delalloc nor unwritten buffer we do not actually
enter xfs_page_state_convert, and ->releasepage also doesn't touch
unampped buffers at all.

> The scary part is that I've seen stack traces (i.e. most stack used)
> through this reclaim path for delalloc conversion even for
> allocations that are GFP_NOFS and the only thing saving us from
> deadlocks is th PF_FSTRANS check. Even worse is that
> shrinker_page_list() will call try_to_release_pages() without
> checking whether it's allowed to enter the filesystem or not, so we
> can be doing block allocation in places we've specifically told the
> memory allocation subsystem not to....

s/shrinker_page_list/shrink_page_list/ and
s/try_to_release_pages/try_to_release_page/ above.

shrink_page_list takes the gfp_mask for try_to_release_page from
the scan_control structure passed to it from all the top of the long
callchain.  I can't find anobvious bug, but this could cause a lot
more harm.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
