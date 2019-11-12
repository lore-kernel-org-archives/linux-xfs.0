Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C266DC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 22:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F4421783
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 22:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKLWOy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 17:14:54 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44781 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbfKLWOy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 17:14:54 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 10D1D7E8EF6;
        Wed, 13 Nov 2019 09:14:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iUeQy-0007UG-Hj; Wed, 13 Nov 2019 09:14:48 +1100
Date:   Wed, 13 Nov 2019 09:14:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: attach dquots before performing xfs_swap_extents
Message-ID: <20191112221448.GQ4614@dread.disaster.area>
References: <157343509505.1948946.5379830250503479422.stgit@magnolia>
 <157343511427.1948946.2692071497822316839.stgit@magnolia>
 <20191111080503.GC4548@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111080503.GC4548@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=y1OQ-_KH7HdE_a4HnVoA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 11, 2019 at 12:05:03AM -0800, Christoph Hellwig wrote:
> On Sun, Nov 10, 2019 at 05:18:34PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure we attach dquots to both inodes before swapping their extents.
> > This was found via manual code inspection by looking for places where we
> > could call xfs_trans_mod_dquot without dquots attached to inodes, and
> > confirmed by instrumenting the kernel and running xfs/328.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, for  while I've been wondering if we could just get rid of the
> concepts of attached dquots.  With the radix-tree/xarray looks up
> are be fairly cheap, and could be done lockless using RCU.  So we could
> try to just kill the concept of attaching the dquot to the inode and
> just look it up once per operation, where operation preferally is
> something high-level like the actual file/inode operation and not a
> low-level thing inside xfs.

If the dquots are not attached to the inode, how would you pass the
3 dquots per inode down the stack to where they are actually used
inside the filesystem? I mean, we have to get the dquots attached to
the transaction so we can update them in xfs_trans_commit ->
xfs_trans_apply_dquot_deltas(), so somehow we'd have to get them
from the high level file/inode operations down to the XFS
transaction context. And things like writeback need dquots attached
for delayed allocation, so various aops would need to do dquot
lookups, too...

I can see the advantage of doing rcu dquot cache lookups in the xfs
context where we are attaching the dquots to the transaction rather
than attaching them to the inode, but I can't see how the "do it at
a high level" aspect of this would work....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
