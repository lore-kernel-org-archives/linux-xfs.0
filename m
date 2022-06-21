Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43560C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 02:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243751AbiFUCIT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jun 2022 22:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiFUCIT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jun 2022 22:08:19 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B38338B7
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 19:08:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1A12E10E99FF;
        Tue, 21 Jun 2022 12:08:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o3TJN-0098Wv-Mf; Tue, 21 Jun 2022 12:08:13 +1000
Date:   Tue, 21 Jun 2022 12:08:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC] [PATCH 00/50] xfs: per-ag centric allocation alogrithms
Message-ID: <20220621020813.GO227878@dread.disaster.area>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <YqsbpL9BZes7qDbv@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqsbpL9BZes7qDbv@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b12810
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=Q8UwoF1wFSFngZMcHv8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 05:01:40AM -0700, Christoph Hellwig wrote:
> On Sat, Jun 11, 2022 at 11:26:09AM +1000, Dave Chinner wrote:
> > 
> > This series starts by driving the perag down into the AGI, AGF and
> > AGFL access routines and unifies the perag structure initialisation
> > with the high level AG header read functions. This largely replaces
> > the xfs_mount/agno pair that is passed to all these functions with a
> > perag, and in most places we already have a perag ready to pass in.
> 
> Btw, one neat thing would be versions of helpers like XFS_AG_DADDR
> and XFS_AGB_TO_FSB that take the pag structure instead of the mp/agno
> pair.

*nod*

Yeah, that's something I'm trying to work towards by driving more
geometry information into the perag. I haven't tried to do the
bigger conversions yet because the perag isn't widely used enough
yet, and it's likely that there will be additional complexities with
the userspace code I haven't realised yet. Getting the allocation
code to pass around referenced perags is a big part of getting
there, but there's still plenty more to do before I think I'll be
able to tackle cleaning up the many unit conversion macros we have.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
