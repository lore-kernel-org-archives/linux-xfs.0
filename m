Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A44C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 01:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B3760F4C
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 01:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhIVBtu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 21:49:50 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60407 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230433AbhIVBtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 21:49:49 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E147B882B77;
        Wed, 22 Sep 2021 11:48:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mSrMi-00FFIs-Kc; Wed, 22 Sep 2021 11:48:04 +1000
Date:   Wed, 22 Sep 2021 11:48:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Fengfei Xi <xi.fengfei@h3c.com>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        tian.xianting@h3c.com
Subject: Re: [PATCH] xfs: fix system crash caused by null bp->b_pages
Message-ID: <20210922014804.GQ1756565@dread.disaster.area>
References: <20201224095142.7201-1-xi.fengfei@h3c.com>
 <63d75865-84c6-0f76-81a2-058f4cad1d84@sandeen.net>
 <YUphLS+pXoVwPxMz@nuc10>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YUphLS+pXoVwPxMz@nuc10>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=IkcTkHD0fZMA:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=7LpL5LFFSHU8rAMU7E4A:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 03:48:13PM -0700, Rustam Kovhaev wrote:
> Hi Fengfei, Eric,
> 
> On Thu, Dec 24, 2020 at 01:35:32PM -0600, Eric Sandeen wrote:
> > On 12/24/20 3:51 AM, Fengfei Xi wrote:
> > > We have encountered the following problems several times:
> > >     1、A raid slot or hardware problem causes block device loss.
> > >     2、Continue to issue IO requests to the problematic block device.
> > >     3、The system possibly crash after a few hours.
> > 
> > What kernel is this on?
> > 
> 
> I have a customer that recently hit this issue on 4.12.14-122.74
> SLE12-SP5 kernel.

I think need to engage SuSE support and engineering, then, as this
is not a kernel supported by upstream devs. I'd be saying the same
thing if this was an RHEL frankenkernel, too.

> Here is my backtrace:
> [965887.179651] XFS (veeamimage0): Mounting V5 Filesystem
> [965887.848169] XFS (veeamimage0): Starting recovery (logdev: internal)
> [965888.268088] XFS (veeamimage0): Ending recovery (logdev: internal)
> [965888.289466] XFS (veeamimage1): Mounting V5 Filesystem
> [965888.406585] XFS (veeamimage1): Starting recovery (logdev: internal)
> [965888.473768] XFS (veeamimage1): Ending recovery (logdev: internal)
> [986032.367648] XFS (veeamimage0): metadata I/O error: block 0x1044a20 ("xfs_buf_iodone_callback_error") error 5 numblks 32

Storage layers returned -EIO a second before things went bad.
Whether that is relevant cannot be determined from the information
provided.

> [986033.152809] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [986033.152973] IP: xfs_buf_offset+0x2c/0x60 [xfs]
> [986033.153013] PGD 0 P4D 0 
> [986033.153041] Oops: 0000 [#1] SMP PTI
> [986033.153083] CPU: 13 PID: 48029 Comm: xfsaild/veeamim Tainted: P           OE      4.12.14-122.74-default #1 SLE12-SP5

And there are unknown proprietary modules loaded, so we can't trust
the code in the kernel to be operating correctly...

I'm not sure there's really anything upstream developers can help
with without any idea of how to reproduce this problem on a current
kernel...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
