Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1215AC25B06
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Aug 2022 22:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiHNWos (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Aug 2022 18:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiHNWor (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Aug 2022 18:44:47 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EE69101ED;
        Sun, 14 Aug 2022 15:44:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 23B8610E874E;
        Mon, 15 Aug 2022 08:44:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oNMLY-00DAwR-OG; Mon, 15 Aug 2022 08:44:40 +1000
Date:   Mon, 15 Aug 2022 08:44:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        linux-xfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
Message-ID: <20220814224440.GR3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvZc+jvRdTLn8rus@pevik>
 <YvZUfq+3HYwXEncw@pevik>
 <YvZTpQFinpkB06p9@pevik>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62f97adc
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=RqjhzPdQHaDuyD3YeBEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 12, 2022 at 03:20:37PM +0200, Petr Vorel wrote:
> Hi all,
> 
> LTP test df01.sh found different size of loop device in v5.19.
> Test uses loop device formatted on various file systems, only XFS fails.
> It randomly fails during verifying that loop size usage changes:
> 
> grep ${TST_DEVICE} output | grep -q "${total}.*${used}" [1]
> 
> How to reproduce:
> # PATH="/opt/ltp/testcases/bin:$PATH" df01.sh -f xfs # it needs several tries to hit
> 
> df saved output:
> Filesystem     1024-blocks    Used Available Capacity Mounted on
> ...
> /dev/loop0          256672   16208    240464       7% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
> df output:
> Filesystem     1024-blocks    Used Available Capacity Mounted on
> ...
> tmpfs               201780       0    201780       0% /run/user/0
> /dev/loop0          256672   15160    241512       6% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
> => different size
> df01 4 TFAIL: 'df -k -P' failed, not expected.

Yup, most likely because we changed something in XFS related to
internal block reservation spaces. That is, the test is making
fundamentally flawed assumptions about filesystem used space
accounting.

It is wrong to assuming that the available capacity of a given empty
filesystem will never change.  Assumptions like this have been
invalid for decades because the available space can change based on
the underlying configuration or the filesystem. e.g. different
versions of mkfs.xfs set different default parameters and so simply
changing the version of xfsprogs you use between the two comparision
tests will make it fail....

And, well, XFS also has XFS_IOC_{GS}ET_RESBLKS ioctls that allow
userspace to change the amount of reserved blocks. They were
introduced in 1997, and since then we've changed the default
reservation the filesystem takes at least a dozen times.

> > It might be a false positive / bug in the test, but it's at least a changed behavior.

Yup, any test that assumes "available space" does not change from
kernel version to kernel version is flawed. There is no guarantee
that this ever stays the same, nor that it needs to stay the same.

> > I was able to reproduce it on v5.19 distro kernels (openSUSE, Debian).
> > I haven't bisected (yet), nor checked Jens' git tree (maybe it has been fixed).
> 
> Forget to note dmesg "operation not supported error" warning on *each* run (even
> successful) on affected v5.19:
> [ 5097.594021] loop0: detected capacity change from 0 to 524288
> [ 5097.658201] operation not supported error, dev loop0, sector 262192 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
> [ 5097.675670] XFS (loop0): Mounting V5 Filesystem
> [ 5097.681668] XFS (loop0): Ending clean mount
> [ 5097.956445] XFS (loop0): Unmounting Filesystem

That warning is from mkfs attempting to use fallocate(ZERO_RANGE) to
offload the zeroing of the journal to the block device. It would
seem that the loop device image file is being hosted on a filesystem
that does not support the fallocate() ZERO_RANGE (or maybe
PUNCH_HOLE) operation. That warning should simply be removed - it
serves no useful purpose to a user...

CHeers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
