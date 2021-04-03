Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EB4C433ED
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Apr 2021 22:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 368F26134F
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Apr 2021 22:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhDCWQk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Apr 2021 18:16:40 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:48316 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236625AbhDCWQk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Apr 2021 18:16:40 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id EF6B01AEA69;
        Sun,  4 Apr 2021 08:16:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lSoZC-00A9MP-Cx; Sun, 04 Apr 2021 08:16:30 +1000
Date:   Sun, 4 Apr 2021 08:16:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: precalculate default inode attribute offset
Message-ID: <20210403221630.GZ63242@dread.disaster.area>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-5-david@fromorbit.com>
 <20210402071059.GI1739516@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402071059.GI1739516@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=7-415B0cAAAA:8
        a=2FITNFeji3tl3-UgjxsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 08:10:59AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 30, 2021 at 04:30:59PM +1100, Dave Chinner wrote:
> > +unsigned int
> > +xfs_bmap_compute_attr_offset(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (mp->m_sb.sb_inodesize == 256)
> > +		return XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> > +	return XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> > +}
> 
> There isn't really anything bmap about this function.  Maybe just merge
> it into xfs_mount_setup_inode_geom?

Sure there is - the XFS_BMDR_SPACE_CALC is a specific bmap btree
root size calculation defined in xfs_bmap_btree.h. I left it here
because I don't want to include xfs_bmap_btree.h into
fs/xfs/xfs_mount.h. There is no reason for xfs_mount.c to know
anything about the internals of bmap btrees, similar to how we call
xfs_bmap_compute_maxlevels() to calculate the static characteristics
of the bmap btrees...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
