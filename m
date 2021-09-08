Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127EBC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 21:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAB7860EB7
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Sep 2021 21:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhIHVkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 17:40:35 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:48994 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbhIHVkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Sep 2021 17:40:35 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 8AEC1107830;
        Thu,  9 Sep 2021 07:39:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mO5Hw-00AFU9-C1; Thu, 09 Sep 2021 07:39:24 +1000
Date:   Thu, 9 Sep 2021 07:39:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     brian <a001@yakkadesign.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Repair Metadata corruption detected at xfs_inode_buf_verify on
 CentOS 7 virtual machine
Message-ID: <20210908213924.GB2361455@dread.disaster.area>
References: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=IkcTkHD0fZMA:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=t0oRnxSuCRo60ujWjTQA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 08, 2021 at 10:35:57AM -0400, brian wrote:
> I have CentOS 7 Virtualbox virtual machine (VM) that gives the following
> error on boot(removed parts replaced with …)
> ----------------------------------------------------------------------------
> XFS (dm-2): Metadata corruption detected at xfs_inode_buf_verify...
> XFS (dm-2): unmount and run xfs_repair
> XFS (dm-2): First 128 bytes of corrupted metadata buffer:
> …

You cut out the part of the error report that actually means
something to us. Can you post the error message in full?

> XFS (dm-2): metadata I/O error in “xlog_recov_do..(read#2)” at daddr 0x1b32
> error 117
> ----------------------------------------------------------------------------
> 
> I tried entered emergency mode, entered password and tried:
>     xfs_repair -L /dev/mapper/centos-root
> 
> But I got the error:
>     /dev/mapper/centos-root contains a mounted filesystem
>     /dev/mapper/centos-root contains a mounted and writable filesystem

$ man xfs_repair
....
  -d	Repair  dangerously.  Allow xfs_repair to repair an XFS
	filesystem mounted read only. This is typically done on a
	root filesystem from single user mode, immediately followed
	by a reboot.

> Next I booted from the Centos ISO then went
>       troubleshooting → Rescue a CentOS system  → 1) Continue
> 
> This fails.  I get lines of = marks.  When I left overnight, I had a blank
> screen.  When I ALT+Tab to program-log and then back to main, I got a screen
> of scrolling errors.

Which typically happens if the filesystem full of inconsistencies
and corruptions.

> I nightly backup my data including this VM with rsync to a USB drive.  My
> last backup was while the VM was running.  In Virtualbox and on my computers
> drive, I deleted the VM using the virtualbox GUI.  I thought this would move
> the VM to the trash but it permanently deleted the VM.  The problem I'm
> having is with the backup VM from my USB drive.

How did you do the backup? Was it an image file backup from the
host, or a full filesystem rsync from inside the guest ?

> How should I troubleshoot and fix this problem?  My main goal is to get my
> data off the VM.  I also unsuccessful with mounting the .vdi file in another
> computer.

Sounds like you simply backed up the image file on the host?

If so, did you freeze the filesystem in the guest (or the whole
guest VM) while you did the backup? If the guest fs wasnt' frozen,
and the VM was active while the backup was done as you say, then it
is guaranteed that the image file that was copied will contain an
inconsistent image of the filesystem. If there was lots of
modifications occurring at the time of the copy being run, it will
be full of corruptions and may well be completely unrecoverable.

DO you have any older backups you can try to recover from?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
