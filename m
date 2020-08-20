Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EC8C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 21:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522172076E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 21:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgHTVYR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 17:24:17 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53197 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726976AbgHTVYQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 17:24:16 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9C2063A5D6B;
        Fri, 21 Aug 2020 07:24:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8s2a-0007Ge-Hq; Fri, 21 Aug 2020 07:24:08 +1000
Date:   Fri, 21 Aug 2020 07:24:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix off-by-one in inode alloc block reservation
 calculation
Message-ID: <20200820212408.GB7941@dread.disaster.area>
References: <20200820170734.200502-1-bfoster@redhat.com>
 <20200820172512.GJ6096@magnolia>
 <20200820174708.GA183950@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820174708.GA183950@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=UUTlDQiA2Cd4_d-9lyEA:9 a=6hhfuhJN2_e6ZukL:21 a=4aw2x13cTvjv5ees:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 01:47:08PM -0400, Brian Foster wrote:
> On Thu, Aug 20, 2020 at 10:25:12AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 20, 2020 at 01:07:34PM -0400, Brian Foster wrote:
> > > The inode chunk allocation transaction reserves inobt_maxlevels-1
> > > blocks to accommodate a full split of the inode btree. A full split
> > > requires an allocation for every existing level and a new root
> > > block, which means inobt_maxlevels is the worst case block
> > > requirement for a transaction that inserts to the inobt. This can
> > > lead to a transaction block reservation overrun when tmpfile
> > > creation allocates an inode chunk and expands the inobt to its
> > > maximum depth. This problem has been observed in conjunction with
> > > overlayfs, which makes frequent use of tmpfiles internally.
> > > 
> > > The existing reservation code goes back as far as the Linux git repo
> > > history (v2.6.12). It was likely never observed as a problem because
> > > the traditional file/directory creation transactions also include
> > > worst case block reservation for directory modifications, which most
> > > likely is able to make up for a single block deficiency in the inode
> > > allocation portion of the calculation. tmpfile support is relatively
> > > more recent (v3.15), less heavily used, and only includes the inode
> > > allocation block reservation as tmpfiles aren't linked into the
> > > directory tree on creation.
> > > 
> > > Fix up the inode alloc block reservation macro and a couple of the
> > > block allocator minleft parameters that enforce an allocation to
> > > leave enough free blocks in the AG for a full inobt split.
> > 
> > Looks all fine to me, but... does a similar logic apply to the other
> > maxlevels uses in the kernel?
> > 
> > fs/xfs/libxfs/xfs_trans_resv.c:73:      blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
> > fs/xfs/libxfs/xfs_trans_resv.c:75:              blocks += max(num_ops * (2 * mp->m_rmap_maxlevels - 1),
> > fs/xfs/libxfs/xfs_trans_resv.c:78:              blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
> > 
> > Can we end up in the same kind of situation with those other trees
> > {bno,cnt,rmap,refc} where we have a maxlevels-1 tall tree and split each
> > level all the way to the top?
> > 
> 
> Hmm.. it seems so at first glance, but I'm not sure I follow the
> calculations in that function. If we factor out the obvious
> num_ops/num_trees components, the comment refers to the following
> generic formula:
> 
> 	((2 blocks/level * max depth) - 1)
> 
> I take it that since this is a log reservation calculation, the two
> block/level multiplier is there because we have to move records between
> two blocks for each level that splits. Is there a reason the -1 is
> applied after that multiplier (as opposed to subtracting 1 from the max
> depth first)? I'm wondering if that's intentional and it reflects that
> the root level is only one block...

Intentional, I think, because that's how btree splits work. :) i.e.
split every level into 2 blocks, then add one for the new root. But
when the tree is already at max height, we can't split the root
block anymore so we are accounting for a split at every level except
the root block, which is a single block....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
