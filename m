Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0ABC0044D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 23:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E1D20757
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 23:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbgCKXZQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 19:25:16 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56055 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387463AbgCKXZQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 19:25:16 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 142353A1F6C;
        Thu, 12 Mar 2020 10:25:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jCAis-00056d-Jf; Thu, 12 Mar 2020 10:25:10 +1100
Date:   Thu, 12 Mar 2020 10:25:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bart Brashers <bart.brashers@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: mount before xfs_repair hangs
Message-ID: <20200311232510.GG10776@dread.disaster.area>
References: <CAHgh4_+15tc6ekqBRHqZrdDmVSfUmMpOGyg_9kWYQ7XOs7D+eQ@mail.gmail.com>
 <CAHgh4_+p0okyt3kC=6HOZb6dr8o3dxqQARoFB-LkR9x-tGuvSA@mail.gmail.com>
 <20200308222646.GL10776@dread.disaster.area>
 <CAHgh4_K_01dS2Z-2QwR2dc5ZDz9J2+tG6W-paOeneUa6G_h9Kw@mail.gmail.com>
 <CAHgh4_KpizhD+V59+nV_Tr1W5i4N+yeSKQL9Sq6E5BwyWyr_aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHgh4_KpizhD+V59+nV_Tr1W5i4N+yeSKQL9Sq6E5BwyWyr_aA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=FwFOetIhxTC6GRzxJ5gA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 04:11:27PM -0700, Bart Brashers wrote:
> After working fine for 2 days, it happened again. Drives went offline
> for no apparent reason, and a logicaldevice (as arcconf calls them)
> failed. arcconf listed the hard drives as all online by the time I had
> logged on.
> 
> The server connected to the JBOD had rebooted by the time I noticed the problem.
> 
> There are two xfs filesystems on this server. I can mount one of them,
> and ran xfs_repair on it.
> 
> I first tried mounting the other read-only,no-recovery. That worked.
> Trying to mount normally hangs. I see in ps aux | grep mount that it's
> not using CPU. Here's the mount command I gave:
> 
> mount -t xfs -o inode64,logdev=/dev/md/nvme2 /dev/volgrp4TB/lvol4TB
> /export/lvol4TB/
> 
> I did an echo w > /proc/sysrc-trigger while I was watching the
> console, it said "SysRq : Show Blocked State". Here's what the output
> of dmesg looks like, starting with that line. Then it gives blocks
> about what's happening on each CPU, some of which mention "xfs".
> 
> [  228.927915] SysRq : Show Blocked State
> [  228.928525]   task                        PC stack   pid father
> [  228.928605] mount           D ffff96f79a553150     0 11341  11254 0x00000080
> [  228.928609] Call Trace:
> [  228.928617]  [<ffffffffb0b7f1c9>] schedule+0x29/0x70
> [  228.928624]  [<ffffffffb0b7cb51>] schedule_timeout+0x221/0x2d0
> [  228.928626]  [<ffffffffb0b7f57d>] wait_for_completion+0xfd/0x140
> [  228.928633]  [<ffffffffb04da0b0>] ? wake_up_state+0x20/0x20
> [  228.928667]  [<ffffffffc04c599e>] ? xfs_buf_delwri_submit+0x5e/0xf0 [xfs]
> [  228.928682]  [<ffffffffc04c3217>] xfs_buf_iowait+0x27/0xb0 [xfs]
> [  228.928696]  [<ffffffffc04c599e>] xfs_buf_delwri_submit+0x5e/0xf0 [xfs]
> [  228.928712]  [<ffffffffc04f2a9e>] xlog_do_recovery_pass+0x3ae/0x6e0 [xfs]
> [  228.928727]  [<ffffffffc04f2e59>] xlog_do_log_recovery+0x89/0xd0 [xfs]
> [  228.928742]  [<ffffffffc04f2ed1>] xlog_do_recover+0x31/0x180 [xfs]
> [  228.928758]  [<ffffffffc04f3fef>] xlog_recover+0xbf/0x190 [xfs]
> [  228.928772]  [<ffffffffc04e658f>] xfs_log_mount+0xff/0x310 [xfs]
> [  228.928801]  [<ffffffffc04dd1b0>] xfs_mountfs+0x520/0x8e0 [xfs]
> [  228.928814]  [<ffffffffc04e02a0>] xfs_fs_fill_super+0x410/0x550 [xfs]
> [  228.928818]  [<ffffffffb064c893>] mount_bdev+0x1b3/0x1f0
> [  228.928831]  [<ffffffffc04dfe90>] ?
> xfs_test_remount_options.isra.12+0x70/0x70 [xfs]
> [  228.928842]  [<ffffffffc04deaa5>] xfs_fs_mount+0x15/0x20 [xfs]
> [  228.928845]  [<ffffffffb064d1fe>] mount_fs+0x3e/0x1b0
> [  228.928850]  [<ffffffffb066b377>] vfs_kern_mount+0x67/0x110
> [  228.928852]  [<ffffffffb066dacf>] do_mount+0x1ef/0xce0
> [  228.928855]  [<ffffffffb064521a>] ? __check_object_size+0x1ca/0x250
> [  228.928858]  [<ffffffffb062368c>] ? kmem_cache_alloc_trace+0x3c/0x200
> [  228.928860]  [<ffffffffb066e903>] SyS_mount+0x83/0xd0
> [  228.928863]  [<ffffffffb0b8bede>] system_call_fastpath+0x25/0x2a

It's waiting for the metadata writes for recovered changes to
complete. This implies the underlying device is either hung or it
extremely slow. I'd suggest "extremely slow" because it's doing it's
own internal rebuild and may well be blocking new writes until it
has recovered the regions the new writes are being directed at...

This all looks like HW raid controller problems, nothign to do with
linux or the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
