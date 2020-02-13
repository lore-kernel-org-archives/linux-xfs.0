Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A39C352A3
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 20:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B3622168B
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 20:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgBMUzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 15:55:10 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39410 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728288AbgBMUzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 15:55:10 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BDB9182255B;
        Fri, 14 Feb 2020 07:55:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j2LVo-0003Ar-Fh; Fri, 14 Feb 2020 07:55:04 +1100
Date:   Fri, 14 Feb 2020 07:55:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     darrick.wong@oracle.com, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, renxudong1@huawei.com
Subject: Re: [PATCH] xfs: add agf freeblocks verify in xfs_agf_verify
Message-ID: <20200213205504.GU10776@dread.disaster.area>
References: <1581587639-130771-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581587639-130771-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=KQegfzDQlqZ9wRH2oaYA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 13, 2020 at 05:53:59PM +0800, Zheng Bin wrote:
> We recently used fuzz(hydra) to test XFS and automatically generate
> tmp.img(XFS v5 format, but some metadata is wrong)
> 
> Test as follows:
> mount tmp.img tmpdir
> cp file1M tmpdir
> sync
> 
> tmpdir/file1M size is 1M, but its data can not sync to disk.
> 
> This is because tmp.img has some problems, using xfs_repair detect
> information as follows:
> 
> agf_freeblks 0, counted 3224 in ag 0
> agf_longest 536874136, counted 3224 in ag 0
> sb_fdblocks 613, counted 3228
> 
> Add these agf freeblocks checks:
> 1. agf_longest < agf_freeblks
> 2. agf_freeblks < sb_fdblocks

Did you audit the other fields in the AGF to see if they were
adequately bounds checked by xfs_agf_verify()?

A quick look at struct xfs_agf and xfs_agf_verify() indicates that
agf_length, agf_rmap_blocks and agf_refcount_blocks are not bounds
checked, either. And agf_spare64 and agf_spare2 are not checked for
being zero....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
