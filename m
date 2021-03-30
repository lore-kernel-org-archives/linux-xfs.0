Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52791C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 00:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324D161987
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 00:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhC3AoP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:44:15 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56834 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230378AbhC3AoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 20:44:09 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 5F67E2642;
        Tue, 30 Mar 2021 11:44:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lR2UJ-008ILd-4I; Tue, 30 Mar 2021 11:44:07 +1100
Date:   Tue, 30 Mar 2021 11:44:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/6] xfs: use s_inodes in xfs_qm_dqrele_all_inodes
Message-ID: <20210330004407.GS63242@dread.disaster.area>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671807853.621936.16639622639548774275.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161671807853.621936.16639622639548774275.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=z5OhlVGQRSegi4PUqh4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:21:18PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
> given that function simplify wants to iterate all live inodes known
> to the VFS.  Just iterate over the s_inodes list.

I'm not sure that assertion is true. We attach dquots during inode
inactivation after the VFS has removed the inode from the s_inodes
list and evicted the inode. Hence there is a window between the
inode being removed from the sb->s_inodes lists and it being marked
XFS_IRECLAIMABLE where we can attach dquots to the inode.

Indeed, an inode marked XFS_IRECLAIMABLE that has gone through
evict -> destroy -> inactive -> nlink != 0 -> xfs_free_ eofblocks()
can have referenced dquots attached to it and require dqrele() to be
called to release them.

Hence I think that xfs_qm_dqrele_all_inodes() is broken if all it is
doing is walking vfs referenced inodes, because it doesn't actually
release the dquots attached to reclaimable inodes. If this did
actually release all dquots, then there wouldn't be a need for the
xfs_qm_dqdetach() call in xfs_reclaim_inode() just before it's
handed to RCU to be freed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
