Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64ECAC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 00:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC082082F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 00:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732849AbgDBAP3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 20:15:29 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33990 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732752AbgDBAP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 20:15:29 -0400
Received: from dread.disaster.area (pa49-180-164-3.pa.nsw.optusnet.com.au [49.180.164.3])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C925A3A2546;
        Thu,  2 Apr 2020 11:15:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jJnVy-0005vS-Nm; Thu, 02 Apr 2020 11:15:22 +1100
Date:   Thu, 2 Apr 2020 11:15:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 207053] New: fsfreeze deadlock on XFS (the FIFREEZE ioctl
 and subsequent FITHAW hang indefinitely)
Message-ID: <20200402001522.GA21885@dread.disaster.area>
References: <bug-207053-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-207053-201763@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=K0+o7W9luyMo1Ua2eXjR1w==:117 a=K0+o7W9luyMo1Ua2eXjR1w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=GaOT5Ju0ZYgFPPENdeEA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 01, 2020 at 07:02:57PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> When we upgraded from kernel 4.14.146 to kernel 4.19.75, we began to experience
> frequent deadlocks from our cronjobs that freeze the filesystem for
> snapshotting.

Probably commit d6b636ebb1c9 ("xfs: halt auto-reclamation activities
while rebuilding rmap") in 4.18, but that fixes a bug that allowed
reaping functions to attempt to modify the filesystem while it was
frozen...

> The fsfreeze stack shows:
> # cat /proc/33256/stack 
> [<0>] __flush_work+0x177/0x1b0
> [<0>] __cancel_work_timer+0x12b/0x1b0
> [<0>] xfs_stop_block_reaping+0x15/0x30 [xfs]
> [<0>] xfs_fs_freeze+0x15/0x40 [xfs]
> [<0>] freeze_super+0xc8/0x190
> [<0>] do_vfs_ioctl+0x510/0x630
> [<0>] ksys_ioctl+0x70/0x80
> [<0>] __x64_sys_ioctl+0x16/0x20
> [<0>] do_syscall_64+0x4e/0x100
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

This indicates that the reaping worker is still busy doing work. It
needs to finish before the freeze will continue to make progress.
So either the system is still doing work, or the kworker has blocked
somewhere.

What is the dmesg output of 'echo w > /prox/sysrq-trigger'?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
