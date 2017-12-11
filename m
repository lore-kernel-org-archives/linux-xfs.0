Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:62698 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752414AbdLKVGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Dec 2017 16:06:10 -0500
Date: Tue, 12 Dec 2017 08:06:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS on RBD crash
Message-ID: <20171211210607.GS5858@dastard>
References: <CADb94503vRdng4T_sTGimZPWhmZE4D9BAC0_OKCGDBAc06PMVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADb94503vRdng4T_sTGimZPWhmZE4D9BAC0_OKCGDBAc06PMVw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Gorbachev <ag@iss-integration.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Dec 09, 2017 at 04:01:34PM -0500, Alex Gorbachev wrote:
> I have experienced a crash today (in a sense of filesystem going
> offline) of a 25TB XFS filesystem.  Tried searching the list and
> google, and not much specific info I can use, so very much appreciate
> any insight:

freespace tree corruption. No idea what the cause might have been.

> System: Ubuntu 16.04, kernel 4.10.17-041017-generic
> 
> Mount info:
> 
> /dev/rbd0 on /srv/exports/sclun63 type xfs
> (rw,relatime,attr2,inode64,logbsize=256k,sunit=8192,swidth=8192,noquota)
                                           ^^^^^^^^^^^^^^^^^^^^^^
Why?

> xfs_repair (had to do -L):

Because the corrupted metadata was in the log, causing mount to
fail, and that's why you zeroed the log?

> root@roc01r-scd224:~# xfs_repair -L /dev/rbd0
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
> ALERT: The filesystem has valuable metadata changes in a log which is being
> destroyed because the -L option was used.
>         - scan filesystem freespace and inode maps...
> freeblk count 3 != flcount 4 in ag 47

Those are from trashing the log, I think.

> sb_ifree 667, counted 615
> sb_fdblocks 3930698117, counted 1111093367

That's a major discrepancy - superblock said ~16TB free, repair
counted only 5TB free. And the inode count is off, too - had you
been removing files recently?

>         - 15:06:10: scanning filesystem freespace - 193 of 193

Lots of AGs for a small filesystem - this filesystem has been grown
several times?

>         - 15:10:22: check for inodes claiming duplicate blocks - 896
> of 896 inodes done

Only ~900 files in the filesystem? 

> No other errors in logs, Ceph or hardware.

And no error reported from xfs_repair, either. So the corruption
occurred in memory and was captured by the log, which you zeroed
to run xfs_repair.

So there's really nothing left for us to analyse and debug.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
