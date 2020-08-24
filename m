Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBDA8C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 23:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1FA20702
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 23:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHXXvL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 19:51:11 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:37701 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726910AbgHXXvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 19:51:10 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 2270CD5BDCC;
        Tue, 25 Aug 2020 09:51:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAMEz-0005gh-VC; Tue, 25 Aug 2020 09:51:05 +1000
Date:   Tue, 25 Aug 2020 09:51:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] iomap: Fix misplaced page flushing
Message-ID: <20200824235105.GB12131@dread.disaster.area>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824145511.10500-2-willy@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=7D6e34dtJzuT3uDABGgA:9 a=CjuIK1q_8ugA:10
        a=1CNFftbPRP8L7MoqJWF3:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 03:55:02PM +0100, Matthew Wilcox (Oracle) wrote:
> If iomap_unshare_actor() unshares to an inline iomap, the page was
> not being flushed.  block_write_end() and __iomap_write_end() already
> contain flushes, so adding it to iomap_write_end_inline() seems like
> the best place.  That means we can remove it from iomap_write_actor().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/iomap/buffered-io.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
