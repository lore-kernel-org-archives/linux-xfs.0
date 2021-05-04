Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CA1C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 00:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AAD06100A
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 00:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhEDAwG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 20:52:06 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:32968 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229610AbhEDAwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 May 2021 20:52:06 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 995C5688A7;
        Tue,  4 May 2021 10:51:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ldjHJ-002GEW-Bl; Tue, 04 May 2021 10:51:09 +1000
Date:   Tue, 4 May 2021 10:51:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: mkfs is broken due to platform_zero_range
Message-ID: <20210504005109.GK63242@dread.disaster.area>
References: <20210504002053.GC7448@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504002053.GC7448@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=9Qi-dW0EAybRhQ27bzMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 03, 2021 at 05:20:53PM -0700, Darrick J. Wong wrote:
> So... I have a machine with an nvme drive manufactured by a certain
> manufacturer who isn't known for the quality of their firmware
> implementation.  I'm pretty sure that this is a result of the use of
> fallocate(FALLOC_FL_ZERO_RANGE) to zero the log during format.
> 
> If I format a device, mounting and repair both fail because the primary
> superblock UUID doesn't match the log UUID:
.....
> And the format works this time too:
> 
> [root@abacus654 ~]# strace -s99 -o /tmp/a mkfs.xfs /dev/nvme0n1  -f
> meta-data=/dev/nvme0n1           isize=512    agcount=6, agsize=268435455 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=1542990848, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Discarding blocks...Done.
> (reverse-i-search)`-n': od -tx1 -Ad -c /tmp/badlog3 | head ^C15
> [root@abacus654 ~]# xfs_repair -n /dev/nvme0n1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
> 
> In conclusion, the drive firmware is broken.
> 
> Question: Should we be doing /some/ kind of re-read after a zeroing the
> log to detect these sh*tty firmwares and fall back to a pwrite()?

No, userspace should not have to wrok around broken hardware. The
kernel needs to blacklist/quirk this device so that it will do
either:

a) redirect to a zeroing mechanism that actually works on that
device; or

b) fail the fallocate() call with -EOPNOTSUPP so that the
application can fall back to manual zeroing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
