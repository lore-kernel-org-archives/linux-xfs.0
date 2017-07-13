Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33401 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbdGMTWt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 15:22:49 -0400
Date: Thu, 13 Jul 2017 12:22:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] Revert "xfs: grab dquots without taking the ilock"
Message-ID: <20170713192242.GD4151@magnolia>
References: <20170713113304.8079-1-hch@lst.de>
 <20170713113304.8079-5-hch@lst.de>
 <20170713163127.GA4151@magnolia>
 <20170713163628.GA4187@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713163628.GA4187@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2017 at 06:36:28PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 13, 2017 at 09:31:27AM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 13, 2017 at 01:33:04PM +0200, Christoph Hellwig wrote:
> > > This reverts commit 50e0bdbe9f48f98bb02eac7030d682f4716884ae.
> > > 
> > > The new XFS_QMOPT_NOLOCK isn't used at all,
> > 
> > It'll get used (eventually) by online fsck.
> 
> As-is that will lead to buggy code. xfs_qm_dqread does transaction
> allocations and disk reads, and none of those should be allowed
> under the ILOCK ever.  That whole callchain is a mess and will need
> some refactoring love to start with, e.g. including the dropping
> of the ilock around the xfs_qm_dqread call in xfs_qm_dqget, and
> a general mess of mixing up way to many things through the xfs_qm_dqget()
> interface.

I thought we /could/ do disk reads with the ilock held -- we certainly
do that to read in bmap extents.  OTOH we never used to read dquot info
off the disk with the quota inode ilock held, so you're right, let's not
introduce that now.

The quota scrubber can be reworked to do all the things it needs to do
without taking any locks, so I'm ok with reverting this and leaving this
whole murky incohesive interface alone.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> > > and conditional locking based on a flag is always the wrong thing to
> > > do - we should be having helpers that can be called without the lock
> > > instead.
> > 
> > Fair enough.  How about this instead:
> 
> Just as bad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
