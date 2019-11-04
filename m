Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB9ECA9ED3
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D059620869
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbfKDUtR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:49:17 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58751 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729710AbfKDUtR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:49:17 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CCF993A0A9C;
        Tue,  5 Nov 2019 07:49:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iRjHh-0006Hb-FZ; Tue, 05 Nov 2019 07:49:09 +1100
Date:   Tue, 5 Nov 2019 07:49:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
Message-ID: <20191104204909.GB4614@dread.disaster.area>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=BTeA3XvPAAAA:8 a=7-415B0cAAAA:8
        a=9rK2l8cHGEVl0CmEovAA:9 a=OCCxXlEOGsAPRoHQ:21 a=EEn7Qb-6C_fkYYwB:21
        a=CjuIK1q_8ugA:10 a=tafbbOV3vt1XuEhzTjGK:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
> From: Yang Guo <guoyang2@huawei.com>
> 
> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
> whether the counter less than 0 and it is a expensive function.
> let's check it only when delta < 0, it will be good for xfs's performance.

Hmmm. I don't recall this as being expensive.

How did you find this? Can you please always document how you found
the problem being addressed in the commit message so that we don't
then have to ask how the problem being fixed is reproduced.

> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Signed-off-by: Yang Guo <guoyang2@huawei.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  fs/xfs/xfs_mount.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index ba5b6f3b2b88..5e8314e6565e 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1174,6 +1174,9 @@ xfs_mod_icount(
>  	int64_t			delta)
>  {
>  	percpu_counter_add_batch(&mp->m_icount, delta, XFS_ICOUNT_BATCH);
> +	if (delta > 0)
> +		return 0;
> +
>  	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH) < 0) {
>  		ASSERT(0);
>  		percpu_counter_add(&mp->m_icount, -delta);

I struggle to see how this is expensive when you have more than
num_online_cpus() * XFS_ICOUNT_BATCH inodes allocated.
__percpu_counter_compare() will always take the fast path so ends up
being very little code at all.

> @@ -1188,6 +1191,9 @@ xfs_mod_ifree(
>  	int64_t			delta)
>  {
>  	percpu_counter_add(&mp->m_ifree, delta);
> +	if (delta > 0)
> +		return 0;
> +
>  	if (percpu_counter_compare(&mp->m_ifree, 0) < 0) {
>  		ASSERT(0);
>  		percpu_counter_add(&mp->m_ifree, -delta);

This one might have some overhead because the count is often at or
around zero, but I haven't noticed it being expensive in kernel
profiles when creating/freeing hundreds of thousands of inodes every
second.

IOWs, we typically measure the overhead of such functions by kernel
profile.  Creating ~200,000 inodes a second, so hammering the icount
and ifree counters, I see:

      0.16%  [kernel]  [k] percpu_counter_add_batch
      0.03%  [kernel]  [k] __percpu_counter_compare

Almost nothing - it's way down the long tail of noise in the
profile.

IOWs, the CPU consumed by percpu_counter_compare() is low that
optimisation isn't going to produce any measurable performance
improvement. Hence it's not really something we've concerned
ourselves about.  The profile is pretty much identical for removing
hundreds of thousands of files a second, too, so there really isn't
any performance gain to be had here.

If you want to optimise code to make it faster and show a noticable
performance improvement, start by running kernel profiles while your
performance critical workload is running. Then look at what the
functions and call chains that consume the most CPU and work out how
to do them better. Those are the places that optimisation will
result in measurable performance gains....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
