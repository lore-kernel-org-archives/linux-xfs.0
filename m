Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD77C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 555A82073F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfH2Iev (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:34:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59952 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfH2Iev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:34:51 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 84CD643DADC;
        Thu, 29 Aug 2019 18:34:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3FtG-0002H4-7y; Thu, 29 Aug 2019 18:34:46 +1000
Date:   Thu, 29 Aug 2019 18:34:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: factor data block addition from
 xfs_dir2_node_addname_int()
Message-ID: <20190829083446.GN1119@dread.disaster.area>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-3-david@fromorbit.com>
 <20190829080529.GB18195@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829080529.GB18195@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=Ari1b7ylKGte6_6CjkAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 01:05:29AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 29, 2019 at 04:30:39PM +1000, Dave Chinner wrote:
> > +			XFS_ERROR_REPORT("xfs_dir2_node_addname_int",
> > +					 XFS_ERRLEVEL_LOW, mp);
> 
> The function name here is incorret now.  I'd say just use __func__
> to avoid that for the future.

Fixed.

> Otherwise some of the code flow in the caller looks very ugly just with
> this patch, but given that it is all sorted out by the end of the series
> I don't really see an issue.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
