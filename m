Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF26EC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 23:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9141610FC
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 23:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhDOXO2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 19:14:28 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:43252 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234659AbhDOXO1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 19:14:27 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id E6E6911406DC;
        Fri, 16 Apr 2021 09:14:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lXBBR-009qp0-TG; Fri, 16 Apr 2021 09:14:01 +1000
Date:   Fri, 16 Apr 2021 09:14:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove XFS_IFEXTENTS
Message-ID: <20210415231401.GR63242@dread.disaster.area>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-8-hch@lst.de>
 <20210414003744.GU3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414003744.GU3957620@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=7-415B0cAAAA:8
        a=ePvp3S5H-cLqKCW9ShIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 05:37:44PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 12, 2021 at 03:38:19PM +0200, Christoph Hellwig wrote:
> > The in-memory XFS_IFEXTENTS is now only used to check if an inode with
> > extents still needs the extents to be read into memory before doing
> > operations that need the extent map.  Add a new xfs_need_iread_extents
> > helper that returns true for btree format forks that do not have any
> > entries in the in-memory extent btree, and use that instead of checking
> > the XFS_IFEXTENTS flag.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> The series seems reasonable to me, though I wonder if Dave will have
> strong(er) opinions?

No, I've already said I'm fine with making these changes to remove
the ambiguity. I've only briefly scan of the patches, but I didn't
see anything that I disagree with that would make me stop, context
switch and ask to be changed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
