Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o524bYWV048106 for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 23:37:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B533130D504
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 21:42:21 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	CrTToBZTKCUzkyGp for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 21:42:21 -0700 (PDT)
Date: Wed, 2 Jun 2010 14:39:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/17] xfs: skip writeback from reclaim context
Message-ID: <20100602043957.GB7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160859.184576507@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160859.184576507@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:29PM -0400, Christoph Hellwig wrote:
> Allowing writeback from reclaim context causes massive problems with stack
> overflows as we can call into the writeback code which tends to be a heavy
> stack user both in the generic code and XFS from random contexts that
> perform memory allocations.
> 
> Follow the example of btrfs (and in slightly different form ext4) and refuse
> to write out data from reclaim context.  This issue should really be handled
> by the VM so that we can tune better for this case, but until we get it
> sorted out there we have to hack around this in each filesystem with a
> complex writeback path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yup, I agree that we have to do this for the moment. It hasn't
caused any problems in my usual OOM testing, so it seems safe
to do.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Also worth thinking about is if should be checked in
xfs_vm_releasepage() as well to avoid the same stack issues if it
triggers allocation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
