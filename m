Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o52Mxo1P116549 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 17:59:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BB4813F4063
	for <xfs@oss.sgi.com>; Wed,  2 Jun 2010 16:02:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	mx3tADeQGqlDmsqQ for <xfs@oss.sgi.com>;
	Wed, 02 Jun 2010 16:02:16 -0700 (PDT)
Date: Thu, 3 Jun 2010 09:02:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/17] xfs: skip writeback from reclaim context
Message-ID: <20100602230209.GA27325@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160859.184576507@bombadil.infradead.org>
	<20100602043957.GB7011@dastard>
	<20100602100812.GA25035@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100602100812.GA25035@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jun 02, 2010 at 06:08:12AM -0400, Christoph Hellwig wrote:
> On Wed, Jun 02, 2010 at 02:39:57PM +1000, Dave Chinner wrote:
> > Also worth thinking about is if should be checked in
> > xfs_vm_releasepage() as well to avoid the same stack issues if it
> > triggers allocation...
> 
> I agree this is a potential problem as well.
> 
> I did some QA runs with this thrown in, and it causes massive OOM killer
> wreckage in xfstests.  I've also cross-checked btrfs and ext4 and
> neither one skips ->releasepage from reclaim context.

Did you skip it unconditionally, or only when a transaction was
required?

The scary part is that I've seen stack traces (i.e. most stack used)
through this reclaim path for delalloc conversion even for
allocations that are GFP_NOFS and the only thing saving us from
deadlocks is th PF_FSTRANS check. Even worse is that
shrinker_page_list() will call try_to_release_pages() without
checking whether it's allowed to enter the filesystem or not, so we
can be doing block allocation in places we've specifically told the
memory allocation subsystem not to....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
