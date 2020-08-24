Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E7CC433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 23:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 716642063A
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 23:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgHXX4J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 19:56:09 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:39941 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgHXX4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 19:56:08 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 591AC1AA954;
        Tue, 25 Aug 2020 09:56:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAMJo-0005hi-Lg; Tue, 25 Aug 2020 09:56:04 +1000
Date:   Tue, 25 Aug 2020 09:56:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/9] iomap: Use kzalloc to allocate iomap_page
Message-ID: <20200824235604.GD12131@dread.disaster.area>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824145511.10500-4-willy@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Eo_zldZ1eKELjHi0JfAA:9 a=CjuIK1q_8ugA:10
        a=1CNFftbPRP8L7MoqJWF3:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 03:55:04PM +0100, Matthew Wilcox (Oracle) wrote:
> We can skip most of the initialisation, although spinlocks still
> need explicit initialisation as architectures may use a non-zero
> value to indicate unlocked.  The comment is no longer useful as
> attach_page_private() handles the refcount now.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/buffered-io.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)

The sooner this goes in the better :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
