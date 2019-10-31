Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B590CA9ECB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 21:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29CB320679
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 21:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfJaVGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Oct 2019 17:06:08 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40113 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726680AbfJaVGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 17:06:08 -0400
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 756FC3A2737;
        Fri,  1 Nov 2019 08:06:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iQHds-0006HY-TC; Fri, 01 Nov 2019 08:06:04 +1100
Date:   Fri, 1 Nov 2019 08:06:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191031210604.GT4614@dread.disaster.area>
References: <20191029223752.28562-1-david@fromorbit.com>
 <20191030142622.GA10453@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191030142622.GA10453@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=UVE_EpKRGt1gxgIJBDsA:9 a=QEXdDO2ut3YA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 07:26:22AM -0700, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, I've been pondering multiple times if we can kill off i_dio_count
> again, at least for iomap users.  I've added in the request of Thomas
> how want to kill non-owner rw_semaphore unlocks.  But it turns out those
> were needed in other placeѕ and have been added back at least partially.
> I'll try to just use those again when I find some time, which should
> simplify a lot of the mess we around waiting for direct I/O.

I kinda planned to kill off inode_dio_wait() for XFS via range
locks. i.e. hold the range lock all the way to DIO completion, then
release it there. This allows things like fallocate, truncate, EOF
extension, etc to run concurrently with all IO and not require
serialisation of the IO in progress to perform extent and size
modification operations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
