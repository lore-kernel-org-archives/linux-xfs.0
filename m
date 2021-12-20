Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4789DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Dec 2021 20:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhLTUzD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Dec 2021 15:55:03 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41078 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhLTUzD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Dec 2021 15:55:03 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 69C0210A5664;
        Tue, 21 Dec 2021 07:55:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mzPgQ-005TOC-Ma; Tue, 21 Dec 2021 07:54:58 +1100
Date:   Tue, 21 Dec 2021 07:54:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chanchal Mathew <chanch13@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS journal log resetting
Message-ID: <20211220205458.GB945095@dread.disaster.area>
References: <20211212230854.GR449541@dread.disaster.area>
 <5171B0E5-B782-4787-BE20-A432D090A9A4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5171B0E5-B782-4787-BE20-A432D090A9A4@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61c0eda5
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=7-415B0cAAAA:8
        a=mywH9eJ9DaN5bUWsRaMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 20, 2021 at 10:48:31AM -0800, Chanchal Mathew wrote:
> I am starting an EC2 instance from an image file with XFS file system. The file system is cleanly unmounted, and the log print output I shared before is run on it before creating a snapshot and starting an instance from it.
> The time is measured from dmesg & journalctl logs. Here is a sample output. Kernel version 5.10.x
>  
> -
> [  1.984392] XFS (nvme0n1p1): Mounting V5 Filesystem
> [  3.538829] XFS (nvme0n1p1): Ending clean mount
> -
> 
> I then edited XFS code to print more log messages for this code path. And found it to spend the nearly 1s time on xlog_find_tail. Here is the debug dmesg output from another image with high log number. If I reset the log to 0, then the mount completes in 200-300ms avg. For a long tail number of 17983, for example, it takes 1s approx.
>  
> -
> [  2.387962] XFS (nvme0n1p1): starting xlog_find_tail
> [  2.392108] XFS (nvme0n1p1): Find previous log record
> [  2.402898] XFS (nvme0n1p1): Assert head_blk < INT_MAX: 17983
> [  2.407355] XFS (nvme0n1p1): Allocate buffer
> [  2.411108] XFS (nvme0n1p1): Search backwards through the log
> [  2.416299] XFS (nvme0n1p1): tail_blk: 17979
> [  2.420045] XFS (nvme0n1p1): Set the log state based on the current head record
> [  2.426834] XFS (nvme0n1p1): Look for an unmount record at the head of the log
> [  2.433763] XFS (nvme0n1p1): Verify the log head of the log is not clean
> [  2.438599] XFS (nvme0n1p1): Note that the unmount was clean
> [  2.442950] XFS (nvme0n1p1): Make sure that there are no blocks in front of the head
> [  3.439000] XFS (nvme0n1p1): finished xlog_find_tail

So there's a delay while recovery writes up to 2MB of zeroed blocks
beyond the head so that future recoveries won't get confused by
stale, unrecovered partial log writes that this recovery ignored.

> Here is the output of xfs_info on the mounted image:
>  
> -
> $ xfs_info /dev/mapper/loop2p1
> meta-data=/dev/mapper/loop2p1  isize=512  agcount=4, agsize=524159 blks
>      =            sectsz=512  attr=2, projid32bit=1
>      =            crc=1    finobt=1 spinodes=0

V5 format - "zeroing" the log with xfs_repair is not actually zeroing
the log sequence numbers - it's re-initialising the log, not
"resetting it to zero".

> data   =            bsize=4096  blocks=2096635, imaxpct=25
>      =            sunit=0   swidth=0 blks
> naming  =version 2       bsize=4096  ascii-ci=0 ftype=1
> log   =internal        bsize=4096  blocks=2560, version=2

And so you have a 10MB log, which means the log block zeroing is
wrapping around the head and having to do two IOs instead of one to
clear the 2MB region.

That is, head_blk = 17983, log->l_logbbsize = 20480, zeroing needs
to run to 17983 + 4096 = 22079, which means it wraps the log and
has to zero 17984 -> 20389, then 0 -> 1599.

WHen the headblk is smaller, this is just a single 2MB sized IO.
When the headblk is within 2MB of the end of the log, it is two
sub-2MB write IOs issued sequentially. If this is taking a long
time, then I'd be looking at why the different IO patterns in
xlog_clear_stale_blocks() result in such a long delay. Smells like
a storage problem, not an XFS issue.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
