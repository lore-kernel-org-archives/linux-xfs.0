Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EB1CA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 21:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40BA321A4A
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 21:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfKCVLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 16:11:31 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60519 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726502AbfKCVLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 16:11:31 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 15C983A10AC;
        Mon,  4 Nov 2019 08:11:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iRN9h-0006JR-Ab; Mon, 04 Nov 2019 08:11:25 +1100
Date:   Mon, 4 Nov 2019 08:11:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs_buf_rele(): xfs: fix use-after-free race in xfs_buf_rele
Message-ID: <20191103211125.GZ4614@dread.disaster.area>
References: <CAE4254A1B4C4A2895049EE040022942@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE4254A1B4C4A2895049EE040022942@alyakaslap>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=L-lUp8TeWKdoQLBd4WkA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 08:24:21PM +0200, Alex Lyakas wrote:
> Hi Dave,
> 
> This commit
> [37fd1678245f7a5898c1b05128bc481fb403c290 xfs: fix use-after-free race in
> xfs_buf_rele]
> fixes a use-after-free issue.
> 
> We are looking at XFS buffer cache + LRU code in kernel 4.14, while the
> above fix arrived in kernel 4.19. Do you think this fix should be backported
> to stable kernels?

IIRC it was pretty difficult to exercise the bug in the first place,
and it was hit because of another bug that was fixed (referenced in
the above commit). There's no real point in fixing this without
fixing the referenced bug, as the referenced bug was the one that
caused all the actual problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
