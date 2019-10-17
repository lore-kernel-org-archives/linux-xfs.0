Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582ADECE58D
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 21:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CC02222BD
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 21:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406520AbfJQVxT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 17:53:19 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56952 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391375AbfJQVxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 17:53:19 -0400
Received: from dread.disaster.area (pa49-181-198-88.pa.nsw.optusnet.com.au [49.181.198.88])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 499D643F0D4;
        Fri, 18 Oct 2019 08:53:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iLDhr-00026K-2v; Fri, 18 Oct 2019 08:53:15 +1100
Date:   Fri, 18 Oct 2019 08:53:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: enhance writeback error message
Message-ID: <20191017215315.GM16973@dread.disaster.area>
References: <20191017210110.GP13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017210110.GP13108@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=ocld+OpnWJCUTqzFQA3oTA==:117 a=ocld+OpnWJCUTqzFQA3oTA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=mGfhwXhhbaZWWKE9U5MA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 17, 2019 at 02:01:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we encounter an IO error during writeback, log the inode, offset, and
> sector number of the failure, instead of forcing the user to do some
> sort of reverse mapping to figure out which file is affected.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
