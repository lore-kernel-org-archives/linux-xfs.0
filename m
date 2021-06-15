Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCC0C48BDF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 17:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 940A26115B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 17:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhFOR7Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 13:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhFOR7Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Jun 2021 13:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71206610A2;
        Tue, 15 Jun 2021 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623779840;
        bh=aFa8QXMcw9GxLKKTQHfCdNT6M0PlUaRPuhJFIkD3JX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f84zgg4Lco6EuA9BnQWkpIhkyIcwWIZ9I6EHL+pasTtMHL/NTbzHg37wHU+WQR3tV
         0Uz6MzBHDWD3tEVS8s3sybGeSsMI33Ip5nFRVC5AMgFndOo+834qBcfIF5bLL6lkp2
         qVCs5hB+MZG4B55ASiV6RTsJweq5SrfjkkzaTfOdqTz+ceqO0rdWchteAz24biWSLe
         oeMxFYj7KywzuFsG1/7LMu5EGGa8meRcGG7fJqsmaHkUS91d88t5FteCf/nwqRf/zn
         4BqtDO1MbKLHsr1KTGsL3e8nty0YnkR2LpeuWl6d28ZZh8Htl1oIpBE07Z5F460r0e
         330WNxAVKH8EQ==
Date:   Tue, 15 Jun 2021 10:57:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: fix CIL push hang in for-next tree
Message-ID: <20210615175719.GD158209@locust>
References: <20210615064658.854029-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615064658.854029-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 15, 2021 at 04:46:56PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is the first fix for the problems Brian has reported from
> generic/019. This has fixed the hang, but the other log recovery
> problem he reported is still present (seen once with these patches
> in place).
> 
> I've tested these out to a couple of hundred cycles of
> continual looping generic/019 before the systems fall over with a
> perag reference count underrun at unmount after a shutdown. I'm
> pretty sure the hang is fixed, as it would manifest within 10-20
> cycles without this patch.
> 
> The first patch is the iclogbuf state tracing I used to capture the
> iclogbuf wrapping state. The second patch is the fix.

I found another bug while testing for-next.  If I run generic/100 more
than about ~30 times with a 1k block size:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 flax-mtr00 5.13.0-rc4-djwx #rc4 SMP
PREEMPT Mon Jun 7 11:17:23 PDT 2021
MKFS_OPTIONS  -- -f -b size=1024, /dev/sdf
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdf /opt

I see this in dmesg:

run fstests generic/100 at 2021-06-15 10:41:45
XFS (sda): ctx ticket reservation ran out. Need to up reservation
XFS (sda): ticket reservation summary:
XFS (sda):   unit res    = 47168 bytes
XFS (sda):   current res = -404 bytes
XFS (sda):   original count  = 1
XFS (sda):   remaining count = 1
XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file fs/xfs/xfs_log.c. Return address = xlog_write+0x608/0x640 [xfs]
XFS (sda): Log I/O Error Detected. Shutting down filesystem
XFS (sda): Please unmount the filesystem and rectify the problem(s)
XFS (sda): Unmounting Filesystem

Looking up that line in gdb produces:

0xffffffffa038a0a8 is in xlog_write (fs/xfs/xfs_log.c:2439).
2434            int                     log_offset;
2435
2436            if (ticket->t_curr_res < 0) {
2437                    xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
2438                         "ctx ticket reservation ran out. Need to up reservation");
2439                    xlog_print_tic_res(log->l_mp, ticket);
2440                    xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
2441            }

I haven't applied these two patches yet, but looking back through
fstests reports I never saw this before the recent for-next push.
I'm uncertain if it's the CIL work or the xattr refactoring that did
this, though AFAICT generic/100 itself does not generate any xattrs and
I don't have any LSMs enabled that would cause them to be created.

--D

> 
> Cheers,
> 
> Dave.
> 
> 
