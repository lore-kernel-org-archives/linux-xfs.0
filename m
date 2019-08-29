Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE5CC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ABF52073F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfH2Ifs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:35:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38457 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfH2Ifs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:35:48 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A24AC43D051;
        Thu, 29 Aug 2019 18:35:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3FuD-0002HH-5j; Thu, 29 Aug 2019 18:35:45 +1000
Date:   Thu, 29 Aug 2019 18:35:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: factor free block index lookup from
 xfs_dir2_node_addname_int()
Message-ID: <20190829083545.GO1119@dread.disaster.area>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-4-david@fromorbit.com>
 <20190829081013.GC18195@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829081013.GC18195@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=5UkKDK10u2-lgvPlUNEA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 01:10:13AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 29, 2019 at 04:30:40PM +1000, Dave Chinner wrote:
> > +	/*
> > +	 * Now we know if we must allocate blocks, so if we are checking whether
> > +	 * we can insert without allocation then we can return now.
> > +	 */
> > +	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
> > +		if (dbno != -1)
> > +			return 0;
> > +		return -ENOSPC;
> > +	}
> 
> Nit: I'd invert the check to rturn -ENOSPC in the branch if dbno is
> -1 to make the flow a littler easier.

Fixed.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
