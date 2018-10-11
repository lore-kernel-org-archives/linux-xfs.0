Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:9502 "EHLO
        ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727822AbeJKN0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:26:12 -0400
Date: Thu, 11 Oct 2018 17:00:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_bmap stuck at ~/.steam/steam.pipe file
Message-ID: <20181011060027.GP6311@dastard>
References: <CABXGCsPMXLbPJdAFq79Fmby3y89s=o7F-tf_+zSo_RsJXjaRaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXGCsPMXLbPJdAFq79Fmby3y89s=o7F-tf_+zSo_RsJXjaRaA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 11, 2018 at 10:47:31AM +0500, Mikhail Gavrilov wrote:
> When I researched the most fragmented files, I found that xfs_bmap
> stuck at the file /home/mikhail/.steam/steam.pipe.

Stuck, or just taking a long time?

> Can you look why it happens?
> 
> $ xfs_bmap -V
> xfs_bmap version 4.18.0
> 
> 
> Here backtrace of xfs_bmap process:
> (gdb) thread apply all bt full
> 
> Thread 1 (Thread 0x7fe0a8c86880 (LWP 21024)):
> #0  0x00007fe0a92f649f in __libc_open64

It's in the kernel open() syscall opening the file. userspace
tracing won't tell you what is going on at this point. Is there
anything in dmesg?

what is the output of `cat /proc/<pid>/stack` for the xfs_io process
that is running the bmap command?

What output ends up in dmesg after running 'echo w > sysrq-trigger'?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
