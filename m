Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o52A5oYp068081 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 05:05:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F6E01B167C0
	for <xfs@oss.sgi.com>; Wed,  2 Jun 2010 03:08:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7iDfVkA1eUNqtMPh for
	<xfs@oss.sgi.com>; Wed, 02 Jun 2010 03:08:18 -0700 (PDT)
Date: Wed, 2 Jun 2010 06:08:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/17] xfs: skip writeback from reclaim context
Message-ID: <20100602100812.GA25035@infradead.org>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160859.184576507@bombadil.infradead.org>
	<20100602043957.GB7011@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100602043957.GB7011@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 02, 2010 at 02:39:57PM +1000, Dave Chinner wrote:
> Also worth thinking about is if should be checked in
> xfs_vm_releasepage() as well to avoid the same stack issues if it
> triggers allocation...

I agree this is a potential problem as well.

I did some QA runs with this thrown in, and it causes massive OOM killer
wreckage in xfstests.  I've also cross-checked btrfs and ext4 and
neither one skips ->releasepage from reclaim context.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
