Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8332DC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6840C20657
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHSArc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:47:32 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:45305 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726533AbgHSArc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:47:32 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id A49B41092D1;
        Wed, 19 Aug 2020 10:47:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8CGF-0007ct-1D; Wed, 19 Aug 2020 10:47:27 +1000
Date:   Wed, 19 Aug 2020 10:47:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: add unlink list pointers to xfs_inode
Message-ID: <20200819004727.GG21744@dread.disaster.area>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-6-david@fromorbit.com>
 <20200819000251.GS6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819000251.GS6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=wU3LiZpsrwaLYY42crIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 05:02:51PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 12, 2020 at 07:25:48PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To move away from using the on disk inode buffers to track and log
> > unlinked inodes, we need pointers to track them in memory. Because
> > we have arbitrary remove order from the list, it needs to be a
> > double linked list.
> > 
> > We start by noting that inodes are always in memory when they are
> > active on the unlinked list, and hence we can track these inodes
> > without needing to take references to the inodes or store them in
> > the list. We cannot, however, use inode locks to protect the inodes
> > on the list - the list needs an external lock to serialise all
> > inserts and removals. We can use the existing AGI buffer lock for
> > this right now as that already serialises all unlinked list
> > traversals and modifications.
> > 
> > Hence we can convert the in-memory unlinked list to a simple
> > list_head list in the perag. We can use list_empty() to detect an
> > empty unlinked list, likewise we can detect the end of the list when
> > the inode next pointer points back to the perag list_head. This
> > makes insert, remove and traversal.
> > 
> > The only complication here is log recovery of old filesystems that
> > have multiple lists. These always remove from the head of the list,
> > so we can easily construct just enough of the unlinked list for
> > recovery from any list to work correctly.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Hm.  This is orthogonal to this patch, but should we get meaner about
> failing the mount if the AGI read fails or the unlinked walk fails?

I don't think it matters. We can leak the unlinked lists and still
have the filesystem operate correctly, so I don't think failing the
mount is necessary or desirable (i.e. how many existing filesystems
will now suddenly refuse to mount?)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
