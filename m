Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AD6C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 05:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 599D7233FF
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 05:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfH2FfZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 01:35:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34620 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725847AbfH2FfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 01:35:25 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7CF0C361704;
        Thu, 29 Aug 2019 15:35:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3D5c-0008UM-Ek; Thu, 29 Aug 2019 15:35:20 +1000
Date:   Thu, 29 Aug 2019 15:35:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v3] xfs: Fix ABBA deadlock between AGI and AGF when
 performing rename() with RENAME_WHITEOUT flag
Message-ID: <20190829053520.GM1119@dread.disaster.area>
References: <55d0f202-62a7-0b1c-a386-2395b19b47c5@gmail.com>
 <51bf333b-7694-68dc-4434-d15cbb24ccfb@gmail.com>
 <51f1096c-6828-5249-16f8-63996ecfa2f4@sandeen.net>
 <ff809542-5b25-d204-47e8-a75bd3e0320b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff809542-5b25-d204-47e8-a75bd3e0320b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=EYvOnsGqRtCEyMDMIrwA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 11:20:37AM +0800, kaixuxia wrote:
> 
> 
> On 2019/8/29 11:04, Eric Sandeen wrote:
> > On 8/28/19 8:27 PM, kaixuxia wrote:
> >> ping...
> >> Because there isn't this patch in the latest xfs-for-next branch 
> >> update...
> > 
> > 1) V3 appears to have no changes from V2.  Why was V3 sent?
> > 
> The V3 subject has been changed to distinguish from another droplink 
> deadlock patch that will be sent soon. This V3 patch aim to fix the 
> rename whiteout deadlock.

And now the subject line for the patch is far too long.  it is
almost twice as long as the old one, doesn't fit on one line without
wrapping, and really doesn't tell us anything much extra. If you
really must say it's a whiteout issue, then:

xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT

is sufficient. It's a summary - the above contains the problem, the
objects involved and the operation that needs to be fixed. Nothing
more is necessary. It needs to fit into ~60 characters so that
when you run git log --one-line the output can be pasted directly
into email without wrapping....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
