Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:31296 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S946037AbcJaTms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2016 15:42:48 -0400
Date: Tue, 1 Nov 2016 06:42:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fwd: mounting a xfs file system gives the message: "failure code
 -3003" and "structure needs cleaning"
Message-ID: <20161031194212.GU14023@dastard>
References: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
 <8bd7b65f-d85d-2958-dd7d-ba97c91ac9ea@telefonica.net>
 <CAPvv1vx-Juge8e=36bq4AFvGxs8Kf7-V_v0j+a9LGWYdDo5h+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPvv1vx-Juge8e=36bq4AFvGxs8Kf7-V_v0j+a9LGWYdDo5h+w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Steffen D." <sdumke@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 31, 2016 at 08:29:37PM +0100, Steffen D. wrote:
> Hello again
> thanks to Carlos for the hint about the language.
> Here are the messages in english:
> ----------
> linux-ibbi:/home/steffen # LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
> xfs_repair /dev/sda4
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> linux-ibbi:/home/steffen #
> ----------
> 
> and
> 
> ----------
> linux-ibbi:/home/steffen # LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
> xfs_repair -n /dev/sda4
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> Metadata corruption detected at block 0x1a1d6001/0x200
> flfirst 118 in agf 2 too large (max = 118)
> agf 118 freelist blocks bad, skipping freelist scan
> Metadata corruption detected at block 0x272c1001/0x200
> flfirst 118 in agf 3 too large (max = 118)
> agf 118 freelist blocks bad, skipping freelist scan
> agi unlinked bucket 51 is 61133235 in ag 2 (inode=598004147)
> sb_icount 349952, counted 357504
> sb_ifree 9426, counted 7433
> sb_fdblocks 9895143, counted 9426793

hmmm - AGFL sizing issue?

What is the error in dmesg when you try to mount the filesystem?
What hardware are you running on (cpu, ram, etc) and where/how was
this filesystem created? Did it come from another machine?

xfs_reapir -L should fix it, but I'd like to understand what the
problem was first and how it happened....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
